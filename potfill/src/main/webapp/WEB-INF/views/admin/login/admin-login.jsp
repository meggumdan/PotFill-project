<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link href="${pageContext.request.contextPath}/css/admin-login/admin-login.css" rel="stylesheet"  type="text/css"/>
</head>
<body>
    <div class="login-container">
        <h1 class="login-title">로그인</h1>
        
        <form class="login-form" method="post" action="${pageContext.request.contextPath}/admin/login">
            <div class="input-group">
                <input type="text" class="input-field" placeholder="username" name="loginId" required>
            </div>
            
            <div class="input-group password-container">
                <input type="password" class="input-field" id="password" name="adminPw" placeholder="password" required>
                <button type="button" class="show-password" onclick="togglePassword()">
                    <span id="eye-icon">👁</span>
                </button>
            </div>
            
            <button type="submit" class="login-button">로그인</button>
        </form>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('eye-icon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.textContent = '🙈';
            } else {
                passwordField.type = 'password';
                eyeIcon.textContent = '👁';
            }
        }

        // 폼 제출 처리
        document.querySelector('.login-form').addEventListener('submit', function(e) {
/*             if(${message} != null ){
	        	e.preventDefault();
	            alert(${message});
            } */
        });

        // 엔터키로 로그인
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.querySelector('.login-button').click();
            }
        });
    </script>
</body>
</html>