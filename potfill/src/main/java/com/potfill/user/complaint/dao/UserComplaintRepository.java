/*
 * 작성자 : 정소영
 * 설명   : 사용자 포트홀 신고 데이터를 관리하는 MyBatis 매퍼 인터페이스
 */
package com.potfill.user.complaint.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.model.ComplaintPhoto;
import com.potfill.user.complaint.model.ComplaintHistory;

@Mapper
public interface UserComplaintRepository {

	// 신고 폼 저장
	public void insertComplaint(Complaint complaint);
	
	// 첨부된 사진 저장
	void insertComplaintPhoto(ComplaintPhoto photo);

	// 나의 신고 이력 조회
	public List<Complaint> findByNameAndPhone(@Param("reporterName") String reporterName, @Param("reporterNumber")String reporterNumber);
	
	// 중복 신고 +1
	Long selectPrimaryComplaintIdByH3Index(String h3Index);
	public int incrementReportCount(Long complaintId);

	// DB에서 같은 H3_INDEX 존재 여부 + 접수 상태 인지 조회
    Integer findLatestStatusByH3Index(String targetCell);

	// 히스토리 추가 (접수상태 등록)
	void insertComplaintHistory(ComplaintHistory history);

	// 구에 맞는 담당자 찾기
	Long findAdminIdByGu(@Param("gu") String gu);

	// 위험도 저장
    void insertRisk(@Param("complaintId") Long complaintId, @Param("riskGrade") int riskGrade);

}
