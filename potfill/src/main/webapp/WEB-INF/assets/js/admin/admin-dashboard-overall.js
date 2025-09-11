/**
 * 대시보드 KPI 카드 관리
 */

$(document).ready(function () {
    // KPI 데이터 로드
    loadKPIData();
    
    // 5분마다 자동 갱신 (선택사항)
    setInterval(loadKPIData, 300000);
});

/**
 * KPI 데이터 로드 및 표시
 */
function loadKPIData() {
    $.ajax({
        url: contextPath + '/admin/api/dashboard/kpi',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            console.log('KPI 데이터 로드 성공:', data);
            updateKPICards(data);
        },
        error: function(xhr, status, error) {
            console.error('KPI 데이터 로드 실패:', error);
            console.error('응답:', xhr.responseText);
            showDefaultKPIValues();
        }
    });
}

/**
 * KPI 카드 업데이트
 */
function updateKPICards(data) {
    // 1. 총 신고 건수
    $('#totalCard .metric-value').text((data.totalComplaints || 0) + ' 건');
    $('#totalCard .metric-change').text(data.totalTrend || '0(0%)');
    
    // 2. 처리중
    $('#processingCard .metric-value').text((data.processingComplaints || 0) + ' 건');
    $('#processingCard .metric-change').text(data.processingTrend || '0(0%)');
    
    // 3. 완료
    $('#completedCard .metric-value').text((data.completedComplaints || 0) + ' 건');
    $('#completedCard .metric-change').text(data.completedTrend || '0(0%)');
    
    // 4. 고위험 지역
    $('#dangerCard .metric-value').text((data.dangerZoneCount || 0) + '개 구역');
    $('#dangerCard .metric-change').text(data.dangerTrend || '0(0%)');
    
    // 전월 대비 색상 처리
    updateTrendColors();
}

/**
 * 전월 대비 증감 색상 업데이트
 */
function updateTrendColors() {
    $('.metric-change').each(function() {
        const text = $(this).text();
        
        // 통일된 스타일 적용 (피그마 디자인 기준)
        $(this).css({
            'color': '#1EE0AC',      // 민트 그린 색상
            'font-weight': '500',     // 중간 굵기
            'font-size': '11px'       // 작은 폰트 크기
        });
    });
    
    // 전월 대비 텍스트도 작게
    $('.metric-period').css({
        'font-size': '10px',
        'color': '#8094AE',
        'margin-top': '2px'
    });
}

/**
 * 오류 시 기본값 표시
 */
function showDefaultKPIValues() {
    $('#totalCard .metric-value').text('0 건');
    $('#processingCard .metric-value').text('0 건');
    $('#completedCard .metric-value').text('0 건');
    $('#dangerCard .metric-value').text('0개 구역');
    
    $('.metric-change').text('0(0%)');
}