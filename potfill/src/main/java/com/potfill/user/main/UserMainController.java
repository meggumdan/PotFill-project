/*
 * 작성자 : 정소영
 * 설명   : 사용자 메인 화면에서 각 메뉴로 이동을 처리하는 컨트롤러
 */
package com.potfill.user.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UserMainController {
	
	//	유저 메인
	@GetMapping()
    public String home() {
		
        return "/user/main";
    }
	
	
	// 신고 화면
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


	// 포트홀 신고 안내 페이지 이동
	@GetMapping("/manual")
	public String complaintManual() {

		return "user/user-manual";
	}
}

