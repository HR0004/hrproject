
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>HRMS - 給与エラー</title>

    

    
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salary.css?v=ja-1">
</head>

<body class="hold-transition hrms-adminlte hrms-salary" data-context-path="${pageContext.request.contextPath}">

<div class="wrapper">

    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>

    <div class="content-wrapper">
<main class="salary-page hrms-page-content">

        <section class="content">
            <div class="container-fluid">

                <div class="salary-error-container content-card">

                    <div class="salary-error-icon">!</div>

                    <h1 class="hrms-page-title">給与情報を確認できません。</h1>

                    <p class="page-path">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}"/>
                            </c:when>
                            <c:otherwise>
                                指定された給与情報を処理できません。
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <a href="${pageContext.request.contextPath}<%= request.isUserInRole("HR_ADMIN") ? "/salary/list" : "/salary/my" %>"
                       class="salary-confirm-btn primary-btn">
                        給与一覧に戻る
                    </a>

                </div>

            </div>
        </section>

    </main>
</div>
</div>

<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>



</body>
</html>
