<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>休暇申請</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-apply.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
        <div class="content hrms-leave-content">
<main class="la-page hrms-page-content hrms-attendance-leave-page">
<header class="hrms-section-page-header">
<h1 class="la-heading hrms-page-title">休暇申請</h1>
<p class="la-subheading page-path">休暇区分と期間を入力して申請します。</p>
</header>
<section aria-labelledby="laFormTitle" class="la-card card">
<div class="la-card-header">
<h2 class="la-card-title" id="laFormTitle">休暇申請フォーム</h2>
</div>
<form id="leaveApplyForm" name="leaveApplyForm" novalidate="">
<div class="la-card-body">
<div class="la-date-grid">
<div class="la-field">
<label class="la-label" for="leaveStartDate">開始日 <span class="la-required">*</span></label> <input class="la-input" id="leaveStartDate" name="startDate" required="" type="date"/>
</div>
<div class="la-field">
<label class="la-label" for="leaveEndDate">終了日 <span class="la-required">*</span></label> <input class="la-input" id="leaveEndDate" name="endDate" required="" type="date"/>
</div>
</div>
<div class="la-field la-radio-field">
<span class="la-label" id="halfDayLabel">半日休暇の区分 <span class="la-required">*</span></span>
<div aria-labelledby="halfDayLabel" class="la-radios" role="radiogroup">
<label class="la-radio-option"><input checked="" name="halfDayType" type="radio" value="FULL"/>全日</label> <label class="la-radio-option"><input name="halfDayType" type="radio" value="AM"/>午前半休</label> <label class="la-radio-option"><input name="halfDayType" type="radio" value="PM"/>午後半休</label>
</div>
</div>
<div class="la-field la-reason-field">
<label class="la-label" for="leaveReason">申請理由 <span class="la-required">*</span></label>
<div class="la-textarea-box">
<textarea class="la-textarea" id="leaveReason" maxlength="50" name="reason" placeholder="休暇の申請理由を入力してください" required=""></textarea>
<span class="la-count" name="reasonCount">0 / 50</span>
</div>
</div>
<p class="la-notice">※ 申請した休暇は管理者の承認後に確定します。承認結果は休暇申請履歴で確認できます。</p>
<div class="la-card-footer">
<button class="la-btn" name="cancelButton" type="button">キャンセル</button>
<button class="la-btn la-btn-primary" name="applyButton" type="submit">申請</button>
</div>
</div>
</form>
</section>
</main>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-apply.js?v=ja-dynamic-2"></script>
</body>
</html>
