/**
 * 지역별 포트홀 신고현황 전용 JavaScript
 */

let statusDonutChart = null;
let statusTable = null;

$(document).ready(function() {
    // 도넛차트 및 테이블 초기화
    initStatusComponents();
});

/**
 * 신고현황 컴포넌트 초기화
 */
function initStatusComponents() {
    initStatusDonutChart();
    initStatusTable();
}

/**
 * 도넛차트 초기화
 */
function initStatusDonutChart() {
    try {
        const ctx = document.getElementById('statusDonutChart');
        if (!ctx) {
            console.error('statusDonutChart 캔버스 요소를 찾을 수 없습니다.');
            return;
        }

        // 기존 차트가 있다면 제거
        if (statusDonutChart) {
            statusDonutChart.destroy();
        }

        // 샘플 데이터
        const statusData = {
            completed: 1158,
            processing: 500,
            received: 341,
            rejected: 272
        };

        const total = statusData.completed + statusData.processing + statusData.received + statusData.rejected;

        // 도넛차트 설정
        const config = {
            type: 'doughnut',
            data: {
                labels: ['완료', '처리중', '접수', '반려'],
                datasets: [{
                    data: [statusData.completed, statusData.processing, statusData.received, statusData.rejected],
                    backgroundColor: [
                        '#A8D5A8',  // 완료 - 연한 초록
                        '#7DA5EB',  // 처리중 - 파랑
                        '#FFB366',  // 접수 - 주황
                        '#8B9DC3'   // 반려 - 회색 파랑
                    ],
                    borderColor: [
                        '#9BC99B',
                        '#6B94D6',
                        '#FF9F4D',
                        '#7A8CB0'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: '#7DA5EB',
                        borderWidth: 1,
                        cornerRadius: 6,
                        displayColors: true,
                        callbacks: {
                            label: function(context) {
                                const percentage = ((context.parsed / total) * 100).toFixed(0);
                                return context.label + ': ' + context.parsed + '건 (' + percentage + '%)';
                            }
                        }
                    }
                },
                layout: {
                    padding: 5
                }
            }
        };

        // 차트 생성
        statusDonutChart = new Chart(ctx, config);

        // 차트 정보 업데이트
        updateChartInfo(statusData, total);

        console.log('도넛차트 초기화 완료');

    } catch (error) {
        console.error('도넛차트 초기화 실패:', error);
    }
}

/**
 * 차트 정보 업데이트
 */
function updateChartInfo(data, total) {
    const infoContainer = document.querySelector('.chart-info');
    if (!infoContainer) return;

    const statusInfo = [
        { label: '완료', value: data.completed, color: '#A8D5A8' },
        { label: '처리중', value: data.processing, color: '#7DA5EB' },
        { label: '접수', value: data.received, color: '#FFB366' },
        { label: '반려', value: data.rejected, color: '#8B9DC3' }
    ];

    infoContainer.innerHTML = statusInfo.map(item => {
        const percentage = ((item.value / total) * 100).toFixed(0);
        return `
            <div class="chart-info-row">
                <div class="info-label">
                    <div class="info-color" style="background-color: ${item.color}"></div>
                    ${item.label}
                </div>
                <div class="info-value">
                    ${item.value.toLocaleString()}건
                    <span class="info-percentage">${percentage}%</span>
                </div>
            </div>
        `;
    }).join('');
}

/**
 * 상태별 테이블 초기화
 */
function initStatusTable() {
    try {
        // 25개 구 샘플 데이터
        const districtData = [
            { rank: 1, district: '중랑구', reports: 127, rate: 92, avgDays: 7.2 },
            { rank: 2, district: '은평구', reports: 111, rate: 89, avgDays: 7.1 },
            { rank: 3, district: '강북구', reports: 108, rate: 76, avgDays: 6.7 },
            { rank: 4, district: '강서구', reports: 96, rate: 75, avgDays: 5.9 },
            { rank: 5, district: '광진구', reports: 89, rate: 73, avgDays: 5.5 },
            { rank: 6, district: '마포구', reports: 88, rate: 69, avgDays: 5.3 },
            { rank: 7, district: '용산구', reports: 81, rate: 68, avgDays: 4.7 },
            { rank: 8, district: '성동구', reports: 76, rate: 64, avgDays: 4.6 },
            { rank: 9, district: '서초구', reports: 75, rate: 60, avgDays: 4.0 },
            { rank: 10, district: '성북구', reports: 71, rate: 52, avgDays: 3.6 },
            { rank: 11, district: '강남구', reports: 68, rate: 55, avgDays: 4.2 },
            { rank: 12, district: '강동구', reports: 65, rate: 58, avgDays: 3.8 },
            { rank: 13, district: '관악구', reports: 62, rate: 65, avgDays: 5.1 },
            { rank: 14, district: '구로구', reports: 59, rate: 62, avgDays: 4.5 },
            { rank: 15, district: '금천구', reports: 57, rate: 67, avgDays: 3.9 },
            { rank: 16, district: '노원구', reports: 54, rate: 70, avgDays: 4.8 },
            { rank: 17, district: '도봉구', reports: 52, rate: 72, avgDays: 5.2 },
            { rank: 18, district: '동대문구', reports: 49, rate: 68, avgDays: 4.1 },
            { rank: 19, district: '동작구', reports: 47, rate: 74, avgDays: 3.7 },
            { rank: 20, district: '서대문구', reports: 45, rate: 71, avgDays: 4.3 },
            { rank: 21, district: '송파구', reports: 43, rate: 66, avgDays: 3.5 },
            { rank: 22, district: '양천구', reports: 41, rate: 69, avgDays: 4.4 },
            { rank: 23, district: '영등포구', reports: 39, rate: 63, avgDays: 5.0 },
            { rank: 24, district: '종로구', reports: 37, rate: 61, avgDays: 4.9 },
            { rank: 25, district: '중구', reports: 35, rate: 59, avgDays: 3.3 }
        ];

        $('#statusTable').DataTable({
            data: districtData,
            columns: [
                { 
                    title: '순위',
                    data: 'rank',
                    className: 'text-center'
                },
                { 
                    title: '지역구명',
                    data: 'district',
                    className: 'text-center'
                },
                { 
                    title: '신고 건수',
                    data: 'reports',
                    className: 'text-center',
                    render: function(data) {
                        return data + ' 건';
                    }
                },
                { 
                    title: '처리율',
                    data: 'rate',
                    className: 'text-center',
                    render: function(data) {
                        return data + '%';
                    }
                },
                { 
                    title: '평균 처리시간(일)',
                    data: 'avgDays',
                    className: 'text-center',
                    render: function(data) {
                        return data + '일';
                    }
                }
            ],
            paging: false,
            searching: false,
            info: false,
            ordering: false,
            autoWidth: false,
            scrollY: '280px',
            scrollCollapse: true,
            language: {
                emptyTable: "표시할 데이터가 없습니다."
            }
        });

        statusTable = $('#statusTable').DataTable();
        
        console.log('상태별 테이블 초기화 완료');

    } catch (error) {
        console.error('상태별 테이블 초기화 실패:', error);
    }
}

/**
 * 도넛차트 데이터 업데이트
 */
function updateStatusDonutChart(newData) {
    try {
        if (!statusDonutChart) {
            console.error('도넛차트가 초기화되지 않았습니다.');
            return;
        }

        const total = newData.completed + newData.processing + newData.received + newData.rejected;
        
        statusDonutChart.data.datasets[0].data = [
            newData.completed, 
            newData.processing, 
            newData.received, 
            newData.rejected
        ];
        
        statusDonutChart.update();
        updateChartInfo(newData, total);
        
        console.log('도넛차트 데이터 업데이트 완료');

    } catch (error) {
        console.error('도넛차트 데이터 업데이트 실패:', error);
    }
}

/**
 * 테이블 데이터 업데이트
 */
function updateStatusTable(newData) {
    try {
        if (!statusTable) {
            console.error('테이블이 초기화되지 않았습니다.');
            return;
        }

        statusTable.clear();
        statusTable.rows.add(newData);
        statusTable.draw();
        
        console.log('상태별 테이블 데이터 업데이트 완료');

    } catch (error) {
        console.error('테이블 데이터 업데이트 실패:', error);
    }
}

/**
 * 컴포넌트 새로고침
 */
function refreshStatusComponents() {
    if (statusDonutChart) {
        statusDonutChart.destroy();
        statusDonutChart = null;
    }
    if (statusTable) {
        statusTable.destroy();
        statusTable = null;
    }
    setTimeout(initStatusComponents, 100);
}

/**
 * 실제 API에서 데이터를 가져오는 함수
 */
function fetchStatusData() {
    // TODO: 실제 API 호출로 대체
    /*
    $.ajax({
        url: '/api/admin/district-status',
        method: 'GET',
        success: function(response) {
            updateStatusDonutChart(response.chartData);
            updateStatusTable(response.tableData);
        },
        error: function(xhr, status, error) {
            console.error('신고현황 데이터 로드 실패:', error);
        }
    });
    */
}