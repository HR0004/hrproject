
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRMS - 給与明細</title>

    

    

    
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

        <section class="content-header">
            <div class="container-fluid salary-heading">
                <h1 class="hrms-page-title">給与明細</h1>
                <p class="page-path">
                    <c:out value="${salary.salaryYearMonth}"/>
                    給与の支給明細です。
                </p>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- 등록 성공 후 표시 -->
                <c:if test="${param.created eq 'true'}">
                    <div class="salary-success-alert">
                        給与を登録しました。
                    </div>
                </c:if>

                <!-- 급여 상세 카드 -->
                <div class="salary-detail-card content-card">

                    <div class="salary-detail-header">
                        <h2>
                            <c:out value="${salary.salaryYearMonth}"/>
                            給与
                        </h2>

                        <p>
                            給与 ID S<c:out value="${salary.salaryId}"/>
                            ・
                            <c:out value="${salary.empId}"/>
                            <c:out value="${salary.employeeName}"/>
                        </p>
                    </div>

                    <div class="salary-detail-rows">

                        <div class="salary-detail-row">
                            <span>基本給</span>
                            <strong>
                                <fmt:formatNumber
                                    value="${salary.baseSalary}"
                                    pattern="#,##0"/> ウォン
                            </strong>
                        </div>

                        <div class="salary-detail-row">
                            <span>手当</span>
                            <strong>
                                <fmt:formatNumber
                                    value="${salary.bonus}"
                                    pattern="#,##0"/> ウォン
                            </strong>
                        </div>

                        <div class="salary-detail-row">
                            <span>控除額</span>
                            <strong>
                                <fmt:formatNumber
                                    value="${salary.deduction}"
                                    pattern="#,##0"/> ウォン
                            </strong>
                        </div>

                    </div>

                    <!-- 실수령액 -->
                    <div class="salary-detail-total">
                        <span>手取り額</span>
                        <strong>
                            <fmt:formatNumber
                                value="${salary.netSalary}"
                                pattern="#,##0"/> ウォン
                        </strong>
                    </div>

                    <!-- 지급일 -->
                    <div class="salary-detail-payment">
                        <span>支給日</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty salary.paymentDate}">
                                    <c:out value="${salary.paymentDate}"/>
                                </c:when>
                                <c:otherwise>未定</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                </div>

                <!-- 하단 버튼 -->
                <div class="salary-detail-actions">
                    <a href="${pageContext.request.contextPath}/salary/list"
                       class="salary-confirm-btn primary-btn">
                        一覧へ
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
