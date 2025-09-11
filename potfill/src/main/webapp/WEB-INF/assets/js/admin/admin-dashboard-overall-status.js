/**
 * 지역별 포트홀 신고현황 전용 JavaScript (작은 도넛차트 버전)
 */

let mainDonutChart = null;
let mainStatusTable = null;

$(document).ready(function() {
	// 신고현황 컴포넌트 초기화
	initMainStatusComponents();
	
	// 실제 데이터 로드
	loadRealData();
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

		// 초기 데이터 (나중에 실제 데이터로 업데이트됨)
		const statusData = {
			completed: 0,
			processing: 0,
			received: 0,
			rejected: 0
		};

		const total = 1; // 0으로 나누기 방지

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
								const total = context.dataset.data.reduce((a, b) => a + b, 0);
								const percentage = total > 0 ? ((context.parsed / total) * 100).toFixed(0) : 0;
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

		console.log('메인 도넛차트 초기화 완료 (작은 크기)');

	} catch (error) {
		console.error('메인 도넛차트 초기화 실패:', error);
	}
}

/**
 * 메인 범례 업데이트 (작은 크기) - 피그마 디자인 적용
 */
function updateMainLegend(data, total) {
	// 완료
	const completedCount = document.querySelector('.completed-count');
	if (completedCount) {
		completedCount.textContent = data.completed.toLocaleString();
		const completedPercentage = total > 0 ? ((data.completed / total) * 100).toFixed(0) : 0;
		const percentElement = completedCount.parentElement.querySelector('.status-percentage');
		if (percentElement) {
			percentElement.textContent = completedPercentage + '%';
		}
	}
	
	// 처리중
	const processingCount = document.querySelector('.processing-count');
	if (processingCount) {
		processingCount.textContent = data.processing.toLocaleString();
		const processingPercentage = total > 0 ? ((data.processing / total) * 100).toFixed(0) : 0;
		const percentElement = processingCount.parentElement.querySelector('.status-percentage');
		if (percentElement) {
			percentElement.textContent = processingPercentage + '%';
		}
	}
	
	// 접수
	const receivedCount = document.querySelector('.received-count');
	if (receivedCount) {
		receivedCount.textContent = data.received.toLocaleString();
		const receivedPercentage = total > 0 ? ((data.received / total) * 100).toFixed(0) : 0;
		const percentElement = receivedCount.parentElement.querySelector('.status-percentage');
		if (percentElement) {
			percentElement.textContent = receivedPercentage + '%';
		}
	}
	
	// 반려
	const rejectedCount = document.querySelector('.rejected-count');
	if (rejectedCount) {
		rejectedCount.textContent = data.rejected.toLocaleString();
		const rejectedPercentage = total > 0 ? ((data.rejected / total) * 100).toFixed(0) : 0;
		const percentElement = rejectedCount.parentElement.querySelector('.status-percentage');
		if (percentElement) {
			percentElement.textContent = rejectedPercentage + '%';
		}
	}
}

/**
 * 메인 상태 테이블 초기화
 */
function initMainStatusTable() {
	try {
		// 초기 빈 데이터로 테이블 생성
		mainStatusTable = $('#mainStatusTable').DataTable({
			data: [],
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
				emptyTable: "데이터를 불러오는 중..."
			}
		});

		console.log('메인 상태 테이블 초기화 완료');

	} catch (error) {
		console.error('메인 상태 테이블 초기화 실패:', error);
	}
}

/**
 * 실제 데이터 로드
 */
function loadRealData() {
	$.ajax({
		url: contextPath + '/admin/api/dashboard/regional',
		type: 'GET',
		dataType: 'json',
		success: function(response) {
			console.log('지역별 신고현황 데이터 로드:', response);
			
			// 도넛차트 데이터 업데이트
			if (response.statusChart) {
				const data = response.statusChart.data || [0, 0, 0, 0];
				const statusData = {
					completed: data[0] || 0,
					processing: data[1] || 0,
					received: data[2] || 0,
					rejected: data[3] || 0
				};
				const total = statusData.completed + statusData.processing + statusData.received + statusData.rejected;
				
				// 차트 업데이트
				if (mainDonutChart) {
					mainDonutChart.data.datasets[0].data = [
						statusData.completed,
						statusData.processing,
						statusData.received,
						statusData.rejected
					];
					mainDonutChart.update();
				}
				
				// 범례 업데이트
				updateMainLegend(statusData, total);
			}
			
			// 테이블 데이터 업데이트
			if (response.regionalDetails && Array.isArray(response.regionalDetails)) {
				const tableData = response.regionalDetails.map((item, index) => ({
					rank: item.no || (index + 1),
					district: item.district || '',
					reports: item.reports || 0,
					rate: item.rate || 0,
					avgDays: item.avgTime || 0
				}));
				
				updateMainStatusTable(tableData);
			}
		},
		error: function(xhr, status, error) {
			console.error('데이터 로드 실패:', error);
			
			// 에러 시 기본값 표시
			const defaultData = {
				completed: 0,
				processing: 0,
				received: 0,
				rejected: 0
			};
			updateMainLegend(defaultData, 0);
		}
	});
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
	setTimeout(loadRealData, 200);
}