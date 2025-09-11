package com.potfill.admin.dashboard_overall.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.potfill.admin.dashboard_overall.dao.DashboardOverallRepository;
import com.potfill.admin.dashboard_overall.model.MajorPlace;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardOverallServiceImpl implements DashboardOverallService {

    private static final Logger logger = LoggerFactory.getLogger(DashboardOverallServiceImpl.class);

    @Autowired
    private DashboardOverallRepository dashboardOverallRepository;

    @Override
    public int getMajorPlacesCount() {
        return dashboardOverallRepository.getMajorPlacesCount();
    }

    @Override
    public int insertMajorPlace(MajorPlace majorPlace) {
        logger.info("주요장소 저장: {}", majorPlace.toString());
        return dashboardOverallRepository.insertMajorPlace(majorPlace);
    }

    @Override
    public Map<String, Object> getDashboardKPIData() {
        Map<String, Object> kpiData = new HashMap<>();
        try {
            // ===== 현재 월 데이터 =====
            int totalComplaints = dashboardOverallRepository.getTotalComplaints();
            int processingComplaints = dashboardOverallRepository.getProcessingComplaints();
            int completedComplaints = dashboardOverallRepository.getCompletedComplaints();
            Integer dangerGuCount = dashboardOverallRepository.getDangerGuCount();
            int dangerZoneCount = (dangerGuCount != null) ? dangerGuCount : 0;

            int pendingComplaints = totalComplaints - processingComplaints - completedComplaints;

            // ===== 전월 데이터 =====
            int lastMonthTotal = dashboardOverallRepository.getLastMonthTotalComplaints();
            int lastMonthProcessing = dashboardOverallRepository.getLastMonthProcessingComplaints();
            int lastMonthCompleted = dashboardOverallRepository.getLastMonthCompletedComplaints();
            Integer lastMonthDanger = dashboardOverallRepository.getLastMonthDangerGuCount();
            int lastMonthDangerCount = (lastMonthDanger != null) ? lastMonthDanger : 0;

            // ===== 전월 대비 증감 계산 - 수정된 부분 =====
            String totalTrend = calculateTrend(totalComplaints, lastMonthTotal);
            String processingTrend = calculateTrend(processingComplaints, lastMonthProcessing);
            String completedTrend = calculateTrend(completedComplaints, lastMonthCompleted);
            String dangerTrend = calculateTrend(dangerZoneCount, lastMonthDangerCount);

            // ===== 결과 저장 =====
            kpiData.put("totalComplaints", totalComplaints);
            kpiData.put("processingComplaints", processingComplaints);
            kpiData.put("completedComplaints", completedComplaints);
            kpiData.put("pendingComplaints", pendingComplaints);
            kpiData.put("dangerZoneCount", dangerZoneCount);

            kpiData.put("totalTrend", totalTrend);
            kpiData.put("processingTrend", processingTrend);
            kpiData.put("completedTrend", completedTrend);
            kpiData.put("dangerTrend", dangerTrend);

            logger.info("대시보드 KPI 데이터 조회 완료: total={}, processing={}, completed={}, danger={}",
                    totalComplaints, processingComplaints, completedComplaints, dangerZoneCount);

        } catch (Exception e) {
            logger.error("대시보드 KPI 데이터 조회 중 오류 발생", e);

            // 오류 시 기본값 반환
            kpiData.put("totalComplaints", 0);
            kpiData.put("processingComplaints", 0);
            kpiData.put("completedComplaints", 0);
            kpiData.put("pendingComplaints", 0);
            kpiData.put("dangerZoneCount", 0);

            kpiData.put("totalTrend", "+0(0%)");
            kpiData.put("processingTrend", "+0(0%)");
            kpiData.put("completedTrend", "+0(0%)");
            kpiData.put("dangerTrend", "+0(0%)");
        }
        return kpiData;
    }
    
    /**
     * 전월 대비 변화량 계산 (수정된 메서드)
     */
    private String calculateTrend(int current, int lastMonth) {
        int diff = current - lastMonth;
        double percent = 0;
        
        if (lastMonth == 0) {
            if (current > 0) {
                // 전월 0에서 현재 값이 있는 경우
                return "+" + current + "(new)";
            } else {
                // 둘 다 0인 경우
                return "+0(0%)";
            }
        }
        
        percent = (diff * 100.0) / lastMonth;
        
        // 항상 +/- 부호 표시
        String sign = diff >= 0 ? "+" : "";
        String percentStr = String.format("%.0f", Math.abs(percent));
        
        return sign + diff + "(" + percentStr + "%)";
    }
    
    @Override
    public List<Map<String, Object>> getPriorityTop5() {
        return dashboardOverallRepository.getPriorityTop5();
    }
    
 // DashboardOverallServiceImpl.java에 추가할 메서드

    @Override
    public Map<String, Object> getAreaRanking() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // DB에서 구별 우선도 랭킹 조회
            List<Map<String, Object>> rankingList = dashboardOverallRepository.getAreaRanking();
            
            // Chart.js 형식으로 데이터 변환
            List<String> labels = new ArrayList<>();
            List<Double> data = new ArrayList<>();
            
            for (Map<String, Object> item : rankingList) {
                String guName = (String) item.get("GUNAME");
                Object scoreObj = item.get("PRIORITYSCORE");
                
                // Oracle은 대문자로 반환하므로 대소문자 처리
                if (guName == null) {
                    guName = (String) item.get("guname");
                }
                if (scoreObj == null) {
                    scoreObj = item.get("priorityscore");
                }
                
                labels.add(guName != null ? guName : "");
                
                // Number 타입으로 안전하게 변환
                double score = 0.0;
                if (scoreObj != null) {
                    if (scoreObj instanceof Number) {
                        score = ((Number) scoreObj).doubleValue();
                    } else {
                        try {
                            score = Double.parseDouble(scoreObj.toString());
                        } catch (NumberFormatException e) {
                            score = 0.0;
                        }
                    }
                }
                data.add(score);
            }
            
            result.put("labels", labels);
            result.put("data", data);
            
            logger.info("지역구별 우선도 랭킹 조회 완료: {}개 구", labels.size());
            
        } catch (Exception e) {
            logger.error("지역구별 우선도 랭킹 조회 실패", e);
            
            // 오류 시 빈 데이터 반환
            result.put("labels", new ArrayList<>());
            result.put("data", new ArrayList<>());
        }
        
        return result;
    }
    
    @Override
    public Map<String, Object> getRegionalStatus() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 1. 도넛차트 데이터 (전체 처리 현황)
            List<Map<String, Object>> statusList = dashboardOverallRepository.getOverallStatus();
            
            // 상태별 집계
            int completed = 0;
            int processing = 0;
            int received = 0;
            int rejected = 0;
            
            for (Map<String, Object> item : statusList) {
                String status = (String) item.get("STATUS");
                if (status == null) {
                    status = (String) item.get("status");
                }
                
                Object countObj = item.get("COUNT");
                if (countObj == null) {
                    countObj = item.get("count");
                }
                
                int count = 0;
                if (countObj != null) {
                    if (countObj instanceof Number) {
                        count = ((Number) countObj).intValue();
                    }
                }
                
                if ("완료".equals(status)) {
                    completed = count;
                } else if ("처리중".equals(status)) {
                    processing = count;
                } else if ("접수".equals(status)) {
                    received = count;
                } else if ("반려".equals(status)) {
                    rejected = count;
                }
            }
            
            // 도넛차트용 데이터
            Map<String, Object> statusChart = new HashMap<>();
            statusChart.put("labels", Arrays.asList("완료", "처리중", "접수", "반려"));
            statusChart.put("data", Arrays.asList(completed, processing, received, rejected));
            
            // 2. 구별 상세 현황 (테이블용)
            List<Map<String, Object>> districtList = dashboardOverallRepository.getDistrictDetails();
            
            // Oracle 대문자 키를 소문자로 변환
            List<Map<String, Object>> regionalDetails = new ArrayList<>();
            int rank = 1;
            for (Map<String, Object> item : districtList) {
                Map<String, Object> detail = new HashMap<>();
                detail.put("no", rank++);
                
                String district = (String) item.get("DISTRICT");
                if (district == null) district = (String) item.get("district");
                detail.put("district", district);
                
                Object reports = item.get("REPORTS");
                if (reports == null) reports = item.get("reports");
                detail.put("reports", reports);
                
                Object rate = item.get("RATE");
                if (rate == null) rate = item.get("rate");
                detail.put("rate", rate);
                
                Object avgTime = item.get("AVGTIME");
                if (avgTime == null) avgTime = item.get("avgtime");
                detail.put("avgTime", avgTime);
                
                regionalDetails.add(detail);
            }
            
            result.put("statusChart", statusChart);
            result.put("regionalDetails", regionalDetails);
            
            logger.info("지역별 포트홀 신고현황 조회 완료");
            
        } catch (Exception e) {
            logger.error("지역별 포트홀 신고현황 조회 실패", e);
            
            // 오류 시 빈 데이터 반환
            Map<String, Object> emptyChart = new HashMap<>();
            emptyChart.put("labels", Arrays.asList("완료", "처리중", "접수", "반려"));
            emptyChart.put("data", Arrays.asList(0, 0, 0, 0));
            
            result.put("statusChart", emptyChart);
            result.put("regionalDetails", new ArrayList<>());
        }
        
        return result;
    }
}