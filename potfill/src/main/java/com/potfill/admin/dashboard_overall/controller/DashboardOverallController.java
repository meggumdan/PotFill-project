package com.potfill.admin.dashboard_overall.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin")
public class DashboardOverallController {
    
    private static final Logger logger = LoggerFactory.getLogger(DashboardOverallController.class);
    
    /**
     * 관리자 대시보드 메인 페이지
     * URL: http://localhost:8080/potfill/admin/dashboard
     * JSP 파일: src/main/webapp/WEB-INF/views/admin/dashboard_overall/dashboard-overall.jsp
     */
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String dashboard(Model model) {
        logger.info("관리자 대시보드 접근");
        model.addAttribute("pageTitle", "대시보드 전체");
        
        // 폴더명: dashboard_overall, 파일명: dashboard-overall.jsp
        return "admin/dashboard_overall/dashboard-overall";
    }
    
    /**
     * 관리자 테스트 페이지
     */
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String adminTest(Model model) {
        logger.info("관리자 테스트 페이지 접근");
        model.addAttribute("message", "관리자 페이지 연결 테스트 성공!");
        return "admin/test";
    }
    
    /**
     * KPI 데이터 API
     */
    @RequestMapping(value = "/api/dashboard/kpi", method = RequestMethod.GET)
    @ResponseBody
    public String getKPIData() {
        logger.info("KPI 데이터 API 호출");
        
        String jsonResponse = "{" +
            "\"totalReports\": 1247," +
            "\"processingReports\": 89," +
            "\"completedReports\": 1158," +
            "\"dangerZones\": 23," +
            "\"trends\": {" +
                "\"totalReports\": \"+127(12%)\"," +
                "\"processingReports\": \"-5(-5%)\"," +
                "\"completedReports\": \"+132(13%)\"," +
                "\"dangerZones\": \"+3(15%)\"" +
            "}" +
        "}";
        
        return jsonResponse;
    }
    
    /**
     * 우선처리 지역 TOP 5 데이터 API
     */
    @RequestMapping(value = "/api/dashboard/priority", method = RequestMethod.GET)
    @ResponseBody
    public String getPriorityRegionsData() {
        logger.info("우선처리 지역 TOP 5 데이터 API 호출");
        
        String jsonResponse = "[" +
            "{\"rank\": 1, \"region\": \"강남구 역삼동\", \"pending\": 15, \"maxDays\": 7, \"repeat\": 3, \"majorLocation\": true, \"score\": 94.2}," +
            "{\"rank\": 2, \"region\": \"서초구 방배동\", \"pending\": 12, \"maxDays\": 14, \"repeat\": 8, \"majorLocation\": true, \"score\": 87.5}," +
            "{\"rank\": 3, \"region\": \"마포구 상암동\", \"pending\": 8, \"maxDays\": 6, \"repeat\": 7, \"majorLocation\": false, \"score\": 85.1}," +
            "{\"rank\": 4, \"region\": \"광진구 화양동\", \"pending\": 6, \"maxDays\": 5, \"repeat\": 10, \"majorLocation\": true, \"score\": 79.7}," +
            "{\"rank\": 5, \"region\": \"종로구 혜화동\", \"pending\": 5, \"maxDays\": 9, \"repeat\": 2, \"majorLocation\": false, \"score\": 70.8}" +
        "]";
        
        return jsonResponse;
    }
    
    /**
     * 지역별 우선도 랭킹 데이터 API
     */
    @RequestMapping(value = "/api/dashboard/ranking", method = RequestMethod.GET)
    @ResponseBody
    public String getRegionRankingData() {
        logger.info("지역별 우선도 랭킹 데이터 API 호출");
        
        String jsonResponse = "{" +
            "\"labels\": [\"강남구\", \"서초구\", \"마포구\", \"송파구\", \"영등포구\", \"용산구\", \"종로구\", \"중구\", \"성동구\", \"광진구\"]," +
            "\"data\": [87.5, 78.3, 75.1, 68.9, 68.2, 65.4, 58.7, 52.3, 48.1, 42.5]" +
        "}";
        
        return jsonResponse;
    }
    
    /**
     * 지역별 포트홀 신고현황 데이터 API
     */
    @RequestMapping(value = "/api/dashboard/regional", method = RequestMethod.GET)
    @ResponseBody
    public String getRegionalStatusData() {
        logger.info("지역별 포트홀 신고현황 데이터 API 호출");
        
        String jsonResponse = "{" +
            "\"statusChart\": {" +
                "\"labels\": [\"완료\", \"처리중\", \"미처리\"]," +
                "\"data\": [1158, 89, 223]" +
            "}," +
            "\"regionalDetails\": [" +
                "{\"no\": 1, \"district\": \"종로구\", \"reports\": 127, \"rate\": 92, \"avgTime\": 7.2}," +
                "{\"no\": 2, \"district\": \"은평구\", \"reports\": 111, \"rate\": 89, \"avgTime\": 7.1}," +
                "{\"no\": 3, \"district\": \"강북구\", \"reports\": 108, \"rate\": 76, \"avgTime\": 6.7}," +
                "{\"no\": 4, \"district\": \"강서구\", \"reports\": 96, \"rate\": 75, \"avgTime\": 5.9}," +
                "{\"no\": 5, \"district\": \"광진구\", \"reports\": 89, \"rate\": 73, \"avgTime\": 5.5}" +
            "]" +
        "}";
        
        return jsonResponse;
    }
}