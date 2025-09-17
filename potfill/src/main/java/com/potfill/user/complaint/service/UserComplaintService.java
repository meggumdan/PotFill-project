/*
 * 작성자 : 정소영
 * 설명   : 사용자 신고 처리 비즈니스 로직을 담당하는 서비스 인터페이스
 */
package com.potfill.user.complaint.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.potfill.user.complaint.model.Complaint;

public interface UserComplaintService {

	// 신고 등록
	void saveComplaint(Complaint complaint, List<MultipartFile> photoFiles) throws IOException;

	// 나의 신고 내역 가져오기
	List<Complaint> findByNameAndPhone(String reporterName, String reporterNumber);

	// 신고 위치 중복확인
	double[] getCoordinatesFromAddress(String address);

	// 중복 여부 확인
	boolean isDuplicateLocation(double lat, double lon);

	// 신고 누적
	Long incrementDuplicateHit(double lat, double lon); // 추가


}
