
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 내 정보 수정</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeemyedit.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeemyedit myedit-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="myedit-content hrms-page-content"><span class="sr-only" id="loginUser"></span>
<div class="myedit-heading">
<h1 class="hrms-page-title">내 정보 수정</h1>
<p>본인의 연락처와 이메일을 직접 수정할 수 있습니다.</p>
</div>
<!-- 안내 메시지 -->
<div class="myedit-notice">
<strong>ⓘ 회색 입력란은 수정할 수 없는 인사 정보입니다.</strong>
<p>
                    성명·부서·직급·입사일 등 변경이 필요한 경우
                    인사 담당자에게 문의하세요.
                </p>
</div>
<form id="myInfoEditForm" novalidate="">
<!-- 기본 정보 카드 -->
<section class="myedit-card">
<div class="myedit-card-heading">
<h2>기본 정보</h2>
<span class="myedit-status" id="statusBadge">
                            조회 전
                        </span>
</div>
<!-- 읽기 전용 정보 -->
<div class="myedit-grid">
<div class="myedit-field">
<label for="empId">사번 (변경 불가)</label>
<input id="empId" placeholder="사번" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="ename">성명 (변경 불가)</label>
<input id="ename" placeholder="성명" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="departmentName">부서 (변경 불가)</label>
<input id="departmentName" placeholder="부서" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="jobName">직급 (변경 불가)</label>
<input id="jobName" placeholder="직급" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="hiredate">입사일 (변경 불가)</label>
<input id="hiredate" placeholder="입사일" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
<div class="myedit-field">
<label for="status">재직 상태 (변경 불가)</label>
<input id="status" placeholder="재직 상태" readonly="" type="text"/>
<span class="myedit-lock">🔒</span>
</div>
</div>
<hr class="myedit-divider"/>
<!-- 수정 가능한 정보 -->
<h2 class="myedit-section-title">수정 가능한 정보</h2>
<div class="myedit-grid">
<div class="myedit-field">
<label for="email">이메일 *</label>
<input autocomplete="email" id="email" maxlength="40" name="email" placeholder="example@hrms.com" required="" type="email"/>
</div>
<div class="myedit-field">
<label for="phone">연락처</label>
<input autocomplete="tel" id="phone" maxlength="13" name="phone" placeholder="010-0000-0000" type="tel"/>
</div>
</div>
<p class="myedit-message" id="myEditMessage" role="status"></p>
</section>
<!-- 저장 영역 -->
<section class="myedit-actions">
<div class="myedit-actions-text">
<strong>저장 전 확인</strong>
<p>
                            이메일 형식과 연락처 입력값을 확인 후 저장하세요.
                            변경된 정보는 본인 계정에 반영됩니다.
                        </p>
</div>
<div class="myedit-buttons">
<button class="myedit-btn myedit-btn-outline" id="cancelMyEditBtn" type="button">
                            취소
                        </button>
<button class="myedit-btn myedit-btn-outline" id="passwordChangeBtn" type="button">
                            비밀번호 변경
                        </button>
<button class="myedit-btn myedit-btn-primary" id="saveMyInfoBtn" type="submit">
                            변경사항 저장
                        </button>
</div>
</section>
</form>
</main>
<div class="password-modal" id="passwordModal">
<div class="password-modal-content">
<div class="password-modal-header">
<h3>비밀번호 변경</h3>
<button id="closePasswordModal" type="button">×</button>
</div>
<p class="password-modal-description">
            계정 보안을 위해 현재 비밀번호를 확인해 주세요.
        </p>
<form id="passwordChangeForm">
<label for="currentPassword">현재 비밀번호</label>
<input autocomplete="current-password" id="currentPassword" required="" type="password"/>
<label for="newPassword">새 비밀번호</label>
<input autocomplete="new-password" id="newPassword" required="" type="password"/>
<label for="confirmPassword">새 비밀번호 확인</label>
<input autocomplete="new-password" id="confirmPassword" required="" type="password"/>
<p class="password-message" id="passwordMessage"></p>
<div class="password-modal-buttons">
<button class="myedit-btn myedit-btn-outline" id="cancelPasswordModal" type="button">
                    취소
                </button>
<button class="myedit-btn myedit-btn-primary" type="submit">
                    비밀번호 변경
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
                취소
            </button>
<button class="info-modal-primary" id="infoModalConfirm" type="button">
                확인
            </button>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeemyedit.js?v=1"></script>
</body></html>
