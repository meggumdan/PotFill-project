<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/user/complaint.css'/>">
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
				<h3>포트홀 신고하기</h3>
				<p>도로에 발생한 포트홀을 신고해 주세요.</p>
			</div>
	
	
			<!-- 입력 폼  -->
			<div class="complaint-form">
				<form action="<c:url value='/user/complaint'/>" method="post" enctype="multipart/form-data">
					
					<!-- 테스트 -->
					<input type="hidden" id="lat" value="37.5665">
					<input type="hidden" id="lon" value="126.9780">
					
					<div>
						<label>포트홀 위치 <span class="required">*</span></label> <input type="text" id="place" name="incidentAddress" required>
						<div class="button-box">
							<button type="button" id="check-btn")>위치 중복 확인</button>
						</div>
					</div>
					
					<div>
						<label>성명 <span class="required">*</span></label> 
						<input type="text" id="name" name="reporterName" required>
					</div>
	
					<div>
						<label>연락처 <span class="required">*</span></label> 
						<input type="text" id="phonenumber" name="reporterNumber" placeholder="-없이 입력해주세요" required>
					</div>
	
					<div>
						<label>상세 설명 </label> 
						<input type="text" id="content" name="reportContent" placeholder="포트홀에  설명해 주세요." >
					</div>
	
					<div class="photo-section">
						<label>포트홀 사진</label>
						<p>사진이 있으면 신속한 처리에 도움이 됩니다.</p>
	
						<div class="photo-box">
							<label for="fileInput" class="photo-upload"></label> 
							<input type="file" id="fileInput" name="photoFiles" accept="image/*" style="display: none;">
							<input type="file" id="fileInput" name="photoFiles" accept="image/*" multiple style="display: none;">
						</div>
					</div>
	
					<div class="submit-box">
						<button type="submit" class="submit-btn">신고 하기</button>
					</div>
				</form>
			</div>
			</div>
	
	
		<script>
			$(document).ready(function() {
				$("#check-btn").click(function() {
					let address = $("#place").val();
	
					if (!address) {
						alert("주소를 입력해 주세요.");
						return;
					}
	
					$.ajax({
						  url: "<c:url value='/user/complaint/check-duplicate'/>",
						  type: "POST",
						  contentType: "application/json; charset=UTF-8",
						  dataType: "json",
						  data: JSON.stringify({ address: $("#incidentAddress").val() }),
						  success: function(res){
						    console.log("resp:", res);
						    alert(res.duplicate ? "이미 신고된 위치입니다." : "신고 가능한 위치입니다.");
						  },
						  error: function(xhr){
						    console.error("status=", xhr.status, "body=", xhr.responseText);
						    alert("위치 확인 중 오류가 발생했습니다.");
						  }
						});

				});
			});
			
			
			
			/* $.ajax({
			    url: "/user/complaint/check-duplicate",
			    type: "POST",
			    contentType: "application/json",
			    data: JSON.stringify({
			        address: $("#incidentAddress").val(),
			        lat: $("#lat").val(),
			        lon: $("#lon").val()
			    }),
			    success: function(res) {
			        alert(res.duplicate ? "이미 신고됨" : "신고 가능");
			    }
			}); */

		</script>
	</body>
</html>