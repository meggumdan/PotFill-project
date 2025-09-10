package com.potfill.admin.district.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.potfill.admin.district.service.DistrictService;

import jakarta.servlet.http.HttpSession;


@Controller
public class ManagerDistrictController {

    private final DistrictService districtService;

    @Autowired
    public ManagerDistrictController(DistrictService districtService) {
        this.districtService = districtService;
    }

    @GetMapping("/admin/district")
    public String managerDistrict(Model model) {
        model.addAttribute("newCount", districtService.getNewCount());
        model.addAttribute("processingCount", districtService.getProcessingCount());
        model.addAttribute("completedCount", districtService.getCompletedCount());
        model.addAttribute("dailyCounts", districtService.getDailyCounts());
        model.addAttribute("emergencyList", districtService.getEmergencyList());

        return "admin/district/district";
    }
    
    @PostMapping("/admin/complaints/setSession")
    public String setComplaintSession(@RequestParam("id") Long id, HttpSession session) {
        // 세션에 클릭한 민원 ID 저장
        session.setAttribute("selectedComplaintId", id);

        // 민원 조회 페이지로 redirect
        return "redirect:/admin/complaints/list";
    }
}