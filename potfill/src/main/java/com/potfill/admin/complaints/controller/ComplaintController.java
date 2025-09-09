package com.potfill.admin.complaints.controller;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.potfill.admin.complaints.service.ComplaintService;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
@Controller
@RequestMapping("/admin/complaints")
public class ComplaintController {
    
    @Autowired
    private ComplaintService complaintService;
    
    /**
     * 민원 관리 메인 페이지
     */
    @GetMapping("/list")
    public String complaintList(Model model) {
        return "admin/complaints/list";
    }
    
    /**
     * 민원 리스트 AJAX 조회
     */
    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> getComplaintList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "pageSize", defaultValue = "20") int pageSize,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "riskLevel", required = false) String riskLevel,
            @RequestParam(value = "gu", required = false) String gu,
            @RequestParam(value = "dong", required = false) String dong,
            @RequestParam(value = "sortBy", defaultValue = "created_at") String sortBy,
            @RequestParam(value = "sortOrder", defaultValue = "DESC") String sortOrder,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            HttpSession session) {
        
        Map<String, Object> searchParams = new HashMap<>();
        searchParams.put("page", page);
        searchParams.put("pageSize", pageSize);
        searchParams.put("searchType", searchType);
        searchParams.put("searchKeyword", searchKeyword);
        searchParams.put("status", status);
        searchParams.put("riskLevel", riskLevel);
        searchParams.put("gu", gu);
        searchParams.put("dong", dong);
        searchParams.put("sortBy", sortBy);
        searchParams.put("sortOrder", sortOrder);
        searchParams.put("startDate", startDate);
        searchParams.put("endDate", endDate);
        
        // 세션에서 관리자 정보 가져오기 (필요시)
        // Long adminId = (Long) session.getAttribute("adminId");
        // searchParams.put("adminId", adminId);
        
        Map<String, Object> response = new HashMap<>();
        try {
            Map<String, Object> result = complaintService.getComplaintListWithPaging(searchParams);
            response.put("success", true);
            response.put("data", result);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "민원 데이터를 불러올 수 없습니다.");
            e.printStackTrace();
        }
        
        return response;
    }
    
    /**
     * 민원 상세 정보 AJAX 조회
     */
    @GetMapping("/api/detail/{complaintId}")
    @ResponseBody
    public Map<String, Object> getComplaintDetail(@PathVariable Long complaintId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Map<String, Object> detail = complaintService.getComplaintDetail(complaintId);
            if (detail != null) {
                response.put("success", true);
                response.put("data", detail);
            } else {
                response.put("success", false);
                response.put("message", "해당 민원 정보를 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "민원 상세 정보를 불러올 수 없습니다.");
            e.printStackTrace();
        }
        
        return response;
    }
    
    /**
     * 민원 상태 변경 (간단 변경)
     */
    @PostMapping("/api/status")
    @ResponseBody
    public Map<String, Object> updateStatus(
            @RequestParam Long complaintId,
            @RequestParam String status,
            @RequestParam(required = false) String comment,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 세션에서 관리자 ID 가져오기
            Long adminId = 1L; // 임시값, 실제로는 session.getAttribute("adminId")
            
            boolean success = complaintService.updateComplaintStatus(complaintId, status, comment, adminId);
            if (success) {
                response.put("success", true);
                response.put("message", "상태가 성공적으로 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "상태 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "잘못된 상태 변경 요청입니다.");
            e.printStackTrace();
        }
        
        return response;
    }
    
    /**
     * 민원 위험도 수정
     */
    @PostMapping("/api/risk")
    @ResponseBody
    public Map<String, Object> updateRiskLevel(
            @RequestParam Long complaintId,
            @RequestParam String riskLevel) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            boolean success = complaintService.updateComplaintRisk(complaintId, riskLevel);
            if (success) {
                response.put("success", true);
                response.put("message", "위험도가 성공적으로 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "위험도 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "위험도 값이 유효하지 않습니다.");
            e.printStackTrace();
        }
        
        return response;
    }
    
    /**
     * 민원 위치 수정
     */
    @PostMapping("/api/location")
    @ResponseBody
    public Map<String, Object> updateLocation(
            @RequestParam Long complaintId,
            @RequestParam Double lat,
            @RequestParam Double lon,
            @RequestParam String address) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            boolean success = complaintService.updateComplaintLocation(complaintId, lat, lon, address);
            if (success) {
                response.put("success", true);
                response.put("message", "위치가 성공적으로 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "위치 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "유효하지 않은 좌표입니다.");
            e.printStackTrace();
        }
        
        return response;
    }
    
    
    /**
     * 민원 목록 엑셀 내보내기
     */
    @GetMapping("/export")
    public void exportComplaintsToExcel(
            HttpServletResponse response,
            // JavaScript에서 보낸 모든 파라미터를 받습니다.
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
            @RequestParam(value = "status", required = false) String status,
            // JSP의 필터 ID는 riskFilter지만, API에서는 riskLevel로 사용하고 있으므로 맞춰줍니다.
            @RequestParam(value = "risk", required = false) String riskLevel, 
            @RequestParam(value = "gu", required = false) String gu,
            @RequestParam(value = "dong", required = false) String dong,
            // JSP의 필터 ID는 sortFilter지만, API에서는 sortBy, sortOrder로 나눠서 사용합니다.
            @RequestParam(value = "sort", defaultValue = "created_at,DESC") String sort) {
        
        try {
            // 1. 파일 이름 및 HTTP 헤더 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
            String fileName = "민원_목록_" + sdf.format(new Date()) + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            // 2. 서비스에 넘길 검색 파라미터 맵 생성
            Map<String, Object> searchParams = new HashMap<>();
            searchParams.put("searchType", searchType);
            searchParams.put("searchKeyword", searchKeyword);
            searchParams.put("status", status);
            searchParams.put("riskLevel", riskLevel);
            searchParams.put("gu", gu);
            searchParams.put("dong", dong);

            // 정렬 파라미터 파싱 (예: "created_at,DESC")
            if (sort != null && !sort.isEmpty()) {
                String[] sortParams = sort.split(",");
                if (sortParams.length == 2) {
                    searchParams.put("sortBy", sortParams[0]);
                    searchParams.put("sortOrder", sortParams[1]);
                }
            }

            // 3. 서비스 레이어 호출하여 엑셀 파일 생성
            complaintService.exportComplaintsToExcel(searchParams, response.getOutputStream());

        } catch (IOException e) {
            // 엑셀 생성 중 오류 발생 시 처리
            e.printStackTrace();
            // 필요하다면 에러 페이지로 리다이렉트하거나 다른 처리를 할 수 있습니다.
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
}