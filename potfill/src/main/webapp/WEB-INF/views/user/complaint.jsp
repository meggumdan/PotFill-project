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
					<input type="hidden" id="locationConfirmed" name="locationConfirmed" value="N"><!-- ★ 추가 -->

					<!-- 위치 확인 영역 -->
					<div class="location-section">

						<!-- 지도 래퍼 -->
						<div class="map-wrap" style="width:285px; height:285px;">
							<div id="map" style="width:285px; height:265px;"></div>

							<!-- 지도 잠금 오버레이 -->
							<div id="map-lock" class="map-lock hidden" aria-hidden="true">
								<div class="map-lock-msg">
									<strong>신고 위치가 확정되었습니다.</strong><br>
									<span>
										위치를 다시 선택하려면 아래의 <br>
										<b>신고 위치 변경</b> 버튼을 눌러 주세요.
									</span>
								</div>
							</div>
						</div>

						<label>포트홀 위치 <span class="required">*</span></label>
						<input type="text" id="place" name="incidentAddress" readonly>

						<div class="button-box">
							<button type="button" id="check-btn">신고 위치 중복 확인</button>
							<button type="button" id="change-loc-btn" class="hidden">신고 위치 변경</button>
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

							<!-- 썸네일/플러스 버튼이 들어갈 리스트 -->
							<div id="photoList" class="photo-list" aria-live="polite"></div>

							<!-- 실제 파일 input들이 들어가는 곳(숨김) -->
							<div id="fileInputs" style="display:none;"></div>
						</div>

						<div class="submit-box">
							<!-- 제출 버튼 (JS가 enable/disable 제어) -->
							<button type="submit" class="submit-btn" disabled>신고 하기</button>
						</div>
					</div>
				</form>
			</div>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>
		</div>
		
		<script>
			$(document).ready(function () {

				// ===== 내부 상태 =====
				let isLocationOK = false; // 신고 가능한 위치가 최종 확정되었는지 확인
				const $extra = $("#extra-section");
				const $submit = $(".submit-btn");

				// ===== 공통 유틸 =====
				function lockMap() {
					map.setDraggable(false);
					map.setZoomable(false);
					if (map.setKeyboardShortcuts) map.setKeyboardShortcuts(false);
					$("#map-lock").removeClass("hidden").addClass("show");
				}
				function unlockMap() {
					map.setDraggable(true);
					map.setZoomable(true);
					if (map.setKeyboardShortcuts) map.setKeyboardShortcuts(true);
					$("#map-lock").removeClass("show").addClass("hidden");
				}
				function setExtraEnabled(enabled) {
					// 보이기/숨김은 별도, 여기선 입력 가능 여부만
					$extra.toggleClass("disabled", !enabled);
					$extra.find("input, textarea, select, button").prop("disabled", !enabled);
					// 제출 버튼은 아래 updateSubmitState가 최종 통제
				}
				function updateSubmitState() {
					// 위치 OK일 때만 제출 가능
					$submit.prop("disabled", !isLocationOK);
				}
				function setLocationFlag(ok) {
					isLocationOK = !!ok;
					$("#locationConfirmed").val(ok ? "Y" : "N");
					updateSubmitState();
				}

				// ===== 초기 상태 =====
				setLocationFlag(false);
				setExtraEnabled(false); // 폼은 처음엔 비활성(숨김이기도 함)
				$("#change-loc-btn").addClass("hidden");
				$("#check-btn").removeClass("hidden");

				// ===== 연락처 숫자만 =====
				$("#phonenumber").on("input", function () {
					this.value = this.value.replace(/[^0-9]/g, "");
				});

				// ===== 중복 확인 =====
				$("#check-btn").off("click").on("click", function () {
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
								alert("이미 신고된 위치입니다");

								// 서버에 카운트 +1
								$.ajax({
									url: "<c:url value='/user/complaint/duplicate-hit'/>",
									type: "POST",
									contentType: "application/json; charset=UTF-8",
									data: JSON.stringify({ lat, lon })
								}).always(function(){ /* 실패해도 UI 흐름 유지 */ });

								// 폼은 닫고(또는 그대로) / 지도는 활성 상태 유지
								$extra.removeClass("show").addClass("hidden");
								setExtraEnabled(false);
								setLocationFlag(false);
								unlockMap();
								$("#change-loc-btn").addClass("hidden");
								$("#check-btn").removeClass("hidden");
							} else {
								// === 1번 상황(OK) 또는 3번 마지막 스텝(재확정) ===
								alert("신고 가능한 위치입니다.");

								// 지도 잠금 + 폼 표시/활성 + 제출 가능
								lockMap();
								$extra.removeClass("hidden").addClass("show");
								setExtraEnabled(true);
								setLocationFlag(true);

								// 버튼 토글
								$("#check-btn").addClass("hidden");
								$("#change-loc-btn").removeClass("hidden");
							}
						},
						error: function (xhr) {
							console.error("status=", xhr.status, "body=", xhr.responseText);
							alert("위치 확인 중 오류가 발생했습니다.");
						}
					});
				});

				// ===== 위치 변경 (시나리오 3 중간 단계) =====
				$("#change-loc-btn").off("click").on("click", function () {
					// 지도 풀고, 입력폼은 보이되 비활성(값은 유지)
					unlockMap();
					setExtraEnabled(false);

					// 재확정 필요 → 제출 불가
					setLocationFlag(false);

					// 버튼 토글
					$("#change-loc-btn").addClass("hidden");
					$("#check-btn").removeClass("hidden");
				});

				// ===== 제출 가드: OK 아닌 상태면 막기 =====
				$("form").off("submit").on("submit", function (e) {
					if (!isLocationOK) {
						e.preventDefault();
						alert("신고 가능 위치 확인 후에만 제출할 수 있습니다.");
						return false;
					}
				});

				// ====== 이미지 첨부(그대로 사용) ======
				(function initPhotoPicker(){
					const MAX_PHOTOS = 3;
					const ALLOWED_TYPES = ["image/jpeg","image/png","image/webp","image/heic","image/heif"];
					const MAX_SIZE_MB = 10;

					const $photoList = $("#photoList");
					const $fileInputsWrap = $("#fileInputs");

					window.renderSlots = renderSlots; // 초기화 버튼 등에서 재사용할 수 있게 노출
					renderSlots();

					function renderSlots() {
						$photoList.empty();
						const count = $fileInputsWrap.find('input[type="file"]').length;

						$fileInputsWrap.find('input[type="file"]').each(function () {
							const id = $(this).attr("id");
							const file = this.files && this.files[0];
							const $slot = $('<div class="photo-slot"></div>');

							if (file) {
								const url = URL.createObjectURL(file);
								const $img = $('<img class="photo-thumb">').attr("src", url);
								const $rm = $('<button type="button" class="remove-btn">×</button>');
								$rm.on("click", function () {
									$('#' + id).remove();
									renderSlots();
								});
								$slot.append($img).append($rm);
							}
							$photoList.append($slot);
						});

						if (count < MAX_PHOTOS) {
							const $add = $('<div class="photo-slot add" title="사진 추가"></div>');
							$add.on("click", handleAddClick);
							$photoList.append($add);
						}
					}

					function handleAddClick() {
						const count = $fileInputsWrap.find('input[type="file"]').length;
						if (count >= MAX_PHOTOS) { alert("이미지는 최대 " + MAX_PHOTOS + "장까지 첨부할 수 있습니다."); return; }

						const id = "photoInput_" + Date.now();
						const $inp = $('<input>', {
							type: "file", id, name: "photoFiles",
							accept: "image/*", capture: "environment"
						});

						$inp.on("change", function (e) {
							const file = e.target.files && e.target.files[0];
							if (!file) { $(this).remove(); return; }
							if (!ALLOWED_TYPES.includes(file.type)) { alert("JPG/PNG/WEBP(또는 HEIC/HEIF)만 업로드할 수 있습니다."); $(this).remove(); return; }
							if (file.size > MAX_SIZE_MB * 1024 * 1024) { alert("각 파일은 최대 " + MAX_SIZE_MB + "MB까지 업로드할 수 있습니다."); $(this).remove(); return; }
							renderSlots();
						});

						$fileInputsWrap.append($inp);
						$inp.trigger("click");
					}
				})();
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