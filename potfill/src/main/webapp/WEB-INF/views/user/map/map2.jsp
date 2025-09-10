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

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey }&libraries=services,clusterer"></script>
	<script>
	// 1) 지도 먼저 생성
	var mapContainer = document.getElementById('map');
	var mapOption = {
	  center: new kakao.maps.LatLng(37.5642135, 127.0016985),
	  level: 10
	};
	var map = new kakao.maps.Map(mapContainer, mapOption);

	// 2) 클러스터러 생성 (이제 map 준비됨)
	var clusterer = new kakao.maps.MarkerClusterer({
	  map: map,
	  averageCenter: true,
	  minLevel: 8,
	  disableClickZoom: true
	});

	// 3) 서버 데이터 -> positions 구성
	var positions = [];
	<c:forEach items="${holeList}" var="row">
	  <c:if test="${not empty row['LAT'] and not empty row['LON']}">
	    positions.push({
	      latlng: new kakao.maps.LatLng(${row['LAT']}, ${row['LON']}),
	      reportCount: ${row['REPORTCOUNT']},
	      content: '' // 초기 내용 필요시 채우기
	    });
	  </c:if>
	</c:forEach>

	// 4) 마커 이미지 공통 설정
	var imageSize = new kakao.maps.Size(40, 40);
	var imageOption = { offset: new kakao.maps.Point(20, 40) };

	// 5) 클러스터러에 넣을 마커들 생성 (map 지정 X)
	var clusterMarkers = positions.map(function(p) {
	  var imageName = getImageNameByreportCount(p.reportCount);
	  var imageSrc = '${pageContext.request.contextPath}/images/' + imageName + '.png';
	  var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

	  return new kakao.maps.Marker({
	    position: p.latlng,
	    image: markerImage
	  });
	});

	// 6) 클러스터러에 추가
	clusterer.addMarkers(clusterMarkers);

	// 7) 클러스터 클릭 핸들러
	kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
	  var level = map.getLevel() - 1;

	  map.setLevel(level, { anchor: cluster.getCenter() });
	});

	// 8) 오버레이/지오코더 등 부가 기능 (선택)
	// 오버레이는 마커 클릭 이벤트를 마커 생성 시에 함께 달아주면 됩니다.
	// 아래는 예시로, contentText 대신 content 사용:
	var overlays = [];
	var activeOverlay = null;
	var geocoder = new kakao.maps.services.Geocoder();

	clusterMarkers.forEach(function(marker, i) {
	  var overlay = new kakao.maps.CustomOverlay({
	    content: buildOverlayContent(positions[i].content || '주소 로딩 중...', i),
	    map: null,
	    position: positions[i].latlng,
	    yAnchor: 1
	  });
	  overlays[i] = overlay;

	  kakao.maps.event.addListener(marker, 'click', function() {
	    if (activeOverlay === i) {
	      overlays[i].setMap(null);
	      activeOverlay = null;
	      return;
	    }
	    if (activeOverlay !== null && overlays[activeOverlay]) {
	      overlays[activeOverlay].setMap(null);
	    }
	    overlays[i].setMap(map);
	    activeOverlay = i;

	    // 역지오코딩
	    searchDetailAddrFromCoords(marker.getPosition(), function(result, status) {
	      var detailAddr = '주소를 불러오지 못했습니다.';
	      if (status === kakao.maps.services.Status.OK && Array.isArray(result) && result.length > 0) {
	        detailAddr = (result[0].road_address ? '도로명주소 : ' + result[0].road_address.address_name + '<br>' : '')
	                    + '지번 주소 : ' + result[0].address.address_name;
	      }
	      overlay.setContent(buildOverlayContent(detailAddr, i));
	    });
	  });
	});
	
	  kakao.maps.event.addListener(map, 'click', () => {
		    if (activeOverlay !== null && overlays[activeOverlay]) {
		      overlays[activeOverlay].setMap(null);
		      activeOverlay = null;
		    }
		  });

	function getImageNameByreportCount(expr) {
	  switch (expr) {
	    case 1: return "location-green";
	    case 2: return "location-yellow";
	    default: return "location-red";
	  }
	}

	function buildOverlayContent(addressHtml, idx) {
	  return (
	    '<div class="wrap">' +
	      '<div class="info">' +
	        '<div class="title">나의 위치' +
	          '<div class="close" onclick="closeOverlay(' + idx + ')" title="닫기"></div>' +
	        '</div>' +
	        '<div class="body">' +
	          '<div class="desc">' +
	            '<div class="ellipsis">' + (addressHtml || '') + '</div>' +
	            '<div class="jibun ellipsis">(관할) 0000행정복지센터</div>' +
	          '</div>' +
	        '</div>' +
	      '</div>' +
	    '</div>'
	  );
	}

	function searchDetailAddrFromCoords(coords, callback) {
	  geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
	}

	function closeOverlay(idx) {
	  if (overlays[idx]) overlays[idx].setMap(null);
	  if (activeOverlay === idx) activeOverlay = null;
	}
	</script>
</body>

</html>