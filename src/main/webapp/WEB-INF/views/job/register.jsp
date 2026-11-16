<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>役職登録</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/job-register.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-job-register job-popup-body" data-context-path="${pageContext.request.contextPath}">
<div class="hrms-popup-content">

 メイン画面 
<div class="job-popup-card job-register-page">
<main class="job-register-container">
<!-- 상단 -->
<div class="job-breadcrumb">
                HRMS / 役職管理 / 役職登録
            </div>
<div class="job-page-heading">
<div>
<h1 class="hrms-page-title">役職登録</h1>
<p>新しい役職を登録します。</p>
</div>
</div>
<!-- 안내 -->
<div class="job-info-box">
                役職コードは登録後に自動生成されます。
            </div>
<!-- 직급 등록 -->
<section class="job-register-card">
<div class="job-card-heading">
<h2>役職基本情報</h2>
<p>役職情報を入力してください。</p>
</div>
<form id="jobRegisterForm">
<div class="job-form-group">
<label for="jobName">
                            役職名 <span class="required">*</span>
</label>
<input id="jobName" maxlength="20" name="jobName" placeholder="例: 社員、 主任、 課長" required="" type="text"/>
<small>
                            役職名を入力してください。
                        </small>
</div>
<div class="job-form-group">
<label>役職コード</label>
<input readonly="" type="text" value="登録時に自動生成"/>
<small>
                            役職コードはサーバーで自動生成されます。
                        </small>
</div>
<div class="job-form-actions">
<a class="job-cancel-btn" href="${pageContext.request.contextPath}/jobs">
                            キャンセル
                        </a>
<button class="job-submit-btn" id="registerBtn" type="submit">
                            役職登録
                        </button>
</div>
</form>
</section>
</main>
</div>
 AdminLTE JavaScript 

</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/job-register.js?v=ja-1"></script>
</body></html>
