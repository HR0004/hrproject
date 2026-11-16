<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>社員の休暇申請管理</title>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-admin.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
        <div class="content hrms-leave-content">
<main class="alr-page hrms-page-content hrms-attendance-leave-page">
<header class="alr-heading hrms-section-page-header">
<div>
<h1 class="alr-title hrms-page-title">社員の休暇申請管理</h1>
<p class="alr-subtitle page-path">社員の休暇申請を検索し、承認状況を確認できます。</p>
</div>
<span class="alr-demo">部署別検索 ・ 承認・否認</span>
</header>
<p role="status" aria-live="polite" id="adminLeaveMessage"></p>
<section aria-label="休暇申請の検索条件" class="alr-panel alr-filter">
<div class="alr-field">
<label for="alrDepartment">検索対象部署</label><select id="alrDepartment" name="departmentId"><option value="">すべての部署</option></select>
</div>
<div class="alr-field">
<label for="alrStartDate">申請開始日</label><input id="alrStartDate" name="startDate" type="date"/>
</div>
<div class="alr-field">
<label for="alrEndDate">申請終了日</label><input id="alrEndDate" name="endDate" type="date"/>
</div>
<div class="alr-field">
<label for="alrStatus">処理状態</label> <select id="alrStatus" name="statusFilter"><option value="ALL">すべて</option>
<option value="PENDING">承認待ち</option>
<option value="APPROVED">承認済み</option>
<option value="REJECTED">否認</option><option value="CANCELED">取消済み</option></select>
</div>
<div class="alr-field alr-grow">
<label for="alrKeyword">社員検索</label><input id="alrKeyword" name="keyword" maxlength="50" placeholder="氏名または社員番号" type="search"/>
</div>
<div class="alr-actions">
<button class="alr-btn alr-btn-primary" name="searchLeaveRequests" type="button">検索</button>
<button class="alr-btn" name="resetLeaveRequests" type="button">リセット</button>
</div>
</section>
<section aria-label="休暇申請の集計" class="alr-stats">
<div class="alr-stat card">
<div class="alr-stat-label">申請件数合計</div>
<div class="alr-stat-value" name="allCount">0件</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">承認待ち</div>
<div class="alr-stat-value" name="pendingCount">0件</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">承認済み</div>
<div class="alr-stat-value" name="approvedCount">0件</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">否認</div>
<div class="alr-stat-value" name="rejectedCount">0件</div>
</div>
</section>
<section aria-label="社員の休暇申請一覧" class="alr-panel">
<div class="alr-panel-head">
<h2 class="alr-section-title">休暇申請一覧</h2>
<div class="alr-count" name="resultCount">合計 0件</div>
</div>
<div class="alr-scroll">
<div class="hrms-table-scroll"><table class="alr-table">
<thead>
<tr>
<th>申請日</th>
<th>所属部署</th>
<th>社員番号 / 氏名</th>
<th>取得期間</th>
<th>申請日数</th>
<th>申請理由</th>
<th>処理状態</th>
<th>操作</th>
</tr>
</thead>
<tbody name="leaveRequestRows"></tbody>
</table></div>
</div>
<div class="alr-footer">※ 承認時に、申請日数が該当年度の休暇残日数から差し引かれます。 処理済みの申請は再処理できません。</div>
</section>
</main>
<div aria-labelledby="alrDetailTitle" aria-modal="true" class="alr-overlay" name="leaveDetailOverlay" role="dialog">
<div class="alr-dialog">
<div class="alr-dialog-head">
<h2 id="alrDetailTitle">休暇申請の詳細</h2>
<button aria-label="閉じる" class="alr-close" name="closeLeaveDetail" type="button">×</button>
</div>
<dl class="alr-detail" name="leaveDetailContent"></dl>
<div class="alr-dialog-bottom">
<button class="alr-btn" name="closeLeaveDetail" type="button">閉じる</button>
</div>
</div>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-admin.js?v=ja-dynamic-2"></script>
</body>
</html>
