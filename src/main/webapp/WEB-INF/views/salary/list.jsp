
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRMS - 給与管理</title>

    <!-- Font Awesome -->
    

    <!-- AdminLTE -->
    

<!-- css -->

    
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salary.css?v=ja-1">
</head>

<body class="hold-transition hrms-adminlte hrms-salary" data-context-path="${pageContext.request.contextPath}">

<div class="wrapper">

    <!-- 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>

    <!-- 공통 사이드바 -->
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>

    <div class="content-wrapper">
<main class="salary-page hrms-page-content">

        <!-- 페이지 제목 -->
        <section class="content-header">
            <div class="container-fluid">
                <div class="salary-heading">
                    <h1 class="hrms-page-title">給与管理</h1>
                    <p class="page-path">社員別の月次給与を検索・管理できます。</p>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- 통계 카드 -->
                <div class="salary-stats">

                    <div class="salary-stat-card summary-card">
                        <span>給与対象者</span>
                        <strong id="salaryEmployeeCount">0名</strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>支給予定</span>
                        <strong id="salaryRecordCount">0件</strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>給与総額</span>
                        <strong id="salaryTotalAmount">0ウォン</strong>
                    </div>

                    <div class="salary-stat-card summary-card">
                        <span>検索年月</span>
                        <strong id="salaryMonthInfo">すべて</strong>
                    </div>

                </div>

                <!-- 급여 목록 툴바 -->
                <div class="salary-toolbar">

                    <div class="salary-toolbar-title">
                        <h2>給与一覧</h2>
                        <p>検索範囲 ・ 閲覧権限のある社員</p>
                    </div>

                    <!-- 기존 SalaryController.list()와 연결 -->
                    <form id="salarySearchForm"
                          method="get"
                          action="${pageContext.request.contextPath}/salary/list"
                          class="salary-search-form">

                        <!-- 지급 연월 -->
                        <input type="month"
                               id="salaryYearMonth"
                               name="salaryYearMonth"
                               value="<c:out value='${salaryYearMonth}'/>"
                               aria-label="支給年月"
                               class="salary-input salary-month-input">

                        <!-- 사번 / 사원명 -->
                        <input type="text"
                               id="employeeKeyword"
                               name="employeeKeyword"
                               value="<c:out value='${employeeKeyword}'/>"
                               placeholder="社員番号 / 社員名で検索"
                               aria-label="社員番号または社員名"
                               maxlength="50"
                               class="salary-input salary-keyword-input">

                        <button type="submit"
                                class="salary-search-btn">
                            <i class="fas fa-search"></i>
                            検索
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/salary/my" class="salary-cancel-btn">自分の給与を表示</a>
                    <!-- 급여 등록 -->
                    <a href="${pageContext.request.contextPath}/salary/create"
                       class="salary-register-btn primary-btn">
                        + 給与登録
                    </a>

                </div>

                <!-- 검색 오류 -->
                <c:if test="${not empty salarySearchError}">
                    <div class="salary-alert salary-alert-error">
                        <c:out value="${salarySearchError}"/>
                    </div>
                </c:if>

                <!-- 급여 테이블 -->
                <div class="salary-table-wrap">

                    <table class="salary-table" id="salaryTable">

                        <thead>
                            <tr>
                                <th>給与 ID</th>
                                <th>社員</th>
                                <th>支給年月</th>
                                <th>基本給</th>
                                <th>手当</th>
                                <th>控除額</th>
                                <th>手取り額</th>
                            </tr>
                        </thead>

                        <tbody id="salaryTableBody">

                            <c:forEach var="salary" items="${salaries}">
                                <tr class="salary-data-row"
                                    data-emp-id="${salary.empId}"
                                    data-net-salary="${salary.netSalary}">

                                    <!-- 급여 ID -->
                                    <td>
                                        <a class="salary-detail-link"
                                           href="${pageContext.request.contextPath}/salary/detail/${salary.salaryId}">
                                            S<c:out value="${salary.salaryId}"/>
                                        </a>
                                    </td>

                                    <!-- 사원 -->
                                    <td>
                                        <c:out value="${salary.empId}"/>
                                        <c:out value="${salary.employeeName}"/>
                                    </td>

                                    <!-- 지급 연월 -->
                                    <td>
                                        <c:out value="${salary.salaryYearMonth}"/>
                                    </td>

                                    <!-- 기본급 -->
                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.baseSalary}"
                                            pattern="#,##0"/>
                                    </td>

                                    <!-- 수당 -->
                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.bonus}"
                                            pattern="#,##0"/>
                                    </td>

                                    <!-- 공제액 -->
                                    <td>
                                        <fmt:formatNumber
                                            value="${salary.deduction}"
                                            pattern="#,##0"/>
                                    </td>

                                    <!-- 실수령액 -->
                                    <td class="salary-net">
                                        <fmt:formatNumber
                                            value="${salary.netSalary}"
                                            pattern="#,##0"/>
                                    </td>

                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>

                    <!-- 조회 결과 없음 -->
                    <div id="salaryEmpty"
                         class="salary-empty"
                         style="display:none;">
                        該当する給与履歴がありません。
                    </div>

                </div>

                <p class="salary-table-notice">
                    給与 IDを選択すると詳細画面に移動します。
                </p>

                <!-- 페이지 처리 -->
                <div class="salary-pagination-area">

                    <span id="salaryCountInfo">合計 0件</span>

                    <div id="salaryPagination"
                         class="salary-pagination">
                    </div>

                </div>

            </div>
        </section>
    </main>
</div>
</div>

<!-- jQuery -->
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>

<!-- Bootstrap -->


<!-- AdminLTE -->


<script>

// ==========================================
// 1. 給与一覧のページ処理
// ==========================================

const salaryRows = Array.from(
    document.querySelectorAll(".salary-data-row")
);

const salaryPageSize = 10;
let salaryCurrentPage = 1;

function showSalaryPage(page) {

    const totalCount = salaryRows.length;
    const totalPages = Math.ceil(totalCount / salaryPageSize);

    if (totalPages === 0) {
        salaryCurrentPage = 1;
    } else {
        salaryCurrentPage = Math.max(
            1, Math.min(page, totalPages)
        );
    }

    const startIndex =
        (salaryCurrentPage - 1) * salaryPageSize;

    const endIndex = startIndex + salaryPageSize;

    salaryRows.forEach((row, index) => {
        row.style.display =
            index >= startIndex && index < endIndex
                ? ""
                : "none";
    });

    document.getElementById("salaryEmpty").style.display =
        totalCount === 0 ? "block" : "none";

    document.getElementById("salaryCountInfo").textContent =
        "合計 " + totalCount + "件";

    printSalaryPagination(totalPages);
}


// ==========================================
// 2. ページ番号を表示
// ==========================================

function printSalaryPagination(totalPages) {

    const pagination =
        document.getElementById("salaryPagination");

    pagination.innerHTML = "";

    if (totalPages === 0) {
        return;
    }

    function addButton(label, page, disabled, active) {

        const button = document.createElement("button");

        button.type = "button";
        button.textContent = label;
        button.disabled = disabled;

        button.className = active
            ? "salary-page-btn active"
            : "salary-page-btn";

        button.addEventListener("click", () => {
            showSalaryPage(page);
        });

        pagination.appendChild(button);
    }

    // 前のページ
    addButton(
        "‹",
        salaryCurrentPage - 1,
        salaryCurrentPage === 1,
        false
    );

    // ページ番号
    for (let i = 1; i <= totalPages; i++) {
        addButton(
            i,
            i,
            false,
            i === salaryCurrentPage
        );
    }

    // 次のページ
    addButton(
        "›",
        salaryCurrentPage + 1,
        salaryCurrentPage === totalPages,
        false
    );
}


// ==========================================
// 3. 給与統計を表示
// ==========================================

function printSalaryStats() {

    // 現在の検索結果に基づく給与データ
    const uniqueEmployees = new Set();
    let totalAmount = 0;

    salaryRows.forEach(row => {

        uniqueEmployees.add(row.dataset.empId);

        totalAmount += Number(
            row.dataset.netSalary || 0
        );
    });

    document.getElementById("salaryEmployeeCount").textContent =
        uniqueEmployees.size + "名";

    document.getElementById("salaryRecordCount").textContent =
        salaryRows.length + "件";

    document.getElementById("salaryTotalAmount").textContent =
        totalAmount.toLocaleString("ja-JP") + "ウォン";

    const month =
        document.getElementById("salaryYearMonth").value;

    document.getElementById("salaryMonthInfo").textContent =
        month || "すべて";
}


// ==========================================
// 4. 画面を初期化
// ==========================================

document.addEventListener("DOMContentLoaded", () => {

    printSalaryStats();
    showSalaryPage(1);

});

</script>

</body>
</html>
