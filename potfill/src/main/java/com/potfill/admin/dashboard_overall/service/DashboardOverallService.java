package com.potfill.admin.dashboard_overall.service;

import java.util.List;
import java.util.Map;

import com.potfill.admin.dashboard_overall.model.MajorPlace;

public interface DashboardOverallService {
    
    /**
     * 현재 등록된 주요장소 개수 조회
     */
    int getMajorPlacesCount();
    
    /**
     * 주요장소 삽입
     */
    int insertMajorPlace(MajorPlace majorPlace);
    
    /**
     * 대시보드 핵심 지표 데이터 조회
     */
    Map<String, Object> getDashboardKPIData();
    
    /**
     * 우선처리 지역 TOP 5
     */
    List<Map<String, Object>> getPriorityTop5();
    
    /**
     * 지역구별 우선도 랭킹
     */
    Map<String, Object> getAreaRanking();
    
    /**
     * 지역별 포트홀 신고현황 (도넛차트 + 테이블)
     */
    Map<String, Object> getRegionalStatus();
}