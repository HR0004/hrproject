<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 근태 현황</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-my.css?v=1">
</head>
<body class="hold-transition hrms-adminlte hrms-attendance" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
<nav class="hrms-attendance-links px-4 pt-3" aria-label="근태 화면 이동">
    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/attendance" aria-current="page">내 근태</a>
    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/attendance/monthly">월별 조회</a>
</nav>
        <div class="content hrms-attendance-content">
<section class="att-dashboard" id="att-dashboard">
<header>
<h2 class="att-heading">내 근태 현황</h2>
<p class="att-caption">출근 및 퇴근을 등록하고 나의 근태 기록을 확인할 수 있습니다.</p>
</header>
<!-- 위에 꺼 -->
<section class="att-today-card card">
<h3 class="att-card-title">오늘의 출퇴근</h3>
<div class="att-today-grid">
<div class="att-today-col">
<p class="att-label">근무 일자</p>
<div class="att-value" name="workDate">-</div>
<div class="att-mt">
<p class="att-label">기준 근무시간</p>
<div class="att-value">09:00 - 18:00</div>
</div>
</div>
<!-- 나누기 -->
<div class="att-today-col">
<p class="att-label">현재 상태</p>
<span class="att-status-badge"> <span class="att-dot"></span>
<span name="attendanceStatus">출근 전</span>
</span>
<div class="att-time-grid">
<div>
<p class="att-label">출근 시간</p>
<div class="att-time" name="clockIn">--:--</div>
</div>
<div>
<p class="att-label">퇴근 시간</p>
<div class="att-time" name="clockOut">--:--</div>
</div>
</div>
</div>
<!--  나누고  -->
<div class="att-today-col">
<div class="att-checkin-controls">
<div>
<div class="att-button-pair">
<button class="att-button att-button-primary" disabled="" name="clockInButton" type="button">출근하기</button>
<button class="att-button" disabled="" name="clockOutButton" type="button">퇴근하기</button>
</div>
<p class="att-help">본인 계정의 출근·퇴근 시간을 등록합니다.</p>
</div>
</div>
</div>
</div>
</section>
<!-- 아래 꺼 -->
<section class="att-section card">
<div class="att-records-header">
<div>
<h2 class="att-heading">나의 근태 기록</h2>
<p class="att-caption">최근 근태 기록을 확인할 수 있습니다.</p>
<p aria-live="polite" class="att-reload-hint" id="att-message"></p>
</div>
<div class="att-filter">
<button class="att-filter-btn att-dark" name="moveMonthlyView" type="button">월별 상세 조회</button>
<input aria-label="조회할 연월" class="att-month-input" id="att-month" type="month"/>
<button class="att-filter-btn" id="att-search" type="button">기간
								조회</button>
</div>
</div>
<div class="att-table-wrap">
<table class="att-table">
<thead>
<tr>
<th>근무 일자</th>
<th>출근 시간</th>
<th>퇴근 시간</th>
<th>근무 시간</th>
<th>상태</th>
<th>비고</th>
</tr>
</thead>
<tbody id="att-rows">
<tr>
<td class="att-empty" colspan="6">근태 기록을 불러오는 중입니다.</td>
</tr>
</tbody>
</table>
</div>
<p class="att-footer-note">※ 근무 시간은 화면에서 계산한 임시 값입니다. 휴게시간 공제 등
						실제 근태 규칙은 Service에서 처리해야 합니다.</p>
</section>
<!-- 팝업창 -->
<div class="att-dialog-overlay" hidden="" id="att-dialog-overlay">
<div aria-labelledby="att-dialog-title" aria-modal="true" class="att-dialog" role="dialog">
<div class="att-dialog-top">
<h3 id="att-dialog-title">월별 상세 조회</h3>
<button aria-label="닫기" class="att-close" id="att-dialog-close" type="button">×</button>
</div>
<p class="att-caption" id="att-dialog-month" style="margin-bottom: 18px !important"></p>
<div class="att-summary-grid">
<div class="att-summary-item">
								조회된 근무 기록<b id="att-count-total">0건</b>
</div>
<div class="att-summary-item">
								정상 근무<b id="att-count-normal">0건</b>
</div>
<div class="att-summary-item">
								지각<b id="att-count-late">0건</b>
</div>
<div class="att-summary-item">
								조퇴<b id="att-count-early">0건</b>
</div>
</div>
<p class="att-footer-note">현재 조회된 목록을 기준으로 집계합니다.</p>
</div>
</div>
<!-- 월별 팝업 창 -->
</section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/attendance-my.js?v=1"></script>
</body>
</html>
