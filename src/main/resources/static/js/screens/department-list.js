const contextPath = (document.body.getAttribute("data-context-path") || "");

let departmentList = [];


// 1. 부서 목록 조회
const getList = async () => {

    try {
        const response = await fetch(
            contextPath + "/api/departments", {
                method: "GET"
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "部署一覧の取得に失敗しました");
        }

        departmentList = result.data;

        filterDepartments();
        updateSummary();

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 2. 부서 목록 출력
const renderList = (list) => {

    const tbody = document.getElementById("departmentBody");

    tbody.replaceChildren();

    if (list.length === 0) {
        const tr = document.createElement("tr");
        const td = document.createElement("td");
        td.colSpan = 5;
        td.textContent = "検索結果がありません。";
        td.style.textAlign = "center";
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }

    list.forEach(dept => {

        const tr = document.createElement("tr");

        // 부서 코드
        const code = document.createElement("td");
        code.textContent = dept.departmentCode;

        // 부서명
        const name = document.createElement("td");
        name.textContent = dept.departmentName;
        
        // 부서별 사원 수
        const employeeCount = document.createElement("td");
        employeeCount.textContent = (dept.employeeCount ?? 0) + "名";

        // 상태
        const active = Number(dept.isActive) === 1;

        const status = document.createElement("td");
        status.textContent = active ? "有効" : "無効";

        // 관리 버튼
        const action = document.createElement("td");

        // 수정 버튼
        const editBtn = document.createElement("button");
        editBtn.type = "button";
        editBtn.textContent = "編集";

        editBtn.onclick = () => {

        	window.open(
        		    contextPath + "/jobs/new",
        		    "jobRegisterPopup",
        		    "width=700,height=700,scrollbars=yes"
        		);
        };

        // 비활성화 버튼
        const deleteBtn = document.createElement("button");
        deleteBtn.type = "button";
        deleteBtn.textContent = "無効化";

        deleteBtn.onclick = () => {
            deactivate(dept.departmentId);
        };

        editBtn.disabled = !active;
        deleteBtn.disabled = !active;

        action.append(editBtn, deleteBtn);

        tr.append(code, name, employeeCount, status, action);

        tbody.appendChild(tr);
    });
};


// 3. 부서 비활성화
const deactivate = async (departmentId) => {

    if (!confirm("この部署を無効にしますか？")) {
        return;
    }

    try {
        const response = await fetch(
            contextPath + "/api/departments/" + departmentId, {
                method: "DELETE"
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "部署の無効化に失敗しました");
        }

        alert(result.message);

        location.reload();

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 4. 부서 통계
const updateSummary = () => {

    const activeCount = departmentList.filter(
        dept => Number(dept.isActive) === 1
    ).length;

    document.getElementById("totalCount").textContent =
        departmentList.length;

    document.getElementById("activeCount").textContent =
        activeCount;

    document.getElementById("inactiveCount").textContent =
        departmentList.length - activeCount;
};


// 5. 부서 검색 (별도 JS 파일 없이 현재 JSP에서 처리)
const filterDepartments = () => {
    const keyword = document.getElementById("keyword")
        .value.trim().toLowerCase();
    const status = document.getElementById("searchStatus").value;

    const filtered = departmentList.filter(dept => {
        const code = String(dept.departmentCode ?? "").toLowerCase();
        const name = String(dept.departmentName ?? "").toLowerCase();
        const matchesKeyword = code.includes(keyword) || name.includes(keyword) || window.hrmsJapaneseLabel(dept.departmentName ?? "").toLowerCase().includes(keyword);
        const matchesStatus = status === "" || Number(dept.isActive) === Number(status);
        return matchesKeyword && matchesStatus;
    });

    renderList(filtered);
};

document.getElementById("keyword")
    .addEventListener("input", filterDepartments);

document.getElementById("searchStatus")
    .addEventListener("change", filterDepartments);


//부서 등록 팝업
document.getElementById("openRegisterBtn").addEventListener("click", () => {

    const width = 550;
    const height = 400;

    const left = Math.round(window.screenX + (window.outerWidth - width) / 2);
    const top = Math.round(window.screenY + (window.outerHeight - height) / 2);

    window.open(
        contextPath + "/departments/new",
        "departmentRegisterPopup",
        "width=" + width +
        ",height=" + height +
        ",left=" + left +
        ",top=" + top +
        ",scrollbars=yes,resizable=yes"
    );
});


// 7. 목록 자동 조회
getList();
