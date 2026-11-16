<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>부서 수정</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/department-edit.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-department-edit popup-body" data-context-path="${pageContext.request.contextPath}">
<div class="hrms-popup-content">

<div class="popup-card">
<h2 class="hrms-page-title">부서 수정</h2>
<p class="popup-description">부서 코드는 변경할 수 없습니다.</p>
<form id="editForm">
<div class="form-group">
<label for="departmentCode">부서 코드</label> <input id="departmentCode" readonly="" type="text"/>
</div>
<div class="form-group">
<label for="departmentName">부서명</label> <input id="departmentName" maxlength="20" required="" type="text"/>
</div>
<div class="button-group">
<button id="bt-cancel" type="button">취소</button>
<button class="primary-btn" type="submit">수정 완료</button>
</div>
</form>
</div>

</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/department-edit.js?v=1"></script>
</body></html>
