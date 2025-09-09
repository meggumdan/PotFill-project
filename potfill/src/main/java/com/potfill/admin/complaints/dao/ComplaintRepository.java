package com.potfill.admin.complaints.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.potfill.admin.complaints.model.Complaint;
import com.potfill.admin.complaints.model.ComplaintHistory;
import com.potfill.admin.complaints.model.ReportPhoto;
@Mapper
public interface ComplaintRepository {
    
    // 민원 리스트 조회 (검색, 정렬, 필터 조건 포함)
    List<Complaint> getComplaintList(@Param("searchParams") Map<String, Object> searchParams);
    
    // 민원 총 개수 (페이징용)
    int getComplaintCount(@Param("searchParams") Map<String, Object> searchParams);
    
    // 민원 상세 조회
    Complaint getComplaintById(@Param("complaintId") Long complaintId);
    
    // 민원 상태 변경
    int updateComplaintStatus(@Param("complaintId") Long complaintId, 
                             @Param("status") String status);
    
    // 민원 위험도 수정
    int updateComplaintRisk(@Param("complaintId") Long complaintId, 
                           @Param("riskLevel") String riskLevel);
    
    // 민원 위치 수정
    int updateComplaintLocation(@Param("complaintId") Long complaintId,
                               @Param("lat") Double lat,
                               @Param("lon") Double lon,
                               @Param("incidentAddress") String incidentAddress);
    
    // 민원 히스토리 추가
    int insertComplaintHistory(ComplaintHistory history);
    
    // 민원 히스토리 조회
    List<ComplaintHistory> getComplaintHistories(@Param("complaintId") Long complaintId);
    
    // 민원 사진 조회
    List<ReportPhoto> getComplaintPhotos(@Param("complaintId") Long complaintId);
    
    // 중복 신고 확인 (H3 기반)
    List<Complaint> getDuplicateComplaints(@Param("h3Index") String h3Index,
                                          @Param("complaintId") Long complaintId);
    
    // 대시보드 통계용 메서드들
    Map<String, Object> getDashboardStats(@Param("adminId") Long adminId);
}