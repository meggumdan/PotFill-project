<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POTFILL - 관리자 대시보드</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    
    <!-- 관리자 CSS 파일들 -->
    <link href="${pageContext.request.contextPath}/css/admin/admin-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin/admin-sidebar.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin/admin-dashboard-overall-top5.css" rel="stylesheet">
    
<!--     <style>
    .section-title {
        font-size: 8px !important;
        height: 10px !important;
        margin-bottom: 1px !important;
        padding-bottom: 0px !important;
        line-height: 1 !important;
    }
    .section-icon {
        font-size: 8px !important;
    }
    </style> -->
</head>
<body>
    <div class="admin-layout">
        <!-- 헤더 Include -->
        <%@ include file="../admin_component/header.jsp" %>
        
        <!-- 사이드바 Include -->
        <%@ include file="../admin_component/sidebar.jsp" %>
        
        <!-- 메인 컨텐츠 영역 -->
        <main class="admin-main">
            <div class="dashboard-container">
                <!-- 대시보드 컨텐츠 -->
                <div class="dashboard-content">
                    <!-- 핵심 지표 카드 (상단) -->
                    <div class="metrics-section">
                        <div class="metric-card">
                            <div class="metric-header">
                                <div class="metric-icon">📊</div>
                                <div class="metric-title">총 신고 건수</div>
                            </div>
                            <div class="metric-value">1,247 건</div>
                            <div>
                                <div class="metric-change">+127(12%)</div>
                                <div class="metric-period">전월 대비</div>
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-header">
                                <div class="metric-icon">⏳</div>
                                <div class="metric-title">처리 중</div>
                            </div>
                            <div class="metric-value">89 건</div>
                            <div>
                                <div class="metric-change">-5(-5%)</div>
                                <div class="metric-period">전월 대비</div>
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-header">
                                <div class="metric-icon">✅</div>
                                <div class="metric-title">완료</div>
                            </div>
                            <div class="metric-value">1,158 건</div>
                            <div>
                                <div class="metric-change">+132(13%)</div>
                                <div class="metric-period">전월 대비</div>
                            </div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-header">
                                <div class="metric-icon">🚨</div>
                                <div class="metric-title">고위험 지역</div>
                            </div>
                            <div class="metric-value">23개 구역</div>
                            <div>
                                <div class="metric-change">+3(15%)</div>
                                <div class="metric-period">전월 대비</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 하단 그리드 레이아웃 -->
                    <div class="dashboard-grid">
                        <!-- 우선 처리 지역 TOP 5 (좌상단) -->
                        <div class="priority-section">
                            <h3 class="section-title">
                                <span class="section-icon">🚨</span>
                                우선 처리 지역 TOP 5
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
                                            <th>우선순위 점수</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td>강남구 역삼동</td>
                                            <td>15 건</td>
                                            <td>7일</td>
                                            <td>9회</td>
                                            <td><span class="check-icon">✓</span></td>
                                            <td class="priority-score">94.2</td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td>서초구 방배동</td>
                                            <td>12 건</td>
                                            <td>14일</td>
                                            <td>8회</td>
                                            <td><span class="check-icon">✓</span></td>
                                            <td class="priority-score">87.5</td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td>마포구 상암동</td>
                                            <td>8 건</td>
                                            <td>6일</td>
                                            <td>7회</td>
                                            <td><span class="cross-icon">X</span></td>
                                            <td class="priority-score">85.1</td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td>광진구 화양동</td>
                                            <td>6 건</td>
                                            <td>5일</td>
                                            <td>10회</td>
                                            <td><span class="check-icon">✓</span></td>
                                            <td class="priority-score">79.7</td>
                                        </tr>
                                        <tr>
                                            <td>5</td>
                                            <td>종로구 혜화동</td>
                                            <td>5 건</td>
                                            <td>9일</td>
                                            <td>2회</td>
                                            <td><span class="cross-icon">X</span></td>
                                            <td class="priority-score">70.8</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- 지역별(구별) 우선도 랭킹 (좌하단) -->
                        <div class="ranking-section">
                            <h3 class="section-title">
                                <span class="section-icon">📊</span>
                                지역별(구별) 우선도 랭킹
                            </h3>
                            <div class="temp-content">
                                <div>
                                    <h4>우선도 랭킹 차트</h4>
                                    <p>서울시 25개 구별<br>종합 우선도 점수</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 지역별 포트홀 신고현황 (우상하단) -->
                        <div class="status-section">
                            <h3 class="section-title">
                                <span class="section-icon">📍</span>
                                지역별 포트홀 신고현황
                            </h3>
                            <div class="temp-content">
                                <div>
                                    <h4>전체 처리 현황</h4>
                                    <p>도넛차트<br><br>구별 상세 현황<br>신고건수, 처리율, 평균처리시간</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    
    <!-- 우선 처리 지역 TOP 5 테이블 JavaScript -->
    <script src="${pageContext.request.contextPath}/js/admin/admin-dashboard-overall-top5.js"></script>
</body>
</html>