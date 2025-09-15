<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div style="padding-top:10px;">
	<div class="sub-container">

		<!-- 설명 -->
		<div class="sub-top">
			<div
				style="display: flex; align-items: center; justify-content: space-between; position: relative;">
				<h3>포트홀 신고 안내</h3>
				<button type="button" id="close-btn"
					class="btn border-0 bg-transparent">×</button>
			</div>
		</div>

		<div class="sub-manual-content-bg">
			<!-- 안내 본문 -->
			<div class="sub-manual-content">
				<p style="padding: 0; margin: 0 0 10px 0;">아래에 절차에 맞게 작성해주세요.</p>
				<div class="sub-img-wrapper">
					<h4>1. 포트홀 발생 위치 선택</h4>
					<p>지도를 직접 드래그&클릭 해서 포트홀이 발생한 위치를 선택해주세요.</p>
					<div class="sub-highlight-box style1">
						<img
							src="${pageContext.request.contextPath}/images/select-map.png"
							alt="위치 선택" class="sub-img-area sub-img-center">
					</div>
				</div>

				<div>
					<h4>2. 신고 위치 중복 확인</h4>
					<p>이미 접수된 포트홀에 대해서는 신고할 수 없습니다.</p>
					<div class="sub-highlight-box style2">
						<img src="${pageContext.request.contextPath}/images/distinct.png"
							alt="위치 선택" class="sub-img-area sub-img-center">
					</div>
				</div>

				<div>
					<h4>3. 민원인 정보 입력</h4>
					<p class="sub-small-font">「민원 처리에 관한 법률」 제17조(민원의 신청)에 따라 민원인은
						신청서에 성명, 주소 등 필요한 사항을 기재하여 제출해야 합니다.</p>
					<div class="sub-highlight-box style3">
						<img src="${pageContext.request.contextPath}/images/fill-form.png"
							alt="위치 선택" class="sub-img-area sub-img-center">
					</div>
				</div>

				<div>
					<h4>4. 사진 첨부(선택)</h4>
					<p>최대 3장까지 첨부 가능합니다.</p>
					<div class="sub-highlight-box style4">
						<img
							src="${pageContext.request.contextPath}/images/select-photo.png"
							alt="위치 선택" class="sub-img-area sub-img-center">
					</div>
					<p style="margin: 0;">* 사진 촬영 가이드</p>
					<p style="margin: 0 0 0 10px;">포트홀의 크기를 가늠할 수 있도록 차선의 양 끝을 보이게
						촬영해 주세요.</p>
					<img style="margin: 5px 0 0 10px;"
						src="${pageContext.request.contextPath}/images/guid-img.png"
						alt="가이드" class="sub-img-area sub-img-center">
				</div>
			</div>

		</div>
	</div>
</div>