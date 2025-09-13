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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.potfill.user.complaint.model.Complaint;
import com.potfill.user.complaint.service.UserComplaintService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/complaint")
public class UserComplaintController {

	private final UserComplaintService userComplaintService;

	
	// 신고 중복 확인
	@PostMapping("/check-duplicate")
	@ResponseBody
	public Map<String, Object> checkDuplicate(@RequestBody Map<String, String> req) {
		double lat = Double.parseDouble(req.get("lat"));
		double lon = Double.parseDouble(req.get("lon"));
		boolean duplicate = userComplaintService.isDuplicateLocation(lat, lon);
		return Map.of("duplicate", duplicate);
	}

	// 신고 내용 저장
	@PostMapping
	public String registerComplaint(Complaint complaint, @RequestParam(value="photoFiles", required = false) List<MultipartFile> photoFiles) throws IOException {

		if (complaint.getLat() != null && complaint.getLon() != null) {
			boolean dup = userComplaintService.isDuplicateLocation(complaint.getLat(), complaint.getLon());
			if (dup) {
				return "redirect:/user/complaint?duplicate=true";
			}
		}
		userComplaintService.saveComplaint(complaint, photoFiles);

		// 저장 완료 후 전용 페이지 보여주기
		return "user/complaint-complete";
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
