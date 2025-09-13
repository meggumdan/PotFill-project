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
import com.uber.h3core.H3Core;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserComplaintServiceImpl implements UserComplaintService {
	
	
	private final UserComplaintRepository userComplaintRepository;
	//H3Core h3 = H3Core.newInstance(); // H3 라이브러리 왜안댐 ?????????????
	private final H3Core h3; // 스프링이 Bean 주입

	@Override
	@Transactional
	public void saveComplaint(Complaint complaint, List<MultipartFile> photoFiles) throws IOException {

		// 1) 민원번호 직접 생성
		long complaintId = ComplaintIdGenerator.newId();
		complaint.setComplaintId(complaintId);

		// 2) 좌표가 있으면 H3 인덱스 산출 (해상도는 상황에 맞게 조정: 12 또는 13 권장)
		final int RES = 12;
		if (complaint.getLat() != null && complaint.getLon() != null) {
			complaint.setH3Res(RES);
			String h3Index = h3.geoToH3Address(complaint.getLat(), complaint.getLon(), RES);
			complaint.setH3Index(h3Index);
		}

		// 3) 본문 저장 (DB 유니크 제약이 있으면 여기서 중복 자체가 차단됨)
		userComplaintRepository.insertComplaint(complaint);

		// 4) 파일 저장 (임시로 - 프로젝트 내부 /webapp/upload 사용)
		if (photoFiles != null && !photoFiles.isEmpty()) {
			for (MultipartFile file : photoFiles) {
				if (!file.isEmpty()) {

					// 업로드 디렉토리 설정
					// 개발 환경: 프로젝트 내부(webapp/upload)
					// 운영 환경: basePath 절대경로로 교체 필요
					String basePath = new File("src/main/webapp/upload/").getAbsolutePath() + File.separator;
					System.out.println(">>>>>>>>>>>>>>>>>>>>> user.dir 경로 = " + System.getProperty("user.dir"));
					System.out.println(">>>>>>>>>>>>>>>>>>>>> basePath 경로 = " + basePath);
					
					String uploadDir = basePath + complaintId + File.separator;
					System.out.println(">>>>>>>>>>>>>>>>>>>>> uploadDir 경로 = " + uploadDir);
					

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
				}
			}
		}
	}

	@Override
	public List<Complaint> findByNameAndPhone(String reporterName, String reporterNumber) {
	    // Repository 호출 (mapper.xml에 맞게 구현 필요)
	    return userComplaintRepository.findByNameAndPhone(reporterName, reporterNumber);
	}

	@Override
    public double[] getCoordinatesFromAddress(String address) {
        // 카카오 주소 API 연동해서 변환
        // 지금은 샘플 좌표 반환
        return new double[]{37.5665, 126.9780};
    }

	@Override
	public boolean isDuplicateLocation(double lat, double lon) {
		final int RES = 12;
		String targetCell = h3.geoToH3Address(lat, lon, RES);

		// (1) 가장 빠른 방법: DB에서 같은 H3_INDEX 존재 여부만 조회
		Integer cnt = userComplaintRepository.countByH3Index(targetCell);
		if (cnt != null && cnt > 0) return true;

		// (2) 과거 코드처럼 전수 비교가 필요하면(비추천) 유지 가능
		return false;
	}
}
