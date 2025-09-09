<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@keyProps['kakao.js.apikey']" var="jsKey" />

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Insert title here</title>
	<c:set var="contextPath" value="${pageContext.request.contextPath}" />
	<link href="${pageContext.request.contextPath}/css/user/map/user-map-style.css" rel="stylesheet"  type="text/css">
</head>

<body>


	<button id="find-me">내위치</button><br />
	<p id="status"></p>
	<a id="map-link" target="_blank"></a>
	<div class="hAddr">
		<span class="title">크킄크크클러스터러</span>
		<span id="centerAddr"></span>
	</div>

	<div id="map" style="width:100%;height:350px;"></div>

	<table border="1" style="width:100%; height:100%">
		<thead>
			<tr>
				<th>1</th>
				<th>2</th>
				<th>3</th>
				<th>4</th>
				<th>5</th>
				<th>6</th>
				<th>7</th>
				<th>8</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${holeList}" var="row">
				<tr>
					<td>${row['COMPLAINTID']}</td>
					<td>${row['LAT']}</td>
					<td>${row['LON']}</td>
					<td>${row['REPORTCOUNT']}</td>
					<td>${row['DISTRICTCODE']}</td>
					<td>${row['RISKLEVEL']}</td>
					<td>${row['STATUSCOMMENT']}</td>
					<td>${row['STATUS']}</td>
				</tr>
			</c:forEach>
			<td>
		</tbody>
	</table>

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey }&libraries=services"></script>
	<script>
		// 지도 생성
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			mapOption = {
				center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
				level: 10 // 지도의 확대 레벨 
			};
		
		
		let content = buildOverlayContent();
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다 
		var positions = [];
		<c:forEach items="${holeList}" var="row">
			<c:if test="${not empty row['LAT'] and not empty row['LON']}">
				positions.push({
					latlng: new kakao.maps.LatLng(${row['LAT']}, ${row['LON']}),
				reportCount: ${row['REPORTCOUNT']},
				content: content
				});
			</c:if>
		</c:forEach>


		// 마커 이미지 생성
		var imageSrc; // 마커이미지의 주소입니다    
		var imageSize = new kakao.maps.Size(40, 40), // 마커이미지의 크기입니다
			imageOption = { offset: new kakao.maps.Point(20, 40) }; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.


		// 지오코더 생성 (Geocoder)
		var geocoder = new kakao.maps.services.Geocoder();

		const markers = [];
		const overlays = [];
		let activeOverlay = null;

		// GPS 요청
		if (navigator.geolocation) {

			navigator.geolocation.getCurrentPosition(function (position) {

				const lat = position.coords.latitude; // 위도
				const lon = position.coords.longitude; // 경도
				console.log("위도와 경도 : " + lat + ", " + lon)

				var locPosition = new kakao.maps.LatLng(lat, lon);
				// 마커 생성 함수 호출
				displayMarker(locPosition);

			});

		} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
			var locPosition = new kakao.maps.LatLng(33.450701, 126.570667);
			displayMarker(locPosition);
		}

		// 마커 생성
		function displayMarker(locPosition) {
			console.log(positions.length);
			for (let i = 0; i < positions.length; i++) {
				let imageName = getImageNameByreportCount(positions[i].reportCount);
				console.log(positions[i].reportCount)
				imageSrc = '${pageContext.request.contextPath}/images/' + imageName + '.png';
				console.log(imageSrc);
				var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
					markerPosition = new kakao.maps.LatLng(37.54699, 127.09598); // 마커가 표시될 위치입니다


				const marker = new kakao.maps.Marker({
					map: map,
					position: positions[i].latlng,
					image: markerImage
				});
				markers[i] = marker;


				const overlay = new kakao.maps.CustomOverlay({
					content: buildOverlayContent(positions[i].contentText, i), // ← 인덱스 전달
					map: null,                         // 처음엔 닫아두기
					position: positions[i].latlng,
					yAnchor: 1
				});
				overlays[i] = overlay;

				kakao.maps.event.addListener(marker, 'click', () => {
					if (activeOverlay === i) {
						overlays[i].setMap(null);
						activeOverlay = null;
						return;
					}

					// 다른 게 열려 있으면 닫기
					if (activeOverlay !== null && overlays[activeOverlay]) {
						overlays[activeOverlay].setMap(null);
					}

					overlays[i].setMap(map);
					activeOverlay = i;
					searchDetailAddrFromCoords(marker.getPosition(), (result, status) => {
						let detailAddr = '주소를 불러오지 못했습니다.';
						if (status === kakao.maps.services.Status.OK && Array.isArray(result) && result.length > 0) {
							detailAddr = (result[0].road_address
								? '도로명주소 : ' + result[0].road_address.address_name + '<br>'
								: '') + '지번 주소 : ' + result[0].address.address_name;
						}
						overlay.setContent(buildOverlayContent(detailAddr, i));
					});
				});
			}
			map.setCenter(locPosition);


		}

		function getImageNameByreportCount(expr) {
			let imageName;
			switch (expr) {
				case 1:
					return "location-green";
				case 2:
					return "location-yellow";
				default:
					return "location-red";
			}

			return imageName;
		}


		function buildOverlayContent(addressHtml, idx) {
			return (
				'<div class="wrap">' +
				'  <div class="info">' +
				'    <div class="title">나의 위치 ' +
				'      <div class="close" onclick="closeOverlay(' + idx + ')" title="닫기"></div>' +
				'    </div>' +
				'    <div class="body">' +
				'      <div class="desc">' +
				'       <div class="ellipsis">' + addressHtml + '</div>' +
				'        <div class="jibun ellipsis">(관할) 0000행정복지센터</div>' +
				/*         	      '        <div><a href="https://www.kakaocorp.com/main" target="_blank" class="link">홈페이지</a></div>' + */
				'      </div>' +
				'    </div>' +
				'  </div>' +
				'</div>'
			);
		}

		function searchAddrFromCoords(coords, callback) {
			// 좌표로 행정동 주소 정보를 요청합니다
			geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
		}

		function searchDetailAddrFromCoords(coords, callback) {
			// 좌표로 법정동 상세 주소 정보를 요청합니다
			geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}


		function closeOverlay(idx) {
			if (overlays[idx]) overlays[idx].setMap(null);
			if (activeOverlay === idx) activeOverlay = null;
		}
	</script>
</body>

</html>