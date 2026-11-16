<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>직급 등록</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/job-edit.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-job-edit" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="job-register-page hrms-page-content">
<main class="job-register-container">
<!-- 상단 -->
<div class="job-breadcrumb">
                HRMS / 직급 관리 / 직급 등록
            </div>
<div class="job-page-heading">
<div>
<h1 class="hrms-page-title">직급 등록</h1>
<p>새로운 직급을 등록합니다.</p>
</div>
<a class="job-back-btn" href="${pageContext.request.contextPath}/jobs">
                    목록으로
                </a>
</div>
<!-- 안내 -->
<div class="job-info-box">
                직급 코드는 등록 완료 후 자동으로 생성됩니다.
            </div>
<!-- 직급 등록 -->
<section class="job-register-card">
<div class="job-card-heading">
<h2>직급 기본 정보</h2>
<p>직급 정보를 입력해 주세요.</p>
</div>
<form id="jobRegisterForm">
<div class="job-form-group">
<label for="jobName">
                            직급명 <span class="required">*</span>
</label>
<input id="jobName" maxlength="20" name="jobName" placeholder="예: 사원, 대리, 과장" required="" type="text"/>
<small>
                            직급명을 입력해 주세요.
                        </small>
</div>
<div class="job-form-group">
<label>직급 코드</label>
<input readonly="" type="text" value="등록 시 자동 생성"/>
<small>
                            직급 코드는 서버에서 자동 생성됩니다.
                        </small>
</div>
<div class="job-form-actions">
<a class="job-cancel-btn" href="${pageContext.request.contextPath}/jobs">
                            취소
                        </a>
<button class="job-submit-btn" id="registerBtn" type="submit">
                            직급 등록
                        </button>
</div>
</form>
</section>
</main>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/job-edit.js?v=1"></script>
</body></html>
