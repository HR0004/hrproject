<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>部署別勤怠状況</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-department.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-attendance" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">

        <div class="content hrms-attendance-content">
<main class="dat-page hrms-page-content hrms-attendance-leave-page">
<header class="dat-header hrms-section-page-header">
<div>
<h1 class="dat-title hrms-page-title">部署別勤怠状況</h1>
<p class="dat-subtitle page-path">同じ部署の社員の日別出退勤と勤怠状況を確認できます。</p>
</div>
</header>
<section aria-label="部署別勤怠の検索条件" class="dat-panel dat-filter">
<div class="dat-field">
<label for="datDepartment">検索対象部署</label> <select id="datDepartment" name="departmentId">
<option value="">部署一覧を読み込み中。..</option>
</select>
</div>
<div class="dat-field">
<label for="datWorkDate">勤務日</label><input id="datWorkDate" name="workDate" type="date"/>
</div>
<div class="dat-field">
<label for="datStatus">勤怠状態</label> <select id="datStatus" name="attendanceStatus"><option value="ALL">すべて</option>
<option value="NORMAL">通常出勤</option>
<option value="LATE">遅刻</option>
<option value="EARLY">早退</option>
<option value="LEAVE">休暇</option>
<option value="UNKNOWN">未記録</option></select>
</div>
<div class="dat-field dat-grow">
<label for="datKeyword">社員検索</label><input id="datKeyword" name="attendanceKeyword" placeholder="氏名または社員番号" type="search"/>
</div>
<div class="dat-btn-row">
<button class="dat-btn dat-btn-primary" name="searchDepartmentAttendance" type="button">勤怠検索</button>
<button class="dat-btn" name="resetDepartmentAttendance" type="button">リセット</button>
</div>
</section>
<section aria-label="部署別勤怠サマリー" class="dat-stats">
<div class="dat-stat card">
<div class="dat-stat-label">対象社員</div>
<div class="dat-stat-value" name="allEmployees">0名</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">通常出勤</div>
<div class="dat-stat-value" name="normalEmployees">0名</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">遅刻 ・ 早退</div>
<div class="dat-stat-value" name="lateEmployees">0名</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">休暇 ・ 未記録</div>
<div class="dat-stat-value" name="otherEmployees">0名</div>
</div>
</section>
<section aria-label="部署内社員の勤怠一覧" class="dat-panel">
<div class="dat-panel-head">
<h2 class="dat-section-title">部署別勤怠一覧</h2>
<span class="dat-count" name="attendanceCount">合計 0名</span>
</div>
<div class="dat-scroll">
<div class="hrms-table-scroll"><table class="dat-table">
<thead>
<tr>
<th>社員番号</th>
<th>社員名</th>
<th>勤務日</th>
<th>出勤時刻</th>
<th>退勤時刻</th>
<th>勤怠状態</th>
<th>詳細</th>
</tr>
</thead>
<tbody name="departmentAttendanceRows"></tbody>
</table></div>
</div>
<div class="dat-footer">※ 未記録は欠勤の確定を意味しません。 休暇の取得状況や勤務予定と併せて

						確認してください。</div>
</section>
</main>
<div aria-labelledby="datDetailTitle" aria-modal="true" class="dat-overlay" name="attendanceDetailOverlay" role="dialog">
<div class="dat-dialog">
<div class="dat-dialog-head">
<h2 id="datDetailTitle">社員の勤怠詳細</h2>
<button aria-label="閉じる" class="dat-close" name="closeAttendanceDetail" type="button">×</button>
</div>
<dl class="dat-detail" name="attendanceDetailContent"></dl>
<div class="dat-dialog-bottom">
<button class="dat-btn" name="closeAttendanceDetail" type="button">閉じる</button>
</div>
</div>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/attendance-department.js?v=ja-dynamic-2"></script>
</body>
</html>
