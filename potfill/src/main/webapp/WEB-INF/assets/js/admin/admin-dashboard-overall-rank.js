/**
 * 지역별(구별) 우선도 랭킹 차트 전용 JavaScript
 */

let rankingChart = null;

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

        // 서울 25개 구 데이터
        const seoulDistricts = [
            '강남', '강동', '강북', '강서', '관악', '광진', '구로', '금천', 
            '노원', '도봉', '동대문', '동작', '마포', '서대문', '서초', 
            '성동', '성북', '송파', '양천', '영등포', '용산', '은평', 
            '종로', '중구', '중랑'
        ];

        // 샘플 우선도 점수 데이터
        const priorityScores = [
            85, 78, 65, 82, 70, 88, 75, 60, 
            73, 55, 90, 77, 95, 68, 92, 
            72, 80, 87, 65, 83, 70, 75, 
            58, 62, 69
        ];

        // 번갈아가며 색상 적용
        const backgroundColors = priorityScores.map((_, index) => {
            return index % 2 === 0 ? '#7DA5EB' : '#5B88D6';
        });

        const borderColors = priorityScores.map((_, index) => {
            return index % 2 === 0 ? '#6B94D6' : '#4A77C5';
        });

        // Chart.js 설정
        const config = {
            type: 'bar',
            data: {
                labels: seoulDistricts,
                datasets: [{
                    label: '우선도 점수',
                    data: priorityScores,
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
                                return '우선도 점수: ' + context.parsed.y;
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
                                size: 12,  // 글자 크기
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
        
    } catch (error) {
        console.error('지역별 우선도 랭킹 차트 초기화 실패:', error);
    }
}

/**
 * 차트 데이터 업데이트
 */
function updateRankingChartData(newData) {
    try {
        if (!rankingChart) {
            console.error('차트가 초기화되지 않았습니다.');
            return;
        }

        rankingChart.data.datasets[0].data = newData;
        
        const backgroundColors = newData.map((_, index) => {
            return index % 2 === 0 ? '#7DA5EB' : '#5B88D6';
        });
        
        const borderColors = newData.map((_, index) => {
            return index % 2 === 0 ? '#6B94D6' : '#4A77C5';
        });
        
        rankingChart.data.datasets[0].backgroundColor = backgroundColors;
        rankingChart.data.datasets[0].borderColor = borderColors;
        
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

/**
 * 실제 API에서 데이터를 가져오는 함수
 */
function fetchRankingData() {
    const sampleData = [
        85, 78, 65, 82, 70, 88, 75, 60, 
        73, 55, 90, 77, 95, 68, 92, 
        72, 80, 87, 65, 83, 70, 75, 
        58, 62, 69
    ];
    
    updateRankingChartData(sampleData);
}