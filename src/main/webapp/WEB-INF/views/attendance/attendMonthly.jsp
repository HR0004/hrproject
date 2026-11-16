<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>나의 월별 근태 성적</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-monthly.css?v=job-unified-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=2">
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
<h2 class="ma-title hrms-page-title">나의 월별 근태 성적</h2>
<p class="ma-subtitle page-path">월별 총근일수, 지각·조퇴, 결근 및 연장근무 현황을 확인할 수
							있습니다.</p>
</div>
<div class="ma-search-controls">
<select aria-label="조회할 월 선택" class="ma-month-select" name="selectedMonth">
<option value="2026-12">2026년 12월</option>
<option value="2026-11">2026년 11월</option>
<option selected="" value="2026-10">2026년 10월</option>
<option value="2026-09">2026년 09월</option>
<option value="2026-08">2026년 08월</option>
<option value="2026-07">2026년 07월</option>
<option value="2026-06">2026년 06월</option>
<option value="2026-05">2026년 05월</option>
<option value="2026-04">2026년 04월</option>
<option value="2026-03">2026년 03월</option>
<option value="2026-02">2026년 02월</option>
<option value="2026-01">2026년 01월</option>
</select>
<button class="ma-search-button" name="moveAttendanceButton" type="button">근태 현황</button>
</div>
</header>
<!-- 선택한 월의 근태 통계 -->
<section aria-label="선택 월 근태 통계" class="ma-stats">
<div class="ma-stat-card card">
<p class="ma-stat-label">총 출근일수</p>
<div class="ma-stat-value" name="totalWorkDays">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">지각 · 조퇴</p>
<div class="ma-stat-value" name="lateEarlyCount">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">결근일수</p>
<div class="ma-stat-value" name="absentDays">-</div>
</div>
<div class="ma-stat-card card">
<p class="ma-stat-label">총 연장근무시간</p>
<div class="ma-stat-value" name="overtimeTotal">-</div>
</div>
</section>
<section aria-label="월별 근태 요약">
<div class="ma-section-head">
<h3 class="ma-section-title">월별 근태 요약</h3>
<p class="ma-section-subtitle">개인별 월간 근태 집계</p>
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
<th scope="col">대상 월</th>
<th scope="col">총 출근일수</th>
<th scope="col">지각 횟수</th>
<th scope="col">조퇴 횟수</th>
<th scope="col">결근일수</th>
<th scope="col">총 연장근무시간</th>
<th scope="col">정산 전송 상태</th>
</tr>
</thead>
<tbody name="monthlyAttendanceRows">
<tr>
<td class="ma-empty" colspan="7">근태 데이터를 불러오는 중입니다.</td>
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
<script src="${pageContext.request.contextPath}/static/js/attendance-monthly.js?v=1"></script>
</body>
</html>
