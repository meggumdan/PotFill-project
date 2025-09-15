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
	href="${pageContext.request.contextPath}/css/user/manual.css">

<title>POTFill - 신고 안내</title>
<style>
</style>
</head>
<body>
	<div class="container">

		<!-- 헤더 Include -->
		<%@ include file="/WEB-INF/views/user/user_component/header.jsp"%>

		<!-- 설명 -->
		<div class="top">
			<h3>포트홀 신고 안내</h3>
			<p>아래에 절차에 맞게 작성해주세요.</p>
		</div>

		<div class="manual-content-bg">
			<!-- 안내 본문 -->
			<div class="manual-content">
				<div class="img-wrapper">
					<h4>1. 포트홀 발생 위치 선택</h4>
					<p>지도를 직접 드래그&클릭 해서 포트홀이 발생한 위치를 선택해주세요.</p>
					<div class="highlight-box circle square">
						<img
							src="${pageContext.request.contextPath}/images/select-map.png"
							alt="위치 선택" class="img-area img-center">
					</div>
				</div>

				<div>
					<h4>2. 신고 위치 중복 확인</h4>
					<p>이미 접수된 포트홀에 대해서는 신고할 수 없습니다.</p>
					<img src="${pageContext.request.contextPath}/images/distinct.png"
						alt="위치 선택" class="img-area img-center">
				</div>

				<div>
					<h4>3. 민원인 정보 입력</h4>
					<p class="small-font">「민원 처리에 관한 법률」 제17조(민원의 신청)에 따라 민원인은 신청서에
						성명, 주소 등 필요한 사항을 기재하여 제출해야 합니다.</p>
					<img src="${pageContext.request.contextPath}/images/fill-form.png"
						alt="위치 선택" class="img-area img-center">
				</div>

				<div>
					<h4>4. 사진 첨부(선택)</h4>
					<p>최대 3장까지 첨부 가능합니다.</p>
					<img
						src="${pageContext.request.contextPath}/images/select-photo.png"
						alt="위치 선택" class="img-area img-center">
				</div>
			</div>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp"%>

		</div>
	</div>
</body>
</html>
