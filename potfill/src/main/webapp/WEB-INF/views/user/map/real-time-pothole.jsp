<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@keyProps['kakao.js.apikey']" var="jsKey" />

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/user/component.css">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/user/complaint.css'/>">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/map/user-map-style.css'/>">
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
				<h3>실시간 포트홀 현황</h3>
				<p>아직 보수되지 않은 포트홀이 지도에 표시됩니다.</p>
			</div>
			<div class="map-wrap">
				<div id="map" style="height:314px;"></div>
				<div class="content-wrap" id="content">
				</div>
			</div>

			<!-- 푸터 Include -->
			<%@ include file="/WEB-INF/views/user/user_component/footer.jsp" %>

		</div>
	
		<script type="text/javascript"
			src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey }&libraries=services,clusterer"></script>
		<script src="${pageContext.request.contextPath}/js/map/map-common.js?v=1"></script>
		<script>
			
			/* ---- 라벨 및 상수 선언 ---- */
		
			// 지도 최소 레벨
			const MAP_MIN_LEVEL = 8;

			// 클러스터 최소 레벨
			const CLUSTER_MIN_LEVEL = 6;
			
			// 지도 기본 좌표
			const DEFAULT_LAT_LNG = new kakao.maps.LatLng(37.5642135, 127.0016985);
		
			// 민원 처리 상태 라벨 번역
			const STATUS_LABELS = {
				RECEIVED: '접수',
				PROCESSING: '처리중',
				COMPLETED: '완료',
				REJECTED: '반려'
			};
		
			
			/* ---- 지도 생성 ---- */
			
			// 지도 생성
			var mapContainer = document.getElementById('map');
			var mapOption = {
				center: DEFAULT_LAT_LNG,
				level: MAP_MIN_LEVEL
			};
			var map = new kakao.maps.Map(mapContainer, mapOption);
		
			// 클러스터러 생성
			var clusterer = new kakao.maps.MarkerClusterer({
				map: map,
				averageCenter: true,
				minLevel: CLUSTER_MIN_LEVEL,
				disableClickZoom: true
			}); //clusterer end
		
			// 서버 데이터 -> positions 구성
			var positions = [];
			<c:forEach items="${holeList}" var="row">
				<c:if test="${not empty row['LAT'] and not empty row['LON']}">
					positions.push({
						latlng: new kakao.maps.LatLng(${row['LAT']}, ${row['LON']}),
					reportCount: ${row['REPORTCOUNT']},
					content: '', // 초기 내용 필요시 채우기
					status: PotfillMap.mapStatus('${row['STATUS']}', STATUS_LABELS, '접수')
							}); //positions.push end
				</c:if>
			</c:forEach>
		
			// 마커 이미지 공통 설정
			var imageSize = new kakao.maps.Size(40, 40);
			var imageOption = { offset: new kakao.maps.Point(20, 40) };
		
			// 클러스터러에 넣을 마커들 생성 (map 지정 X)
			var clusterMarkers = positions.map(function (position) {
				const imageName = PotfillMap.getMarkerIconName({
					type: 'report',
					status: position.status,
					reportCount: position.reportCount
				});
		
				var imageSrc = '${pageContext.request.contextPath}/images/' + imageName;
				var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
		
				return new kakao.maps.Marker({
					position: position.latlng,
					image: markerImage
				}); //return new kakao.maps.Marker
			}); //clusterMarkers
		
			// 클러스터러에 추가
			clusterer.addMarkers(clusterMarkers);
		
			// 클러스터 클릭 핸들러
			kakao.maps.event.addListener(clusterer, 'clusterclick', function (cluster) {
				var level = map.getLevel() - 1;
		
				map.setLevel(level, {
					anchor: cluster.getCenter(),
				});
			}); // kakao.maps.event.addListener
		
		
			// 내 위치 마커
			(function addAUserLocation() {
				var userMarker = null;
		
				// 내 위치 아이콘
				const userImage = PotfillMap.getMarkerIconName({
					type: 'me'
				});
				var imageSrcUser = '${pageContext.request.contextPath}/images/' + userImage;
				var userMarkerImage = new kakao.maps.MarkerImage(imageSrcUser, imageSize, imageOption);
		
				function upsertUserMarker(latlng) {
					if (!userMarker) {
						userMarker = new kakao.maps.Marker({
							position: latlng,
							image: userMarkerImage,
							clickable: false,
							zIndex: 0
						});
						userMarker.setMap(map);
					} else {
						userMarker.setPosition(latlng);
					}
				}
		
		
				const fallback = DEFAULT_LAT_LNG;
		
				// GPS 승인
				if (navigator.geolocation) {
					navigator.geolocation.getCurrentPosition(
						(position) => {
							const location = new kakao.maps.LatLng(position.coords.latitude, position.coords.longitude);
							upsertUserMarker(location);
							map.setCenter(location);
						},
						(err) => {
							console.warn('Geolocation error:', err);
							upsertUserMarker(fallback);
							map.setCenter(fallback);
						},
						{ enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
					);
				} else {
					upsertUserMarker(fallback);
					map.setCenter(fallback);
				}
			})();
		
		
			// 줌 이벤트
			kakao.maps.event.addListener(map, 'zoom_changed', function () {
				const level = map.getLevel();
				const isClusteredNow = level >= CLUSTER_MIN_LEVEL;
		
			}); // zoom addListener
		
			var geocoder = new kakao.maps.services.Geocoder();
		
			clusterMarkers.forEach(function (marker, i) {
		
				// 마커 클릭 이벤트
				kakao.maps.event.addListener(marker, 'click', function () {
		
					// 역지오코딩
					PotfillMap.searchDetailAddrFromCoords(geocoder, marker.getPosition(), function (result, status) {
						var detailAddr = '주소를 불러오지 못했습니다.';
						if (status === kakao.maps.services.Status.OK && Array.isArray(result) && result.length > 0) {
							detailAddr = (
								result[0].road_address ?
									'		<strong class="icon">' +
									'          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">' +
									'            <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6" />' +
									'          </svg>' +
									'        </strong>' +
									'        <div class="info-address-title">' +
									'          <span class="address-road-title">도로명 주소</span>' +
									'        </div>' +
									'        <div class="info-address-content">' +
									'          <span class="address-road-content">' + result[0].road_address.address_name + '</span>' +
									'        </div>' +
									'      </div>'
									: '') +
									'<strong class="icon">' +
									'        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">' +
									'          <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6" />' +
									'        </svg>' +
									'      </strong>' +
									'      <div class="info-address-title">' +
									'        <span class="address-road-title">지번 주소</span>' +
									'      </div>' +
									'      <div class="info-address-content">' +
									'        <span class="address-road-content">' + result[0].address.address_name + '</span>' +
									'      </div>' +
									'    </div>';
						} // if
		
		
						showBelowOverlay({
							addressHtml: detailAddr || '주소 로딩 중...',
							idx: i,
							reportCount: positions[i].reportCount,
							status: positions[i].status
						}); // buildOverlayContent
					}); // searchDetailAddrFromCoords
					map.setCenter(marker.getPosition());
				}); // kakao.maps.event.addListener
			});
		
			kakao.maps.event.addListener(map, 'click', () => {
				hideBelowOverlay();
			}); // kakao.maps.event.addListener
		
		
			// 오버레이창 내용 html 생성
			function buildOverlayContent({ addressHtml = '', idx, status = '', reportCount = '' } = {}) {
				return (
					'<div class="out-box">' +
					'  <div class="inline-box">' +
					'    <h2 class="title-box">' +
					'      <span class="info-title">포트홀 정보</span>' +
					'    </h2>' +
					'    <div class="info-warp">' +
					'      <div class="info-box">' +
									addressHtml +
					'    <strong class="icon">' +
					'      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">' +
					'        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z" />' +
					'      </svg>' +
					'    </strong>' +
					'    <div class="info-state-title">' +
					'      <span class="state-title">상태</span>' +
					'      <span class="colons">:</span>' +
					'      <span class="state-content">' + status + '</span>' +
					'    </div>' +
					'    <div class="info-address-content">' +
					'      <span class="state-title">누적신고 수</span>' +
					'      <span class="colons">:</span>' +
					'      <span class="state-content">' + reportCount + '</span>' +
					'    </div>' +
					'  </div>' +
					'</div>'
				);
			} // buildOverlayContent
		
		
			function showBelowOverlay(props) {
				const box = document.getElementById('content');
				box.innerHTML = buildOverlayContent({ ...props, idx: 'dom' });
				box.hidden = false;
			}
		
		
			function hideBelowOverlay() {
				const box = document.getElementById('content');
				box.hidden = true;
				box.innerHTML = '';
			}
		
			// closeOverlay와 호환 (지도용 + DOM용 겸용)
			const _closeOverlayOrig = window.closeOverlay;
			window.closeOverlay = function (idx) {
				if (idx === 'dom') { hideBelowOverlay(); return; }
				if (typeof _closeOverlayOrig === 'function') _closeOverlayOrig(idx);
			};
		
		
		</script>
	</body>
</html>