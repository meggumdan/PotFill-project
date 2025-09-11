package com.potfill.user.complaint.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.service.UserComplaintService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/complaint")
public class UserComplaintController {

	private final UserComplaintService userComplaintService;

	// 신고 화면 이동
	@GetMapping
	public String complaint() {

		return "user/complaint";
	}
	
	// 신고 중복 확인
	@PostMapping("/check-duplicate")
	public Map<String, Object> checkDuplicate(@RequestBody Map<String, String> req) {
		String address = req.get("address");

		// 1. 주소 -> 위도/경도 변환 (예: 카카오 API)
		double[] coords = userComplaintService.getCoordinatesFromAddress(address);
		double lat = coords[0];
		double lon = coords[1];

		// 2. 중복 여부 확인 (H3)
		boolean duplicate = userComplaintService.isDuplicateLocation(lat, lon);

		return Map.of("duplicate", duplicate);
	}

	// 신고 내용 저장
	@PostMapping
	public String registerComplaint(Complaint complaint, 
			@RequestParam(value="photoFiles", required = false) List<MultipartFile> photoFiles) throws IOException {
		
		userComplaintService.saveComplaint(complaint, photoFiles);
		
		
		// 추후에 나의 신고 현황으로 바로가게 바꾸기
		// 연락처를 파라미터로 넘겨줌
	    // redirectAttributes.addAttribute("phone", complaint.getReporterNumber());
		// return "redirect:/user/complaints/status";
		return "redirect:/user/complaint"; 
	}
	
	// 나의 신고 화면 이동
	@GetMapping("/list")
	public String myComplaint() {

		return "user/my-complaint";
	}


	// 나의 신고 화면 이동
	@PostMapping("/list")
	public String getMyComplaint(@RequestParam String reporterName, @RequestParam String reporterNumber, Model model) throws IOException {

		List<Complaint> list = userComplaintService.findByNameAndPhone(reporterName, reporterNumber);
		model.addAttribute("complaints", list);
		model.addAttribute("inputName", reporterName);
		model.addAttribute("inputPhone", reporterNumber);

		return "user/my-complaint";
	}
	
	
	
	
	

}
