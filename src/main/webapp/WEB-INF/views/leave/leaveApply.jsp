<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>휴가 신청</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-apply.css?v=job-unified-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=2">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
        <div class="content hrms-leave-content">
<main class="la-page hrms-page-content hrms-attendance-leave-page">
<header class="hrms-section-page-header">
<h1 class="la-heading hrms-page-title">휴가 신청</h1>
<p class="la-subheading page-path">휴가 종류와 기간을 입력하여 휴가를 신청합니다.</p>
</header>
<section aria-labelledby="laFormTitle" class="la-card card">
<div class="la-card-header">
<h2 class="la-card-title" id="laFormTitle">휴가 신청서</h2>
</div>
<form id="leaveApplyForm" name="leaveApplyForm" novalidate="">
<div class="la-card-body">
<div class="la-date-grid">
<div class="la-field">
<label class="la-label" for="leaveStartDate">시작일 <span class="la-required">*</span></label> <input class="la-input" id="leaveStartDate" name="startDate" required="" type="date"/>
</div>
<div class="la-field">
<label class="la-label" for="leaveEndDate">종료일 <span class="la-required">*</span></label> <input class="la-input" id="leaveEndDate" name="endDate" required="" type="date"/>
</div>
</div>
<div class="la-field la-radio-field">
<span class="la-label" id="halfDayLabel">반차 여부 <span class="la-required">*</span></span>
<div aria-labelledby="halfDayLabel" class="la-radios" role="radiogroup">
<label class="la-radio-option"><input checked="" name="halfDayType" type="radio" value="FULL"/>종일</label> <label class="la-radio-option"><input name="halfDayType" type="radio" value="AM"/>오전 반차</label> <label class="la-radio-option"><input name="halfDayType" type="radio" value="PM"/>오후 반차</label>
</div>
</div>
<div class="la-field la-reason-field">
<label class="la-label" for="leaveReason">신청 사유 <span class="la-required">*</span></label>
<div class="la-textarea-box">
<textarea class="la-textarea" id="leaveReason" maxlength="50" name="reason" placeholder="휴가 신청 사유를 입력하세요" required=""></textarea>
<span class="la-count" name="reasonCount">0 / 50</span>
</div>
</div>
<p class="la-notice">※ 신청한 휴가는 관리자 승인 후 확정되며, 승인 결과는 나의 휴가 신청
								내역에서 확인할 수 있습니다.</p>
<div class="la-card-footer">
<button class="la-btn" name="cancelButton" type="button">취소</button>
<button class="la-btn la-btn-primary" name="applyButton" type="submit">신청</button>
</div>
</div>
</form>
</section>
</main>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-apply.js?v=1"></script>
</body>
</html>
