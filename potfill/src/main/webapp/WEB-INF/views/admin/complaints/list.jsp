<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>민원 관리 - PotFill</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<style>
/* CSS는 변경 사항이 없으므로 생략합니다. */
.sidebar {
	min-height: 100vh;
	background-color: #343a40;
}

.main-content {
	min-height: 100vh;
}

.complaint-item {
	cursor: pointer;
	border-left: 4px solid transparent;
	transition: all 0.3s;
}

.complaint-item:hover {
	background-color: #f8f9fa;
	border-left-color: #007bff;
}

.complaint-item.selected {
	background-color: #e3f2fd;
	border-left-color: #2196f3;
}

.risk-badge {
	font-size: 0.75rem;
}

.risk-high {
	background-color: #dc3545;
}

.risk-medium {
	background-color: #fd7e14;
}

.risk-low {
	background-color: #28a745;
}

.status-received {
	background-color: #6c757d;
}

.status-processing {
	background-color: #17a2b8;
}

.status-completed {
	background-color: #28a745;
}

.status-rejected {
	background-color: #dc3545;
}

.detail-panel {
	height: calc(100vh - 140px);
	overflow-y: auto;
}

.list-panel {
	height: calc(100vh - 140px);
	overflow-y: auto;
}
</style>
</head>
<body>
	<%-- 테스트용 h2 태그는 이제 필요 없으므로 삭제합니다. --%>
	<%-- <jsp:include page="/WEB-INF/views/admin/common/header.jsp"/> --%>

	<div class="container-fluid">
		<div class="row">
			<%-- <div class="col-md-2 p-0">
                <jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp"/>
            </div> --%>

			<div class="col-md-10 main-content p-4">
				<div class="d-flex justify-content-between align-items-center mb-4">
					<h2>
						<i class="fas fa-tasks me-2"></i>민원 관리
					</h2>
					<div class="d-flex gap-2">
						<button class="btn btn-outline-success" id="exportBtn">
							<i class="fas fa-download"></i> 내보내기
						</button>
					</div>
				</div>

				<div class="card mb-4">
					<div class="card-body">
						<div class="row g-3">
							<div class="col-md-2">
								<label class="form-label">기간</label> <select class="form-select"
									id="periodFilter">
									<option value="">전체</option>
									<option value="today">오늘</option>
									<option value="week">7일</option>
									<option value="month">30일</option>
									<option value="custom">직접 선택</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">상태</label> <select class="form-select"
									id="statusFilter">
									<option value="">전체</option>
									<option value="RECEIVED">접수</option>
									<option value="PROCESSING">처리중</option>
									<option value="COMPLETED">완료</option>
									<option value="REJECTED">반려</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">위험도</label> <select
									class="form-select" id="riskFilter">
									<option value="">전체</option>
									<option value="HIGH">높음</option>
									<option value="MEDIUM">보통</option>
									<option value="LOW">낮음</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">구/동</label> <select
									class="form-select" id="guFilter">
									<option value="">전체</option>
									<option value="강남구">강남구</option>
									<option value="서초구">서초구</option>
									<option value="송파구">송파구</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">정렬</label> <select class="form-select"
									id="sortFilter">
									<option value="created_at,DESC">최신순</option>
									<option value="risk_level,DESC">위험도순</option>
									<option value="report_count,DESC">신고건수순</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">&nbsp;</label>
								<button class="btn btn-primary d-block w-100" id="searchBtn">
									<i class="fas fa-search"></i> 검색
								</button>
							</div>
						</div>
						<div class="row mt-3">
							<div class="col-md-8">
								<div class="input-group">
									<select class="form-select" id="searchType"
										style="max-width: 120px;">
										<option value="complaintId">민원ID</option>
										<option value="reporterName">신고자명</option>
										<option value="reporterNumber">전화번호</option>
										<option value="address">주소</option>
									</select> <input type="text" class="form-control" id="searchKeyword"
										placeholder="검색어를 입력하세요" onkeypress="handleEnterKey(event)">
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-md-6">
						<div class="card">
							<div
								class="card-header d-flex justify-content-between align-items-center">
								<h5 class="mb-0">민원 목록</h5>
								<span class="badge bg-secondary" id="totalCount">0건</span>
							</div>
							<div class="card-body p-0 list-panel" id="complaintList"></div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="card">
							<div class="card-header">
								<h5 class="mb-0">상세 정보</h5>
							</div>
							<div class="card-body detail-panel" id="detailPanel">
								<div class="text-center text-muted py-5">
									<i class="fas fa-hand-pointer fa-3x mb-3"></i>
									<p>민원을 선택하여 상세 정보를 확인하세요.</p>
								</div>
							</div>
						</div>
					</div>
				</div>

				<nav class="mt-4" id="paginationArea"></nav>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<script>
        // 수정 1: Context Path를 JSP를 통해 JavaScript 변수로 설정합니다.
        // 이렇게 하면 프로젝트 배포 경로가 바뀌어도 AJAX URL이 정상적으로 동작합니다.
        const CONTEXT_PATH = "/potfill"; 

        let currentPage = 1;
        let selectedComplaintId = null;
        
        $(document).ready(function() {
            loadComplaintList();
            
            // ★ 수정: 검색 버튼과 필터 변경 이벤트를 하나의 핸들러로 통합
            $('#searchBtn, #statusFilter, #riskFilter, #guFilter, #sortFilter, #periodFilter').on('click change', function() {
                currentPage = 1;
                loadComplaintList();
            });
        });

        function loadComplaintList() {
            // 필터와 검색창의 모든 값을 가져와 searchParams 객체를 만듭니다.
            const searchParams = {
                page: currentPage,
                pageSize: 20,
                searchType: $('#searchType').val(),
                searchKeyword: $('#searchKeyword').val(),
                status: $('#statusFilter').val(),
                riskLevel: $('#riskFilter').val(),
                gu: $('#guFilter').val(),
                sortBy: $('#sortFilter').val().split(',')[0],
                sortOrder: $('#sortFilter').val().split(',')[1]
                // 기간(period) 필터는 필요 시 여기에 추가합니다.
            };
            
            $.ajax({
                url: CONTEXT_PATH + '/admin/complaints/api/list',
                method: 'GET',
                data: searchParams, // 완성된 파라미터를 서버로 전송
                success: function(response) {
                    // 성공 응답을 받으면, 데이터를 화면에 그리고 페이지네이션을 업데이트합니다.
                    if (response.success) {
                        renderComplaintList(response.data.complaints);
                        renderPagination(response.data);
                        $('#totalCount').text(response.data.totalCount + '건');
                    } else {
                        $('#complaintList').html(`<div class="text-center text-muted p-4">${escapeHtml(response.message)}</div>`);
                    }
                },
                error: function() {
                    // 통신 실패 시 에러 메시지를 표시합니다.
                    $('#complaintList').html('<div class="text-center text-danger p-4">데이터를 불러오는 데 실패했습니다.</div>');
                }
            });
        }
       // 민원 리스트 렌더링
function renderComplaintList(complaints) {
    let html = '';
    if (!complaints || complaints.length === 0) { // complaints가 null이거나 비어있는 경우 방어 코드
        html = '<div class="text-center text-muted py-4">검색 결과가 없습니다.</div>';
    } else {
        complaints.forEach(function(complaint) {
            // ★ 수정: Optional Chaining(?.)을 사용하여 null 오류를 원천적으로 방지합니다.
            const riskClass = complaint.riskLevel?.toLowerCase() || 'low';
            const statusClass = complaint.status?.toLowerCase() || 'received';
            const statusText = getStatusText(complaint.status);
            const riskText = getRiskText(complaint.riskLevel);
            
            const safeAddress = escapeHtml(complaint.incidentAddress || '주소 없음');
            const maskedName = maskName(escapeHtml(complaint.reporterName)); 
            
            const duplicateBadge = complaint.reportCount > 1 
                ? `<span class="badge bg-warning text-dark">중복 ${complaint.reportCount}건</span>` 
                : '';

            html += `
                <div class="complaint-item p-3 border-bottom" data-id="${complaint.complaintId}" 
                     onclick="selectComplaint(${complaint.complaintId})">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <div>
                            <h6 class="mb-1">#${complaint.complaintId}</h6>
                            <small class="text-muted">${formatDate(complaint.createdAt)}</small>
                        </div>
                        <div class="text-end">
                            <span class="badge risk-${riskClass} risk-badge me-1">${riskText}</span>
                            <span class="badge status-${statusClass}">${statusText}</span>
                        </div>
                    </div>
                    <p class="mb-2 text-truncate">${safeAddress}</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">신고자: ${maskedName}</small>
                        ${duplicateBadge}
                    </div>
                </div>
            `;
        });
    }
    $('#complaintList').html(html);
}
function selectComplaint(complaintId) {
    selectedComplaintId = complaintId;
    $('.complaint-item').removeClass('selected');
    $(`.complaint-item[data-id="${complaintId}"]`).addClass('selected');
    loadComplaintDetail(complaintId);
} 
       
function loadComplaintDetail(complaintId) {
    $.ajax({
        url: `${CONTEXT_PATH}/admin/complaints/api/detail/${complaintId}`,
        method: 'GET',
        success: function(response) {
            if (response.success) {
                renderComplaintDetail(response.data);
            } else {
                $('#detailPanel').html(`<div class="text-center text-danger p-4">${escapeHtml(response.message)}</div>`);
            }
        },
        error: function() {
            $('#detailPanel').html('<div class="text-center text-danger p-4">상세 정보를 불러오는 데 실패했습니다.</div>');
        }
    });
}

        // 요약 탭 렌더링
        function renderSummaryTab(complaint) {
            // 수정 2: 출력되는 모든 데이터에 escapeHtml 함수를 적용합니다.
            return `
                <div class="row">
                    <div class="col-md-6">
                        <table class="table table-borderless">
                            <tr><th width="30%">신고자:</th><td>${escapeHtml(complaint.reporterName)} (${maskPhone(complaint.reporterNumber)})</td></tr>
                            </table>
                    </div>
                </div>
                <div class="mt-3">
                    <h6>신고 내용:</h6>
                    <p class="bg-light p-3 rounded">${escapeHtml(complaint.reportContent || '내용 없음')}</p>
                </div>
            `;
        }
        
        function changeStatus(complaintId) {
            // 수정 3: prompt 대신 Bootstrap Modal을 사용하는 것을 강력히 권장합니다.
            // 아래는 임시로 현재 로직을 유지하되, 개선 방향을 제시합니다.
            // TODO: Bootstrap Modal로 교체하여 사용자 경험 개선
            const newStatus = prompt('새로운 상태를 입력하세요 (RECEIVED/PROCESSING/COMPLETED/REJECTED):');
            if (newStatus) {
                const comment = prompt('처리 코멘트를 입력하세요:');
                
                $.ajax({
                    // 수정 1: URL 앞에 CONTEXT_PATH를 추가합니다.
                    url: CONTEXT_PATH + '/admin/complaints/api/status',
                    method: 'POST',
                    data: { complaintId, status: newStatus, comment },
                    success: function(response) { /* ... */ },
                    error: function() { /* ... */ }
                });
            }
        }
        
        // --- 유틸리티 함수들 ---

        // 수정 2: XSS 방지를 위한 HTML 이스케이프 함수 추가
        function escapeHtml(text) {
            if (text === null || text === undefined) {
                return '';
            }
            return text
                 .replace(/&/g, "&amp;")
                 .replace(/</g, "&lt;")
                 .replace(/>/g, "&gt;")
                 .replace(/"/g, "&quot;")
                 .replace(/'/g, "&#039;");
        }
        
        function getStatusText(status) {
            const statusMap = { 'RECEIVED': '접수', 'PROCESSING': '처리중', 'COMPLETED': '완료', 'REJECTED': '반려' };
            return statusMap[status] || '미정';
        }

        function getRiskText(risk) {
            const riskMap = { 'HIGH': '높음', 'MEDIUM': '보통', 'LOW': '낮음' };
            return riskMap[risk] || '낮음';
        }

        function maskName(name) {
            if (!name || name.length < 2) return name;
            return name.charAt(0) + '*'.repeat(name.length - 2) + name.charAt(name.length - 1);
        }

        function maskPhone(phone) {
            if (!phone) return '';
            return phone.replace(/(\d{3})-(\d{4})-(\d{4})/, '$1-****-$3');
        }

        function formatDate(dateValue) {
            if (!dateValue) return '';
            const date = new Date(dateValue);
            return date.toLocaleDateString('ko-KR');
        }

        function formatDateTime(dateValue) {
            if (!dateValue) return '';
            const date = new Date(dateValue);
            return date.toLocaleString('ko-KR');
        }
        
        function escapeHtml(text) {
            if (text === null || text === undefined) return '';
            return text.toString().replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }
        
        function handleEnterKey(event) {
            if (event.key === 'Enter') {
                currentPage = 1;
                loadComplaintList();
            }
        }

        function renderPagination(data) {
            if (!data || data.totalPages <= 1) {
                $('#paginationArea').html('');
                return;
            }
            let html = '<ul class="pagination justify-content-center">';
            if (data.currentPage > 1) {
                html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(${data.currentPage - 1})">이전</a></li>`;
            }
            for (let i = Math.max(1, data.currentPage - 2); i <= Math.min(data.totalPages, data.currentPage + 2); i++) {
                html += `<li class="page-item ${i === data.currentPage ? 'active' : ''}"><a class="page-link" href="#" onclick="goToPage(${i})">${i}</a></li>`;
            }
            if (data.currentPage < data.totalPages) {
                html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(${data.currentPage + 1})">다음</a></li>`;
            }
            html += '</ul>';
            $('#paginationArea').html(html);
        }

        function goToPage(page) {
            event.preventDefault();
            currentPage = page;
            loadComplaintList();
        }
    </script>
</body>
</html>