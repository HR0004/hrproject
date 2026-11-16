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
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - マイページ</title>
<meta content="${_csrf.token}" name="_csrf"/>
<meta content="${_csrf.headerName}" name="_csrf_header"/>
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/mypage.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-mypage" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="hrms-page hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<h2 class="hrms-page-title">マイページ</h2>
<p class="mypage-location">ホーム &gt; マイページ</p>
</div>
</div>
<div class="profile-card">
<div class="profile-header">
<div class="profile-avatar">👤</div>
<div>
<h3 class="mypage-name">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.ename != null ? sessionScope.loginUser.emp.ename : 'ユーザー'}"
                        ) %>さん
                    </h3>
<span class="badge badge-primary">
                        <%= request.isUserInRole("HR_ADMIN")
                            ? "人事管理者"
                            : "一般社員" %>
                    </span>
</div>
</div>
<h4 class="mypage-info-title">プロフィール</h4>
<div class="row">
<div class="col-md-6 info-group">
<div class="info-label">ID</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.loginId}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">氏名</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.ename}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">メールアドレス</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.email != null ? sessionScope.loginUser.emp.email : 'admin@hrms.com'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">電話番号</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.phone != null ? sessionScope.loginUser.emp.phone : '010-1234-5678'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">入社日</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.emp.hiredate != null ? sessionScope.loginUser.emp.hiredate : '2024-01-01'}"
                        ) %>
                    </div>
</div>
<div class="col-md-6 info-group">
<div class="info-label">最終ログイン</div>
<div class="info-value">
                        <%= mypageText(
                            pageContext,
                            "${sessionScope.loginUser.lastLoginAt != null ? sessionScope.loginUser.lastLoginAt : 'たった今'}"
                        ) %>
                    </div>
</div>
</div>
</div>
<section aria-labelledby="password-title" class="profile-card password-card">
<h3 class="password-title" id="password-title">
                パスワード変更
            </h3>
<p class="password-note">
                現在のパスワードを確認してから新しいパスワードに変更します。
            </p>
<div aria-live="polite" class="password-message" hidden="" id="password-message" role="status"></div>
<form action="${pageContext.request.contextPath}/api/accounts/me/password" class="password-form" id="password-form" method="post">
<div class="form-group">
<label for="current-password">現在のパスワード</label>
<input autocomplete="current-password" class="form-control" id="current-password" name="currentPassword" required="" type="password"/>
</div>
<div class="form-group">
<label for="new-password">新しいパスワード</label>
<input aria-describedby="password-help" autocomplete="new-password" class="form-control" id="new-password" minlength="8" name="newPassword" required="" type="password"/>
<p class="password-help" id="password-help">
                        8文字以上で入力してください。
                    </p>
</div>
<div class="form-group">
<label for="confirm-password">新しいパスワードの確認</label>
<input autocomplete="new-password" class="form-control" id="confirm-password" minlength="8" name="newPasswordConfirm" required="" type="password"/>
</div>
<button class="password-submit" id="password-submit" type="submit">
                    パスワード変更
                </button>
</form>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/mypage.js?v=ja-1"></script>
</body></html>
