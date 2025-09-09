<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>일반 관리자 페이지~~</h1>
	
	<ul>
	    <li>login_id: ${adminInfo.loginId}</li>
	    <li>admin_name: ${adminInfo.adminName}</li>
	    <li>email: ${adminInfo.email}</li>
	    <li>phone: ${adminInfo.phone}</li>
	    <li>district_code: ${adminInfo.districtCode}</li>
	    <li>admin_role: ${adminInfo.adminRole}</li>
	</ul>
	<button><a href="${pageContext.request.contextPath}/admin/logout">로그아웃</a></button>
	
</body>
</html>