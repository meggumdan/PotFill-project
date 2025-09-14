<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- 관리자 사이드바 -->
<aside class="admin-sidebar">
	<!-- 로고 영역 -->
	<div class="sidebar-logo">
		<img
			src="${pageContext.request.contextPath}/images/potfill-logo-white.png"
			alt="POTFILL 로고" class="logo">
	</div>

	<nav class="sidebar-nav">
		<ul class="nav-menu">
			<!-- 대시보드 -->
			<li class="nav-item"><a
				href="${pageContext.request.contextPath}/admin/dashboard"
				class="nav-link"> <i class="nav-icon">📊</i> <span
					class="nav-text">대시보드</span>
			</a>
				<ul class="sub-menu">
					<li class="sub-item"><a
						href="${pageContext.request.contextPath}/admin/dashboard"
						class="sub-link"> > 전체 보기 </a></li>
					<li class="sub-item"><a
						href="${pageContext.request.contextPath}/admin/district"
						class="sub-link"> > 관할 보기 </a></li>
				</ul></li>

			<!-- 민원 관리 -->
			<li class="nav-item"><a
				href="${pageContext.request.contextPath}/admin/complaints/list"
				class="nav-link"> <i class="nav-icon">📝</i> <span
					class="nav-text">민원 관리</span>
			</a></li>

			<!-- 포트홀 지도 -->
			<li class="nav-item"><a
				href="${pageContext.request.contextPath}/admin/map" class="nav-link">
					<i class="nav-icon">🗺️</i> <span class="nav-text">포트홀 지도</span>
			</a></li>
		</ul>
	</nav>
</aside>

<!-- JavaScript 파일 포함 -->
<script
	src="${pageContext.request.contextPath}/js/admin/admin-sidebar.js"></script>
