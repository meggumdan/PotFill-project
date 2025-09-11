package com.potfill.admin.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
   
        HttpSession session = request.getSession();

    
        if (session.getAttribute("adminInfo") == null) {
            
            System.out.println(">> 미인증 사용자 요청");
           
            response.sendRedirect(request.getContextPath() + "/admin/login");
            
            
            return false;
        }
        
      
        return true;
    }
}