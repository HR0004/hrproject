
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 社員の新規登録</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeeregister.css?v=ja-1">
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
<h1 class="hrms-page-title">社員の新規登録</h1>
<p>社員管理 / 社員の新規登録</p>
</div>
<a class="employee-register-btn btn-outline" href="${pageContext.request.contextPath}/employees">
<i class="fas fa-arrow-left"></i> 一覧へ
                </a>
</div>
<!-- 사원 등록 폼 -->
<section class="employee-register-card">
<h2>社員基本情報</h2>
<p class="employee-register-hint">
                    * の項目は必須です。
                </p>
<form id="employeeRegisterForm" novalidate="">
<div class="employee-register-grid">
<!-- 사번 -->
<div class="register-field field-id">
<label>社員番号 *</label>
<input readonly="" type="text" value="自動生成"/>
</div>
<!-- 성명 -->
<div class="register-field field-name">
<label for="ename">氏名 *</label>
<input id="ename" maxlength="30" placeholder="氏名を入力" required="" type="text"/>
</div>
<!-- 재직 상태 -->
<div class="register-field field-status">
<label for="status">在籍状態 *</label>
<select id="status" required="">
<option value="ACTIVE">在籍</option>
<option value="LEAVE">休職</option>
<option value="RETIRED">退職</option>
</select>
</div>
<!-- 이메일 -->
<div class="register-field field-email">
<label for="email">メールアドレス *</label>
<input id="email" maxlength="40" placeholder="example@hrms.com" required="" type="email"/>
</div>
<!-- 연락처 -->
<div class="register-field field-phone">
<label for="phone">電話番号</label>
<input id="phone" maxlength="13" placeholder="010-0000-0000" type="tel"/>
</div>
<!-- 등록 전 확인 사항 -->
<div class="register-notice field-notice">
<h3>登録前の確認事項</h3>
<p>✓ 必須入力項目の確認</p>
<p>✓ 部署と役職の選択</p>
<p>✓ 社員番号を自動生成</p>
<p>✓ 社員基本情報を保存</p>
</div>
<!-- 로그인 ID -->
<div class="register-field field-login-id">
<label for="loginId">ログイン ID *</label>
<input id="loginId" maxlength="30" placeholder="ログイン ID 入力" required="" type="text"/>
</div>
<!-- 초기 비밀번호 -->
<div class="register-field field-password">
<label for="password">初期パスワード *</label>
<input id="password" minlength="8" placeholder="初期パスワードを入力" required="" type="password"/>
</div>
<!-- 입사일 -->
<div class="register-field field-hiredate">
<label for="hiredate">入社日 *</label>
<input id="hiredate" required="" type="date"/>
</div>
<!-- 소속 부서 -->
<div class="register-field field-department">
<label for="departmentId">所属部署 *</label>
<select id="departmentId" required="">
<option value="">部署を選択してください</option>
<option value="1">経営支援チーム</option>
<option value="2">開発チーム</option>
<option value="3">営業チーム</option>
</select>
</div>
<!-- 직급 -->
<div class="register-field field-job">
<label for="jobId">役職 *</label>
<select id="jobId" required="">
<option value="">役職を選択してください</option>
<option value="1">社員</option>
<option value="2">主任</option>
<option value="3">課長</option>
<option value="4">次長</option>
<option value="5">部長</option>
</select>
</div>
</div>
<!-- 버튼 -->
<div class="register-actions">
<a class="employee-register-btn btn-outline" href="${pageContext.request.contextPath}/employees">
                            キャンセル
                        </a>
<button class="employee-register-btn btn-primary-custom" id="registerBtn" type="submit">
                            社員登録
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
                        キャンセル
                    </button>
<button class="btn btn-primary flex-fill" id="popupAction" type="button">
                        確認
                    </button>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeeregister.js?v=ja-1"></script>
</body></html>
