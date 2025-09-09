package com.potfill.user.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UserMainController {
	
	//	임시로 메인 == 유저메인
	@GetMapping("/user")
    public String home() {
		
        return "/user/main";
    }
	
	
	// 신고화면 
	@GetMapping("/user/complaint")
	public String complaint() {
		
		return "user/complaint";
	}
	
	
	// 실시간 포트홀 지도
	@GetMapping("/user/potholemap")
	public String potholemap() {
		
		return "user/potholemap";
	}

	// 나의 신고
	@GetMapping("/user/mycomplaint")
	public String mycomplaint() {
		
		return "user/mycomplaint";
	}

}

