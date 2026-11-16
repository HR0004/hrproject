const contextPath = (document.body.getAttribute("data-context-path") || "");

let jobList = [];
let currentPage = 1;
const pageSize = 10;


// 1. 직급 목록 조회
const getList = async () => {
    try {
        const response = await fetch(contextPath + "/api/jobs");
        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "직급 목록 조회 실패");
        }

        jobList = result.data;

        updateSummary();
        await loadPage(1);

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


//서버에서 페이지별 직급 조회
const loadPage = async (page = 1) => {
 try {
     const response = await fetch(
         contextPath + "/api/jobs/page?currentPage=" + page
     );

     const result = await response.json();

     if (!response.ok || !result.success) {
         throw new Error(result.message || "페이지 조회 실패");
     }

     const pager = result.data;

     currentPage = pager.currentPage;

     renderList(pager.list);
     renderPagination(pager.totalCount);

 } catch (error) {
     console.error(error);
     alert(error.message);
 }
};


//페이지 버튼 생성
const renderPagination = (totalCount) => {

 const container = document.getElementById("pagination");
 container.replaceChildren();

 const totalPage = Math.ceil(totalCount / pageSize);

 if (totalPage <= 1) return;

 const firstPage =
     currentPage - (currentPage - 1) % 10;

 const lastPage = Math.min(firstPage + 9, totalPage);

 const addButton = (text, page, disabled = false) => {
     const btn = document.createElement("button");

     btn.type = "button";
     btn.textContent = text;
     btn.disabled = disabled;
     btn.className = "btn btn-sm " +
         (page === currentPage
             ? "btn-primary"
             : "btn-outline-secondary");

     btn.onclick = () => changePage(page);

     container.appendChild(btn);
 };

 addButton("이전", currentPage - 1, currentPage === 1);

 for (let i = firstPage; i <= lastPage; i++) {
     addButton(i, i);
 }

 addButton("다음", currentPage + 1, currentPage === totalPage);
};


//페이지 이동
const changePage = async (page) => {

 const keyword = document.getElementById("keyword").value.trim();
 const status = document.getElementById("searchStatus").value;

 if (keyword || status !== "") {
     filterJobs(page);
 } else {
     await loadPage(page);
 }
};


// 2. 직급 목록 출력
const renderList = (list) => {

    const tbody = document.getElementById("jobBody");

    tbody.replaceChildren();

    if (list.length === 0) {
        const tr = document.createElement("tr");
        const td = document.createElement("td");
        td.colSpan = 5;
        td.textContent = "검색 결과가 없습니다.";
        td.style.textAlign = "center";
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }

    list.forEach(job => {

        const tr = document.createElement("tr");

        // 직급 코드
        const code = document.createElement("td");
        code.textContent = job.jobCode;

        // 직급명
        const name = document.createElement("td");
        name.textContent = job.jobName;
        
        // 직급별 사원 수
        const employeeCount = document.createElement("td");
        employeeCount.textContent = job.employeeCount == null ? "-" : job.employeeCount + "명";

        // 상태
        const active = Number(job.isActive) === 1;

        const status = document.createElement("td");
        status.textContent = active ? "활성" : "비활성";

        // 관리 버튼
        const action = document.createElement("td");

        // 수정 버튼
        const editBtn = document.createElement("button");
        editBtn.type = "button";
        editBtn.textContent = "수정";

        editBtn.onclick = () => {

            window.open(
                contextPath + "/jobs/edit?jobId="
                    + job.jobId,
                "jobEditPopup",
                "width=600,height=450"
            );
        };

        // 비활성화 버튼
        const deleteBtn = document.createElement("button");
        deleteBtn.type = "button";
        deleteBtn.textContent = "비활성화";

        deleteBtn.onclick = () => {
            deactivate(job.jobId);
        };

        editBtn.disabled = !active;
        deleteBtn.disabled = !active;

        action.append(editBtn, deleteBtn);

        tr.append(code, name, employeeCount, status, action);

        tbody.appendChild(tr);
    });
};


// 3. 직급 비활성화
const deactivate = async (jobId) => {

    if (!confirm("해당 직급을 비활성화하시겠습니까?")) {
        return;
    }

    try {
        const response = await fetch(
            contextPath + "/api/jobs/" + jobId, {
                method: "DELETE"
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "직급 비활성화 실패");
        }

        alert(result.message);

        location.reload();

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 4. 직급 통계
const updateSummary = () => {

    const activeCount = jobList.filter(
        job => Number(job.isActive) === 1
    ).length;

    document.getElementById("totalCount").textContent =
        jobList.length;

    document.getElementById("activeCount").textContent =
        activeCount;

    document.getElementById("inactiveCount").textContent =
        jobList.length - activeCount;
};



/*-------------------------------------
  5. 직급 검색 + 페이징
-------------------------------------*/
const filterJobs = (page = 1) => {

    const keyword = document.getElementById("keyword")
        .value.trim().toLowerCase();

    const status = document.getElementById("searchStatus").value;

    // 검색 조건이 없으면 서버 페이징 사용
    if (!keyword && status === "") {
        loadPage(page);
        return;
    }

    // 직급명, 직급 코드, 활성 상태 검색
    const filtered = jobList.filter(job => {

        const code = String(job.jobCode ?? "").toLowerCase();
        const name = String(job.jobName ?? "").toLowerCase();

        const matchesKeyword =
            code.includes(keyword) || name.includes(keyword);

        const matchesStatus =
            status === "" ||
            Number(job.isActive) === Number(status);

        return matchesKeyword && matchesStatus;
    });

    // 검색 결과의 전체 페이지 수
    const totalPage = Math.max(
        1,
        Math.ceil(filtered.length / pageSize)
    );

    // 현재 페이지 설정
    currentPage = Math.max(1, Math.min(page, totalPage));

    // 현재 페이지에 출력할 데이터
    const start = (currentPage - 1) * pageSize;

    renderList(filtered.slice(start, start + pageSize));

    // 페이지 버튼 출력
    renderPagination(filtered.length);
};

// 검색어 입력 시 1페이지부터 조회
document.getElementById("keyword")
    .addEventListener("input", () => filterJobs(1));

// 활성/비활성 필터 변경 시 1페이지부터 조회
document.getElementById("searchStatus")
    .addEventListener("change", () => filterJobs(1));


/*-------------------------------------
  6. 직급 등록 팝업
-------------------------------------*/
document.getElementById("openRegisterBtn")
    .addEventListener("click", () => {

        const width = 650;
        const height = 500;

        const left = Math.round(
            window.screenX + (window.outerWidth - width) / 2
        );

        const top = Math.round(
            window.screenY + (window.outerHeight - height) / 2
        );

        window.open(
            contextPath + "/jobs/new",
            "jobRegisterPopup",
            "width=" + width +
            ",height=" + height +
            ",left=" + left +
            ",top=" + top +
            ",scrollbars=yes,resizable=yes"
        );
    });


/*-------------------------------------
  7. 목록 자동 조회
-------------------------------------*/
getList();
