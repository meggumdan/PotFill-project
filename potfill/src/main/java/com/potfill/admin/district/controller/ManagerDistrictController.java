package com.potfill.admin.district.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.potfill.admin.district.service.DistrictService;

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
}