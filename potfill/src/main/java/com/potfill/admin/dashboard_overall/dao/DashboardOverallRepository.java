package com.potfill.admin.dashboard_overall.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import com.potfill.admin.dashboard_overall.model.MajorPlace;

@Mapper
public interface DashboardOverallRepository {
    
    /**
     * 전체 주요장소 개수 조회
     */
    int getMajorPlacesCount();
    
    /**
     * 주요장소 삽입
     */
    int insertMajorPlace(MajorPlace majorPlace);
    /**
     * 주요장소 삭제
     */
    
    int deleteByAreaName(String areaName);

    
    /**
     * 총 신고건수 (현재월)
     */
    int getTotalComplaints();
    
    /**
     * 처리중 건수 (현재월)
     */
    int getProcessingComplaints();
    
    /**
     * 완료 건수 (현재월)
     */
    int getCompletedComplaints();
    
    /**
     * 고위험 구 개수 (최근 90일 기준)
     */
    Integer getDangerGuCount();
    
    /**
     * 총 신고건수 (전월)
     */
    int getLastMonthTotalComplaints();
    
    /**
     * 처리중 건수 (전월)
     */
    int getLastMonthProcessingComplaints();
    
    /**
     * 완료 건수 (전월)
     */
    int getLastMonthCompletedComplaints();
    
    /**
     * 고위험 구 개수 (전월)
     */
    Integer getLastMonthDangerGuCount();
    
    /**
     * 우선처리 지역 TOP 5
     */
    List<Map<String, Object>> getPriorityTop5();
    
    /**
     * 지역구별 우선도 랭킹 (TOP 10)
     */
    List<Map<String, Object>> getAreaRanking();
    
    /**
     * 전체 처리 현황 (도넛차트용)
     */
    List<Map<String, Object>> getOverallStatus();

    /**
     * 구별 상세 현황 (테이블용)
     */
    List<Map<String, Object>> getDistrictDetails();
}