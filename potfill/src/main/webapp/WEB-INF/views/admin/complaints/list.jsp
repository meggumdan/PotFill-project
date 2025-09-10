<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@keyProps['kakao.js.apikey']" var="jsKey" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>민원 관리 - PotFill</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    
     <link href="${pageContext.request.contextPath}/css/admin/admin-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin/admin-sidebar.css" rel="stylesheet">
    
    
    <link href="<c:url value='/css/admin/complaints.css'/>" rel="stylesheet">
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${jsKey}&libraries=services"></script>

<script>
	const SELECTED_COMPLAINT_ID = "${selectedComplaintId}";
</script>
<script src="/assets/js/admin/complaints.js"></script>
</head>
<body>

      <div class="admin-layout">
        
        <%@ include file="../admin_component/header.jsp" %>
        <%@ include file="../admin_component/sidebar.jsp" %>
             

            <main class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2></i>민원 관리</h2>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-success" id="exportBtn">
                        <i class="fas fa-download"></i> 내보내기
                    </button>
                </div>
            </div>

            <div class="row">
                
                <div class="col-md-6">
                    
                    <div class="card mb-4">
                        <div class="card-body">
                            
                            <div class="row g-3">
                                <div class="col">
                                    <label class="form-label">기간</label> 
                                    <select class="form-select" id="periodFilter">
                                        <option value="">전체</option>
                                        <option value="today">오늘</option>
                                        <option value="week">7일</option>
                                        <option value="month">30일</option>
                                        <option value="custom">직접 선택</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label class="form-label">상태</label> 
                                    <select class="form-select" id="statusFilter">
                                        <option value="">전체</option>
                                        <option value="RECEIVED">접수</option>
                                        <option value="PROCESSING">처리중</option>
                                        <option value="COMPLETED">완료</option>
                                        <option value="REJECTED">반려</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label class="form-label">위험도</label> 
                                    <select class="form-select" id="riskFilter">
                                        <option value="">전체</option>
                                        <option value="HIGH">높음</option>
                                        <option value="MEDIUM">보통</option>
                                        <option value="LOW">낮음</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label class="form-label">구/동</label> 
                                    <select class="form-select" id="guFilter">
                                        <option value="">전체</option>
                                        <option value="강남구">강남구</option>
                                        <option value="서초구">서초구</option>
                                        <option value="송파구">송파구</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label class="form-label">정렬</label> 
                                    <select class="form-select" id="sortFilter">
                                        <option value="created_at,DESC">최신순</option>
                                        <option value="risk_level,DESC">위험도순</option>
                                        <option value="report_count,DESC">신고건수순</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col">
                                    <div class="input-group">
                                        <select class="form-select" id="searchType" style="flex: 0 0 120px;">
                                            <option value="complaintId">민원ID</option>
                                            <option value="reporterName">신고자명</option>
                                            <option value="reporterNumber">전화번호</option>
                                            <option value="address">주소</option>
                                        </select>
                                       
                                        <!-- 지민  value="${selectedComplaintId}" 만 추가 -->
                                        <input type="text" class="form-control" id="searchKeyword" placeholder="검색어를 입력하세요" onkeypress="handleEnterKey(event)" value="${selectedComplaintId}">
                                                                               
                                        <button class="btn btn-primary" id="searchBtn">
                                            <i class="fas fa-search"></i> 검색
                                        </button>
                                        <button class="btn btn-secondary" type="button" id="resetBtn">
                                            <i class="fas fa-sync-alt"></i> 초기화
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">민원 목록</h5>
                            <span class="badge bg-secondary" id="totalCount">0건</span>
                        </div>
                        <div class="card-body p-0 list-panel" id="complaintList"></div>
                    </div>
                    
                    <nav class="mt-4" id="paginationArea"></nav>
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
                </div> </main>
        </div> 

    <div class="modal fade" id="riskChangeModal" tabindex="-1" aria-labelledby="riskChangeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="riskChangeModalLabel">민원 위험도 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="riskChangeForm">
                        <input type="hidden" id="riskComplaintId">
                        <p class="mb-2"><strong>민원 #${selectedComplaintId}</strong>의 위험도를 변경합니다.</p>
                        <p class="text-muted small">위험도는 신고 건수를 기반으로 자동 계산되지만, 관리자가 직접 조정할 수 있습니다.</p>
                        <div class="mb-3">
                            <label for="modalRiskSelect" class="form-label">변경할 위험도</label>
                            <select class="form-select" id="modalRiskSelect" required>
                                <option value="" disabled selected>위험도를 선택하세요...</option>
                                <option value="HIGH">높음</option>
                                <option value="MEDIUM">보통</option>
                                <option value="LOW">낮음</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="saveRiskBtn">위험도 저장</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="locationChangeModal" tabindex="-1" aria-labelledby="locationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="locationModalLabel">민원 위치 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="map" style="width: 100%; height: 400px;"></div>
                    <div class="mt-3">
                        <p class="mb-1"><strong>변경될 주소:</strong> <span id="newAddressText">주소를 불러오는 중...</span></p>
                        <p class="mb-0 text-muted small"><strong>좌표:</strong> <span id="newCoordsText"></span></p>
                    </div>
                    <input type="hidden" id="newLat">
                    <input type="hidden" id="newLon">
                    <input type="hidden" id="newAddress">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="saveLocationBtn">위치 저장</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
    
    <script src="<c:url value='/js/admin/complaints.js'/>"></script>
</body>
</html>