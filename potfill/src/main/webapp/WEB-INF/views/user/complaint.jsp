<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@keyProps['kakao.js.apikey']" var="jsKey" />

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<link rel="stylesheet" type="text/css"
			  href="${pageContext.request.contextPath}/css/user/component.css">

		<link rel="stylesheet" type="text/css"
			  href="${pageContext.request.contextPath}/css/user/complaint.css">

		<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

		<title>POTFill</title>
	</head>
	<body>
		<!-- 젤 큰 영역 -->
		<div class="container">

			<!-- 헤더 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/header.jsp" %>
	
			<!-- 설명  -->
			<div class="explain">
				<h3>포트홀 신고하기</h3>
				<p>도로에 발생한 포트홀을 신고해 주세요.</p>
			</div>
	
	
			<!-- 입력 폼  -->
			<div class="complaint-form">
				<form action="<c:url value='/user/complaint'/>" method="post" enctype="multipart/form-data">
	
					<!-- 사용자에게 보이지 않는 값  -->
					<input type="hidden" id="lat" name="lat" value="">
					<input type="hidden" id="lon" name="lon" value="">
					<input type="hidden" id="gu" name="gu" value="">
					<input type="hidden" id="dong" name="dong" value="">

					<!-- 위치 확인 영역 -->
					<div class="location-section">
						<div id="map" style="width:285px; height:265px;"></div>
						<label>포트홀 위치 <span class="required">*</span></label>
						<input type="text" id="place" name="incidentAddress" readonly>
						<div class="button-box">
							<button type="button" id="check-btn">신고 위치 중복 확인</button>
						</div>
					</div>

					<!-- 추가 입력 영역 (처음엔 숨김) -->
					<div id="extra-section" class="extra-section hidden">
						<div>
							<label>성명 <span class="required">*</span></label>
							<input type="text" id="name" name="reporterName" required>
						</div>
						<div>
							<label>연락처 <span class="required">*</span></label>
							<input type="text" id="phonenumber" name="reporterNumber"
								   placeholder="-없이 입력해주세요" required
								   pattern="[0-9]+"
								   inputmode="numeric" maxlength="11">
						</div>
						<div>
							<label>상세 설명 </label>
							<input type="text" id="content" name="reportContent" placeholder="포트홀에 설명해 주세요.">
						</div>
						<div class="photo-section">
							<label>포트홀 사진</label>
							<p>사진이 있으면 신속한 처리에 도움이 됩니다.</p>
							<div class="photo-box">
								<label for="fileInput" class="photo-upload"></label>
								<input type="file" id="fileInput" name="photoFiles" accept="image/*" multiple style="display:none;">
							</div>
						</div>
						<div class="submit-box">
							<button type="submit" class="submit-btn">신고 하기</button>
						</div>
					</div>
				</form>
			</div>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>
		</div>
		
		<script>
			$(document).ready(function() {

				// 숫자만 허용
				$("#phonenumber").on("input", function() {
					this.value = this.value.replace(/[^0-9]/g, "");
				});

				// 위도 경도로 중복 위치 검사
				$("#check-btn").click(function () {
					const lat = $("#lat").val();
					const lon = $("#lon").val();
					if (!lat || !lon) { alert("지도를 클릭해 위치를 지정해 주세요."); return; }

					$.ajax({
						url: "<c:url value='/user/complaint/check-duplicate'/>",
						type: "POST",
						contentType: "application/json; charset=UTF-8",
						dataType: "json",
						data: JSON.stringify({ lat, lon }),
						success: function (res) {
							if (res.duplicate) {
								alert("이미 신고된 위치입니다.");
								// 폼 전체 숨기기
								$("#extra-section").removeClass("show").addClass("hidden");
							} else {
								alert("신고 가능한 위치입니다.");
								// 추가 입력란 애니메이션으로 표시
								$("#extra-section").removeClass("hidden").addClass("show");
								$("#check-btn").hide(); // 중복확인 버튼 숨기고 아래 입력만 보이게
							}
						},
						error: function (xhr) {
							console.error("status=", xhr.status, "body=", xhr.responseText);
							alert("위치 확인 중 오류가 발생했습니다.");
						}
					});
				});
			});

		</script>
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey }&libraries=services,clusterer"></script>
		<script>
			// 지도 생성
			const mapContainer = document.getElementById('map');
			const mapOption = {
			    center: new kakao.maps.LatLng(37.5642135, 127.0016985),
			    level: 3
			};
			const map = new kakao.maps.Map(mapContainer, mapOption);
	
			const imageName = 'location-me';
			const imageSrc = '${pageContext.request.contextPath}/images/' + imageName + '.gif';
			const imageSize = new kakao.maps.Size(40, 40);
			const imageOption = { offset: new kakao.maps.Point(20, 40) };
			const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
		</script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/user/map-complaint.js">
		</script>

	</body>
</html>