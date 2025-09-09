package com.potfill.admin.complaints.service;

import java.util.List;
import java.util.Map;
import com.potfill.admin.complaints.model.Complaint;
import com.potfill.admin.complaints.model.ComplaintHistory;
import com.potfill.admin.complaints.model.ReportPhoto;

public interface ComplaintService {
    
    // 민원 리스트 조회 (페이징 포함)
    Map<String, Object> getComplaintListWithPaging(Map<String, Object> searchParams);
    
    // 민원 상세 조회 (히스토리, 사진 포함)
    Map<String, Object> getComplaintDetail(Long complaintId);
    
    // 민원 상태 변경 및 히스토리 기록
    boolean updateComplaintStatus(Long complaintId, String status, String comment, Long adminId);
    
    // 민원 위험도 수정
    boolean updateComplaintRisk(Long complaintId, String riskLevel);
    
    // 민원 위치 수정
    boolean updateComplaintLocation(Long complaintId, Double lat, Double lon, String address);
    
    // 중복 신고 확인
    List<Complaint> checkDuplicateComplaints(String h3Index, Long complaintId);
    
    // 대시보드 통계 데이터 조회
    Map<String, Object> getDashboardStatistics(Long adminId);
}