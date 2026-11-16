<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>休暇状況</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-balance.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">

        <div class="content hrms-leave-content">
<section class="leave-dashboard hrms-page-content hrms-attendance-leave-page">
<header class="hrms-section-page-header">
<h2 class="leave-heading hrms-page-title">休暇状況</h2>
<p class="leave-caption page-path">付与された休暇日数・取得日数・残日数を確認できます。</p>
</header>
<!-- 1. 나의 휴가 현황 -->
<section class="leave-card card">
<div class="leave-card-head">
<h3 class="leave-card-title">自分の休暇状況</h3>
</div>
<div class="leave-summary-grid">
<div class="leave-summary-item">
<div class="leave-summary-label">付与日数合計</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="totalDays">-</div>
</div>
</div>
<div class="leave-summary-item">
<div class="leave-summary-label">取得日数</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="usedDays">-</div>
</div>
</div>
<div class="leave-summary-item">
<div class="leave-summary-label">残日数</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="remainingDays">-</div>
</div>
</div>
</div>
</section>
<!-- 2. 휴가 사용 내역 -->
<section class="leave-card leave-history-card card">
<div class="leave-card-head">
<h3 class="leave-card-title">休暇取得履歴</h3>
<div class="leave-card-count" name="leaveHistoryCount">読み込み中</div>
</div>
<div class="leave-table-scroll">
<div class="hrms-table-scroll"><table class="leave-table">
<thead>
<tr>
<th>取得日</th>
<th>休暇区分</th>
<th>取得期間</th>
<th>取得日数</th>
<th>処理状態</th>
</tr>
</thead>
<!-- 현재는 화면 설계의 예시 데이터 4건 -->
<tbody name="leaveHistoryRows">
<tr>
<td class="leave-empty" colspan="5">休暇取得履歴を読み込んでいます。</td>
</tr>
</tbody>
</table></div>
</div>
<p class="leave-note">※ 休暇日数は会社の休暇規程に基づいて計算されます。</p>
</section>
<!-- 3. 화면 이동 버튼 (기능은 나중에 연결) -->
<div class="leave-actions">
<button class="leave-button" name="leaveHistoryButton" type="button">休暇申請履歴</button>
<button class="leave-button leave-button-primary" name="leaveApplyButton" type="button">休暇申請</button>
</div>
</section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-balance.js?v=ja-dynamic-2"></script>
</body>
</html>
