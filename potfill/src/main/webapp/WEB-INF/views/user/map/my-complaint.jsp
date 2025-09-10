<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/user/my-complaint.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<title>POTFill</title>
</head>
<body>

	<!-- 젤 큰 영역 -->
	<div class="container">
		<div class="header">
			<div id="intro" class="logo-small-box">
				<h1 class="logo">POTFill</h1>
			</div>
		</div>

		<!-- 설명  -->
		<div class="explain">
			<h3>신고 조회하기</h3>
			<p>나의 신고 내역을 조회할 수 있습니다.</p>
		</div>


		<!-- 입력 폼: 결과가 없을 때만 노출 -->
		<c:if test="${empty complaints}">
			<!-- 입력 폼  -->
			<div class="complaint-form">
				<form action="<c:url value='/user/complaint/lookup'/>" method="post"
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

					<div class="submit-box">
						<button type="submit" class="submit-btn">조회 하기</button>
					</div>
				</form>
			</div>
		</c:if>

		<c:if test="${not empty complaints}">
			<h3>조회 결과</h3>
			<table>
				<tr>
					<th>ID</th>
					<th>주소</th>
					<th>내용</th>
					<th>날짜</th>
				</tr>
				<c:forEach var="c" items="${complaints}">
					<tr>
						<td>${c.complaintId}</td>
						<td>${c.incidentAddress}</td>
						<td>${c.description}</td>
						<td>${c.createdAt}</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>

	</div>
</body>
</html>