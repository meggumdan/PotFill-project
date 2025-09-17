/*
* 작성자 : 정소영
* 설명 : H3 라이브러리 해상도 확인을 위한 js
*/

;(() => {
    'use strict';

    // ===== H3 시각화 =====
    let h3Overlays = []; // 그려둔 폴리곤들을 담아두고 지울 때 사용

    // v3/v4 호환용 래퍼
    function h3LatLngToIndex(lat, lng, res) {
        if (h3?.latLngToCell) return h3.latLngToCell(lat, lng, res);    // v4
        if (h3?.geoToH3)      return h3.geoToH3(lat, lng, res);         // v3
        throw new Error("h3-js not loaded");
    }
    function h3IndexToBoundary(idx) {
        // 두 함수 모두 false 로 주면 [lat, lng] 순서 반환됨 (카카오 LatLng에 바로 사용 가능)
        if (h3?.cellToBoundary) return h3.cellToBoundary(idx, false);   // v4
        if (h3?.h3ToGeoBoundary) return h3.h3ToGeoBoundary(idx, false); // v3
        throw new Error("h3-js not loaded");
    }
    function h3Neighbors(idx, k) {
        if (h3?.gridDisk) return h3.gridDisk(idx, k); // v4 (중심 포함)
        if (h3?.kRing)    return h3.kRing(idx, k);    // v3 (중심 포함)
        return [idx];
    }

    function clearH3Overlays() {
        h3Overlays.forEach(p => p.setMap && p.setMap(null));
        h3Overlays = [];
    }

    function drawH3CellAt(lat, lng, res, options = { ring: 0 }) {
        if (!window.map) { console.warn("kakao map not ready"); return; }
        clearH3Overlays();
        const centerIdx = h3LatLngToIndex(lat, lng, res);
        const indices = options.ring ? h3Neighbors(centerIdx, options.ring) : [centerIdx];

        indices.forEach((idx, i) => {
            const boundary = h3IndexToBoundary(idx);
            const path = boundary.map(([la, lo]) => new kakao.maps.LatLng(la, lo));

            const poly = new kakao.maps.Polygon({
                map,
                path,
                strokeWeight: 2,
                strokeColor: '#FA8C2D',
                strokeOpacity: 0.9,
                fillColor: i === 0 ? 'rgba(250,140,45,0.20)' : 'rgba(250,140,45,0.10)',
                fillOpacity: 0.6
            });
            h3Overlays.push(poly);
        });

        // 보기 좋게 해당 폴리곤 영역으로 지도 bounds 맞추기(선택)
        const bounds = new kakao.maps.LatLngBounds();
        h3Overlays.forEach(poly => poly.getPath()[0].forEach(latlng => bounds.extend(latlng)));
        map.setBounds(bounds, 20, 20, 20, 20);
    }

    // 버튼: H3 보기
    $("#h3-draw-btn").off("click").on("click", function(){
        const lat = parseFloat($("#lat").val());
        const lon = parseFloat($("#lon").val());
        if (!lat || !lon) { alert("지도를 클릭해 위치를 지정해 주세요."); return; }
        const res = parseInt($("#h3-res").val(), 10);

        // 주변 링까지 같이 보고 싶으면 ring: 1로 (효과적 반경 넓힘)
        drawH3CellAt(lat, lon, res, { ring: 0 });
    });

    // 버튼: 지우기
    $("#h3-clear-btn").off("click").on("click", function(){
        clearH3Overlays();
    });

    // 필요 시 외부에서 호출할 수 있게 노출
    window.drawH3CellAt = drawH3CellAt;
    window.clearH3Overlays = clearH3Overlays;
})();