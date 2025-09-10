/**
 * 지역별 포트홀 신고현황 전용 JavaScript (작은 도넛차트 버전)
 */

let mainDonutChart = null;
let mainStatusTable = null;

$(document).ready(function() {
	// 신고현황 컴포넌트 초기화
	initMainStatusComponents();
});

/**
 * 메인 신고현황 컴포넌트 초기화
 */
function initMainStatusComponents() {
	initMainDonutChart();
	initMainStatusTable();
}

/**
 * 메인 도넛차트 초기화 (작은 크기)
 */
function initMainDonutChart() {
	try {
		const ctx = document.getElementById('statusDonutChart');
		if (!ctx) {
			console.error('statusDonutChart 캔버스 요소를 찾을 수 없습니다.');
			return;
		}

		// 기존 차트가 있다면 제거
		if (mainDonutChart) {
			mainDonutChart.destroy();
		}

		// 샘플 데이터
		const statusData = {
			completed: 1158,
			processing: 500,
			received: 341,
			rejected: 272
		};

		const total = statusData.completed + statusData.processing + statusData.received + statusData.rejected;

		// 도넛차트 설정 (작은 크기) - 피그마 디자인 색상 적용
		const config = {
			type: 'doughnut',
			data: {
				labels: ['완료', '처리중', '접수', '반려'],
				datasets: [{
					data: [statusData.completed, statusData.processing, statusData.received, statusData.rejected],
					backgroundColor: [
						'#D4DFB8',  // 완료 - 피그마 디자인 색상
						'#3D70C3',  // 처리중 - 피그마 디자인 색상
						'#FFB97D',  // 접수 - 피그마 디자인 색상
						'#868EA1'   // 반려 - 피그마 디자인 색상
					],
					borderColor: '#FFFFFF',
					borderWidth: 1
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				cutout: '50%',
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
						cornerRadius: 4,
						displayColors: true,
						titleFont: { size: 9 },
						bodyFont: { size: 8 },
						callbacks: {
							label: function(context) {
								const percentage = ((context.parsed / total) * 100).toFixed(0);
								return context.label + ': ' + context.parsed + '건 (' + percentage + '%)';
							}
						}
					}
				},
				layout: {
					padding: 2
				}
			}
		};

		// 차트 생성
		mainDonutChart = new Chart(ctx, config);

		// 캔버스 크기 강제 설정 (CSS가 적용되지 않을 경우 대비)
		ctx.style.width = '170px !important';
		ctx.style.height = '170px !important';
		ctx.style.maxWidth = '170px';
		ctx.style.maxHeight = '170px';
		ctx.width = 170;
		ctx.height = 170;

		// 부모 컨테이너도 강제 설정
		const container = ctx.parentElement;
		if (container) {
			container.style.width = '170px';
			container.style.height = '170px';
			container.style.maxWidth = '170px';
			container.style.maxHeight = '170px';
		}

		// 범례 정보 업데이트
		updateMainLegend(statusData, total);

		console.log('메인 도넛차트 초기화 완료 (작은 크기)');

	} catch (error) {
		console.error('메인 도넛차트 초기화 실패:', error);
	}
}

/**
 * 메인 범례 업데이트 (작은 크기) - 피그마 디자인 적용
 */
function updateMainLegend(data, total) {
	// HTML에서 직접 정의된 범례의 값만 업데이트
	const completedCount = document.querySelector('.completed-count');
	const processingCount = document.querySelector('.processing-count');
	const receivedCount = document.querySelector('.received-count');
	const rejectedCount = document.querySelector('.rejected-count');
	
	if (completedCount) {
		completedCount.textContent = data.completed.toLocaleString();
		const completedPercentage = ((data.completed / total) * 100).toFixed(0);
		completedCount.nextElementSibling.nextElementSibling.textContent = completedPercentage + '%';
	}
	
	if (processingCount) {
		processingCount.textContent = data.processing.toLocaleString();
		const processingPercentage = ((data.processing / total) * 100).toFixed(0);
		processingCount.nextElementSibling.nextElementSibling.textContent = processingPercentage + '%';
	}
	
	if (receivedCount) {
		receivedCount.textContent = data.received.toLocaleString();
		const receivedPercentage = ((data.received / total) * 100).toFixed(0);
		receivedCount.nextElementSibling.nextElementSibling.textContent = receivedPercentage + '%';
	}
	
	if (rejectedCount) {
		rejectedCount.textContent = data.rejected.toLocaleString();
		const rejectedPercentage = ((data.rejected / total) * 100).toFixed(0);
		rejectedCount.nextElementSibling.nextElementSibling.textContent = rejectedPercentage + '%';
	}
}

/**
 * 메인 상태 테이블 초기화
 */
function initMainStatusTable() {
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

		mainStatusTable = $('#mainStatusTable').DataTable({
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
			scrollY: '225px',
			scrollCollapse: true,
			language: {
				emptyTable: "표시할 데이터가 없습니다."
			}
		});

		console.log('메인 상태 테이블 초기화 완료');

	} catch (error) {
		console.error('메인 상태 테이블 초기화 실패:', error);
	}
}

/**
 * 도넛차트 데이터 업데이트
 */
function updateMainDonutChart(newData) {
	try {
		if (!mainDonutChart) {
			console.error('메인 도넛차트가 초기화되지 않았습니다.');
			return;
		}

		const total = newData.completed + newData.processing + newData.received + newData.rejected;

		mainDonutChart.data.datasets[0].data = [
			newData.completed,
			newData.processing,
			newData.received,
			newData.rejected
		];

		mainDonutChart.update();
		updateMainLegend(newData, total);

		console.log('메인 도넛차트 데이터 업데이트 완료');

	} catch (error) {
		console.error('메인 도넛차트 데이터 업데이트 실패:', error);
	}
}

/**
 * 테이블 데이터 업데이트
 */
function updateMainStatusTable(newData) {
	try {
		if (!mainStatusTable) {
			console.error('메인 테이블이 초기화되지 않았습니다.');
			return;
		}

		mainStatusTable.clear();
		mainStatusTable.rows.add(newData);
		mainStatusTable.draw();

		console.log('메인 상태 테이블 데이터 업데이트 완료');

	} catch (error) {
		console.error('메인 테이블 데이터 업데이트 실패:', error);
	}
}

/**
 * 컴포넌트 새로고침
 */
function refreshMainStatusComponents() {
	if (mainDonutChart) {
		mainDonutChart.destroy();
		mainDonutChart = null;
	}
	if (mainStatusTable) {
		mainStatusTable.destroy();
		mainStatusTable = null;
	}
	setTimeout(initMainStatusComponents, 100);
}