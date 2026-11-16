<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>직원 휴가 신청 관리</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-admin.css?v=job-unified-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=2">
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
<h1 class="alr-title hrms-page-title">직원 휴가 신청 관리</h1>
<p class="alr-subtitle page-path">담당 직원의 휴가 신청을 조회하고 승인 상태를 확인합니다.</p>
</div>
<span class="alr-demo">화면 예시 데이터 · DB 미연결</span>
</header>
<section aria-label="휴가 신청 검색 조건" class="alr-panel alr-filter">
<div class="alr-field">
<label for="alrStartDate">신청 시작일</label><input id="alrStartDate" name="startDate" type="date" value="2026-10-01"/>
</div>
<div class="alr-field">
<label for="alrEndDate">신청 종료일</label><input id="alrEndDate" name="endDate" type="date" value="2026-11-30"/>
</div>
<div class="alr-field">
<label for="alrStatus">처리 상태</label> <select id="alrStatus" name="statusFilter"><option value="ALL">전체</option>
<option value="PENDING">승인 대기</option>
<option value="APPROVED">승인 완료</option>
<option value="REJECTED">반려</option></select>
</div>
<div class="alr-field alr-grow">
<label for="alrKeyword">사원 검색</label><input id="alrKeyword" name="keyword" placeholder="이름 또는 사번" type="search"/>
</div>
<div class="alr-actions">
<button class="alr-btn alr-btn-primary" name="searchLeaveRequests" type="button">조회</button>
<button class="alr-btn" name="resetLeaveRequests" type="button">초기화</button>
</div>
</section>
<section aria-label="휴가 신청 집계" class="alr-stats">
<div class="alr-stat card">
<div class="alr-stat-label">전체 신청</div>
<div class="alr-stat-value" name="allCount">0건</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">승인 대기</div>
<div class="alr-stat-value" name="pendingCount">0건</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">승인 완료</div>
<div class="alr-stat-value" name="approvedCount">0건</div>
</div>
<div class="alr-stat card">
<div class="alr-stat-label">반려</div>
<div class="alr-stat-value" name="rejectedCount">0건</div>
</div>
</section>
<section aria-label="직원 휴가 신청 목록" class="alr-panel">
<div class="alr-panel-head">
<h2 class="alr-section-title">휴가 신청 목록</h2>
<div class="alr-count" name="resultCount">총 0건</div>
</div>
<div class="alr-scroll">
<div class="hrms-table-scroll"><table class="alr-table">
<thead>
<tr>
<th>신청일</th>
<th>사번 / 이름</th>
<th>사용 기간</th>
<th>신청 일수</th>
<th>신청 사유</th>
<th>처리 상태</th>
<th>관리</th>
</tr>
</thead>
<tbody name="leaveRequestRows"></tbody>
</table></div>
</div>
<div class="alr-footer">※ 샘플 화면입니다. 승인·반려는 백엔드 권한 검증 및 처리 API
						연결 후 사용할 수 있습니다.</div>
</section>
</main>
<div aria-labelledby="alrDetailTitle" aria-modal="true" class="alr-overlay" name="leaveDetailOverlay" role="dialog">
<div class="alr-dialog">
<div class="alr-dialog-head">
<h2 id="alrDetailTitle">휴가 신청 상세</h2>
<button aria-label="닫기" class="alr-close" name="closeLeaveDetail" type="button">×</button>
</div>
<dl class="alr-detail" name="leaveDetailContent"></dl>
<div class="alr-dialog-bottom">
<button class="alr-btn" name="closeLeaveDetail" type="button">닫기</button>
</div>
</div>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-admin.js?v=1"></script>
</body>
</html>
