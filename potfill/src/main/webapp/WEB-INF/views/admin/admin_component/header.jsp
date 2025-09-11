<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<header class="admin-header">
	<div class="header-container">
		<div class="header-right">

			<c:choose>
				<%-- adminInfo 객체가 존재할 경우 (로그인 상태) --%>
				<c:when test="${not empty adminInfo}">
					<div class="user-info">
						<%-- 컨트롤러에서 넘겨준 adminInfo 객체의 adminName 필드를 사용 --%>
						<span class="welcome-text"><c:out
								value="${adminInfo.adminName}" />님 안녕하세요</span>
						<div class="user-actions">
							<button type="button" id="btnLogout" class="btn-logout">로그아웃</button>
						</div>
					</div>
				</c:when>

				<%-- adminInfo 객체가 없을 경우 (로그아웃 상태) --%>
				<c:otherwise>
					<div class="user-info">
						<div class="user-actions">

							<a href="${pageContext.request.contextPath}/admin/login"
								class="btn-logout">로그인</a>
						</div>
					</div>
				</c:otherwise>
			</c:choose>

		</div>
	</div>
</header>