/**
 * 
 */
/**
 * /assets/js/admin/complaints.js
 * 민원 관리 페이지 클라이언트 사이드 스크립트
 */

// --- 1. 전역 변수 선언 ---
let currentPage = 1;
let selectedComplaintId = null;
let currentComplaintDetail = null; // 현재 선택된 민원의 상세 데이터를 저장할 변수

// 지도 관련 전역 변수
let map = null;
let marker = null;
let geocoder = null;

// --- 2. 초기화 및 이벤트 핸들러 ---
$(document).ready(function() {
	// Kakao Geocoder 초기화
	geocoder = new kakao.maps.services.Geocoder();

	// 최초 목록 로딩
	loadComplaintList();

	// 필터 및 검색 버튼 이벤트
	$('#searchBtn').on('click', function() {
		currentPage = 1;
		loadComplaintList();
	});

	$('#statusFilter, #riskFilter, #guFilter, #sortFilter, #periodFilter').on('change', function() {
		currentPage = 1;
		loadComplaintList();
	});


	// '내보내기' 버튼 클릭 이벤트
	$('#exportBtn').on('click', function() {
		// 현재 필터와 검색 조건들을 가져옴
		const params = {
			period: $('#periodFilter').val(),
			status: $('#statusFilter').val(),
			risk: $('#riskFilter').val(),
			gu: $('#guFilter').val(),
			sort: $('#sortFilter').val(),
			searchType: $('#searchType').val(),
			searchKeyword: $('#searchKeyword').val()
		};

		// 쿼리 스트링으로 변환 (예: period=today&status=RECEIVED...)
		// 값이 없는 파라미터는 제외
		const queryString = Object.entries(params)
			.filter(([key, value]) => value !== null && value !== '')
			.map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
			.join('&');

		// 새로운 URL로 이동하여 파일 다운로드를 트리거
		window.location.href = `${CONTEXT_PATH}/admin/complaints/export?${queryString}`;
	});

	//  상세 보기의 '정보 보기/숨기기' 버튼 클릭 이벤트
	$(document).on('click', '#toggleInfoBtn', function() {
		const $btn = $(this);
		const $infoText = $('#reporterInfoText');
		const currentState = $btn.data('state');

		if (currentState === 'masked') {
			// 마스킹 -> 전체 정보 보기로 변경
			const fullName = $btn.data('fullName');
			const fullNumber = $btn.data('fullNumber');

			$infoText.text(`${fullName} (${fullNumber})`);
			$btn.html('<i class="fas fa-eye-slash"></i> 정보 숨기기');
			$btn.data('state', 'full');

			// 여기에 나중에 감사 로그를 남기는 AJAX 호출을 추가 할 말
			// console.log(`관리자가 ${selectedComplaintId}번 민원의 개인정보를 열람했습니다.`);

		} else {
			// 전체 정보 -> 마스킹으로 변경
			const maskedName = $btn.data('maskedName');
			const maskedNumber = $btn.data('maskedNumber');

			$infoText.text(`${maskedName} (${maskedNumber})`);
			$btn.html('<i class="fas fa-eye"></i> 정보 보기');
			$btn.data('state', 'masked');
		}
	});

	// 초기화 버튼 이벤트
	$('#resetBtn').on('click', function() {
		$('#statusFilter, #riskFilter, #guFilter, #periodFilter').val('');
		$('#searchType').val('complaintId');
		$('#searchKeyword').val('');
		$('#sortFilter').val('created_at,DESC');
		currentPage = 1;
		loadComplaintList();
	});

	// 검색창 엔터키 이벤트
	$('#searchKeyword').on('keypress', function(e) {
		if (e.key === 'Enter') {
			currentPage = 1;
			loadComplaintList();
		}
	});

	// 상태 '저장' 버튼 클릭 이벤트 (상세보기 패널)
	$(document).on('click', '#saveNewStatusBtn', function() {
		const complaintId = selectedComplaintId;
		const status = $('#newStatusSelect').val();
		const comment = $('#newCommentText').val();

		if (!status) {
			alert('변경할 상태를 선택해주세요.');
			return;
		}

		$.ajax({
			url: CONTEXT_PATH + '/admin/complaints/api/status',
			method: 'POST',
			data: { complaintId, status, comment },
			success: function(response) {
				if (response.success) {
					alert('상태가 성공적으로 변경되었습니다.');
					loadComplaintDetail(complaintId); // 우측 상세보기 뷰 새로고침

					// 좌측 리스트의 상태 배지 실시간 업데이트
					const listItem = $(`.complaint-item[data-id="${complaintId}"]`);
					if (listItem.length > 0) {
						const statusBadge = listItem.find('.badge[class*="status-"]');
						statusBadge.removeClass((index, className) => (className.match(/\bstatus-\S+/g) || []).join(' '))
							.addClass(`status-${status.toLowerCase()}`)
							.text(getStatusText(status));
					}
				} else {
					alert('상태 변경에 실패했습니다: ' + response.message);
				}
			},
			error: function() {
				alert('상태 변경 중 오류가 발생했습니다.');
			}
		});
	});

	// 상태 '취소' 버튼 클릭 이벤트 (상세보기 패널)
	$(document).on('click', '#cancelUpdateBtn', function() {
		$('#statusUpdateDiv').hide();
		$('#actionButtons').show();
	});

	// 위험도 '저장' 버튼 클릭 이벤트 (모달)
	$('#saveRiskBtn').on('click', function() {
		const complaintId = $('#riskComplaintId').val();
		const riskLevel = $('#modalRiskSelect').val();

		if (!riskLevel) {
			alert('변경할 위험도를 선택해주세요.');
			return;
		}

		$.ajax({
			url: CONTEXT_PATH + '/admin/complaints/api/risk',
			method: 'POST',
			data: { complaintId, riskLevel },
			success: function(response) {
				if (response.success) {
					alert('위험도가 성공적으로 변경되었습니다.');

					const riskModal = bootstrap.Modal.getInstance(document.getElementById('riskChangeModal'));
					riskModal.hide();

					loadComplaintDetail(complaintId); // 우측 상세보기 뷰 새로고침

					// 좌측 리스트의 위험도 배지 실시간 업데이트
					const listItem = $(`.complaint-item[data-id="${complaintId}"]`);
					if (listItem.length > 0) {
						const riskBadge = listItem.find('.risk-badge');
						riskBadge.removeClass('risk-high risk-medium risk-low')
							.addClass(`risk-${riskLevel.toLowerCase()}`)
							.text(getRiskText(riskLevel));
					}
				} else {
					alert('위험도 변경에 실패했습니다: ' + response.message);
				}
			},
			error: function() {
				alert('위험도 변경 중 오류가 발생했습니다.');
			}
		});
	});

	// 위치 '저장' 버튼 클릭 이벤트 (모달)
		$('#saveLocationBtn').on('click', function() {
			const complaintId = selectedComplaintId;
			const lat = $('#newLat').val();
			const lon = $('#newLon').val();
			const address = $('#newAddress').val();

			if (!address || address === "주소를 찾을 수 없습니다.") {
				alert("유효한 주소를 찾을 수 없습니다. 마커를 다른 위치로 옮겨보세요.");
				return;
			}

			$.ajax({
				url: `${CONTEXT_PATH}/admin/complaints/api/location`,
				method: 'POST',
				data: { complaintId, lat, lon, address },
				success: function(response) {

					if (response.success) {
						alert('위치가 성공적으로 변경되었습니다.');
						bootstrap.Modal.getInstance(document.getElementById('locationChangeModal')).hide();
						loadComplaintDetail(complaintId); // 상세보기 새로고침
						
						//  리스트 새록고침
						const listItem = $(`.complaint-item[data-id="${complaintId}"]`);
						if (listItem.length > 0) {
							listItem.find('p.text-truncate').text(address);
						}
					} else {
					
						alert('위치 변경에 실패했습니다: ' + response.message);
					}
				},
				
				error: function() {
					
					alert('위치 변경 중 서버 오류가 발생했습니다.');
				}
			});
		}); 
		});
// --- 3. 데이터 로딩 및 렌더링 함수 ---

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
			const statusText = getStatusText(complaint.status);
			const riskText = getRiskText(complaint.riskLevel);
			const safeAddress = escapeHtml(complaint.incidentAddress || '주소 없음');
			const maskedName = maskName(escapeHtml(complaint.reporterName));

			// [유지] 누적 신고 뱃지는 그대로 둡니다.
			const countBadge = complaint.reportCount > 1
				? `<span class="badge rounded-pill bg-warning text-dark ms-2">누적${complaint.reportCount}건</span>`
				: '';

			// [복원] 위험도/상태 뱃지를 다시 묶어서 관리합니다.
			const statusBadgesHtml = `
				<div class="d-flex align-items-center gap-2">
					<span class="badge risk-badge risk-${riskClass}">${riskText}</span>
					
					<span class="badge list-status-badge">${statusText}</span>
				</div>
			`;

			html += `
                <div class="complaint-item p-3 border-bottom" data-id="${complaint.complaintId}" 
                    onclick="selectComplaint(${complaint.complaintId})">

                    <div class="d-flex justify-content-between align-items-center"> 
                        <div>
                            <h6 class="mb-1">#${complaint.complaintId}</h6>
                            <p class="mb-1 text-truncate" style="max-width: 300px;">${safeAddress}</p>
                            <small class="text-muted">
                                ${formatDate(complaint.createdAt)} / 신고자: ${maskedName}
                                ${countBadge}
                            </small>
                        </div>
                        
                        ${statusBadgesHtml}
                    </div>
                </div>
            `;
		});
	}
	$('#complaintList').html(html);
}


function loadComplaintDetail(complaintId) {
	$('#detailPanel').html('<div class="text-center py-5"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>');

	$.ajax({
		url: `${CONTEXT_PATH}/admin/complaints/api/detail/${complaintId}`,
		method: 'GET',
		success: function(response) {
			if (response.success) {
				currentComplaintDetail = response.data.complaint; // 상세 데이터 저장
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
	const currentStatus = complaint.status || 'RECEIVED';
	const currentRisk = complaint.riskLevel || 'LOW';
	const maskedName = maskName(escapeHtml(complaint.reporterName));
	const maskedNumber = maskPhone(complaint.reporterNumber);
	const fullName = escapeHtml(complaint.reporterName);
	const fullNumber = escapeHtml(complaint.reporterNumber);

	const riskBadgeHtml = `<span class="risk-badge risk-${currentRisk.toLowerCase()}">${getRiskText(currentRisk)}</span>`;
	const statusBadgeHtml = `<span class="badge status-badge status-${currentStatus.toLowerCase()}">${getStatusText(currentStatus)}</span>`;

	return `
        <h5>민원 기본 정보</h5>
        <table class="table table-bordered align-middle">
            <tbody>
                <tr><th style="width:25%;">민원 ID</th><td>${complaint.complaintId}</td></tr>
                <tr>
				<th>신고자</th>
				    <td>
				        <span id="reporterInfoText">${maskedName} (${maskedNumber})</span>
				        <button type="button" class="btn btn-sm btn-outline-secondary ms-2" id="toggleInfoBtn"
								data-full-name="${fullName}"
                                data-full-number="${fullNumber}"
                                data-masked-name="${maskedName}"
                                data-masked-number="${maskedNumber}"
                                data-state="masked">
				            <i class="fas fa-eye"></i> 정보 보기
				        </button>
				    </td>
				</tr>
                <tr><th>접수일시</th><td>${formatDateTime(complaint.createdAt)}</td></tr>
                <tr><th>주소</th><td>${escapeHtml(complaint.incidentAddress)}</td></tr>
                <tr><th>상태</th><td>${statusBadgeHtml}</td></tr>
                <tr><th>위험도</th><td>${riskBadgeHtml}</td></tr>
            </tbody>
        </table>
        
        <h5 class="mt-4">신고 내용</h5>
        
        <div id="reportContent" class="p-3 bg-light border rounded" style="white-space: pre-wrap;">${escapeHtml(complaint.reportContent || '내용 없음')}</div>
        
       
        <div class="mt-2 d-flex justify-content-end">
            <button class="btn btn-outline-primary btn-sm" id="aiSummaryBtn">
                <i class="fas fa-robot"></i> AI 요약 보기
            </button>
        </div>
        <div id="aiSummaryResult" class="mt-2" style="display: none;">
            <!-- 여기에 요약 결과가 표시됩니다 -->
        </div>
        

        <div class="d-flex justify-content-end gap-2 mt-4" id="actionButtons">
            <button class="btn btn-outline-secondary btn-sm" onclick="changeStatus('${currentStatus}')"><i class="fas fa-edit"></i> 상태 변경</button>
            <button class="btn btn-outline-warning btn-sm" onclick="changeRisk('${complaint.complaintId}', '${currentRisk}')"><i class="fas fa-exclamation-triangle"></i> 위험도 수정</button>
            <button class="btn btn-outline-secondary btn-sm" onclick="editLocation()"><i class="fas fa-map-marker-alt"></i> 위치 수정</button>
        </div>

        <div class="card mt-3" id="statusUpdateDiv" style="display: none;">
            <div class="card-body">
                <h6 class="card-title">상태 변경 및 코멘트</h6>
                <div class="mb-3">
                    <select class="form-select" id="newStatusSelect">
                        <option value="RECEIVED">접수</option>
                        <option value="PROCESSING">처리중</option>
                        <option value="COMPLETED">완료</option>
                        <option value="REJECTED">반려</option>
                    </select>
                </div>
                <div class="mb-3">
                    <textarea class="form-control" id="newCommentText" rows="3" placeholder="처리 결과를 입력하세요."></textarea>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <button class="btn btn-secondary btn-sm" id="cancelUpdateBtn">취소</button>
                    <button class="btn btn-primary btn-sm" id="saveNewStatusBtn">저장</button>
                </div>
            </div>
        </div>
    `;
}
// AI 요약 버튼 클릭 이벤트
$(document).on('click', '#aiSummaryBtn', function() {
    const content = $('#reportContent').text(); // 원본 민원 내용 가져오기
    const $resultDiv = $('#aiSummaryResult');
    const $btn = $(this);

    if (content.trim() === '내용 없음' || content.trim() === '') {
        alert('요약할 내용이 없습니다.');
        return;
    }

    // 로딩 상태 표시 (버튼 비활성화 및 스피너 아이콘)
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 요약 중...');
    $resultDiv.hide();

    $.ajax({
        url: CONTEXT_PATH + '/admin/complaints/api/summarize',
        method: 'POST',
        data: { content: content },
        success: function(response) {
            if (response.success) {
                // 성공 시, 결과를 예쁘게 포장해서 보여줌
                const summaryHtml = `
                    <div class="p-3 border-primary border-start border-4 bg-light">
                        <h6>🤖 AI 요약</h6>
                        <p class="mb-0" style="white-space: pre-wrap;">${escapeHtml(response.summary)}</p>
                    </div>
                `;
                $resultDiv.html(summaryHtml).slideDown();
            } else {
                // 실패 시, 에러 메시지 표시
                $resultDiv.html(`<div class="alert alert-danger mb-0">${escapeHtml(response.message)}</div>`).slideDown();
            }
        },
        error: function() {
            // 통신 자체에 실패했을 때 에러 메시지 표시
            $resultDiv.html('<div class="alert alert-danger mb-0">요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</div>').slideDown();
        },
        complete: function() {
            // 요청 완료 시 (성공/실패 무관) 버튼 상태를 원래대로 복구
            $btn.prop('disabled', false).html('<i class="fas fa-robot"></i> AI 요약 보기');
        }
    });
});

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

function renderPagination(data) {
	if (!data || data.totalPages <= 1) {
		$('#paginationArea').html('');
		return;
	}
	let html = '<ul class="pagination justify-content-center">';
	if (data.currentPage > 1) {
		html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(event, ${data.currentPage - 1})">이전</a></li>`;
	}
	for (let i = Math.max(1, data.currentPage - 2); i <= Math.min(data.totalPages, data.currentPage + 2); i++) {
		html += `<li class="page-item ${i === data.currentPage ? 'active' : ''}"><a class="page-link" href="#" onclick="goToPage(event, ${i})">${i}</a></li>`;
	}
	if (data.currentPage < data.totalPages) {
		html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(event, ${data.currentPage + 1})">다음</a></li>`;
	}
	html += '</ul>';
	$('#paginationArea').html(html);
}


// --- 4. 사용자 액션 함수 ---

function selectComplaint(complaintId) {
	selectedComplaintId = complaintId;
	$('.complaint-item').removeClass('selected');
	$(`.complaint-item[data-id="${complaintId}"]`).addClass('selected');
	loadComplaintDetail(complaintId);
}

function changeStatus(currentStatus) {
	$('#newStatusSelect').val(currentStatus);
	$('#newCommentText').val('');
	$('#actionButtons').hide();
	$('#statusUpdateDiv').show();
}

function changeRisk(complaintId, currentRisk) {
	$('#riskComplaintId').val(complaintId);
	$('#riskChangeModal .modal-body p > strong').text(`민원 #${complaintId}`);
	$('#modalRiskSelect').val(currentRisk);

	const riskModal = new bootstrap.Modal(document.getElementById('riskChangeModal'));
	riskModal.show();
}

function editLocation() {
	if (!currentComplaintDetail) return;

	const locationModal = new bootstrap.Modal(document.getElementById('locationChangeModal'));

	// Modal이 완전히 나타난 후에 지도를 생성해야 깨지지 않음
	document.getElementById('locationChangeModal').addEventListener('shown.bs.modal', function() {
		initMap(currentComplaintDetail.lat, currentComplaintDetail.lon);
	}, { once: true }); // 이벤트가 한번만 실행되도록 설정

	locationModal.show();
}

function goToPage(event, page) {
	event.preventDefault();
	currentPage = page;
	loadComplaintList();
}


// --- 5. 지도 관련 함수 ---

function initMap(lat, lon) {
	const mapContainer = document.getElementById('map');
	const mapOption = {
		center: new kakao.maps.LatLng(lat, lon),
		level: 3
	};

	map = new kakao.maps.Map(mapContainer, mapOption);
	marker = new kakao.maps.Marker({
		position: new kakao.maps.LatLng(lat, lon),
		draggable: true
	});
	marker.setMap(map);

	kakao.maps.event.addListener(marker, 'dragend', function() {
		updateLocationInfo(marker.getPosition());
	});

	updateLocationInfo(marker.getPosition());
}

function updateLocationInfo(latlng) {
	$('#newLat').val(latlng.getLat());
	$('#newLon').val(latlng.getLng());
	$('#newCoordsText').text(`위도: ${latlng.getLat().toFixed(6)}, 경도: ${latlng.getLng().toFixed(6)}`);

	geocoder.coord2Address(latlng.getLng(), latlng.getLat(), function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			const address = result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
			$('#newAddress').val(address);
			$('#newAddressText').text(address);
		} else {
			$('#newAddressText').text("주소를 찾을 수 없습니다.");
			$('#newAddress').val("");
		}
	});
}


// --- 6. 유틸리티 함수 ---

function escapeHtml(text) {
	if (text === null || text === undefined) return '';
	return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
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
	if (name.length == 2) return name.charAt(0) + '*';
	return name.charAt(0) + '*'.repeat(name.length - 2) + name.charAt(name.length - 1);
}

function maskPhone(phone) {
	if (!phone) return '';
	return phone.replace(/(\d{3})-(\d{4})-(\d{4})/, '$1-****-$3');
}

function formatDate(dateValue) {
	if (!dateValue) return '';
	return new Date(dateValue).toLocaleDateString('ko-KR');
}

function formatDateTime(dateValue) {
	if (!dateValue) return '';
	return new Date(dateValue).toLocaleString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' });
}