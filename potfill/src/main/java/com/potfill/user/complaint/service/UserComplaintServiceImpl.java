/*
 * 작성자 : 정소영, 이지민
 * 설명   : 사용자 신고 처리 비즈니스 로직 구현체
 */

package com.potfill.user.complaint.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.potfill.user.common.ComplaintIdGenerator;
import com.potfill.user.complaint.dao.UserComplaintRepository;
import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.model.ComplaintPhoto;
import com.potfill.user.complaint.model.ComplaintHistory;
import com.uber.h3core.H3Core;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserComplaintServiceImpl implements UserComplaintService {
	
	private final UserComplaintRepository userComplaintRepository;

	// H3 라이브러리 주입
	private final H3Core h3;

	// 파이썬 실행시 필요한 서비스 주입
    private final RiskService riskService;

	// H3 해상도 설정 (1-15)
	final int RES = 10;


	/*
	* 신고 저장 기능
	*/
	@Override
	@Transactional
	public void saveComplaint(Complaint complaint, List<MultipartFile> photoFiles) throws IOException {

		// 1) 민원번호 직접 생성
		long complaintId = ComplaintIdGenerator.newId();
		complaint.setComplaintId(complaintId);

		// 2) 좌표가 있으면 H3 인덱스 산출
		if (complaint.getLat() != null && complaint.getLon() != null) {
			complaint.setH3Res(RES);
			String h3Index = h3.geoToH3Address(complaint.getLat(), complaint.getLon(), RES);
			complaint.setH3Index(h3Index);
		}

		// 3) 담당자 배정 (gu 기준, 없으면 null)
		Long adminId = userComplaintRepository.findAdminIdByGu(complaint.getGu());
		if (adminId != null) {
			complaint.setAssignedAdminId(adminId);
		}

		// 4) 본문 저장
		userComplaintRepository.insertComplaint(complaint);
		System.out.println(adminId);

		// 5) 파일 저장
		String firstPhotoPath = null; // AI 실행용 대표 사진 경로 저장
		if (photoFiles != null && !photoFiles.isEmpty()) {
			for (MultipartFile file : photoFiles) {
				if (!file.isEmpty()) {

					// 업로드 디렉토리 설정
					// 개발 환경: 프로젝트 내부(webapp/upload)
					// 운영 환경: basePath 절대경로로 교체 필요
					// String basePath = new File("src/main/webapp/upload/").getAbsolutePath() + File.separator;
					String basePath = "C:" + File.separator + "project-potfill" + File.separator;
					String uploadDir = basePath + complaintId + File.separator;

					File dir = new File(uploadDir);
					if (!dir.exists()) {
						dir.mkdirs(); // 폴더 없으면 생성
					}

					// 저장할 파일명 생성
					String uuid = UUID.randomUUID().toString();
					String originalName = file.getOriginalFilename();
					String extension = "";

					if (originalName != null && originalName.contains(".")) {
						extension = originalName.substring(originalName.lastIndexOf("."));
					}

					// 서버에 저장할 안전한 파일명
					String storedName = uuid + extension;

					// 실제 서버 파일 저장
					File dest = new File(uploadDir + storedName);
					file.transferTo(dest);

					// DB에 파일 메타데이터 저장 
					ComplaintPhoto photo = new ComplaintPhoto();
					photo.setComplaintId(complaint.getComplaintId());
					// 웹에서 접근 가능한 경로만 저장 (DB에는 OS 절대경로 대신 상대경로 권장)
					photo.setFileUrl("/upload/" + complaintId + "/" + storedName);
					photo.setOriginalName(originalName); // 원본 파일명
					photo.setStoredName(storedName); // 서버 저장된 파일명

					userComplaintRepository.insertComplaintPhoto(photo);
					
					// 대표 사진 경로 (실제 파일 경로)
					// 업로드 중 첫 번째 파일만 대표 사진으로 선택
					if (firstPhotoPath == null) {
					    firstPhotoPath = dest.getAbsolutePath();
					    System.out.println("대표 사진 경로: " + firstPhotoPath);
					}
				}
			}
		}

		// 6) 히스토리테이블에 접수 상태 등록 (RECEIVED)
		ComplaintHistory history = ComplaintHistory.builder()
				.complaintId(complaintId)
				.status("RECEIVED")
				.statusComment("신규 접수")
				.build();
		userComplaintRepository.insertComplaintHistory(history);
		
		// 첨부 사진이 있으면 RiskService 호출
		if (firstPhotoPath != null) {
		    riskService.analyzeAndSaveRisk(complaintId, firstPhotoPath);
		}
	}

	/*
	 * 신고 내역 조회
	 */
	@Override
	public List<Complaint> findByNameAndPhone(String reporterName, String reporterNumber) {

	    return userComplaintRepository.findByNameAndPhone(reporterName, reporterNumber);
	}

	@Override
    public double[] getCoordinatesFromAddress(String address) {
        // 카카오 주소 API 연동해서 변환
        // 지금은 샘플 좌표 반환
        return new double[]{37.5665, 126.9780};
    }


	/*
	 * 신고 위치 중복 확인
	 */
	@Override
	public boolean isDuplicateLocation(double lat, double lon) {
		String targetCell = h3.geoToH3Address(lat, lon, RES);

		// DB에서 같은 H3_INDEX 존재 여부 + 접수 상태 인지 조회
		Integer cnt = userComplaintRepository.findLatestStatusByH3Index(targetCell);
		if (cnt != null && cnt > 0) return true;

		return false;
	}

	/*
	 * 신고 누적
	 */
	@Transactional
	@Override
	public Long incrementDuplicateHit(double lat, double lon) {
		String h3Index = h3.geoToH3Address(lat, lon, RES);

		// 대표 신고 1건 선택
		Long complaintId = userComplaintRepository.selectPrimaryComplaintIdByH3Index(h3Index);
		if (complaintId == null) return null;

		userComplaintRepository.incrementReportCount(complaintId);
		return complaintId;
	}
}
