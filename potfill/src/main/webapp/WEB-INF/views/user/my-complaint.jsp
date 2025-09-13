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
		href="${pageContext.request.contextPath}/css/user/my-complaint.css">

	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

	<title>POTFill</title>
</head>
	<body>
	
		<!-- 젤 큰 영역 -->
		<div class="container">

			<!-- 헤더 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/header.jsp" %>
			
			<!-- 입력 폼: 결과가 없을 때만 노출 -->
			<c:if test="${empty complaints}">
			
				<!-- 설명  -->
				<div class="explain">
					<h3>신고 조회하기</h3>
					<p>나의 신고 내역을 조회할 수 있습니다.</p>
				</div>
				
				<!-- 입력 폼  -->
				<div class="complaint-form">
					<form action="<c:url value='/user/complaint/list'/>" method="post"
						enctype="multipart/form-data">
						<div>
							<label>성명 <span class="required">*</span></label> <input
								type="text" id="name" name="reporterName" required>
						</div>
	
						<div>
							<label>연락처 <span class="required">*</span></label> <input
								type="text" id="phonenumber" name="reporterNumber"
								placeholder="-없이 입력해주세요" required>
						</div>
	
						<div>
							<button type="submit" class="submit-btn">조회 하기</button>
						</div>
					</form>
				</div>
			</c:if>
	
			<c:if test="${not empty complaints}">
				<div class="explain">
					<h3>내 신고 조회 결과</h3>
				</div>
				
				<div class="complaint-list">
					<c:forEach var="c" items="${complaints}">
						<div class="complaint-card">
							<!-- 진행 상태 -->
							<div class="status">
								<div
									class="status-step ${complaint.status eq '접수' ? 'active' : ''}">접수</div>
								<div
									class="status-step ${complaint.status eq '처리중' ? 'active' : ''}">처리중</div>
								<div
									class="status-step ${complaint.status eq '완료' ? 'active' : ''}">완료</div>
							</div>
	
							<!-- 상세 정보 -->
							<div class="complaint-info">
								<div>
									<span class="complaint-label">민원 번호</span>
									${c.complaintId}
								</div>
								<div>
									<span class="complaint-label">신고 위치</span>
									${c.incidentAddress}
								</div>
								<div>
									<span class="complaint-label">신고 일자</span>
									${c.createdAt}
								</div>
								<div>
									<span class="complaint-label">담당 기관</span>
									${c.assignedDepartment}
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>

		</div>
	</body>
</html>