const contextPath = (document.body.getAttribute("data-context-path") || "");

/* 부서 목록 불러오기 */
async function loadDepartments() {
    try {
        const response = await fetch(contextPath + "/api/departments");

        if (!response.ok) {
            throw new Error("部署一覧の取得に失敗しました");
        }

        const result = await response.json();
        const departments = Array.isArray(result) ? result : result.data;
        const select = document.getElementById("searchDept");

        select.innerHTML = '<option value="">すべての部署</option>';

        (departments || []).forEach(dept => {
            const option = document.createElement("option");
            option.value = dept.departmentId;
            option.textContent = dept.departmentName;
            select.appendChild(option);
        });

    } catch (error) {
        console.error("部署一覧の取得エラー:", error);
    }
}

/* 사원 검색 */
async function searchEmployees() {
    try {
        const response = await fetch(contextPath + "/api/employees");

        if (!response.ok) {
            throw new Error("検索に失敗しました");
        }

        const employees = await response.json();

        const keyword = $("#searchKeyword").val().trim().toLowerCase();
        const dept = $("#searchDept").val();
        const job = $("#searchJob").val();
        const status = $("#searchStatus").val();
        const startDate = $("#startDate").val();
        const endDate = $("#endDate").val();

        const result = employees.filter(emp => {

            const keywordMatch =
                String(emp.empId).includes(keyword) ||
                (emp.ename ?? "").toLowerCase().includes(keyword);

            const statusMatch =
                !status || emp.status === status;

            const hireDate = emp.hiredate
                ? new Date(emp.hiredate)
                : null;

            const startMatch =
                !startDate ||
                (hireDate &&
                 hireDate >= new Date(startDate + "T00:00:00"));

            const endMatch =
                !endDate ||
                (hireDate &&
                 hireDate <= new Date(endDate + "T23:59:59.999"));

            const deptMatch =
                !dept ||
                String(emp.department?.departmentId) === dept;

            const jobMatch =
                !job ||
                String(emp.job?.jobId) === job;

            return keywordMatch &&
                   deptMatch &&
                   jobMatch &&
                   statusMatch &&
                   startMatch &&
                   endMatch;
        });

        $("#resultCount").text(result.length + "名");
        printSearchResults(result);

    } catch (error) {
        console.error("社員検索エラー:", error);
        alert("社員の検索中にエラーが発生しました。");
    }
}

/* 검색 결과 출력 */
function printSearchResults(employees) {
    const tbody = $("#searchResultBody").empty();

    employees.forEach(emp => {
        const tr = $("<tr>");
        const url = contextPath + "/employees/" + emp.empId;

        $("<td>").text(emp.empId).appendTo(tr);
        $("<td>").text(emp.ename).appendTo(tr);
        $("<td>").text(emp.department?.departmentName ?? "-").appendTo(tr);
        $("<td>").text(emp.job?.jobName ?? "-").appendTo(tr);
        $("<td>").text(emp.email ?? "-").appendTo(tr);

        const hiredate = emp.hiredate
            ? new Date(emp.hiredate).toLocaleDateString("ja-JP")
            : "-";

        $("<td>").text(hiredate).appendTo(tr);

        const status = {
            ACTIVE: "在籍",
            LEAVE: "休職",
            RETIRED: "退職"
        }[emp.status] ?? "未確認";

        $("<td>").text(status).appendTo(tr);

        $("<td>").append(
            $("<a>").attr("href", url).text("詳細"),
            " / ",
            $("<a>").attr("href", url + "/edit").text("編集")
        ).appendTo(tr);

        tbody.append(tr);
    });

    if (employees.length === 0) {
        $("<tr>").append(
            $("<td>")
                .attr("colspan", 8)
                .addClass("empty-message")
                .text("検索結果がありません。")
        ).appendTo(tbody);
    }
}

/* 검색 조건 초기화 */
function resetSearch() {
    $("#searchKeyword").val("");
    $("#searchDept").val("");
    $("#searchJob").val("");
    $("#searchStatus").val("");
    $("#startDate").val("");
    $("#endDate").val("");

    $("#resultCount").text("0名");

    $("#searchResultBody").html(
        '<tr><td colspan="8" class="empty-message">' +
        '検索条件を入力して検索ボタンを押してください。' +
        '</td></tr>'
    );
}

/* 이벤트 */
document.addEventListener("DOMContentLoaded", () => {
    loadDepartments();

    document.getElementById("searchBtn")
        .addEventListener("click", searchEmployees);

    document.getElementById("resetBtn")
        .addEventListener("click", resetSearch);

    document.getElementById("searchKeyword")
        .addEventListener("keydown", event => {
            if (event.key === "Enter") {
                searchEmployees();
            }
        });
});
