
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 社員管理</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeelist.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeelist" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-page hrms-page-content">
<!-- 제목 -->
<section class="content-header">
<div class="container-fluid">
<h1 class="employee-page-title hrms-page-title">社員管理</h1>
<p class="employee-page-desc">
                    社員検索 ・ 登録 ・ 編集 ・ 退職処理
                </p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 통계 카드 -->
<div class="employee-stats">
<div class="employee-stat-card">
<div class="employee-stat-label">社員総数</div>
<div class="employee-stat-number" id="totalCount">0</div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">在籍</div>
<div class="employee-stat-number" id="activeCount">0</div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">休職</div>
<div class="employee-stat-number" id="leaveCount">0</div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">退職</div>
<div class="employee-stat-number" id="retiredCount">0</div>
</div>
</div>
<!-- 사원 목록 상단 -->
<div class="employee-toolbar">
<h2 class="employee-list-title">社員一覧を表示</h2>
<div class="employee-toolbar-actions">
<!-- 검색 / 필터 -->
<a class="employee-search-btn" href="${pageContext.request.contextPath}/employees/search" style="display:inline-flex;align-items:center;
                                  justify-content:center;width:171px;
                                  min-width:171px;height:52px;
                                  padding:0 15px;border:1px solid #dce5f1;
                                  border-radius:11px;background:#fff;
                                  color:#172033;font-size:13px;
                                  font-weight:600;text-decoration:none;
                                  white-space:nowrap;box-sizing:border-box;">
                            ⚲ 検索 / フィルター
                        </a>
<!-- 사원 등록 -->
<button class="employee-register-btn" onclick="registerEmployee()" type="button">
                            + 社員登録
                        </button>
</div>
</div>
<!-- 사원 목록 -->
<div class="employee-table-wrap">
<div class="hrms-table-scroll"><table class="employee-table" id="employeeTable">
<thead>
<tr>
<th>社員番号</th>
<th>氏名</th>
<th>部署</th>
<th>役職</th>
<th>メールアドレス</th>
<th>入社日</th>
<th>状態</th>
<th>操作</th>
</tr>
</thead>
<tbody id="employeeTableBody"></tbody>
</table></div>
<div class="employee-empty" id="employeeEmpty">
                        登録されている社員がいません。
                    </div>
</div>
<!-- 페이지네이션 -->
<div class="employee-pagination-wrap">
<div class="employee-pagination" id="employeePagination"></div>
</div>
<p class="employee-notice">
                    ※ 社員を選択して詳細を表示、 情報の編集または退職処理を行います。
                </p>
</div>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeelist.js?v=ja-dynamic-2"></script>
</body></html>
