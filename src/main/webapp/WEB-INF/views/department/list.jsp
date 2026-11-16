
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>部署管理</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/department-list.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-department-list" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-search-page hrms-page-content">
<section class="content-header">
<div class="container-fluid">
<h2 class="page-title hrms-page-title">部署管理</h2>
<p class="page-path">HRMS / 部署管理</p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 부서 통계 -->
<section class="summary-row">
<div class="summary-card">
<p>すべての部署</p>
<h3 id="totalCount">0</h3>
</div>
<div class="summary-card">
<p>有効な部署</p>
<h3 id="activeCount">0</h3>
</div>
<div class="summary-card">
<p>無効な部署</p>
<h3 id="inactiveCount">0</h3>
</div>
</section>
<!-- 검색 및 등록 -->
<section class="table-top">
<h3>一覧検索</h3>
<div class="table-actions">
<input id="keyword" placeholder="部署名 / 部署コードで検索" type="text"/>
<select aria-label="部署の状態で絞り込み" id="searchStatus">
<option value="">すべての状態</option>
<option value="1">有効</option>
<option value="0">無効</option>
</select>
<button class="primary-btn" id="openRegisterBtn" type="button">
								+ 部署登録</button>
</div>
</section>
<!-- 부서 목록 -->
<div class="hrms-table-scroll"><table class="department-table">
<thead>
<tr>
<th>部署コード</th>
<th>部署名</th>
<th>人数</th>
<th>状態</th>
<th>操作</th>
</tr>
</thead>
<tbody id="departmentBody"></tbody>
</table></div>
</div>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/department-list.js?v=ja-dynamic-2"></script>
</body></html>
