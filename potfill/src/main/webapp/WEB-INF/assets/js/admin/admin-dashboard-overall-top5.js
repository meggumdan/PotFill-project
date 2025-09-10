/**
 * 우선처리 지역 TOP 5 테이블 전용 JavaScript
 */

let priorityTable = null;

$(document).ready(function () {
    initPriorityTable();
    fetchPriorityData(); // 최초 로드
});

/** 테이블 초기화 */
function initPriorityTable() {
    try {
        if ($.fn.DataTable.isDataTable('#priorityTable')) {
            priorityTable = $('#priorityTable').DataTable();
            priorityTable.clear().draw(); // 기존 데이터 클리어
            return;
        }

        priorityTable = $('#priorityTable').DataTable({
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

        // 초기화 직후 테이블 비우기
        priorityTable.clear().draw();

        console.log('우선처리 지역 TOP 5 테이블 초기화 완료');
    } catch (error) {
        console.error('우선처리 지역 TOP 5 테이블 초기화 실패:', error);
    }
}

/** API 데이터로 테이블 갱신 */
function updatePriorityTableData(items) {
    try {
        if (!priorityTable) {
            initPriorityTable();
        }
        
        priorityTable.clear();

        items.forEach((item, idx) => {
            const checkIcon = item.isNearMajorLocation
                ? '<span class="check-icon">✓</span>'
                : '<span class="cross-icon">✗</span>';

            priorityTable.row.add([
                idx + 1,
                item.regionName || '-',
                (item.pendingCount || 0) + ' 건',
                (item.maxElapsedDays || 0) + '일',
                (item.repeatCount || 0) + '회',
                checkIcon,
                '<span class="priority-score">' + Number(item.priorityScore || 0).toFixed(1) + '</span>'
            ]);
        });

        priorityTable.draw();
        console.log('우선처리 지역 데이터 업데이트 완료:', items.length + '개 항목');
    } catch (error) {
        console.error('우선처리 지역 데이터 업데이트 실패:', error);
    }
}

/** 백엔드에서 실데이터 가져오기 */
function fetchPriorityData() {
    const url = contextPath + '/admin/api/dashboard/priority';
    
    console.log('우선처리 TOP5 API 호출:', url);

    $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        success: function (resp) {
            console.log('우선처리 TOP5 응답:', resp);
            
            // Oracle JDBC는 컬럼명을 대문자로 반환하므로 대소문자 모두 처리
            const normalized = (Array.isArray(resp) ? resp : []).map(r => ({
                regionName: r.REGIONNAME || r.regionName || '',
                pendingCount: Number(r.PENDINGCOUNT || r.pendingCount || 0),
                maxElapsedDays: Number(r.MAXELAPSEDDAYS || r.maxElapsedDays || 0),
                repeatCount: Number(r.REPEATCOUNT || r.repeatCount || 0),
                isNearMajorLocation: Number(r.ISNEARMAJORLOCATION || r.isNearMajorLocation || 0) === 1,
                priorityScore: Number(r.PRIORITYSCORE || r.priorityScore || 0)
            }));

            updatePriorityTableData(normalized);
        },
        error: function (xhr, status, error) {
            console.error('우선처리 지역 데이터 로드 실패:', error);
            console.error('응답:', xhr.responseText);
            // 실패 시 빈 테이블 표시
            updatePriorityTableData([]);
        }
    });
}

/** 외부에서 강제 새로고침할 때 사용 */
function refreshPriorityTable() {
    fetchPriorityData();
}