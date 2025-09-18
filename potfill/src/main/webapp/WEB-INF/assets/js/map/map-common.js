/**
 * 작성자 : 김슬기
 * 설명 : 사용자 및 관리자 지도의 공통 함수  
 */

(() => {
  // 신고 수에 따라 마커 이미지 이름 return
  function getImageNameByReportCount(reportCount) {
	const n = Number(reportCount) || 0;
	if (n <= 1) return "location-green.png";
	if (n === 2) return "location-yellow.png";
	return "location-red.png"; 
  }
 
  // type에 따라 신고 마커 또는 사용자 위치 표시 마커 리턴
  // 신고 마커일 경우, status가 처리 중이면 'location-blue-check.png' 리턴
  function getMarkerIconName({ type, status, reportCount }) {
    if (type === 'me') return 'location-me.gif';               
    // 신고 마커
    if (status === '처리중') return 'location-blue-check.png';  
    return getImageNameByReportCount(reportCount);             
  }
  
 // 민원 처리 상태에 따른 내용 매핑
  function mapStatus(raw, STATUS_LABELS, fallback = '접수') {
    if (!raw) return fallback;
    return (STATUS_LABELS && STATUS_LABELS[raw]) || fallback;
  }

  
  // 역지오코딩 - 경도와 위도를 주소로 변환
  function searchDetailAddrFromCoords(geocoder, coords, callback) {
  	geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
  }

  // 네임스페이스에 붙이기
  var root = window.PotfillMap || {};
  root.getImageNameByReportCount = getImageNameByReportCount;
  root.getMarkerIconName = getMarkerIconName;
  root.searchDetailAddrFromCoords = searchDetailAddrFromCoords;
  root.mapStatus = mapStatus;
  window.PotfillMap = root;
  })(window);