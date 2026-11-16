<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>휴가 현황</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-balance.css?v=job-unified-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=2">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">

        <div class="content hrms-leave-content">
<section class="leave-dashboard hrms-page-content hrms-attendance-leave-page">
<header class="hrms-section-page-header">
<h2 class="leave-heading hrms-page-title">휴가 현황</h2>
<p class="leave-caption page-path">부여된 휴가와 사용 및 잔여 일수를 확인할 수 있습니다.</p>
</header>
<!-- 1. 나의 휴가 현황 -->
<section class="leave-card card">
<div class="leave-card-head">
<h3 class="leave-card-title">나의 휴가 현황</h3>
</div>
<div class="leave-summary-grid">
<div class="leave-summary-item">
<div class="leave-summary-label">총 부여 일수</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="totalDays">-</div>
</div>
</div>
<div class="leave-summary-item">
<div class="leave-summary-label">사용 일수</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="usedDays">-</div>
</div>
</div>
<div class="leave-summary-item">
<div class="leave-summary-label">잔여 일수</div>
<div class="leave-summary-bottom">
<div class="leave-summary-value" name="remainingDays">-</div>
</div>
</div>
</div>
</section>
<!-- 2. 휴가 사용 내역 -->
<section class="leave-card leave-history-card card">
<div class="leave-card-head">
<h3 class="leave-card-title">휴가 사용 내역</h3>
<div class="leave-card-count" name="leaveHistoryCount">조회 중</div>
</div>
<div class="leave-table-scroll">
<div class="hrms-table-scroll"><table class="leave-table">
<thead>
<tr>
<th>사용일</th>
<th>휴가 종류</th>
<th>사용 기간</th>
<th>사용 일수</th>
<th>처리 상태</th>
</tr>
</thead>
<!-- 현재는 화면 설계의 예시 데이터 4건 -->
<tbody name="leaveHistoryRows">
<tr>
<td class="leave-empty" colspan="5">휴가 사용 내역을 불러오는 중입니다.</td>
</tr>
</tbody>
</table></div>
</div>
<p class="leave-note">※ 휴가 일수는 회사 휴가 정책에 따라 산정됩니다.</p>
</section>
<!-- 3. 화면 이동 버튼 (기능은 나중에 연결) -->
<div class="leave-actions">
<button class="leave-button" name="leaveHistoryButton" type="button">휴가 신청 내역</button>
<button class="leave-button leave-button-primary" name="leaveApplyButton" type="button">휴가 신청</button>
</div>
</section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-balance.js?v=1"></script>
</body>
</html>
