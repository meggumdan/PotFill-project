package com.potfill.admin.district.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.potfill.admin.district.model.Complaint;
import com.potfill.admin.district.model.DailyCount;

public interface DistrictRepository {
    
    int getNewCount(@Param("districtCode") String districtCode);
    int getProcessingCount(@Param("districtCode") String districtCode);
    int getCompletedCount(@Param("districtCode") String districtCode);

    // 긴급건수 출력
    List<Complaint> getEmergencyList(@Param("districtCode") String districtCode);

    // 최근 7일 일자별 건수
    List<DailyCount> getDailyCounts(@Param("districtCode") String districtCode);
}
