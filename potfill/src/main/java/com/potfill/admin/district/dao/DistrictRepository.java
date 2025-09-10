package com.potfill.admin.district.dao;

import java.util.List;

import com.potfill.admin.district.model.Complaint;
import com.potfill.admin.district.model.DailyCount;

public interface DistrictRepository {

	int getNewCount();
	int getProcessingCount();
	int getCompletedCount();
	
	// 긴급건수 출력(일단은 카운트 높은순 limit 5 출력)
	List<Complaint> getEmergencyList();
	// 최근 7일 일자별 건수
    List<DailyCount> getDailyCounts();
}
