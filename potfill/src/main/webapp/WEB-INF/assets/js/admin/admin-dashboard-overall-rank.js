/**
 * 지역별(구별) 우선도 랭킹 차트 전용 JavaScript
 */

let rankingChart = null;

// 서울시 25개구 고정 리스트
const SEOUL_25_GU = [
    '강남', '강동', '강북', '강서', '관악', 
    '광진', '구로', '금천', '노원', '도봉', 
    '동대문', '동작', '마포', '서대문', '서초', 
    '성동', '성북', '송파', '양천', '영등포', 
    '용산', '은평', '종로', '중구', '중랑'
];

$(document).ready(function() {
    // 지역별 우선도 랭킹 차트 초기화
    setTimeout(initRankingChart, 100);
});

/**
 * 지역별 우선도 랭킹 차트 초기화
 */
function initRankingChart() {
    try {
        const ctx = document.getElementById('rankingChart');
        if (!ctx) {
            console.error('rankingChart 캔버스 요소를 찾을 수 없습니다.');
            return;
        }

        // 기존 차트가 있다면 제거
        if (rankingChart) {
            rankingChart.destroy();
        }

        // 초기 25개구 데이터 (모두 0으로 시작)
        const initialData = new Array(25).fill(0);
        
        // 번갈아가며 색상 적용
        const backgroundColors = SEOUL_25_GU.map((_, index) => {
            return index % 2 === 0 ? '#7DA5EB' : '#5B88D6';
        });
        
        const borderColors = SEOUL_25_GU.map((_, index) => {
            return index % 2 === 0 ? '#6B94D6' : '#4A77C5';
        });

        // Chart.js 설정
        const config = {
            type: 'bar',
            data: {
                labels: SEOUL_25_GU,
                datasets: [{
                    label: '우선도 점수',
                    data: initialData,
                    backgroundColor: backgroundColors,
                    borderColor: borderColors,
                    borderWidth: 1,
                    borderRadius: 2,
                    borderSkipped: false,
                    maxBarThickness: 15,  // 막대 최대 두께 (픽셀 단위)
                    barThickness: 10,     // 막대 고정 두께 (픽셀 단위)
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                aspectRatio: 2.5,
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
                        displayColors: false,
                        callbacks: {
                            title: function(context) {
                                return context[0].label + '구';
                            },
                            label: function(context) {
                                return '우선도 점수: ' + context.parsed.y.toFixed(1);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        categoryPercentage: 1.0,
                        barPercentage: 0.4,
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#364A63',
                            font: {
                                size: 12,
                                family: 'Noto Sans KR'
                            },
                            maxRotation: 0,
                            minRotation: 0,
                            autoSkip: false,
                            maxTicksLimit: 25
                        },
                        border: {
                            display: false
                        }
                    },
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: '#E9ECEF',
                            lineWidth: 1
                        },
                        ticks: {
                            color: '#8094AE',
                            font: {
                                size: 11,
                                family: 'Noto Sans KR'
                            },
                            stepSize: 20
                        },
                        border: {
                            display: false
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                elements: {
                    bar: {
                        borderWidth: 1
                    }
                },
                layout: {
                    padding: {
                        top: 10,
                        bottom: 10,
                        left: 10,
                        right: 10
                    }
                },
                animation: {
                    duration: 1000
                }
            }
        };

        // 차트 생성
        rankingChart = new Chart(ctx, config);
        
        console.log('지역별 우선도 랭킹 차트 초기화 완료');
        
        // 실제 데이터 로드
        fetchRankingData();
        
    } catch (error) {
        console.error('지역별 우선도 랭킹 차트 초기화 실패:', error);
    }
}

/**
 * 실제 API에서 데이터를 가져오는 함수
 */
function fetchRankingData() {
    $.ajax({
        url: contextPath + '/admin/api/dashboard/ranking',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            console.log('지역구별 랭킹 데이터:', response);
            
            if (response && response.labels && response.data) {
                updateRankingChartWithAPIData(response.labels, response.data);
            } else {
                console.error('응답 데이터 형식이 올바르지 않습니다:', response);
            }
        },
        error: function(xhr, status, error) {
            console.error('지역구별 랭킹 데이터 로드 실패:', error);
            // 오류 시 모든 구가 0점으로 표시됨
        }
    });
}

/**
 * API 데이터로 차트 업데이트 (25개구는 모두 유지)
 */
function updateRankingChartWithAPIData(apiLabels, apiData) {
    try {
        if (!rankingChart) {
            console.error('차트가 초기화되지 않았습니다.');
            return;
        }

        // 25개구 데이터 배열 초기화 (모두 0)
        const chartData = new Array(25).fill(0);
        
        // API에서 받은 데이터를 매칭
        for (let i = 0; i < apiLabels.length; i++) {
            // 구 이름 정규화 (강남구 -> 강남)
            const guName = apiLabels[i].replace('구', '');
            
            // SEOUL_25_GU 배열에서 해당 구의 인덱스 찾기
            const index = SEOUL_25_GU.indexOf(guName);
            
            if (index !== -1) {
                // 해당 인덱스에 점수 설정
                chartData[index] = apiData[i] || 0;
            }
        }

        // 차트 데이터만 업데이트 (라벨과 색상은 유지)
        rankingChart.data.datasets[0].data = chartData;
        rankingChart.update();
        
        console.log('지역별 우선도 랭킹 차트 데이터 업데이트 완료');
        
    } catch (error) {
        console.error('차트 데이터 업데이트 실패:', error);
    }
}

/**
 * 차트 새로고침
 */
function refreshRankingChart() {
    if (rankingChart) {
        rankingChart.destroy();
        rankingChart = null;
    }
    setTimeout(initRankingChart, 100);
}

/**
 * 차트 리사이즈
 */
function resizeRankingChart() {
    if (rankingChart) {
        rankingChart.resize();
    }
}