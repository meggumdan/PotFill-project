/*
 * 작성자 : 이지민
 * 설명 : 민원 지역 관련 비즈니스 인터페이스
 */
package com.potfill.admin.district.service;

import java.util.List;

import com.potfill.admin.district.model.Complaint;
import com.potfill.admin.district.model.DailyCount;


public interface DistrictService {
    
	// 총 민원 건수
    int getNewCount(String districtCode);
    int getProcessingCount(String districtCode);
    int getCompletedCount(String districtCode);
    // 최근 7일 일자별 접수/완료 건수
    List<DailyCount> getDailyCounts(String districtCode);
    // 긴급 민원 리스트
    List<Complaint> getEmergencyList(String districtCode);
}