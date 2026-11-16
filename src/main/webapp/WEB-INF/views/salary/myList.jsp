
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>HRMS - 自分の給与を表示</title>

    

    
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
                <h1 class="hrms-page-title">自分の給与を表示</h1>
                <p class="page-path">ご自身の月別給与と支給履歴を確認できます。</p>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- 최근 급여 요약 -->
                <div class="salary-stats">

                    <div class="salary-stat-card summary-card">
                        <span>選択年月</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty latestSalary}">
                                    <c:out value="${latestSalary.salaryYearMonth}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>基本給</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty latestSalary}">
                                    <fmt:formatNumber
                                        value="${latestSalary.baseSalary}"
                                        pattern="#,##0"/>ウォン
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>手取り額</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty latestSalary}">
                                    <fmt:formatNumber
                                        value="${latestSalary.netSalary}"
                                        pattern="#,##0"/>ウォン
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>支給日</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty latestSalary}">
                                    <c:out value="${latestSalary.paymentDate}"
                                           default="未定"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                </div>

                <!-- 목록 제목 및 연도 검색 -->
                <div class="salary-toolbar">

                    <div class="salary-toolbar-title">
                        <h2>自分の給与一覧</h2>
                        <p>
                            社員番号 <c:out value="${empId}"/> ・ 自分の給与
                        </p>
                    </div>

                    <form method="get"
                          action="${pageContext.request.contextPath}/salary/my"
                          class="salary-search-form">

                        <select name="year"
                                class="salary-input salary-month-input">

                            <option value="">年を選択</option>

                            <c:forEach var="yearOption" items="${years}">
                                <option value="${yearOption}"
                                    <c:if test="${searchYear eq yearOption.toString()}">
                                        selected
                                    </c:if>>
                                    <c:out value="${yearOption}"/>年の全月
                                </option>
                            </c:forEach>

                        </select>

                        <button type="submit"
                                class="salary-register-btn primary-btn">
                            検索
                        </button>
                    </form>

                </div>

                <!-- 본인 급여 목록 -->
                <div class="salary-table-wrap">

                    <table class="salary-table salary-my-table">

                        <thead>
                            <tr>
                                <th>支給年月</th>
                                <th>基本給</th>
                                <th>手当</th>
                                <th>控除額</th>
                                <th>手取り額</th>
                                <th>支給日</th>
                            </tr>
                        </thead>

                        <tbody id="mySalaryTableBody">

                            <c:forEach var="salary" items="${salaries}">
                                <tr class="my-salary-row">

                                    <td>
                                        <a class="salary-detail-link"
                                           href="${pageContext.request.contextPath}/salary/my/detail/${salary.salaryId}">
                                            <c:out value="${salary.salaryYearMonth}"/>
                                        </a>
                                    </td>

                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.baseSalary}"
                                            pattern="#,##0"/>
                                    </td>

                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.bonus}"
                                            pattern="#,##0"/>
                                    </td>

                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.deduction}"
                                            pattern="#,##0"/>
                                    </td>

                                    <td class="salary-net">
                                        <fmt:formatNumber
                                            value="${salary.netSalary}"
                                            pattern="#,##0"/>
                                    </td>

                                    <td>
                                        <c:out value="${salary.paymentDate}"
                                               default="未定"/>
                                    </td>

                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>

                    <c:if test="${empty salaries}">
                        <div class="salary-empty">
                            該当する給与履歴がありません。
                        </div>
                    </c:if>

                </div>

                <p class="salary-table-notice">
                    支給年月を選択すると詳細画面に移動します。
                </p>

                <!-- 페이지 처리 -->
                <div class="salary-pagination-area">

                    <span id="mySalaryCount">
                        合計 <c:out value="${salaries.size()}"/>件
                    </span>

                    <div id="mySalaryPagination"
                         class="salary-pagination">
                    </div>

                </div>

            </div>
        </section>

    </main>
</div>
</div>

<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>



<script>
const mySalaryRows = Array.from(
    document.querySelectorAll(".my-salary-row")
);

const mySalaryPageSize = 10;
let mySalaryCurrentPage = 1;

function showMySalaryPage(page) {
    const totalPages =
        Math.ceil(mySalaryRows.length / mySalaryPageSize);

    mySalaryCurrentPage = page;

    const start = (page - 1) * mySalaryPageSize;

    mySalaryRows.forEach((row, index) => {
        row.style.display =
            index >= start && index < start + mySalaryPageSize
                ? ""
                : "none";
    });

    const pagination =
        document.getElementById("mySalaryPagination");

    pagination.innerHTML = "";

    if (totalPages <= 1) return;

    function addButton(text, target, disabled, active) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.textContent = text;
        btn.className =
            "salary-page-btn" + (active ? " active" : "");
        btn.disabled = disabled;

        btn.addEventListener("click", () => {
            showMySalaryPage(target);
        });

        pagination.appendChild(btn);
    }

    addButton("‹", page - 1, page === 1, false);

    for (let i = 1; i <= totalPages; i++) {
        addButton(i, i, false, i === page);
    }

    addButton("›", page + 1,
              page === totalPages, false);
}

showMySalaryPage(1);
</script>

</body>
</html>
