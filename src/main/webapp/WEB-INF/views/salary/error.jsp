
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>HRMS - 급여 오류</title>

    

    
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salary.css?v=salary-unified-1">
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

                    <h1 class="hrms-page-title">급여 정보를 확인할 수 없습니다.</h1>

                    <p class="page-path">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}"/>
                            </c:when>
                            <c:otherwise>
                                요청하신 급여 정보를 처리할 수 없습니다.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <a href="${pageContext.request.contextPath}<%= request.isUserInRole("HR_ADMIN") ? "/salary/list" : "/salary/my" %>"
                       class="salary-confirm-btn primary-btn">
                        급여 목록으로 돌아가기
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
