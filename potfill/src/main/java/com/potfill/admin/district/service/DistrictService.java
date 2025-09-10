package com.potfill.admin.district.service;

import java.util.List;

import com.potfill.admin.district.model.Complaint;
import com.potfill.admin.district.model.DailyCount;


public interface DistrictService {

    // 총 민원 건수
    int getNewCount();
    int getProcessingCount();
    int getCompletedCount();
    
    // 최근 7일 일자별 접수/완료 건수
    List<DailyCount> getDailyCounts();
    
    // 긴급 민원 리스트
    List<Complaint> getEmergencyList();
}