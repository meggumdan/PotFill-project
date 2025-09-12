package com.potfill.user.complaint.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.model.ComplaintPhoto;

@Mapper
public interface UserComplaintRepository {

	// 신고 폼 저장
	public void insertComplaint(Complaint complaint);
	
	// 첨부된 사진 저장
	void insertComplaintPhoto(ComplaintPhoto photo);

	// 나의 신고 이력 조회
	public List<Complaint> findByNameAndPhone(@Param("reporterName") String reporterName, @Param("reporterNumber")String reporterNumber);

	// 데이터베이스에 저장된 위도 경도 가져오기
	public List<Complaint> findAllCoords();

	// 중복인 장소의 상태 확인
	public String findLatestStatusByComplaintId(Long complaintId);
	
	// 중복 신고 +1
	public int incrementReportCount(Long complaintId);

	// 주어진 H3 셀(targetCell)과 동일한 위치에 등록된 민원 건수를 조회
    Integer countByH3Index(String targetCell);
}
