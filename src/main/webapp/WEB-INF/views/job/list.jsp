
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>직급 관리</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/job-list.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-job-list" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="hrms-page-content">
<section class="content-header">
<div class="container-fluid">
<h2 class="page-title hrms-page-title">직급 관리</h2>
<p class="page-path">HRMS / 직급 관리</p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 직급 통계 -->
<section class="summary-row">
<div class="summary-card">
<p>전체 직급</p>
<h3 id="totalCount">0</h3>
</div>
<div class="summary-card">
<p>활성 직급</p>
<h3 id="activeCount">0</h3>
</div>
<div class="summary-card">
<p>비활성 직급</p>
<h3 id="inactiveCount">0</h3>
</div>
</section>
<!-- 검색 및 등록 -->
<section class="table-top">
<h3>목록 조회</h3>
<div class="table-actions">
<input id="keyword" placeholder="직급명 / 직급 코드 검색" type="text"/>
<select aria-label="직급 상태 필터" id="searchStatus">
<option value="">전체 상태</option>
<option value="1">활성</option>
<option value="0">비활성</option>
</select>
<button class="primary-btn" id="openRegisterBtn" type="button">
								+ 직급 등록</button>
</div>
</section>
<!-- 직급 목록 -->
<div class="hrms-table-scroll"><table class="job-table">
<thead>
<tr>
<th>직급 코드</th>
<th>직급명</th>
<th>인원</th>
<th>상태</th>
<th>관리</th>
</tr>
</thead>
<tbody id="jobBody"></tbody>
</table></div>
<!-- 직급 페이징 -->
<div id="pagination" style="display: flex; justify-content: center; gap: 8px; margin-top: 20px;">
</div>
</div>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/job-list.js?v=1"></script>
</body></html>
