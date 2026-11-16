<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 社員の詳細情報を表示</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeedetail.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeedetail" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-detail-page hrms-page-content">
<main class="employee-detail-container">
<!-- 상단 제목 -->
<div class="employee-detail-heading">
<div>
<h1 class="hrms-page-title">社員の詳細情報を表示</h1>
<p>社員管理 / 社員一覧 / 社員の詳細情報</p>
</div>
<a class="employee-detail-button employee-detail-button-outline" href="<%=contextPath%>/employees">
<i class="fas fa-arrow-left"></i> 一覧へ
					</a>
</div>
<!-- 사원 요약 정보 -->
<section class="employee-detail-card employee-detail-summary">
<div class="employee-detail-person">
<div class="employee-detail-avatar">
<i class="fas fa-user"></i>
</div>
<div>
<h2 id="summaryName"></h2>
<p>
<span id="summaryEmpId"></span> ・ <span id="summaryDept"></span>
								/ <span id="summaryJob"></span>
</p>
</div>
</div>
<!-- 재직 상태 -->
<span class="employee-detail-status" id="detailStatusBadge">
<span class="employee-detail-status-dot"></span> <span id="summaryStatus"></span>
</span>
</section>
<!-- 사원 기본 정보 -->
<section class="employee-detail-card employee-detail-info">
<h2>社員基本情報</h2>
<p class="employee-detail-hint">tb_employee 基準 ・ セキュリティ上、パスワードは表示しません。</p>
<div class="employee-detail-grid">
<!-- 사번 -->
<div class="employee-detail-field">
<label>社員番号</label>
<div class="employee-detail-value">
<span id="detailEmpId"></span>
</div>
</div>
<!-- 성명 -->
<div class="employee-detail-field">
<label>氏名</label>
<div class="employee-detail-value" id="detailName"></div>
</div>
<!-- 부서 -->
<div class="employee-detail-field">
<label>所属部署</label>
<div class="employee-detail-value">
<span id="detailDept"></span>
</div>
</div>
<!-- 직급 -->
<div class="employee-detail-field">
<label>役職</label>
<div class="employee-detail-value">
<span id="detailJob"></span>
</div>
</div>
<!-- 이메일 -->
<div class="employee-detail-field">
<label>メールアドレス</label>
<div class="employee-detail-value">
<span id="detailEmail"></span>
</div>
</div>
<!-- 연락처 -->
<div class="employee-detail-field">
<label>電話番号</label>
<div class="employee-detail-value">
<span id="detailPhone"></span>
</div>
</div>
<!-- 입사일 -->
<div class="employee-detail-field">
<label>入社日</label>
<div class="employee-detail-value">
<span id="detailHiredate"></span>
</div>
</div>
<!-- 재직 상태 -->
<div class="employee-detail-field">
<label>在籍状態</label>
<div class="employee-detail-value">
<span id="detailStatus"></span>
</div>
</div>
</div>
</section>
<!-- 관리자 작업 -->
<section class="employee-detail-card employee-detail-actions">
<div class="employee-detail-actions-text">
<span>管理者操作</span>
<p>社員情報を確認し、編集または退職処理を行えます。</p>
</div>
<div class="employee-detail-action-buttons">
<!-- 목록으로 -->
<a class="employee-detail-button employee-detail-button-outline" href="<%=contextPath%>/employees">

							一覧へ </a>
<!-- 정보 수정 -->
<button class="employee-detail-button employee-detail-button-primary" onclick="editEmployee()" type="button">情報編集</button>
<!-- 퇴직 처리 -->
<button class="btn btn-danger px-4 py-2" id="retireBtn" type="button">退職処理</button>
</div>
</section>
</main>
</div>
<div class="modal fade" id="retirePopup" tabindex="-1">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<div class="modal-body p-4">
<h4 class="font-weight-bold mb-4">
<span class="mr-2" id="retirePopupIcon"></span>
<span id="retirePopupTitle"></span>
</h4>
<p id="retirePopupMessage"></p>
<div class="bg-light rounded p-3 my-4" id="retirePopupDetail"></div>
<div class="d-flex">
<button class="btn btn-outline-secondary flex-fill mr-2" data-dismiss="modal" id="retirePopupCancel" type="button">
                        キャンセル
                    </button>
<button class="btn btn-primary flex-fill" id="retirePopupAction" type="button">
                        確認
                    </button>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeedetail.js?v=ja-1"></script>
</body></html>
