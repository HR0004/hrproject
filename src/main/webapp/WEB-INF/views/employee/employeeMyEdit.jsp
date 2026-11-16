
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - プロフィール編集</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeemyedit.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeemyedit myedit-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="myedit-content hrms-page-content"><span class="sr-only" id="loginUser"></span>
<div class="myedit-heading">
<h1 class="hrms-page-title">プロフィール編集</h1>
<p>ご自身の電話番号とメールアドレスを変更できます。</p>
</div>
<!-- 안내 메시지 -->
<div class="myedit-notice">
<strong>ⓘ グレーの入力欄は変更できない人事情報です。</strong>
<p>
                    氏名・部署・役職・入社日などの変更が必要な場合は
                    人事担当者にお問い合わせください。
                </p>
</div>
<form id="myInfoEditForm" novalidate="">
<!-- 기본 정보 카드 -->
<section class="myedit-card">
<div class="myedit-card-heading">
<h2>基本情報</h2>
<span class="myedit-status" id="statusBadge">
                            読み込み前
                        </span>
</div>
<!-- 읽기 전용 정보 -->
<div class="myedit-grid">
<div class="myedit-field">
<label for="empId">社員番号 (変更不可)</label>
<input id="empId" placeholder="社員番号" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="ename">氏名 (変更不可)</label>
<input id="ename" placeholder="氏名" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="departmentName">部署 (変更不可)</label>
<input id="departmentName" placeholder="部署" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="jobName">役職 (変更不可)</label>
<input id="jobName" placeholder="役職" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="hiredate">入社日 (変更不可)</label>
<input id="hiredate" placeholder="入社日" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="status">在籍状態 (変更不可)</label>
<input id="status" placeholder="在籍状態" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
</div>
<hr class="myedit-divider"/>
<!-- 수정 가능한 정보 -->
<h2 class="myedit-section-title">変更可能な情報</h2>
<div class="myedit-grid">
<div class="myedit-field">
<label for="email">メールアドレス *</label>
<input autocomplete="email" id="email" maxlength="40" name="email" placeholder="example@hrms.com" required="" type="email"/>
</div>
<div class="myedit-field">
<label for="phone">電話番号</label>
<input autocomplete="tel" id="phone" maxlength="13" name="phone" placeholder="010-0000-0000" type="tel"/>
</div>
</div>
<p class="myedit-message" id="myEditMessage" role="status"></p>
</section>
<!-- 저장 영역 -->
<section class="myedit-actions">
<div class="myedit-actions-text">
<strong>保存前の確認</strong>
<p>
                            メールアドレスの形式と電話番号を確認して保存してください。
                            変更した情報はご自身のアカウントに反映されます。
                        </p>
</div>
<div class="myedit-buttons">
<button class="myedit-btn myedit-btn-outline" id="cancelMyEditBtn" type="button">
                            キャンセル
                        </button>
<button class="myedit-btn myedit-btn-outline" id="passwordChangeBtn" type="button">
                            パスワード変更
                        </button>
<button class="myedit-btn myedit-btn-primary" id="saveMyInfoBtn" type="submit">
                            変更を保存
                        </button>
</div>
</section>
</form>
</main>
<div class="password-modal" id="passwordModal">
<div class="password-modal-content">
<div class="password-modal-header">
<h3>パスワード変更</h3>
<button id="closePasswordModal" type="button">×</button>
</div>
<p class="password-modal-description">
            アカウント保護のため、現在のパスワードを確認してください。
        </p>
<form id="passwordChangeForm">
<label for="currentPassword">現在のパスワード</label>
<input autocomplete="current-password" id="currentPassword" required="" type="password"/>
<label for="newPassword">新しいパスワード</label>
<input autocomplete="new-password" id="newPassword" required="" type="password"/>
<label for="confirmPassword">新しいパスワードの確認</label>
<input autocomplete="new-password" id="confirmPassword" required="" type="password"/>
<p class="password-message" id="passwordMessage"></p>
<div class="password-modal-buttons">
<button class="myedit-btn myedit-btn-outline" id="cancelPasswordModal" type="button">
                    キャンセル
                </button>
<button class="myedit-btn myedit-btn-primary" type="submit">
                    パスワード変更
                </button>
</div>
</form>
</div>
</div>
<div class="info-modal" id="myInfoModal">
<div class="info-modal-content">
<div class="info-modal-title">
<span class="info-modal-icon" id="infoModalIcon">?</span>
<h3 id="infoModalTitle"></h3>
</div>
<p id="infoModalMessage"></p>
<div class="info-modal-description" id="infoModalDescription"></div>
<div class="info-modal-buttons">
<button class="info-modal-secondary" id="infoModalCancel" type="button">
                キャンセル
            </button>
<button class="info-modal-primary" id="infoModalConfirm" type="button">
                確認
            </button>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeemyedit.js?v=ja-1"></script>
</body></html>
