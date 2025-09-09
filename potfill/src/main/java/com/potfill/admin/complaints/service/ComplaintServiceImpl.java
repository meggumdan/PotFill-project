package com.potfill.admin.complaints.service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.potfill.admin.complaints.dao.ComplaintRepository;
import com.potfill.admin.complaints.model.Complaint;
import com.potfill.admin.complaints.model.ComplaintHistory;
import com.potfill.admin.complaints.model.ReportPhoto;

@Service
public class ComplaintServiceImpl implements ComplaintService {
    
    @Autowired
    private ComplaintRepository complaintRepository;
    
    @Override
    public Map<String, Object> getComplaintListWithPaging(Map<String, Object> searchParams) {
        Map<String, Object> result = new HashMap<>();
        
        int page = searchParams.get("page") != null ? (Integer) searchParams.get("page") : 1;
        int pageSize = searchParams.get("pageSize") != null ? (Integer) searchParams.get("pageSize") : 20;

        //  시작 행과 끝 행 번호를 Java에서 미리 계산합니다.
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;
        
        //  계산된 값을 Map에 넣습니다.
        searchParams.put("startRow", startRow);
        searchParams.put("endRow", endRow);
        
        List<Complaint> complaints = complaintRepository.getComplaintList(searchParams);
        int totalCount = complaintRepository.getComplaintCount(searchParams);
        
        result.put("complaints", complaints);
        result.put("totalCount", totalCount);
        result.put("currentPage", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
    
    @Override
    public Map<String, Object> getComplaintDetail(Long complaintId) {
        Map<String, Object> result = new HashMap<>();
        
        // 민원 기본 정보 조회
        Complaint complaint = complaintRepository.getComplaintById(complaintId);
        if (complaint == null) {
            return null;
        }
        
        // 민원 히스토리 조회
        List<ComplaintHistory> histories = complaintRepository.getComplaintHistories(complaintId);
        
        // 민원 사진 조회
        List<ReportPhoto> photos = complaintRepository.getComplaintPhotos(complaintId);
        
        // 중복 신고 확인
        List<Complaint> duplicateComplaints = null;
        if (complaint.getH3Index() != null) {
            duplicateComplaints = complaintRepository.getDuplicateComplaints(
                complaint.getH3Index(), complaintId);
        }
        
        result.put("complaint", complaint);
        result.put("histories", histories);
        result.put("photos", photos);
        result.put("duplicateComplaints", duplicateComplaints);
        
        return result;
    }
    
    @Override
    @Transactional
    public boolean updateComplaintStatus(Long complaintId, String status, String comment, Long adminId) {
        try {
            // 상태 업데이트
            int updated = complaintRepository.updateComplaintStatus(complaintId, status);
            
            if (updated > 0) {
                // 히스토리 기록
                ComplaintHistory history = ComplaintHistory.builder()
                    .complaintId(complaintId)
                    .adminId(adminId)
                    .status(status)
                    .statusComment(comment)
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .build();
                
                complaintRepository.insertComplaintHistory(history);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateComplaintRisk(Long complaintId, String riskLevel) {
        try {
            int updated = complaintRepository.updateComplaintRisk(complaintId, riskLevel);
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateComplaintLocation(Long complaintId, Double lat, Double lon, String address) {
        try {
            int updated = complaintRepository.updateComplaintLocation(complaintId, lat, lon, address);
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Complaint> checkDuplicateComplaints(String h3Index, Long complaintId) {
        return complaintRepository.getDuplicateComplaints(h3Index, complaintId);
    }
    
    @Override
    public Map<String, Object> getDashboardStatistics(Long adminId) {
        return complaintRepository.getDashboardStats(adminId);
    }
}