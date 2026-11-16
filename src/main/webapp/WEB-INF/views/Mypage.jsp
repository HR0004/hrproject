<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.jsp.PageContext" %>
<%@ page import="javax.servlet.jsp.JspFactory" %>

<%!
    private String mypageText(PageContext context, String expression) {
        Object value = JspFactory.getDefaultFactory()
            .getJspApplicationContext(context.getServletContext())
            .getExpressionFactory()
            .createValueExpression(
                context.getELContext(),
                expression,
                Object.class
            )
            .getValue(context.getELContext());

        if (value == null) {
            return "";
        }

        return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 마이페이지</title>
<meta content="${_csrf.token}" name="_csrf"/>
<meta content="${_csrf.headerName}" name="_csrf_header"/>
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/mypage.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-mypage" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="hrms-page hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<h2 class="hrms-page-title">마이페이지</h2>
<p class="mypage-location">홈 &gt; 마이페이지</p>
</div>
</div>
<div class="profile-card">
<div class="profile-header">
<div class="profile-avatar">👤</div>
<div>
<h3 class="mypage-name">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.ename != null ? sessionScope.loginUser.emp.ename : '사용자'}"
                        ) %>님
                    </h3>
<span class="badge badge-primary">
                        <%= request.isUserInRole("HR_ADMIN")
                            ? "인사 관리자"
                            : "일반 사원" %>
                    </span>
</div>
</div>
<h4 class="mypage-info-title">내 정보</h4>
<div class="row">
<div class="col-md-6 info-group">
<div class="info-label">아이디</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.loginId}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">이름</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.ename}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">이메일</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.email != null ? sessionScope.loginUser.emp.email : 'admin@hrms.com'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">연락처</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.phone != null ? sessionScope.loginUser.emp.phone : '010-1234-5678'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">입사일</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.hiredate != null ? sessionScope.loginUser.emp.hiredate : '2024-01-01'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">최종 로그인</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.lastLoginAt != null ? sessionScope.loginUser.lastLoginAt : '방금 전'}"
                        ) %>
                    </div>
</div>
</div>
</div>
<section aria-labelledby="password-title" class="profile-card password-card">
<h3 class="password-title" id="password-title">
                비밀번호 변경
            </h3>
<p class="password-note">
                현재 비밀번호를 확인한 후 새 비밀번호로 변경합니다.
            </p>
<div aria-live="polite" class="password-message" hidden="" id="password-message" role="status"></div>
<form action="${pageContext.request.contextPath}/api/accounts/me/password" class="password-form" id="password-form" method="post">
<div class="form-group">
<label for="current-password">현재 비밀번호</label>
<input autocomplete="current-password" class="form-control" id="current-password" name="currentPassword" required="" type="password"/>
</div>
<div class="form-group">
<label for="new-password">새 비밀번호</label>
<input aria-describedby="password-help" autocomplete="new-password" class="form-control" id="new-password" minlength="8" name="newPassword" required="" type="password"/>
<p class="password-help" id="password-help">
                        8자 이상으로 입력해 주세요.
                    </p>
</div>
<div class="form-group">
<label for="confirm-password">새 비밀번호 확인</label>
<input autocomplete="new-password" class="form-control" id="confirm-password" minlength="8" name="newPasswordConfirm" required="" type="password"/>
</div>
<button class="password-submit" id="password-submit" type="submit">
                    비밀번호 변경
                </button>
</form>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/mypage.js?v=1"></script>
</body></html>
