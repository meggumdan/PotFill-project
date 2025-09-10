package com.potfill.admin.managerdistrict.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.potfill.admin.managerdistrict.service.ComplaintService;

@Controller
public class ManagerDistrictController {

    private final ComplaintService complaintService;

    @Autowired
    public ManagerDistrictController(ComplaintService complaintService) {
        this.complaintService = complaintService;
    }

    //@RequestMapping(value = "/admin/managerdistrict", method = RequestMethod.GET)
    @GetMapping("/admin/managerdistrict")
    public String managerDistrict(Model model) {
        model.addAttribute("newCount", complaintService.getNewCount());
        model.addAttribute("processingCount", complaintService.getProcessingCount());
        model.addAttribute("completedCount", complaintService.getCompletedCount());
        model.addAttribute("dailyCounts", complaintService.getDailyCounts());
        model.addAttribute("emergencyList", complaintService.getEmergencyList());

        return "admin/managerdistrict/managerdistrict";
    }
}