<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/css/user/component.css">

	<link rel="stylesheet" type="text/css"
		href="${pageContext.request.contextPath}/css/user/complaint-complete.css">

	<script
		src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
	<title>POTFill</title>
</head>
	<body>
	
		<!-- 젤 큰 영역 -->
		<div class="container">

			<!-- 헤더 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/header.jsp" %>

			<!-- 본문 -->
			<div class="content">
				<!-- 체크 애니메이션 -->
				<div class="check-area">
					<img src="<c:url value='/images/check.png'/>" alt="완료 체크" class="check-gif">
				</div>

				<!-- 안내 문구 -->
				<div class="message">
					<p class="point">신고가 정상적으로 접수 되었습니다.</p>
					<p>포트홀이 빠르게 처리될 수 있도록 노력하겠습니다.</p>
				</div>

				<!-- 버튼 영역 -->
				<div class="btn-area">
					<a href="<c:url value='/user/complaint'/>" class="btn">추가 신고하기</a>
					<a href="<c:url value='/user/complaint/list'/>" class="btn">나의 신고 현황</a>
				</div>
			</div>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>

		</div>
	</body>
</html>