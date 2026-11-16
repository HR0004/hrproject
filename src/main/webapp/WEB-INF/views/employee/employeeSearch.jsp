
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 社員検索 ・ 検索</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeesearch.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeesearch" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-search-page hrms-page-content">
<section class="content-header">
<div class="container-fluid">
<h1 class="employee-page-title hrms-page-title">社員検索 ・ 検索</h1>
<p class="employee-page-desc">
                    社員番号、 氏名、 部署、 役職や在籍状態で社員を検索します。
                </p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 검색 조건 -->
<div class="search-panel">
<h2 class="search-section-title">検索条件</h2>
<div class="search-grid">
<div class="search-field">
<label for="searchKeyword">社員番号 / 氏名</label>
<input class="search-input" id="searchKeyword" placeholder="社員番号または氏名" type="text"/>
</div>
<div class="search-field">
<label for="searchDept">部署</label>
<select class="search-input" id="searchDept">
<option value="">すべての部署</option>
</select>
</div>
<div class="search-field">
<label for="searchJob">役職</label>
<select class="search-input" id="searchJob">
<option value="">すべての役職</option>
</select>
</div>
<div class="search-field">
<label for="searchStatus">在籍状態</label>
<select class="search-input" id="searchStatus">
<option value="">すべて</option>
<option value="ACTIVE">在籍</option>
<option value="LEAVE">休職</option>
<option value="RETIRED">退職</option>
</select>
</div>
</div>
<div class="search-bottom">
<div class="search-field search-date-field">
<label for="startDate">入社日</label>
<div class="date-range">
<input class="search-input" id="startDate" type="date"/>
<span class="date-separator">~</span>
<input aria-label="入社日の検索終了日" class="search-input" id="endDate" type="date"/>
</div>
</div>
<div class="search-actions">
<button class="search-btn" id="resetBtn" type="button">
                                リセット
                            </button>
<button class="search-btn search-btn-primary" id="searchBtn" type="button">
                                検索
                            </button>
</div>
</div>
</div>
<!-- 검색 결과 -->
<div class="search-results">
<div class="search-result-header">
<h2 class="search-result-title">
                            検索結果
                            <span id="resultCount">0名</span>
</h2>
<a class="back-list-btn" href="${pageContext.request.contextPath}/employees">
                            すべての社員を表示
                        </a>
</div>
<div class="search-table-wrap">
<div class="hrms-table-scroll"><table class="employee-table">
<thead>
<tr>
<th>社員番号</th>
<th>氏名</th>
<th>部署</th>
<th>役職</th>
<th>メールアドレス</th>
<th>入社日</th>
<th>在籍状態</th>
<th>操作</th>
</tr>
</thead>
<tbody id="searchResultBody">
<tr>
<td class="empty-message" colspan="8">
                                        検索条件を入力して検索ボタンを押してください。
                                    </td>
</tr>
</tbody>
</table></div>
</div>
</div>
</div>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeesearch.js?v=ja-1"></script>
</body></html>
