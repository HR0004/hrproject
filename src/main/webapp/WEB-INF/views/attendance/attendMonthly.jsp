<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>月次勤怠実績</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-monthly.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-attendance" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">

        <div class="content hrms-attendance-content">
<main class="ma-page hrms-page-content hrms-attendance-leave-page">
<header class="ma-head hrms-section-page-header">
<div>
<h2 class="ma-title hrms-page-title">月次勤怠実績</h2>
<p class="ma-subtitle page-path">月別の出勤日数、遅刻・早退・欠勤、残業時間を確認できます。</p>
</div>
<div class="ma-search-controls">
<select aria-label="検索対象月を選択" class="ma-month-select" name="selectedMonth">
<option value="2026-12">2026年 12月</option>
<option value="2026-11">2026年 11月</option>
<option selected="" value="2026-10">2026年 10月</option>
<option value="2026-09">2026年 09月</option>
<option value="2026-08">2026年 08月</option>
<option value="2026-07">2026年 07月</option>
<option value="2026-06">2026年 06月</option>
<option value="2026-05">2026年 05月</option>
<option value="2026-04">2026年 04月</option>
<option value="2026-03">2026年 03月</option>
<option value="2026-02">2026年 02月</option>
<option value="2026-01">2026年 01月</option>
</select>
<button class="ma-search-button" name="moveAttendanceButton" type="button">勤怠状況</button>
</div>
</header>
<!-- 선택한 월의 근태 통계 -->
<section aria-label="選択月の勤怠統計" class="ma-stats">
<div class="ma-stat-card card">
<p class="ma-stat-label">出勤日数合計</p>
<div class="ma-stat-value" name="totalWorkDays">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">遅刻 ・ 早退</p>
<div class="ma-stat-value" name="lateEarlyCount">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">欠勤日数</p>
<div class="ma-stat-value" name="absentDays">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">残業時間合計</p>
<div class="ma-stat-value" name="overtimeTotal">-</div>
</div>
</section>
<section aria-label="月次勤怠サマリー">
<div class="ma-section-head">
<h3 class="ma-section-title">月次勤怠サマリー</h3>
<p class="ma-section-subtitle">個人別の月次勤怠集計</p>
</div>
<div class="ma-table-scroll">
<div class="hrms-table-scroll"><table class="ma-table">
<colgroup>
<col style="width: 15%;"/>
<col style="width: 15%;"/>
<col style="width: 14%;"/>
<col style="width: 14%;"/>
<col style="width: 14%;"/>
<col style="width: 17%;"/>
<col style="width: 11%;"/>
</colgroup>
<thead>
<tr>
<th scope="col">対象月</th>
<th scope="col">出勤日数合計</th>
<th scope="col">遅刻回数</th>
<th scope="col">早退回数</th>
<th scope="col">欠勤日数</th>
<th scope="col">残業時間合計</th>
<th scope="col">精算データ送信状況</th>
</tr>
</thead>
<tbody name="monthlyAttendanceRows">
<tr>
<td class="ma-empty" colspan="7">勤怠データを読み込んでいます。</td>
</tr>
</tbody>
</table></div>
</div>
</section>
</main>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/attendance-monthly.js?v=ja-dynamic-2"></script>
</body>
</html>
