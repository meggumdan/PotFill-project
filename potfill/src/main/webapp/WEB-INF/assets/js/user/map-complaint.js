/**
 * 
 */


// 지오코더(Geocoder)
const geocoder = new kakao.maps.services.Geocoder();

let marker = null;

// 공용 마커 생성/갱신 함수
function upsertMarker(latlng) {
    if (!marker) {
        marker = new kakao.maps.Marker({
            map,
            position: latlng,
            image: markerImage
        });
    } else {
        marker.setPosition(latlng);
    }
    return marker;
}

// 공용: 위경도/주소 표시 함수
function showLatLngAndAddress(latlng) {
    // 주소 조회 (Reverse geocoding)
    geocoder.coord2Address(latlng.getLng(), latlng.getLat(), function (result, status) {
        let detailAddr = '주소를 불러오지 못했습니다.';
        let gu;
        let dong;
        if (status === kakao.maps.services.Status.OK && Array.isArray(result) && result.length > 0) {
            const road = result[0].road_address ? (result[0].road_address.address_name) : ''; // 도로명 주소
            const jibun = result[0].address.address_name;	 // 지번 주소
            detailAddr = (road ? road + '\n' : jibun); // 도로명 주소가 없으면 지번 대입

            const address = result[0].address;
            gu = address.region_2depth_name;   // 구
            dong = address.region_3depth_name; // 법정동

            console.log("구:", gu, " / 동:", dong);
        }
        document.getElementById("place").value = detailAddr;
        document.getElementById("lat").value = latlng.getLat();
        document.getElementById("lon").value = latlng.getLng();
        document.getElementById("gu").value = gu;
        document.getElementById("dong").value = dong;
    });
}

// GPS 요청
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
        function (position) {
            const lat = position.coords.latitude;
            const lon = position.coords.longitude;
            const locPosition = new kakao.maps.LatLng(lat, lon);

            // 마커/센터 지정
            upsertMarker(locPosition);
            map.setCenter(locPosition);

            // 승인 직후 위경도 + 주소 표시
            showLatLngAndAddress(locPosition);
        },
        function (error) {
            // 에러 시 기본 좌표로
            const fallback = new kakao.maps.LatLng(37.5642135, 127.0016985);
            upsertMarker(fallback);
            map.setCenter(fallback);
            console.warn('Geolocation error:', error);

            showLatLngAndAddress(fallback);
        },
        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
    );
} else {
    const fallback = new kakao.maps.LatLng(33.450701, 126.570667);
    upsertMarker(fallback);
    map.setCenter(fallback);
    showLatLngAndAddress(fallback);
}

// 지도 클릭 시: 마커 이동 + 주소/위경도 표시
kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
    const latlng = mouseEvent.latLng;

    // 1) 마커 갱신
    upsertMarker(latlng);

    // 2) 공용 함수로 주소/위경도 표시
    showLatLngAndAddress(latlng);
});

function searchAddrFromCoords(coords, callback) {
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
}
function searchDetailAddrFromCoords(coords, callback) {
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}
