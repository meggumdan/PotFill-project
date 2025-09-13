<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/user/main.css'/>">
		<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
		<title>POTFill</title>
	</head>
	<body>
	
		<!-- 젤 큰 영역 -->
		<div class="container">
			
			<!--  인트로 -->
			<div id="intro" class="logo-box">
				<h1 class="logo">POTFill</h1>
			</div>
			
			<!-- 메인 메뉴 -->
			<div id="menu" class="menu-box hidden">
				<ul>
					<li><a href="<c:url value='/user/complaint' />">포트홀 신고하기</a></li>
					<li><a href="<c:url value='/user/map' />">포트홀 실시간</a></li>
					<li><a href="<c:url value='/user/complaint/list' />">나의 신고 현황</a></li>
					<li><a href="<c:url value='' />">포트홀 신고 안내</a></li>
				</ul>
			</div>
			
		</div>
		
		
		<script>
			$(document).ready(function(){
				
				
				// 메인 시작 효과
				setTimeout(function(){
					
					// 배경 흰색으로 
					$('.container').css('background-color' , '#F5F5F7');
					// 로고 효과
					$("#intro").addClass("move-up");
					// 메뉴 표시
					$("#menu").removeClass("hidden").addClass("show");
				},1000);
			});
		</script>
		
	</body>
</html>