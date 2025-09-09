<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/user/complaint.css'/>">
		<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
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
				<h3>포트홀 신고하기</h3>
				<p>도로에 발생한 포트홀을 신고해 주세요.</p>
			</div>
			
			
			<!-- 입력 폼  -->
			<div class="complaint-form">
				<div>
					<label>성명 <span class="required">*</span></label>
					<input type="text" id="name" required>
				</div>
				
				<div>
					<label>연락처 <span class="required">*</span></label>
					<input type="nunmber" id="phonenumber" placeholder="-없이 " required>
				</div>
				
				<div>
					<label>포트홀 위치 <span class="required">*</span></label>
					<input type="text" id="place" required>
					
					<div class="button-box">
						<button>현재 위치 저장</button>
						<button>위치 검색</button>
					</div>
				</div>

				<div class="photo-section">
					<label>포트홀 사진</label>
					<p>사진이 있으면 신속한 처리에 도움이 됩니다.</p>
	
					<div class="photo-box">
						<!-- 첨부된 사진 미리보기 -->
						<%-- <div class="photo-preview">
							<img id="previewImg" src="<c:url value='/images/default.png'/>"
								alt="사진 미리보기">
						</div> --%>
	
						<!-- 업로드 버튼 -->
						<label for="fileInput" class="photo-upload"></label> 
						<input type="file" id="fileInput" accept="image/*" style="display: none;">
					</div>
				</div>

		</div>
			
			
			
			
			
			
			
		</div>
		
	</body>
</html>