<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@keyProps['kakao.js.apikey']" var="jsKey" />

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/user/complaint.css'/>">
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/map/user-map-style.css'/>">
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
				<h3>실시간 포트홀 현황</h3>
				<p>아직 보수되지 않은 포트홀이 지도에 표시됩니다.</p>
			</div>
			<div class="map-wrap">
				<div id="map" style="width:375;height:314px;"></div>
				<div class="content-wrap" id="content">
				</div>
			</div>
		</div>
	
		<script type="text/javascript"
			src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey }&libraries=services,clusterer"></script>
		<script>
			// 1) 지도 생성
			var mapContainer = document.getElementById('map');
			var mapOption = {
				center: new kakao.maps.LatLng(37.5642135, 127.0016985),
				level: 8
			};
			var map = new kakao.maps.Map(mapContainer, mapOption);
	
			// 2) 클러스터러 생성 (이제 map 준비됨)
			var clusterer = new kakao.maps.MarkerClusterer({
				map: map,
				averageCenter: true,
				minLevel: 6,
				disableClickZoom: true
			}); //clusterer end
	
			// 3) 서버 데이터 -> positions 구성
			var positions = [];
			<c:forEach items="${holeList}" var="row">
				<c:if test="${not empty row['LAT'] and not empty row['LON']}">
					positions.push({
						latlng: new kakao.maps.LatLng(${row['LAT']}, ${row['LON']}),
					reportCount: ${row['REPORTCOUNT']},
					content: '', // 초기 내용 필요시 채우기
					status: '${row['STATUS']}'
					}); //positions.push end
				</c:if>
			</c:forEach>
	
	
			// 4) 마커 이미지 공통 설정
			var imageSize = new kakao.maps.Size(40, 40);
			var imageOption = { offset: new kakao.maps.Point(20, 40) };
	
			// 5) 클러스터러에 넣을 마커들 생성 (map 지정 X)
			var clusterMarkers = positions.map(function (position) {
				let imageName;
				if (position.status === '처리중') {
					imageName = 'location-blue-check';
				} else {
					imageName = getImageNameByReportCount(position.reportCount);
	
				}
				var imageSrc = '${pageContext.request.contextPath}/images/' + imageName + '.png';
				var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
	
				return new kakao.maps.Marker({
					position: position.latlng,
					image: markerImage
				}); //return new kakao.maps.Marker
			}); //clusterMarkers
	
			// 6) 클러스터러에 추가
			clusterer.addMarkers(clusterMarkers);
	
			// 7) 클러스터 클릭 핸들러
			kakao.maps.event.addListener(clusterer, 'clusterclick', function (cluster) {
				var level = map.getLevel() - 1;
	
				map.setLevel(level, { anchor: cluster.getCenter() });
			}); // kakao.maps.event.addListener
	
			// 8) 오버레이/지오코더
			var overlays = [];
			var activeOverlay = null;
			var geocoder = new kakao.maps.services.Geocoder();
	
			clusterMarkers.forEach(function (marker, i) {
				var overlay = new kakao.maps.CustomOverlay({
					content: buildOverlayContent({
						addressHtml: positions[i].content || '주소 로딩 중...',
						idx: i,
						reportCount: positions[i].reportCount,
						status: positions[i].status
					}), //buildOverlayContent
					map: null,
					position: positions[i].latlng,
					yAnchor: 1
				}); // var overlay = new kakao.maps.CustomOverlay
				overlays[i] = overlay;
	
				kakao.maps.event.addListener(marker, 'click', function () {
					if (activeOverlay === i) {
						overlays[i].setMap(null);
						activeOverlay = null;
						return;
					} // if
					if (activeOverlay !== null && overlays[activeOverlay]) {
						overlays[activeOverlay].setMap(null);
					} // if
	
					/* overlays[i].setMap(map); */
					activeOverlay = i;
	
					// 역지오코딩
					searchDetailAddrFromCoords(marker.getPosition(), function (result, status) {
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
							riskLevel: positions[i].riskLevel,
							status: positions[i].status
						}); // buildOverlayContent
					}); // searchDetailAddrFromCoords
					map.setCenter(marker.getPosition());
				}); // kakao.maps.event.addListener
			});
			
			kakao.maps.event.addListener(map, 'click', () => {
				if (activeOverlay !== null && overlays[activeOverlay]) {
					overlays[activeOverlay].setMap(null);
					activeOverlay = null;
				} // if
			}); // kakao.maps.event.addListener
	
			
			// 포트홀 상태에 따른 이미지 이름 설정
			function getImageNameByReportCount(expr) {
				switch (expr) {
					case 1: return "location-green";
					case 2: return "location-yellow";
					default: return "location-red";
				}
			}
	
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
	
			
			// 역지오코딩 함수 호출
			function searchDetailAddrFromCoords(coords, callback) {
				geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
			}
	
			function showBelowOverlay(props) {
				const box = document.getElementById('content');
				// buildOverlayContent
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