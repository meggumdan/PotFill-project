/*
 * 작성자 : 김슬기
 * 작성일 : 2025.09.09
 
 
 쪼꼼만 건들게요~  -메꿈4-
 */
package com.potfill.admin.login.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.potfill.admin.login.model.Login;
import com.potfill.admin.login.model.LoginAdminInfo;
import com.potfill.admin.login.service.LoginService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	final Integer ROLE_ZERO = 0;
	
	@Autowired
	LoginService loginService;
	
	@GetMapping(value = "admin/login")
	public String login() {
		return "admin/login/admin-login";
	}
	
	@PostMapping(value = "admin/login")
	public String login(Login login, Model model, HttpServletRequest request) {
		System.out.println(login.getLoginId() + ", " + login.getAdminPw());
		LoginAdminInfo adminInfo = loginService.checkCredentials(login);
		if(adminInfo == null) {
			model.addAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "redirect:admin/login";
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("adminInfo", adminInfo);
			
			return "redirect:/admin/dashboard";
		}
		
	}
	
	
    @GetMapping("admin/logout")
    public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        // 세션 무효화
        if (session != null) {
            session.invalidate();
        }

        // JSESSIONID 쿠키 삭제
        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);

        return "redirect:/admin/login"; // 로그인 페이지로 이동
    }
}
