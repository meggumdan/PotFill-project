/**
 * 우선처리 지역 TOP 5 테이블 전용 JavaScript
 */

$(document).ready(function() {
    // 우선처리 지역 TOP 5 테이블 초기화
    initPriorityTable();
});

/**
 * 우선처리 지역 TOP 5 테이블 초기화
 */
function initPriorityTable() {
    try {
        $('#priorityTable').DataTable({
            paging: false,
            searching: false,
            info: false,
            ordering: false,
            autoWidth: false,
            language: {
                emptyTable: "표시할 데이터가 없습니다."
            },
            columnDefs: [
                { className: "rank-column", targets: 0, width: "50px" },
                { className: "region-column", targets: 1, width: "120px" },
                { className: "data-column", targets: [2, 3, 4], width: "70px" },
                { className: "check-column", targets: 5, width: "80px" },
                { className: "score-column", targets: 6, width: "80px" }
            ]
        });
        
        console.log('우선처리 지역 TOP 5 테이블 초기화 완료');
    } catch (error) {
        console.error('우선처리 지역 TOP 5 테이블 초기화 실패:', error);
    }
}

/**
 * 우선처리 지역 데이터 업데이트
 */
function updatePriorityTableData(data) {
    try {
        const table = $('#priorityTable').DataTable();
        
        // 기존 데이터 클리어
        table.clear();
        
        // 새로운 데이터 추가
        data.forEach(function(item, index) {
            const checkIcon = item.isNearMajorLocation ? 
                '<span class="check-icon">✓</span>' : 
                '<span class="cross-icon">✗</span>';
                
            table.row.add([
                index + 1,
                item.regionName,
                item.pendingCount + ' 건',
                item.maxElapsedDays + '일',
                item.repeatCount + '회',
                checkIcon,
                '<span class="priority-score">' + item.priorityScore + '</span>'
            ]);
        });
        
        // 테이블 다시 그리기
        table.draw();
        
        console.log('우선처리 지역 데이터 업데이트 완료');
    } catch (error) {
        console.error('우선처리 지역 데이터 업데이트 실패:', error);
    }
}

/**
 * 샘플 데이터로 테이블 업데이트 (테스트용)
 */
function loadSamplePriorityData() {
    const sampleData = [
        {
            regionName: '구 역삼동',
            pendingCount: 15,
            maxElapsedDays: 7,
            repeatCount: 9,
            isNearMajorLocation: true,
            priorityScore: 94.2
        },
        {
            regionName: '서초구 방배동',
            pendingCount: 12,
            maxElapsedDays: 14,
            repeatCount: 8,
            isNearMajorLocation: true,
            priorityScore: 87.5
        },
        {
            regionName: '마포구 상암동',
            pendingCount: 8,
            maxElapsedDays: 6,
            repeatCount: 7,
            isNearMajorLocation: false,
            priorityScore: 85.1
        },
        {
            regionName: '광진구 화양동',
            pendingCount: 6,
            maxElapsedDays: 5,
            repeatCount: 10,
            isNearMajorLocation: true,
            priorityScore: 79.7
        },
        {
            regionName: '종로구 혜화동',
            pendingCount: 5,
            maxElapsedDays: 9,
            repeatCount: 2,
            isNearMajorLocation: false,
            priorityScore: 70.8
        }
    ];
    
    updatePriorityTableData(sampleData);
}

/**
 * 우선처리 지역 데이터 실시간 업데이트
 */
function fetchPriorityData() {
    // TODO: 실제 API 호출로 대체
    /*
    $.ajax({
        url: '/api/admin/priority-regions',
        method: 'GET',
        success: function(response) {
            updatePriorityTableData(response.data);
        },
        error: function(xhr, status, error) {
            console.error('우선처리 지역 데이터 로드 실패:', error);
        }
    });
    */
    
    // 임시로 샘플 데이터 로드
    loadSamplePriorityData();
}

/**
 * 테이블 새로고침
 */
function refreshPriorityTable() {
    fetchPriorityData();
}

/**
 * 테이블 데이터 엑셀 내보내기
 */
function exportPriorityTableToExcel() {
    const table = $('#priorityTable').DataTable();
    const data = table.data().toArray();
    
    // TODO: 엑셀 내보내기 구현
    console.log('우선처리 지역 데이터 엑셀 내보내기:', data);
}

/**
 * 테이블 초기화 확인
 */
function checkTableInitialization() {
    console.log('DataTables 로드 여부:', typeof $.fn.DataTable !== 'undefined');
    console.log('테이블 요소 존재 여부:', $('#priorityTable').length > 0);
    console.log('테이블 초기화 여부:', $.fn.DataTable.isDataTable('#priorityTable'));
}