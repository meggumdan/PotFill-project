package com.potfill.admin.district.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.potfill.admin.district.service.DistrictService;
import com.potfill.admin.login.model.LoginAdminInfo;

import jakarta.servlet.http.HttpSession;

@Controller
public class ManagerDistrictController {

	private final DistrictService districtService;

	@Autowired
	public ManagerDistrictController(DistrictService districtService) {
		this.districtService = districtService;
	}

	@GetMapping("/admin/district")
	public String managerDistrict(Model model, HttpSession session) {
		// 세션에서 adminInfo 꺼내오기
		LoginAdminInfo adminInfo = (LoginAdminInfo) session.getAttribute("adminInfo");

		// 로그인 안 되어 있으면 서비스 호출 없이 바로 리다이렉트
		if (adminInfo == null) {
			return "redirect:/admin/login";
		}

		// 로그인 되어 있을 때만 districtCode 사용
		String districtCode = adminInfo.getDistrictCode();

		// 디버깅 로그
		System.out.println("로그인 ID: " + adminInfo.getLoginId());
		System.out.println("관리자 이름: " + adminInfo.getAdminName());
		System.out.println("관할구역 코드: " + districtCode);

		// districtCode 전달
		model.addAttribute("newCount", districtService.getNewCount(districtCode));
		model.addAttribute("processingCount", districtService.getProcessingCount(districtCode));
		model.addAttribute("completedCount", districtService.getCompletedCount(districtCode));
		model.addAttribute("dailyCounts", districtService.getDailyCounts(districtCode));
		model.addAttribute("emergencyList", districtService.getEmergencyList(districtCode));

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