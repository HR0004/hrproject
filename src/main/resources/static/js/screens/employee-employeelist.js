const contextPath = (document.body.getAttribute("data-context-path") || "");

/* 사원 등록 */
function registerEmployee() {
    location.href = contextPath + "/employees/new";
}

/* 사원 상세 */
function viewEmployee(empId) {
    location.href = contextPath + "/employees/" +
        encodeURIComponent(empId);
}

/* 사원 목록 조회 */
async function loadEmployees(page = 1) {
    try {
        const response = await fetch(
            contextPath + "/api/employees/page?currentPage=" + page
        );

        if (!response.ok) {
            throw new Error("사원 목록 조회 실패");
        }

        const pager = await response.json();

        printEmployees(pager.list || []);
        printPagination(pager);

    } catch (error) {
        console.error("사원 목록 조회 오류:", error);

        document.getElementById("employeeTableBody").innerHTML = "";
        document.getElementById("employeePagination").innerHTML = "";

        const empty = document.getElementById("employeeEmpty");
        empty.textContent = "사원 목록을 불러오지 못했습니다.";
        empty.style.display = "block";
    }
}

/* 사원 목록 출력 */
function printEmployees(employees) {
    const tbody = $("#employeeTableBody").empty();
    const empty = document.getElementById("employeeEmpty");

    empty.textContent = "등록된 사원이 없습니다.";
    empty.style.display = employees.length === 0 ? "block" : "none";

    employees.forEach(emp => {
        const url = contextPath + "/employees/" + emp.empId;

        const status = {
            ACTIVE: ["재직", "status-active"],
            LEAVE: ["휴직", "status-leave"],
            RETIRED: ["퇴직", "status-retired"]
        }[emp.status] || ["미확인", ""];

        const tr = $("<tr>");

        $("<td>").text(emp.empId).appendTo(tr);

        $("<td>").append(
            $("<a>")
                .addClass("employee-name")
                .attr("href", url)
                .text(emp.ename)
        ).appendTo(tr);

        [
            emp.department?.departmentName ?? "-",
            emp.job?.jobName ?? "-",
            emp.email ?? "-",
            emp.hiredate
                ? new Date(emp.hiredate).toLocaleDateString("ko-KR")
                : "-"
        ].forEach(value => {
            $("<td>").text(value).appendTo(tr);
        });

        $("<td>").append(
            $("<span>")
                .addClass("employee-status " + status[1])
                .text(status[0])
        ).appendTo(tr);

        $("<td>").append(
            $("<a>")
                .addClass("employee-action-link")
                .attr("href", url)
                .text("상세"),
            " / ",
            $("<a>")
                .addClass("employee-action-link")
                .attr("href", url + "/edit")
                .text("수정")
        ).appendTo(tr);

        tbody.append(tr);
    });
}

/* 페이지네이션 */
function printPagination(pager) {
    const pagination =
        document.getElementById("employeePagination");

    pagination.innerHTML = "";

    if (!pager.totalPage) return;

    const addButton = (text, page, disabled = false, active = false) => {
        const btn = document.createElement("button");

        btn.type = "button";
        btn.textContent = text;
        btn.disabled = disabled;

        btn.className = active
            ? "employee-page-btn active"
            : "employee-page-btn";

        btn.addEventListener("click", () => loadEmployees(page));

        pagination.appendChild(btn);
    };

    addButton("‹", pager.firstPage - 1, pager.firstPage <= 1);

    for (let i = pager.firstPage; i <= pager.lastPage; i++) {
        addButton(i, i, false, i === pager.currentPage);
    }

    addButton("›", pager.lastPage + 1,
              pager.lastPage >= pager.totalPage);
}

/* 전체 사원 통계 */
async function loadEmployeeStats() {
    try {
        const response = await fetch(contextPath + "/api/employees");

        if (!response.ok) {
            throw new Error("통계 조회 실패");
        }

        const employees = await response.json();

        $("#totalCount").text(employees.length);
        $("#activeCount").text(
            employees.filter(emp => emp.status === "ACTIVE").length
        );
        $("#leaveCount").text(
            employees.filter(emp => emp.status === "LEAVE").length
        );
        $("#retiredCount").text(
            employees.filter(emp => emp.status === "RETIRED").length
        );

    } catch (error) {
        console.error("사원 통계 오류:", error);
    }
}

/* 페이지 초기화 */
document.addEventListener("DOMContentLoaded", () => {
    loadEmployees(1);
    loadEmployeeStats();
});
