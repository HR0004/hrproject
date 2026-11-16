
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HRMS - 給与登録</title>






<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salary.css?v=ja-1">
</head>

<body class="hold-transition hrms-adminlte hrms-salary" data-context-path="${pageContext.request.contextPath}">

	<div class="wrapper">

		<%@ include file="/WEB-INF/views/common/adminlte-header.jspf"%>
		<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf"%>

		<div class="content-wrapper">
<main class="salary-page hrms-page-content">

			<section class="content-header">
				<div class="container-fluid salary-heading">
					<h1 class="hrms-page-title">給与登録</h1>
					<p class="page-path">支給対象と金額を入力し、給与明細を確認してください。</p>
				</div>
			</section>

			<section class="content">
				<div class="container-fluid">

					<div class="salary-notice">社員と支給年月を選択すると、給与の登録状況を確認できます。</div>


					<c:if test="${not empty errorMessage}">
						<div class="salary-alert salary-alert-error">
							<c:out value="${errorMessage}" />
						</div>


						<a
							href="${pageContext.request.contextPath}/salary/list?salaryYearMonth=${salaryCreateRequest.salaryYearMonth}&amp;employeeKeyword=${salaryCreateRequest.empId}"
							class="salary-cancel-btn"> 登録済みの給与を表示 </a>

					</c:if>


					<form id="salaryCreateForm" method="post"
						action="${pageContext.request.contextPath}/salary/create">

						<c:if test="${not empty _csrf}">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}">
						</c:if>

						<div class="salary-form-card content-card">

							<h2>給与情報</h2>

							<div class="salary-form-grid">

								<!-- 대상 사원 -->
								<div class="salary-field">
									<label for="empId">対象社員 *</label> <select id="empId"
										name="empId" class="salary-form-input" required>

										<option value="">社員を選択してください</option>

										<c:forEach var="emp" items="${salaryEmployees}">

											<option value="${emp.empId}"
												<c:if test="${salaryCreateRequest.empId == emp.empId}">
                                                selected
                                            </c:if>>
												<c:out value="${emp.empId}" /> -
												<c:out value="${emp.employeeName}" />
											</option>

										</c:forEach>
									</select>
								</div>

								<!-- 지급 연월 -->
								<div class="salary-field">
									<label for="salaryYearMonth">支給年月 *</label> <input
										type="month" id="salaryYearMonth" name="salaryYearMonth"
										class="salary-form-input"
										value="<c:out value='${salaryCreateRequest.salaryYearMonth}'/>"
										required>
								</div>

								<!-- 기본급 -->
								<div class="salary-field">
									<label for="baseSalary">基本給 *</label> <input type="number"
										id="baseSalary" name="baseSalary" class="salary-form-input"
										min="0" max="999999999999999" step="1" placeholder="基本給を入力"
										value="<c:out value='${salaryCreateRequest.baseSalary}'/>"
										required> <small>ウォン単位で入力します。</small>
								</div>

								<!-- 수당 -->
								<div class="salary-field">
									<label for="bonus">手当 *</label> <input type="number" id="bonus"
										name="bonus" class="salary-form-input" min="0"
										max="999999999999999" step="1"
										value="<c:out value='${salaryCreateRequest.bonus}'/>" required>

									<small>手当がない場合は 0ウォンを入力してください。</small>
								</div>

								<!-- 공제액 -->
								<div class="salary-field">
									<label for="deduction">控除額 *</label> <input type="number"
										id="deduction" name="deduction" class="salary-form-input"
										min="0" max="999999999999999" step="1"
										value="<c:out value='${salaryCreateRequest.deduction}'/>"
										required> <small>控除がない場合は 0ウォンを入力してください。</small>
								</div>

								<!-- 지급일 -->
								<div class="salary-field">
									<label for="paymentDate">支給日</label> <input type="date"
										id="paymentDate" name="paymentDate" class="salary-form-input"
										value="<c:out value='${salaryCreateRequest.paymentDate}'/>">

									<small>未定の場合は空欄にできます。</small>
								</div>

							</div>

							<div class="salary-preview">
								<div>
									<span>手取り額の見込み</span> <small>基本給 + 手当 - 控除額</small>
								</div>
								<strong id="netSalaryPreview">0ウォン</strong>
							</div>

							<p id="salaryValidationMessage" class="salary-validation-message"
								role="alert"></p>

						</div>

						<div class="salary-form-actions">
							<a href="${pageContext.request.contextPath}/salary/list"
								class="salary-cancel-btn">キャンセル</a>

							<button type="button" id="salaryReviewBtn"
								class="salary-confirm-btn primary-btn">給与の確認</button>
						</div>

					</form>

				</div>
			</section>
		</main>
</div>
	</div>

	<!-- 최종 등록 확인 팝업 -->
	<div id="salaryModal" class="salary-modal-overlay" hidden>

		<div class="salary-modal" role="dialog" aria-modal="true"
			aria-labelledby="salaryModalTitle">

			<span class="salary-modal-badge">最終確認</span>

			<h2 id="salaryModalTitle">給与を登録しますか？</h2>
			<p>以下の計算結果と支給情報を確認してください。</p>

			<div class="salary-modal-summary">
				<div>
					<span>対象社員</span><strong id="reviewEmployee"></strong>
				</div>
				<div>
					<span>支給年月</span><strong id="reviewMonth"></strong>
				</div>
				<div>
					<span>基本給</span><strong id="reviewBase"></strong>
				</div>
				<div>
					<span>手当</span><strong id="reviewBonus"></strong>
				</div>
				<div>
					<span>控除額</span><strong id="reviewDeduction"></strong>
				</div>
				<div>
					<span>支給日</span><strong id="reviewDate"></strong>
				</div>
			</div>

			<div class="salary-modal-total">
				<span>手取り額</span> <strong id="reviewNet"></strong>
			</div>

			<div class="salary-modal-actions">
				<button type="button" id="salaryBackBtn" class="salary-cancel-btn">戻る</button>

				<button type="button" id="salarySubmitBtn"
					class="salary-confirm-btn primary-btn">登録を確定</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
	
	

	<script>
const salaryForm = document.getElementById("salaryCreateForm");
const salaryModal = document.getElementById("salaryModal");
const validationMessage = document.getElementById("salaryValidationMessage");

const baseInput = document.getElementById("baseSalary");
const bonusInput = document.getElementById("bonus");
const deductionInput = document.getElementById("deduction");

const money = value => Number(value).toLocaleString("ja-JP") + "ウォン";

function getAmount(input) {
    return input.value.trim() === "" ? NaN : Number(input.value);
}

function calculateNet() {
    const base = getAmount(baseInput);
    const bonus = getAmount(bonusInput);
    const deduction = getAmount(deductionInput);

    if (![base, bonus, deduction].every(Number.isSafeInteger) ||
        [base, bonus, deduction].some(v => v < 0 || v > 999999999999999)) {
        return null;
    }

    const net = base + bonus - deduction;
    return Number.isSafeInteger(net) &&
           Math.abs(net) <= 999999999999999 ? net : null;
}

function updatePreview() {
    const net = calculateNet();

    document.getElementById("netSalaryPreview").textContent =
        net === null ? "入力内容の確認が必要です" : money(net);
}

[baseInput, bonusInput, deductionInput].forEach(input => {
    input.addEventListener("input", updatePreview);
});

document.getElementById("salaryReviewBtn").addEventListener("click", () => {

    validationMessage.textContent = "";

    if (!salaryForm.reportValidity()) {
        return;
    }

    const net = calculateNet();

    if (net === null) {
        validationMessage.textContent =
            "金額は 0 以上の 15桁以内の整数で入力し、 計算結果も確認してください。";
        return;
    }

    const employeeSelect = document.getElementById("empId");

    document.getElementById("reviewEmployee").textContent =
        employeeSelect.options[employeeSelect.selectedIndex].text.trim();

    document.getElementById("reviewMonth").textContent =
        document.getElementById("salaryYearMonth").value;

    document.getElementById("reviewBase").textContent =
        money(getAmount(baseInput));

    document.getElementById("reviewBonus").textContent =
        money(getAmount(bonusInput));

    document.getElementById("reviewDeduction").textContent =
        money(getAmount(deductionInput));

    document.getElementById("reviewDate").textContent =
        document.getElementById("paymentDate").value || "未定";

    document.getElementById("reviewNet").textContent = money(net);

    salaryModal.hidden = false;
});

document.getElementById("salaryBackBtn").addEventListener("click", () => {
    salaryModal.hidden = true;
});

document.getElementById("salarySubmitBtn").addEventListener("click", event => {

    if (!salaryForm.reportValidity() || calculateNet() === null) {
        salaryModal.hidden = true;
        return;
    }

    event.currentTarget.disabled = true;
    event.currentTarget.textContent = "登録中。..";

    salaryForm.submit();
});

updatePreview();
</script>

</body>
</html>
