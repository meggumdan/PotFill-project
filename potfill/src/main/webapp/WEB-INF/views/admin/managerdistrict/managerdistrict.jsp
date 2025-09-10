<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>

<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
	background: #f5f6fa;
}

.top-row {
	display: flex;
	justify-content: space-between; /* 좌우 공간 조절 */
	align-items: stretch; /* 같은 높이 맞추기 */
	gap: 20px; /* 카드 사이 간격 */
	margin-bottom: 40px;
}

.card-horizontal {
	display: flex;
	flex: 1;
	align-items: center;
	justify-content: center;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	padding: 30px;
	text-align: center;
	gap: 30px;
}

.card-vertical {
	display: flex;
	flex: none; /* 공간 확장 제거 */
	flex-direction: column; /* 세로 정렬 */
	align-items: center;
	justify-content: center;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	padding: 40px;
	text-align: center;
}

.card-part {
	position: relative; /* 추가 */
}

.card-ing {
	position: absolute;
	top: 50%;
	left: 0; /* 좌측부터 시작 */
	width: 100%; /* card-part 폭만큼 */
	display: flex;
	justify-content: space-between;
	align-items: center;
	transform: translateY(-50%);
}

/* status-box들을 감싸는 영역 */
.status-wrapper {
	height: 100%;
	display: flex;
	justify-content: space-between; /* status-box 간격 */
	align-items: center;
	height: 100%;
	position: relative; /* line 절대 위치 기준 */
	z-index: 1; /* status-box 위로 */
}

/* 가로선 */
.horizontal-line {
	position: absolute;
	top: 50%;
	left: 0;
	right: 0;
	height: 2px;
	background: #eee;
	border-radius: 1px;
	z-index: 0;
}

/* 도트 */
.card-ing {
	position: absolute;
}

.minidot {
	width: 10px;
	height: 10px;
	border-radius: 50%;
	z-index: 1; /* 선 위 */
	margin: 60px; /* 좌우 패딩 포함 */
}

.status-box {
	display: flex;
	flex-direction: column; /* 텍스트 위아래 정렬 */
	justify-content: center; /* 세로 가운데 */
	align-items: center; /* 가로 가운데 */
	text-align: center;
	width: 130px;
	gap: 20px;
}

.status-box span {
	font-size: 20px;
}

.status-box p {
	font-size: 15px;
}

table {
	width: 90%;
	margin: 0 auto;
	border-collapse: collapse;
	background: #fff;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

th, td {
	padding: 10px;
	border: 1px solid #ddd;
	text-align: center;
}

th {
	background: #f0f0f0;
}

#circleChart {
	width: 132px;
	height: 132px;
}

#barChart {
	width: 570px;
	height: 239px;
}

.emergencytable {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

.emergencytable th, .emergencytable td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: center;
}

.emergencytable th {
	background-color: #f8f9fa;
	font-weight: bold;
}

.emergencytable .sf_text_overflow {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.emergencytable .detail-row {
	background-color: #fdfdfd;
}

.emergencytable .detail-row td {
	text-align: left;
	padding: 15px;
}

.emergencytable tr.clickable:hover {
	background-color: #f1f1f1;
	cursor: pointer;
}

.report-content {
	width: 70px;
	display: inline-block;
	text-align: justify;
	font-weight: semibold;
}

.detail-textarea {
	display: flex;
	align-items: flex-start; /* b를 top에 붙이기 */
}

.detail-textarea textarea {
	flex: 1; /* 필요하면 너비 조절 가능 */
}
</style>
</head>
<body>

	<div class="top-row">
		<!-- 신규&진행&완료 건수 출력 -->
		<div class="card-horizontal">

			<div class="card-part">
				<div class="card-ing">
					<!-- 배경 가로선 -->
					<div class="horizontal-line"></div>
					<!-- 도트 -->
					<div class="minidot" style="background: #03A9F4;"></div>
					<div class="minidot" style="background: #FF9800;"></div>
					<div class="minidot" style="background: #9E9E9E;"></div>
				</div>

				<div class="status-wrapper">
					<div class="status-box">
						<span>${newCount} 건</span>
						<p>신규</p>
					</div>
					<div class="status-box">
						<span>${processingCount} 건</span>
						<p>진행중</p>
					</div>
					<div class="status-box">
						<span>${completedCount} 건</span>
						<p>완료</p>
					</div>
				</div>
			</div>
			<!-- 도넛 차트 -->
			<canvas id="circleChart" width="132" height="132"></canvas>
		</div>

		<!-- 최근 7일 건수 -->
		<div class="card-vertical" style="max-height: 240px;">
			<p style="text-align: center; padding-bottom: 10px;">최근 7일간 발생 및
				처리 건수</p>
			<canvas id="barChart" width="400px" height="160px"></canvas>
		</div>

	</div>

	<div class="card-vertical">
		<h3 style="text-align: center; padding-bottom: 20px;">긴급 신고 내역</h3>

		<table class="emergencytable">
			<colgroup>
				<col width="10%">
				<col width="25%">
				<col width="30%">
				<col width="15%">
				<col width="20%">
			</colgroup>
			<thead>
				<tr>
					<th>긴급순위</th>
					<th>신고지역</th>
					<th>신고내용</th>
					<th>발생시간</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="complaint" items="${emergencyList}"
					varStatus="status">
					<!-- 요약행 -->
					<tr class="clickable" data-bs-toggle="collapse"
						data-bs-target="#detail-${status.count}">
						<td>${status.count}</td>
						<td>${complaint.incidentAddress}</td>
						<td class="sf_text_overflow">${complaint.reportContent}</td>
						<td><fmt:formatDate value="${complaint.createdAt}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td style="color: ${complaint.reportCount > 0 ? 'red' : 'green'};">
							${complaint.reportCount > 0 ? '신규' : '완료'}</td>
					</tr>
					<!-- 상세행 -->
					<tr id="detail-${status.count}" class="collapse detail-row">
						<!-- 라벨 -->
						<td colspan="1"
							style="text-align: right; font-weight: bold; vertical-align: top;">

						</td>

						<!-- 내용 -->
						<td colspan="4"><b class="report-content">신&nbsp;고&nbsp;자</b>:&nbsp;${complaint.reporterName}<br>
							<b class="report-content">주&nbsp;소</b>:&nbsp;${complaint.incidentAddress}<br>
							<b class="report-content">발생시간</b>:&nbsp; <fmt:formatDate
								value="${complaint.createdAt}" pattern="yyyy-MM-dd HH:mm" /><br>
							<div class="detail-textarea">
								<b class="report-content">상세내용</b>:&nbsp;
								<textarea class="form-control" rows="3">${complaint.reportContent}</textarea>
							</div>
							<div style="display: flex; justify-content: flex-end;">
								<button class="btn btn-primary">접수</button>
							</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>








		<script>
    // 원형 차트 (완료율)

    const ctxDonut = document.getElementById('circleChart').getContext('2d');

    const dataDounut = {
        labels: ['완료', '미완료'],
        datasets: [{
            data: [${completedCount}, ${newCount + processingCount}],
            backgroundColor: [
                '#00E88B',   // 완료
                '#D0D0D0'   // 미완료
            ],
            borderWidth: [0,5],
            hoverOffset: 1
        }]
    };

    const configDonut = {
        type: 'doughnut',
        data: dataDounut,
        options: {
        		cutout: '80%',
            responsive: false,   // width/height 유지
            elements: {
                arc: {
                    borderWidth: 0 // 테두리 두께를 0으로 설정하여 없앱니다.
                }
            },
            plugins: {
                legend: { display: false }, // legend 숨김
                tooltip: { enabled: true }
            }
        },
        plugins: [{
            id: 'centerText',
            beforeDraw: (chart) => {
                const {width, height, ctx} = chart;
                ctx.save();

                const total = ${newCount + processingCount + completedCount};
                const done = ${completedCount};
                const percent = ((done / total) * 100).toFixed(1) + "%";

                ctx.font = "14px Arial";
                ctx.fillStyle = "#333";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";

                const centerX = width / 2;
                const centerY = height / 2;

                ctx.fillText("Total : " + total, centerX, centerY - 20);
                ctx.fillText("완료 : " + done, centerX, centerY - 5);
                
                ctx.font = "bold 20px Arial";
                ctx.fillText(percent, centerX, centerY + 20);

                ctx.restore();
            }
        }]
    };

    new Chart(ctxDonut, configDonut);
    
    
    // 막대 차트 (최근 7일간 접수/완료 현황)
    const dailyCounts = [
        <c:forEach var="dc" items="${dailyCounts}" varStatus="status">
            {
                date: '<c:out value="${dc.date}" default=""/>',
                received: <c:out value="${dc.newCount}" default="0"/>,
                completed: <c:out value="${dc.completedCount}" default="0"/>
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const dates = dailyCounts.map(dc => dc.date); // 원래 날짜 문자열 그대로 사용
    const receivedData = dailyCounts.map(dc => dc.received);
    const completedData = dailyCounts.map(dc => dc.completed);

    const barData = {
        labels: dates, // 실제 데이터는 원본 유지
        datasets: [
            {
                label: '완료',
                data: completedData,
                backgroundColor: '#D9D9D9',
                borderSkipped: false,
                maxBarThickness: 15
            },
            {
                label: '접수',
                data: receivedData,
                backgroundColor: '#B1F4F0',
                borderSkipped: false,
                maxBarThickness: 15
            }
        ]
    };

    const barConfig = {
    	    type: 'bar',
    	    data: barData,
    	    options: {
    	        responsive: true,
    	        maintainAspectRatio: false,  // true면 canvas 비율에 맞춰 늘어남
    	        interaction: { intersect: false },
    	        layout: { padding: 10 },
    	        scales: {
	    	        	x: {
	    	        	    stacked: true,
	    	        	    grid: { display: false },
	    	        	    ticks: {
	    	        	        callback: function(value, index) {
	    	        	            const d = new Date(this.getLabelForValue(index));
	    	        	            return (d.getMonth() + 1) + '/' + d.getDate();
	    	        	        },
	    	        	        font: { size: 12 }
	    	        	    }
	    	        	},
    	            y: {
    	                stacked: true,
    	                beginAtZero: true,
    	                grid: { color: '#f0f0f0' },
    	                ticks: { stepSize: 1 }
    	            }
    	        },
    	        plugins: {
    	            legend: { position: 'right', labels: { usePointStyle: true, padding: 20 } },
    	            tooltip: {
    	                callbacks: {
    	                    label: function(context) {
    	                        return context.dataset.label + ': ' + context.parsed.y + '건';
    	                    }
    	                }
    	            },
    	            datalabels: {
    	                color: 'white',
    	                anchor: 'center',
    	                align: 'center',
    	                font: { weight: 'bold', size: 12 },
    	                formatter: function(value) {
    	                    return value === 0 ? '' : value;  // 0이면 표시 안함
    	                }
    	            }
    	        }
    	    },
    	    plugins: [ChartDataLabels]
    	};

    	new Chart(document.getElementById('barChart').getContext('2d'), barConfig);
    
</script>
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>