<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/css/user/component.css">

	<link rel="stylesheet" type="text/css"
		href="${pageContext.request.contextPath}/css/user/my-complaint.css">

	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

	<title>POTFill</title>
</head>
	<body>
	
		<!-- 젤 큰 영역 -->
		<div class="container">

			<!-- 헤더 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/header.jsp" %>

			<%-- 결과 있음 --%>
			<c:if test="${not empty complaints}">
				<div class="explain">
					<h3>내 신고 조회 결과</h3>
					<p>신고 내역의 접수 상태를 확인 할 수 있습니다.</p>
				</div>

				<div class="complaint-list">
					<c:forEach var="c" items="${complaints}">
						<div class="complaint-card">
							<div class="status">
								<div class="status-step${c.status == 'RECEIVED' ? ' active' : ''}">접수</div>
								<div class="status-step${c.status == 'PROCESSING' ? ' active' : ''}">처리중</div>
								<div class="status-step${c.status == 'COMPLETED' ? ' active' : ''}">완료</div>
							</div>

							<div class="complaint-info">
								<div>
									<span class="complaint-label">민원 번호</span>
									<span>${c.complaintId}</span>
								</div>
								<div>
									<span class="complaint-label">신고 위치</span>
									<span>${c.incidentAddress}</span>
								</div>
								<div>
									<span class="complaint-label">신고 일자</span>
									<fmt:formatDate value="${c.createdAt}" pattern="yyyy-MM-dd"/>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>

			<%-- 결과 없음 & 검색함: 텍스트 + 홈 버튼 --%>
			<c:if test="${empty complaints and searched}">
				<div class="explain">
					<h3>신고 조회하기</h3>
					<p>신고 진행 상태를 확인할 수 있습니다.</p>
				</div>

				<div class="no-result-plain">
					해당 이름과 번호로 된 <br />
					신고 내역이 없습니다.
				</div>

				<div class="action-btns">
					<a class="btn-primary" href="<c:url value='/'/>">홈으로 가기</a>
				</div>
			</c:if>

			<%-- 초기 진입(검색 전): 폼 --%>
			<c:if test="${empty complaints and not searched}">
				<div class="explain">
					<h3>신고 조회하기</h3>
					<p>나의 신고 내역을 조회할 수 있습니다.</p>
				</div>

				<div class="complaint-form">
					<form action="<c:url value='/user/complaint/list'/>" method="post">
						<div>
							<label>성명 <span class="required">*</span></label>
							<input type="text" id="name" name="reporterName" required>
						</div>
						<div>
							<label>연락처 <span class="required">*</span></label>
							<input type="text" id="phonenumber" name="reporterNumber"
								   placeholder="-없이 입력해주세요" required>
						</div>
						<div>
							<button type="submit" class="submit-btn">조회 하기</button>
						</div>
					</form>
				</div>
			</c:if>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>

		</div>
	</body>
</html>