<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지 테스트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-cogs"></i> 관리자 페이지 연결 테스트
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle"></i>
                            <strong>${message}</strong>
                        </div>
                        
                        <h6>테스트 링크들:</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="list-group">
                                    <a href="${pageContext.request.contextPath}/" class="list-group-item list-group-item-action">
                                        <i class="fas fa-home"></i> 홈페이지
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action">
                                        <i class="fas fa-tachometer-alt"></i> 대시보드 메인 페이지
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6>API 테스트:</h6>
                                <button onclick="testAPI('/admin/api/dashboard/kpi')" class="btn btn-info btn-sm mb-2">
                                    <i class="fas fa-chart-line"></i> KPI API 테스트
                                </button><br>
                                <button onclick="testAPI('/admin/api/dashboard/priority')" class="btn btn-warning btn-sm mb-2">
                                    <i class="fas fa-exclamation-triangle"></i> 우선처리 API 테스트
                                </button><br>
                                <button onclick="testAPI('/admin/api/dashboard/ranking')" class="btn btn-success btn-sm mb-2">
                                    <i class="fas fa-chart-bar"></i> 랭킹 API 테스트
                                </button><br>
                                <button onclick="testAPI('/admin/api/dashboard/regional')" class="btn btn-secondary btn-sm mb-2">
                                    <i class="fas fa-map"></i> 신고현황 API 테스트
                                </button>
                            </div>
                        </div>
                        
                        <div id="apiResult" class="mt-4" style="display: none;">
                            <h6>API 응답 결과:</h6>
                            <pre id="apiResponseContent" style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; max-height: 300px; overflow-y: auto;"></pre>
                        </div>
                        
                        <div class="mt-4">
                            <small class="text-muted">
                                <i class="fas fa-clock"></i> 현재 시간: <%= new java.util.Date() %>
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function testAPI(url) {
            const resultDiv = document.getElementById('apiResult');
            const contentPre = document.getElementById('apiResponseContent');
            
            contentPre.textContent = '요청 중...';
            resultDiv.style.display = 'block';
            
            fetch(url)
                .then(response => response.text())
                .then(data => {
                    contentPre.textContent = JSON.stringify(JSON.parse(data), null, 2);
                })
                .catch(error => {
                    contentPre.textContent = '오류 발생: ' + error.message;
                });
        }
    </script>
</body>
</html>