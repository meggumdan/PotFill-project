package com.potfill.admin.managerdistrict.service;

import java.util.List;

import com.potfill.admin.managerdistrict.model.Complaint;
import com.potfill.admin.managerdistrict.model.DailyCount;


public interface ComplaintService {

    // 총 민원 건수
    int getNewCount();
    int getProcessingCount();
    int getCompletedCount();
    
    // 최근 7일 일자별 접수/완료 건수
    List<DailyCount> getDailyCounts();
    
    // 긴급 민원 리스트
    List<Complaint> getEmergencyList();
}