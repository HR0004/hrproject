<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>自分の勤怠状況</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-my.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-attendance" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">

        <div class="content hrms-attendance-content">
<section class="att-dashboard hrms-page-content hrms-attendance-leave-page" id="att-dashboard">
<header class="hrms-section-page-header">
<h2 class="att-heading hrms-page-title">自分の勤怠状況</h2>
<p class="att-caption page-path">出退勤を打刻して、ご自身の勤怠記録を確認できます。</p>
</header>
<!-- 위에 꺼 -->
<section class="att-today-card card">
<h3 class="att-card-title">本日の出退勤</h3>
<div class="att-today-grid">
<div class="att-today-col">
<p class="att-label">勤務日</p>
<div class="att-value" name="workDate">-</div>
<div class="att-mt">
<p class="att-label">所定勤務時間</p>
<div class="att-value">09:00 - 18:00</div>
</div>
</div>
<!-- 나누기 -->
<div class="att-today-col">
<p class="att-label">現在の状態</p>
<span class="att-status-badge"> <span class="att-dot"></span>
<span name="attendanceStatus">出勤前</span>
</span>
<div class="att-time-grid">
<div>
<p class="att-label">出勤時刻</p>
<div class="att-time" name="clockIn">--:--</div>
</div>
<div>
<p class="att-label">退勤時刻</p>
<div class="att-time" name="clockOut">--:--</div>
</div>
</div>
</div>
<!--  나누고  -->
<div class="att-today-col">
<div class="att-checkin-controls">
<div>
<div class="att-button-pair">
<button class="att-button att-button-primary" disabled="" name="clockInButton" type="button">出勤打刻</button>
<button class="att-button" disabled="" name="clockOutButton" type="button">退勤打刻</button>
</div>
<p class="att-help">ご自身のアカウントで出勤・退勤時刻を登録します。</p>
</div>
</div>
</div>
</div>
</section>
<!-- 아래 꺼 -->
<section class="att-section card">
<div class="att-records-header">
<div>
<h2 class="att-heading">自分の勤怠記録</h2>
<p class="att-caption">最近の勤怠記録を確認できます。</p>
<p aria-live="polite" class="att-reload-hint" id="att-message"></p>
</div>
<div class="att-filter">
<button class="att-filter-btn att-dark" name="moveMonthlyView" type="button">月別詳細</button>
<input aria-label="検索対象年月" class="att-month-input" id="att-month" type="month"/>
<button class="att-filter-btn" id="att-search" type="button">期間
								検索</button>
</div>
</div>
<div class="att-table-wrap">
<div class="hrms-table-scroll"><table class="att-table">
<thead>
<tr>
<th>勤務日</th>
<th>出勤時刻</th>
<th>退勤時刻</th>
<th>勤務時間</th>
<th>状態</th>
<th>備考</th>
</tr>
</thead>
<tbody id="att-rows">
<tr>
<td class="att-empty" colspan="6">勤怠記録を読み込んでいます。</td>
</tr>
</tbody>
</table></div>
</div>
<p class="att-footer-note">※ 勤務時間は画面上で計算した参考値です。 休憩時間の控除など
						実際の勤怠ルールは Serviceで処理する必要があります。</p>
</section>
<!-- 팝업창 -->
<div class="att-dialog-overlay" hidden="" id="att-dialog-overlay">
<div aria-labelledby="att-dialog-title" aria-modal="true" class="att-dialog" role="dialog">
<div class="att-dialog-top">
<h3 id="att-dialog-title">月別詳細</h3>
<button aria-label="閉じる" class="att-close" id="att-dialog-close" type="button">×</button>
</div>
<p class="att-caption" id="att-dialog-month" style="margin-bottom: 18px !important"></p>
<div class="att-summary-grid">
<div class="att-summary-item">
								取得した勤務記録<b id="att-count-total">0件</b>
</div>
<div class="att-summary-item">
								通常勤務<b id="att-count-normal">0件</b>
</div>
<div class="att-summary-item">
								遅刻<b id="att-count-late">0件</b>
</div>
<div class="att-summary-item">
								早退<b id="att-count-early">0件</b>
</div>
</div>
<p class="att-footer-note">現在表示している一覧を基に集計しています。</p>
</div>
</div>
<!-- 월별 팝업 창 -->
</section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/attendance-my.js?v=ja-dynamic-2"></script>
</body>
</html>
