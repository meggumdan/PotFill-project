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
    
    <!-- 관리자 CSS 파일들 -->
    <link href="${pageContext.request.contextPath}/css/admin-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin-sidebar.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin-dashboard-overall.css" rel="stylesheet">
</head>
<body>
    <div class="admin-layout">
        <!-- 헤더 Include -->
        <%@ include file="../adminComponent/header.jsp" %>
        
        <!-- 사이드바 Include -->
        <%@ include file="../adminComponent/sidebar.jsp" %>
        
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
                        <!-- 우선처리 지역 TOP 5 (좌상단) -->
                        <div class="priority-section">
                            <h3 class="section-title">
                                <span class="section-icon">🚨</span>
                                우선처리 지역 TOP 5
                            </h3>
                            <div class="temp-content">
                                <div>
                                    <h4>우선처리 지역 테이블</h4>
                                    <p>순위, 지역명, 미처리건수, 최대경과일,<br>반복신고, 주요장소근접여부, 우선순위점수</p>
                                </div>
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
</body>
</html>