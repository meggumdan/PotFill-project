package com.potfill.admin.dashboard_overall.dao;

import org.apache.ibatis.annotations.Mapper;
import com.potfill.admin.dashboard_overall.model.MajorPlace;

@Mapper
public interface MajorPlaceRepository {
    
    /**
     * 전체 주요장소 개수 조회
     */
    int getMajorPlacesCount();
    
    /**
     * 주요장소 삽입
     */
    int insertMajorPlace(MajorPlace majorPlace);
}