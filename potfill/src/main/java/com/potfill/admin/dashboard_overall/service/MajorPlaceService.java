package com.potfill.admin.dashboard_overall.service;

import com.potfill.admin.dashboard_overall.model.MajorPlace;

public interface MajorPlaceService {
    
    /**
     * 현재 등록된 주요장소 개수 조회
     */
    int getMajorPlacesCount();
    
    /**
     * 주요장소 삽입
     */
    int insertMajorPlace(MajorPlace majorPlace);
}