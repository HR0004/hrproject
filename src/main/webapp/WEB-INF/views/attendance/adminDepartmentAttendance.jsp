<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>부서 근태 현황</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-department.css?v=1">
</head>
<body class="hold-transition hrms-adminlte hrms-attendance" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
<nav class="hrms-attendance-links px-4 pt-3" aria-label="근태 화면 이동">
    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/attendance">내 근태</a>
    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/attendance/monthly">월별 조회</a>
</nav>
        <div class="content hrms-attendance-content">
<main class="dat-page">
<header class="dat-header">
<div>
<h1 class="dat-title">부서 근태 현황</h1>
<p class="dat-subtitle">같은 부서 직원의 일별 출퇴근 및 근태 상태를 확인합니다.</p>
</div>
</header>
<section aria-label="부서 근태 조회 조건" class="dat-panel dat-filter">
<div class="dat-field">
<label for="datDepartment">조회 부서</label> <select id="datDepartment" name="departmentId">
<option value="">부서 목록 불러오는 중...</option>
</select>
</div>
<div class="dat-field">
<label for="datWorkDate">근무 일자</label><input id="datWorkDate" name="workDate" type="date" value="2026-11-05"/>
</div>
<div class="dat-field">
<label for="datStatus">근태 상태</label> <select id="datStatus" name="attendanceStatus"><option value="ALL">전체</option>
<option value="NORMAL">정상 출근</option>
<option value="LATE">지각</option>
<option value="EARLY">조퇴</option>
<option value="LEAVE">휴가</option>
<option value="UNKNOWN">미기록</option></select>
</div>
<div class="dat-field dat-grow">
<label for="datKeyword">직원 검색</label><input id="datKeyword" name="attendanceKeyword" placeholder="이름 또는 사번" type="search"/>
</div>
<div class="dat-btn-row">
<button class="dat-btn dat-btn-primary" name="searchDepartmentAttendance" type="button">근태 조회</button>
<button class="dat-btn" name="resetDepartmentAttendance" type="button">초기화</button>
</div>
</section>
<section aria-label="부서 근태 요약" class="dat-stats">
<div class="dat-stat card">
<div class="dat-stat-label">조회 직원</div>
<div class="dat-stat-value" name="allEmployees">0명</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">정상 출근</div>
<div class="dat-stat-value" name="normalEmployees">0명</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">지각 · 조퇴</div>
<div class="dat-stat-value" name="lateEmployees">0명</div>
</div>
<div class="dat-stat card">
<div class="dat-stat-label">휴가 · 미기록</div>
<div class="dat-stat-value" name="otherEmployees">0명</div>
</div>
</section>
<section aria-label="부서 직원 근태 목록" class="dat-panel">
<div class="dat-panel-head">
<h2 class="dat-section-title">부서별 근태 목록</h2>
<span class="dat-count" name="attendanceCount">총 0명</span>
</div>
<div class="dat-scroll">
<table class="dat-table">
<thead>
<tr>
<th>사번</th>
<th>직원명</th>
<th>근무 일자</th>
<th>출근 시간</th>
<th>퇴근 시간</th>
<th>근태 상태</th>
<th>상세</th>
</tr>
</thead>
<tbody name="departmentAttendanceRows"></tbody>
</table>
</div>
<div class="dat-footer">※ 미기록은 결근 확정이 아닙니다. 휴가 여부 및 근무 일정과 함께

						확인해야 합니다.</div>
</section>
</main>
<div aria-labelledby="datDetailTitle" aria-modal="true" class="dat-overlay" name="attendanceDetailOverlay" role="dialog">
<div class="dat-dialog">
<div class="dat-dialog-head">
<h2 id="datDetailTitle">직원 근태 상세</h2>
<button aria-label="닫기" class="dat-close" name="closeAttendanceDetail" type="button">×</button>
</div>
<dl class="dat-detail" name="attendanceDetailContent"></dl>
<div class="dat-dialog-bottom">
<button class="dat-btn" name="closeAttendanceDetail" type="button">닫기</button>
</div>
</div>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/attendance-department.js?v=1"></script>
</body>
</html>
