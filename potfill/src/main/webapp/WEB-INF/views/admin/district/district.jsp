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

<!-- nav -->
<link
	href="${pageContext.request.contextPath}/css/admin/admin-header.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/css/admin/admin-sidebar.css"
	rel="stylesheet">
<!-- dstrict css -->
<link
	href="${pageContext.request.contextPath}/css/admin/admin-district.css"
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
				<div class="card-vertical"
					style="max-height: 240px; min-width: 600px; padding: 20 40 40 20;">
					<p style="text-align: center; padding-bottom: 3px;">최근 7일간 발생 및
						처리 건수</p>
					<div style="width: 100%; display: flex; justify-content: flex-end;">
						<canvas id="barChart" style="width: 350px; height: 140px;"></canvas>
					</div>
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
								<!-- <td
									style="color: ${complaint.reportCount > 0 ? 'red' : 'green'};">
									${complaint.reportCount > 0 ? '신규' : '완료'}</td>
									
								-->

								<td><c:set var="isNew"
										value="${now.time - complaint.createdAt.time <= 7*24*60*60*1000}" />

									<c:if test="${isNew or complaint.status eq '접수'}">
										<span class="status-label status-new">신규</span>
									</c:if> <c:if test="${complaint.status eq '처리중'}">
										<span class="status-label status-processing">처리중</span>
									</c:if></td>


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
									<div style="text-align: right; margin-top: 5px;">
										<form
											action="${pageContext.request.contextPath}/admin/complaints/setSession"
											method="post" style="display: inline;">
											<input type="hidden" name="id"
												value="${complaint.complaintId}">
											<button type="submit" class="btn btn-primary"
												style="background-color: #00BFFF; border: none;">접수</button>
										</form>
									</div></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

			</div>
		</main>
	</div>

	<!-- JSP에서 값 전달 -->
	<script>
	    const COMPLETED_COUNT = ${completedCount};
	    const NEW_COUNT = ${newCount};
	    const PROCESSING_COUNT = ${processingCount};
	    const TOTAL_COUNT = ${newCount + processingCount + completedCount};
	
	    const DAILY_COUNTS = [
	        <c:forEach var="dc" items="${dailyCounts}" varStatus="status">
	            {
	                date: '<c:out value="${dc.date}" default=""/>',
	                received: <c:out value="${dc.newCount}" default="0"/>,
	                completed: <c:out value="${dc.completedCount}" default="0"/>
	            }<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	</script>
	<!-- Bootstrap -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/admin-district.js"></script>
</body>
</html>