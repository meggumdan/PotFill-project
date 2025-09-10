<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>POTFILL 대시보드</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 220px;
            background-color: #2c3e50;
            color: white;
            padding: 20px;
        }
        .sidebar a {
            color: white;
            display: block;
            padding: 8px 0;
            text-decoration: none;
        }
        .sidebar a:hover {
            text-decoration: underline;
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<!-- 왼쪽 네비게이션 -->
<div class="sidebar">
    <h3 class="mb-4">POTFILL</h3>
    <a href="#">대시보드</a>
    <a href="#">> 전체 보기</a>
    <a href="#">> 관할 보기</a>
    <a href="#">민원 관리</a>
    <a href="#">포트홀 지도</a>
</div>

<!-- 메인 컨텐츠 -->
<div class="content">

    <!-- 상단 카드 영역 -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card p-3 text-center">
                <h5>신규</h5>
                <h3>32건</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 text-center">
                <h5>진행중</h5>
                <h3>26건</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 text-center">
                <h5>완료</h5>
                <h3>46건</h3>
            </div>
        </div>
        <!-- 원형 그래프 -->
        <div class="col-md-3">
            <canvas id="pieChart"></canvas>
        </div>
    </div>

    <!-- 막대 그래프 -->
    <div class="card mb-4 p-3">
        <h5>최근 발생 및 처리</h5>
        <canvas id="barChart"></canvas>
    </div>

    <!-- 아코디언 테이블 -->
    <div class="card p-3">
        <h5>긴급 신고 내역</h5>
        <div class="accordion" id="reportAccordion">

            <div class="accordion-item">
                <h2 class="accordion-header" id="heading1">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapse1">
                        1. 서울특별시 청강궁로 355 (일반) - 진행중
                    </button>
                </h2>
                <div id="collapse1" class="accordion-collapse collapse show" data-bs-parent="#reportAccordion">
                    <div class="accordion-body">
                        <b>사고내용:</b> 사거리에서 사고가 났습니다.<br>
                        <b>발생시간:</b> 25.09.01 14:58:00<br>
                        <b>상태:</b> 진행중
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="heading2">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse2">
                        2. 명륜2가 41-4 (일반) - 신규
                    </button>
                </h2>
                <div id="collapse2" class="accordion-collapse collapse" data-bs-parent="#reportAccordion">
                    <div class="accordion-body">
                        <b>사고내용:</b> 3중 추돌사고 발생<br>
                        <b>발생시간:</b> 25.09.01 14:58:00<br>
                        <b>상태:</b> 신규
                    </div>
                </div>
            </div>

            <!-- 추가 항목 반복 가능 -->
        </div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 원형 그래프
    new Chart(document.getElementById('pieChart'), {
        type: 'doughnut',
        data: {
            labels: ['완료', '미완료'],
            datasets: [{
                data: [91, 89],
                backgroundColor: ['#2ecc71', '#e74c3c']
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // 막대 그래프
    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['8/29','8/30','8/31','9/1','9/2'],
            datasets: [
                { label: '10건 이상', data: [8,4,6,5,13] },
                { label: '5건 이상', data: [2,3,1,2,4] },
                { label: '1건 이상', data: [1,2,2,3,5] },
                { label: '처리 건수', data: [4,2,3,4,6] }
            ]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'top' } }
        }
    });
</script>

</body>
</html>
