
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 신규 사원 등록</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeeregister.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeeregister" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-register-page hrms-page-content">
<main class="employee-register-container">
<!-- 페이지 제목 -->
<div class="employee-register-heading">
<div>
<h1 class="hrms-page-title">신규 사원 등록</h1>
<p>사원 관리 / 신규 사원 등록</p>
</div>
<a class="employee-register-btn btn-outline" href="${pageContext.request.contextPath}/employees">
<i class="fas fa-arrow-left"></i> 목록으로
                </a>
</div>
<!-- 사원 등록 폼 -->
<section class="employee-register-card">
<h2>사원 기본 정보</h2>
<p class="employee-register-hint">
                    * 표시 항목은 필수 입력입니다.
                </p>
<form id="employeeRegisterForm" novalidate="">
<div class="employee-register-grid">
<!-- 사번 -->
<div class="register-field field-id">
<label>사번 *</label>
<input readonly="" type="text" value="자동 생성"/>
</div>
<!-- 성명 -->
<div class="register-field field-name">
<label for="ename">성명 *</label>
<input id="ename" maxlength="30" placeholder="성명 입력" required="" type="text"/>
</div>
<!-- 재직 상태 -->
<div class="register-field field-status">
<label for="status">재직 상태 *</label>
<select id="status" required="">
<option value="ACTIVE">재직</option>
<option value="LEAVE">휴직</option>
<option value="RETIRED">퇴직</option>
</select>
</div>
<!-- 이메일 -->
<div class="register-field field-email">
<label for="email">이메일 *</label>
<input id="email" maxlength="40" placeholder="example@hrms.com" required="" type="email"/>
</div>
<!-- 연락처 -->
<div class="register-field field-phone">
<label for="phone">연락처</label>
<input id="phone" maxlength="13" placeholder="010-0000-0000" type="tel"/>
</div>
<!-- 등록 전 확인 사항 -->
<div class="register-notice field-notice">
<h3>등록 전 확인 사항</h3>
<p>✓ 필수 입력값 확인</p>
<p>✓ 부서 및 직급 선택</p>
<p>✓ 사번 자동 생성</p>
<p>✓ 사원 기본 정보 저장</p>
</div>
<!-- 로그인 ID -->
<div class="register-field field-login-id">
<label for="loginId">로그인 ID *</label>
<input id="loginId" maxlength="30" placeholder="로그인 ID 입력" required="" type="text"/>
</div>
<!-- 초기 비밀번호 -->
<div class="register-field field-password">
<label for="password">초기 비밀번호 *</label>
<input id="password" minlength="8" placeholder="초기 비밀번호 입력" required="" type="password"/>
</div>
<!-- 입사일 -->
<div class="register-field field-hiredate">
<label for="hiredate">입사일 *</label>
<input id="hiredate" required="" type="date"/>
</div>
<!-- 소속 부서 -->
<div class="register-field field-department">
<label for="departmentId">소속 부서 *</label>
<select id="departmentId" required="">
<option value="">부서를 선택하세요</option>
<option value="1">경영지원팀</option>
<option value="2">개발팀</option>
<option value="3">영업팀</option>
</select>
</div>
<!-- 직급 -->
<div class="register-field field-job">
<label for="jobId">직급 *</label>
<select id="jobId" required="">
<option value="">직급을 선택하세요</option>
<option value="1">사원</option>
<option value="2">대리</option>
<option value="3">과장</option>
<option value="4">차장</option>
<option value="5">부장</option>
</select>
</div>
</div>
<!-- 버튼 -->
<div class="register-actions">
<a class="employee-register-btn btn-outline" href="${pageContext.request.contextPath}/employees">
                            취소
                        </a>
<button class="employee-register-btn btn-primary-custom" id="registerBtn" type="submit">
                            사원 등록
                        </button>
</div>
</form>
</section>
</main>
</div>
<div class="modal fade" id="registerPopup" tabindex="-1">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<div class="modal-body p-4">
<h4 class="font-weight-bold mb-4">
<span class="mr-2" id="popupIcon"></span>
<span id="popupTitle"></span>
</h4>
<p class="mb-3" id="popupMessage"></p>
<div class="bg-light rounded p-3 mb-4" id="popupDetail"></div>
<div class="d-flex">
<button class="btn btn-outline-secondary flex-fill mr-2" data-dismiss="modal" id="popupCancel" type="button">
                        취소
                    </button>
<button class="btn btn-primary flex-fill" id="popupAction" type="button">
                        확인
                    </button>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeeregister.js?v=1"></script>
</body></html>
