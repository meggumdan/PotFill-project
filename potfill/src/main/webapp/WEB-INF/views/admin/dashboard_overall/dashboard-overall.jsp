<!--
	작성자 : 최영준 
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>POTFILL - 관리자 대시보드</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet">


<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">

<!-- DataTables CSS -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<!-- 관리자 CSS 파일들 -->
<link
	href="${pageContext.request.contextPath}/css/admin/admin-header.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-sidebar.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall-top5.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall-rank.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall-status.css"
	rel="stylesheet">
</head>
<body>
	<div class="admin-layout">
		<!-- 헤더 Include -->
		<%@ include file="../admin_component/header.jsp"%>
		
		<!-- 사이드바 Include -->
		<%@ include file="../admin_component/sidebar.jsp"%>
		
		<!-- 메인 컨텐츠 영역 -->
		<main class="admin-main">
			<div class="dashboard-container">
				<!-- 대시보드 컨텐츠 -->
				<div class="dashboard-content">
					<!-- 핵심 지표 카드 (상단) -->
					<!-- 핵심 지표 카드 (상단) -->
					<div class="metrics-section">
						<!-- 총 신고 건수 -->
						<div class="metric-card" id="totalCard">
							<div class="metric-header">
								<div class="metric-icon">📊</div>
								<div class="metric-title">총 신고 건수</div>
							</div>
							<div class="metric-value"></div>
							<!-- JS로 채워짐 -->
							<div>
								<div class="metric-change"></div>
								<!-- JS로 채워짐 -->
								<div class="metric-period">전월 대비</div>
							</div>
						</div>

						<!-- 처리 중 -->
						<div class="metric-card" id="processingCard">
							<div class="metric-header">
								<div class="metric-icon">⏳</div>
								<div class="metric-title">처리 중</div>
							</div>
							<div class="metric-value"></div>
							<!-- JS로 채워짐 -->
							<div>
								<div class="metric-change"></div>
								<!-- JS로 채워짐 -->
								<div class="metric-period">전월 대비</div>
							</div>
						</div>

						<!-- 완료 -->
						<div class="metric-card" id="completedCard">
							<div class="metric-header">
								<div class="metric-icon">✅</div>
								<div class="metric-title">완료</div>
							</div>
							<div class="metric-value"></div>
							<!-- JS로 채워짐 -->
							<div>
								<div class="metric-change"></div>
								<!-- JS로 채워짐 -->
								<div class="metric-period">전월 대비</div>
							</div>
						</div>

						<!-- 고위험 지역 -->
						<div class="metric-card" id="dangerCard">
							<div class="metric-header">
								<div class="metric-icon">🚨</div>
								<div class="metric-title">
									고위험 지역 <span tabindex="0" data-bs-toggle="popover"
										data-bs-trigger="hover focus" data-bs-placement="bottom"
										title="고위험 지역 기준" data-bs-html="true"
										data-bs-content="<strong>조건:</strong><br>
                • 90일 내 3건 이상 신고<br>
                • 60일 이내 재발생<br>
                • 위 조건이 구 내 2개 동 이상 해당">
										<i class="bi bi-question-circle"
										style="font-size: 13px; color: #C4CEFE; cursor: pointer;"></i>
									</span>
								</div>
							</div>
							<div class="metric-value"></div>
							<!-- JS로 채워짐 -->
							<div>
								<div class="metric-change"></div>
								<!-- JS로 채워짐 -->
								<div class="metric-period">전월 대비</div>
							</div>							
						</div>						
					</div>


					<!-- 하단 그리드 레이아웃 -->
					<div class="dashboard-grid">
						<!-- 우선 처리 지역 TOP 5 (좌상단) -->
						<div class="priority-section">
							<h3 class="section-title">
								<span class="section-icon">🚨</span> 우선 처리 지역 TOP 5
								    <a href="${pageContext.request.contextPath}/admin/majorPlaceUpload" 
								       class="btn btn-sm btn-primary me-3"
								       style="background-color: #798BFF;border-color: #798BFF;font-size:10px;margin-left: 1%; font-size:10px">
								        <i class="bi bi-pin-map-fill"></i> 주요장소 업로드
								    </a>
							</h3>
							<div class="priority-table-container">
								<table id="priorityTable" class="priority-table">
									<thead>
										<tr>
											<th>순위</th>
											<th>지역명</th>
											<th>미처리 건수</th>
											<th>최대 경과일</th>
											<th>반복 신고</th>
											<th>주요장소 근접 여부</th>
											<th>우선순위 점수 <span tabindex="0" data-bs-toggle="popover"
												data-bs-trigger="hover focus" data-bs-placement="top"
												title="우선순위 점수 산정 기준" data-bs-html="true"
												data-bs-content="(미처리 건수×1.0) + (최대 경과일×0.8)<br>
												 + (반복 신고×1.2)<br>
												 주요장소 근접 시 총점×1.3 가중치 적용">
													<i class="bi bi-question-circle"
													style="font-size: 11px; color: #C4CEFE; cursor: pointer; margin-left: 3px;"></i>
											</span>
											</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>

							</div>
						</div>

						<!-- 지역별(구별) 우선도 랭킹 (좌하단) -->
						<div class="ranking-section">
							<h3 class="section-title">
								<span class="section-icon">📊</span> 지역구별 우선순위 지수 <span
									tabindex="0" data-bs-toggle="popover"
									data-bs-trigger="hover focus" data-bs-placement="right"
									title="지역구별 우선순위 지수 산정" data-bs-html="true"
									data-bs-content="(전체 신고 × 0.5) + (미처리 × 1.5)<br>
									 + (평균 반복 × 2.0) + (영향 동 수 × 1.0) <br>
									 주요장소 1개당 10% 추가 가중치 적용">
									<i class="bi bi-question-circle"
									style="font-size: 13px; color: #C4CEFE; cursor: pointer; margin-left: 5px;"></i>
								</span>
							</h3>
							<!-- 지역별(구별) 우선도 랭킹 (좌하단) 섹션 내부에 추가 -->
							<div class="ranking-chart-container">
								<div class="ranking-chart-wrapper">
									<canvas id="rankingChart"></canvas>
								</div>
							</div>
						</div>

						<!-- 지역별 포트홀 신고현황 섹션 -->
						<div class="status-section">
							<h3 class="section-title">
								<span class="section-icon">📍</span> 지역별 포트홀 신고현황
							</h3>

							<div
								style="text-align: center; font-size: 13px; color: #8094AE; margin-bottom: 0px;">
								전체 처리 현황</div>

							<div style="display: flex; gap: 20px; margin-bottom: 0px;">
								<!-- 도넛차트 (왼쪽) -->
								<div style="width: 170px; height: 170px; flex-shrink: 0;">
									<canvas id="statusDonutChart"
										style="width: 170px !important; height: 170px !important;"></canvas>
								</div>

								<!-- 범례 (오른쪽) - 정사각형 컬러박스와 함께 -->
								<div
									style="flex: 1; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: 0.5fr 0.4fr; gap: 0px 0px; padding-top: 0px; padding-left: 26px"
									class="chart-legend-grid">
									<!-- 완료 -->
									<div class="legend-entry">
										<div class="color-box"
											style="background-color: #D4DFB8; width: 18px; height: 18px; border-radius: 0px; flex-shrink: 0; margin-bottom: 15px;'"></div>
										<div class="legend-details">
											<div class="status-label"
												style="font-size: 15px; color: #364A63; font-weight: 500;">완료</div>
											<div class="status-value"
												style="font-size: 16px; font-weight: 600; color: #8094AE; margin-top: 3px">
												<span class="completed-count">0</span>건 <span
													class="status-percentage"
													style="font-size: 12px; color: #8094AE; margin-left: 3px;">0%</span>
											</div>
										</div>
									</div>

									<!-- 처리중 -->
									<div class="legend-entry">
										<div class="color-box"
											style="background-color: #3D70C3; width: 18px; height: 18px; border-radius: 0px; flex-shrink: 0; margin-bottom: 15px;"></div>
										<div class="legend-details">
											<div class="status-label"
												style="font-size: 15px; color: #364A63; font-weight: 500;">처리중</div>
											<div class="status-value"
												style="font-size: 16px; font-weight: 600; color: #8094AE; margin-top: 3px">
												<span class="processing-count">0</span>건 <span
													class="status-percentage"
													style="font-size: 12px; color: #8094AE; margin-left: 3px;">0%</span>
											</div>
										</div>
									</div>

									<!-- 접수 -->
									<div class="legend-entry">
										<div class="color-box"
											style="background-color: #FFB97D; width: 18px; height: 18px; border-radius: 0px; flex-shrink: 0; margin-bottom: 15px;"></div>
										<div class="legend-details">
											<div class="status-label"
												style="font-size: 15px; color: #364A63; font-weight: 500;">접수</div>
											<div class="status-value"
												style="font-size: 16px; font-weight: 600; color: #8094AE; margin-top: 3px">
												<span class="received-count">0</span>건 <span
													class="status-percentage"
													style="font-size: 12px; color: #8094AE; margin-left: 3px;">0%</span>
											</div>
										</div>
									</div>

									<!-- 반려 -->
									<div class="legend-entry">
										<div class="color-box"
											style="background-color: #868EA1; width: 18px; height: 18px; border-radius: 0px; flex-shrink: 0; margin-bottom: 15px;"></div>
										<div class="legend-details">
											<div class="status-label"
												style="font-size: 15px; color: #364A63; font-weight: 500;">반려</div>
											<div class="status-value"
												style="font-size: 16px; font-weight: 600; color: #8094AE; margin-top: 3px">
												<span class="rejected-count"></span>건 <span
													class="status-percentage"
													style="font-size: 12px; color: #8094AE; margin-left: 3px;">%</span>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div
								style="text-align: center; font-size: 13px; color: #8094AE; margin-bottom: 5px; margin-top: 5%;">
								구별 상세 현황</div>

							<div style="height: calc(100% - 180px); overflow: hidden;">
								<table id="mainStatusTable"
									style="width: 100%; border-collapse: collapse; font-size: 12px;">
								</table>
							</div>
							<!-- 테이블 스타일을 위한 CSS 추가 -->
							<style>
#mainStatusTable tbody td {
	font-size: 14px !important;
	padding: 8px 4px !important;
	color: #364A63 !important;
}

/* 순위 컬럼 (첫 번째 컬럼) */
#mainStatusTable tbody td:nth-child(1) {
	color: #798BFF !important;
	font-weight: 600 !important;
}

/* 평균 처리시간 컬럼 (다섯 번째 컬럼) */
#mainStatusTable tbody td:nth-child(5) {
	color: #E85347 !important;
	font-weight: 600 !important;
}

/* Popover 커스터마이징 */
.popover {
	background-color: rgba(255, 255, 255, 0.95); /* 반투명 배경 */
	backdrop-filter: blur(10px);
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.popover-header {
	background-color: rgba(62, 70, 83, 0.9); /* #3E4653 반투명 */
	color: white;
	font-weight: 600;
	font-size: 13px;
}

.popover-body {
	background-color: rgba(255, 255, 255, 0.95);
	color: #364A63;
	font-size: 12px;
	line-height: 1.5;
}

/* 물음표 아이콘 호버 효과 */
.bi-question-circle:hover {
	transform: scale(1.1);
	transition: transform 0.2s ease;
}
</style>

						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>


	<!-- DataTables -->
	<script
		src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
	<!-- Chart.js CDN -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<!-- 공통 js(kpi 포함) -->
	<script>
		const contextPath = "${pageContext.request.contextPath}";
	</script>

	<script
		src="${pageContext.request.contextPath}/js/admin/admin-dashboard-overall.js"></script>

	<!-- 우선 처리 지역 TOP 5 테이블 JavaScript -->
	<script
		src="${pageContext.request.contextPath}/js/admin/admin-dashboard-overall-top5.js"></script>
	<!-- 랭킹 차트 JavaScript -->
	<script
		src="${pageContext.request.contextPath}/js/admin/admin-dashboard-overall-rank.js"></script>
	<!-- 포트홀 신고 현황 JavaScript -->
	<script
		src="${pageContext.request.contextPath}/js/admin/admin-dashboard-overall-status.js"></script>
	<!-- ❓ 팝오버 초기화 코드 (맨 마지막에 추가) -->
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const popoverTriggerList = [].slice.call(document
					.querySelectorAll('[data-bs-toggle="popover"]'))
			popoverTriggerList.map(function(popoverTriggerEl) {
				return new bootstrap.Popover(popoverTriggerEl)
			})
		});
	</script>
</body>
</html>