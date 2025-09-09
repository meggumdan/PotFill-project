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
									<button class="btn btn-outline-secondary" type="button"
										id="resetBtn">
										<i class="fas fa-sync-alt"></i> 초기화
									</button>
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

	<div class="modal fade" id="statusChangeModal" tabindex="-1" aria-labelledby="statusChangeModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="statusChangeModalLabel">민원 상태 변경</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="statusChangeForm">
						<input type="hidden" id="statusComplaintId">
						
						<div class="mb-3">
							<label for="modalStatusSelect" class="form-label">변경할 상태</label>
							<select class="form-select" id="modalStatusSelect" required>
								<option value="" disabled selected>상태를 선택하세요...</option>
								<option value="RECEIVED">접수</option>
								<option value="PROCESSING">처리중</option>
								<option value="COMPLETED">완료</option>
								<option value="REJECTED">반려</option>
							</select>
						</div>
						
						<div class="mb-3">
							<label for="modalCommentText" class="form-label">처리 코멘트 (메모)</label>
							<textarea class="form-control" id="modalCommentText" rows="4" placeholder="처리 내용을 입력하세요. (예: 처리 업체에 작업 지시 완료)"></textarea>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="saveStatusBtn">변경 내용 저장</button>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<script>
        const CONTEXT_PATH = "/potfill"; 

        let currentPage = 1;
        let selectedComplaintId = null;
        
        $(document).ready(function() {
            loadComplaintList();
            
            $('#searchBtn, #statusFilter, #riskFilter, #guFilter, #sortFilter, #periodFilter').on('click change', function() {
                currentPage = 1;
                loadComplaintList();
            });

            $('#resetBtn').on('click', function() {
                $('#statusFilter, #riskFilter, #guFilter, #periodFilter').val('');
                $('#searchType').val('complaintId');
                $('#searchKeyword').val('');
                $('#sortFilter').val('created_at,DESC');
                currentPage = 1;
                loadComplaintList();
            });

            // ✅ 2. '변경 내용 저장' 버튼 이벤트 핸들러 추가
            $('#saveStatusBtn').on('click', function() {
                const complaintId = $('#statusComplaintId').val();
                const status = $('#modalStatusSelect').val();
                const comment = $('#modalCommentText').val();

                if (!status) {
                    alert('변경할 상태를 선택해주세요.');
                    return;
                }

                $.ajax({
                    url: CONTEXT_PATH + '/admin/complaints/api/status',
                    method: 'POST',
                    data: {
                        complaintId: complaintId,
                        status: status,
                        comment: comment
                    },
                    success: function(response) {
                        if (response.success) {
                            alert('상태가 성공적으로 변경되었습니다.');
                            
                            const statusModal = bootstrap.Modal.getInstance(document.getElementById('statusChangeModal'));
                            statusModal.hide();
                            
                            loadComplaintDetail(complaintId);

                            const listItem = $(`.complaint-item[data-id="${complaintId}"]`);
                            const statusBadge = listItem.find('.badge[class*="status-"]');
                            statusBadge.removeClass().addClass(`badge status-${status.toLowerCase()}`).text(getStatusText(status));

                        } else {
                            alert('상태 변경에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function() {
                        alert('상태 변경 중 오류가 발생했습니다.');
                    }
                });
            });
        });

        function loadComplaintList() {
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
            };
            
            $.ajax({
                url: CONTEXT_PATH + '/admin/complaints/api/list',
                method: 'GET',
                data: searchParams,
                success: function(response) {
                    if (response.success) {
                        renderComplaintList(response.data.complaints);
                        renderPagination(response.data);
                        $('#totalCount').text(response.data.totalCount + '건');
                    } else {
                        $('#complaintList').html(`<div class="text-center text-muted p-4">${escapeHtml(response.message)}</div>`);
                    }
                },
                error: function() {
                    $('#complaintList').html('<div class="text-center text-danger p-4">데이터를 불러오는 데 실패했습니다.</div>');
                }
            });
        }

		function renderComplaintList(complaints) {
			let html = '';
			if (!complaints || complaints.length === 0) {
				html = '<div class="text-center text-muted py-4">검색 결과가 없습니다.</div>';
			} else {
				complaints.forEach(function(complaint) {
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
			$('#detailPanel').html('<div class="text-center py-5"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>');
			
			$.ajax({
				url: `${CONTEXT_PATH}/admin/complaints/api/detail/${complaintId}`,
				method: 'GET',
				success: function(response) {
					if (response.success) {
						renderComplaintDetail(response.data);
					} else {
						$('#detailPanel').html(`<div class="alert alert-danger m-3">${escapeHtml(response.message)}</div>`);
					}
				},
				error: function() {
					$('#detailPanel').html('<div class="alert alert-danger m-3">상세 정보를 불러오는 데 실패했습니다.</div>');
				}
			});
		}

		function renderComplaintDetail(data) {
			const { complaint, histories, photos, duplicateComplaints } = data;

			const detailHtml = `
				<ul class="nav nav-tabs px-3" id="detailTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="summary-tab" data-bs-toggle="tab" data-bs-target="#summary" type="button" role="tab">요약</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab">
							처리 히스토리 <span class="badge bg-secondary">${histories.length}</span>
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="photos-tab" data-bs-toggle="tab" data-bs-target="#photos" type="button" role="tab">
							첨부 사진 <span class="badge bg-secondary">${photos.length}</span>
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="duplicates-tab" data-bs-toggle="tab" data-bs-target="#duplicates" type="button" role="tab">
							중복 신고 <span class="badge bg-warning text-dark">${(duplicateComplaints || []).length}</span>
						</button>
					</li>
				</ul>
				<div class="tab-content p-3" id="detailTabContent">
					<div class="tab-pane fade show active" id="summary" role="tabpanel">
						${renderSummaryTab(complaint)}
					</div>
					<div class="tab-pane fade" id="history" role="tabpanel">
						${renderHistoryTab(histories)}
					</div>
					<div class="tab-pane fade" id="photos" role="tabpanel">
						${renderPhotosTab(photos)}
					</div>
					<div class="tab-pane fade" id="duplicates" role="tabpanel">
						${renderDuplicatesTab(duplicateComplaints)}
					</div>
				</div>
			`;
			
			$('#detailPanel').html(detailHtml);
		}

		function renderSummaryTab(complaint) {
			return `
				<h5>민원 기본 정보</h5>
				<table class="table table-bordered">
					<tbody>
						<tr><th style="width:25%;">민원 ID</th><td>${complaint.complaintId}</td></tr>
						<tr><th>신고자</th><td>${escapeHtml(complaint.reporterName)} (${maskPhone(complaint.reporterNumber)})</td></tr>
						<tr><th>접수일시</th><td>${formatDateTime(complaint.createdAt)}</td></tr>
						<tr><th>주소</th><td>${escapeHtml(complaint.incidentAddress)}</td></tr>
						<tr><th>상태</th><td><span class="badge status-${(complaint.status || 'received').toLowerCase()}">${getStatusText(complaint.status)}</span></td></tr>
						<tr><th>위험도</th><td><span class="badge risk-${(complaint.riskLevel || 'low').toLowerCase()}">${getRiskText(complaint.riskLevel)}</span></td></tr>
					</tbody>
				</table>
				
				<h5 class="mt-4">신고 내용</h5>
				<div class="p-3 bg-light border rounded" style="white-space: pre-wrap;">${escapeHtml(complaint.reportContent || '내용 없음')}</div>
				
				<div class="d-flex justify-content-end gap-2 mt-4">
					<button class="btn btn-info btn-sm" onclick="changeStatus(${complaint.complaintId})"><i class="fas fa-edit"></i> 상태 변경</button>
					<button class="btn btn-warning btn-sm" onclick="changeRisk(${complaint.complaintId})"><i class="fas fa-exclamation-triangle"></i> 위험도 수정</button>
					<button class="btn btn-secondary btn-sm" onclick="editLocation(${complaint.complaintId})"><i class="fas fa-map-marker-alt"></i> 위치 수정</button>
				</div>
			`;
		}

		function renderHistoryTab(histories) {
			if (!histories || histories.length === 0) {
				return '<p class="text-muted">처리 내역이 없습니다.</p>';
			}
			let historyHtml = '<ul class="list-group">';
			histories.forEach(h => {
				historyHtml += `
					<li class="list-group-item">
						<div class="d-flex w-100 justify-content-between">
							<h6 class="mb-1">
								<span class="badge status-${h.status.toLowerCase()}">${getStatusText(h.status)}</span>
								<span class="ms-2">${escapeHtml(h.admin_name || '시스템')}</span>
							</h6>
							<small>${formatDateTime(h.createdAt)}</small>
						</div>
						<p class="mb-1">${escapeHtml(h.statusComment || '코멘트 없음')}</p>
					</li>
				`;
			});
			historyHtml += '</ul>';
			return historyHtml;
		}

		function renderPhotosTab(photos) {
			if (!photos || photos.length === 0) {
				return '<p class="text-muted">첨부된 사진이 없습니다.</p>';
			}
			let photosHtml = '<div class="row g-2">';
			photos.forEach(p => {
				photosHtml += `
					<div class="col-md-6">
						<a href="${p.fileUrl}" target="_blank">
							<img src="${p.fileUrl}" class="img-fluid rounded" alt="${escapeHtml(p.photoName)}">
						</a>
					</div>
				`;
			});
			photosHtml += '</div>';
			return photosHtml;
		}

		function renderDuplicatesTab(duplicates) {
			if (!duplicates || duplicates.length === 0) {
				return '<p class="text-muted">동일 위치에 다른 신고가 없습니다.</p>';
			}
			let dupHtml = '<ul class="list-group">';
			duplicates.forEach(d => {
				dupHtml += `
					<li class="list-group-item list-group-item-action" style="cursor:pointer;" onclick="selectComplaint(${d.complaintId})">
						<div class="d-flex w-100 justify-content-between">
							<h6 class="mb-1">#${d.complaintId} - ${escapeHtml(d.incidentAddress)}</h6>
							<small>${formatDate(d.createdAt)}</small>
						</div>
						<small>상태: ${getStatusText(d.status)} / 위험도: ${getRiskText(d.riskLevel)}</small>
					</li>
				`;
			});
			dupHtml += '</ul>';
			return dupHtml;
		}
		
        // ✅ 3. 기존 changeStatus 함수를 Modal을 띄우는 역할로 변경
        function changeStatus(complaintId) {
            $('#statusComplaintId').val(complaintId);
            $('#modalStatusSelect').val('');
            $('#modalCommentText').val('');
            
            const statusModal = new bootstrap.Modal(document.getElementById('statusChangeModal'));
            statusModal.show();
        }

        function changeRisk(complaintId) {
            alert(`위험도 수정 기능 구현 필요 (ID: ${complaintId})`);
        }

        function editLocation(complaintId) {
            alert(`위치 수정 기능 구현 필요 (ID: ${complaintId})`);
        }
        
        // --- 유틸리티 함수들 ---

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
            return date.toLocaleString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' });
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