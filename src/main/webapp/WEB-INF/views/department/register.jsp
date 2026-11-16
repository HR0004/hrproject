<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>部署登録</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/department-register.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-department-register popup-body" data-context-path="${pageContext.request.contextPath}">
<div class="hrms-popup-content">

<div class="popup-card">
<h2 class="hrms-page-title">部署の新規登録</h2>
<p class="popup-description">
        部署コードは登録時に自動生成されます。
    </p>
<form id="registerForm">
<div class="form-group">
<label for="departmentName">部署名</label>
<input id="departmentName" maxlength="50" name="departmentName" placeholder="部署名を入力してください。" required="" type="text"/>
</div>
<div class="button-group">
<button id="cancelBtn" type="button">
                キャンセル
            </button>
<button class="primary-btn" type="submit">
                登録
            </button>
</div>
</form>
</div>

</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/department-register.js?v=ja-1"></script>
</body></html>
