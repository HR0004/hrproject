/* DB에 등록된 부서 목록 조회 */
	
/* DB에 등록된 부서 목록을 SelectBox에 표시 */
async function loadDepartments() {

    const select = $("#datDepartment");

    try {
        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/departments",
            { method: "GET" }
        );

        if (!response.ok) {
            throw new Error("부서 목록 조회 실패: " + response.status);
        }

        const result = await response.json();

        console.log("부서 목록 API 응답:", result);

        // API가 배열 또는 data/content에 배열을 반환하는 경우 처리
        const departments = Array.isArray(result)
            ? result
            : (Array.isArray(result.data)
                ? result.data
                : (Array.isArray(result.content) ? result.content : []));

        select.empty();

        select.append(
            $("<option>").val("").text("전체 부서")
        );

        departments.forEach(function(dept) {

            // 부서 DTO의 필드 이름
            const id = dept.departmentId;
            const name = dept.departmentName;

            if (id == null || !name) {
                return;
            }

            select.append(
                $("<option>")
                    .val(id)
                    .text(name)
            );
        });

    } catch (error) {

        console.error("부서 조회 오류:", error);

        select.empty().append(
            $("<option>")
                .val("")
                .text("부서 조회 실패")
        );
    }
}


// 개발용 예시. 실제 구현은 로그인 관리자의 부서를 서버가 판정해 조회해야 합니다.

let departmentAttendanceRows = [];

const deptStatusText = {NORMAL:"정상 출근", LATE:"지각", EARLY:"조퇴", LEAVE:"휴가", UNKNOWN:"미기록"};

const deptStatusClass = {NORMAL:"dat-pill-normal", LATE:"dat-pill-late", EARLY:"dat-pill-early", LEAVE:"dat-pill-leave", UNKNOWN:"dat-pill-unknown"};


const getDepartmentAttendance = async function() {

    // 1. 사용자가 선택한 조회 조건
    const departmentId = $("#datDepartment").val();
    const selectedDate = $("input[name='workDate']").val();
    const status = $("select[name='attendanceStatus']").val();
    const keyword = $("input[name='attendanceKeyword']")
        .val().trim().toLowerCase();

    const $tbody = $("tbody[name='departmentAttendanceRows']");
    $tbody.empty();

    try {

        // 2. DB 조회 API에 부서 ID와 날짜 전달
        const params = new URLSearchParams();

        if (departmentId) {
            params.set("departmentId", departmentId);
        }

        params.set("workDate", selectedDate);

        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/attendance/department?"
            + params.toString()
        );

        if (!response.ok) {
            throw new Error("근태 조회 실패: " + response.status);
        }

        // 3. 서버에서 받은 실제 근태 데이터
        const data = await response.json();

        if (!Array.isArray(data)) {
            throw new Error("근태 데이터 형식이 올바르지 않습니다.");
        }

        departmentAttendanceRows = data;
		

     // 부서 ID를 실제 부서 이름으로 변환
     departmentAttendanceRows.forEach(function(item) {

         const option = $("#datDepartment option").filter(
             function() {
                 return this.value === String(item.departmentId);
             }
         ).first();

         item.department = option.length
             ? option.text()
             : "부서 정보 없음";
     });

        // 4. 상태와 직원 이름/사번 필터
        const rows = departmentAttendanceRows.filter(function(item) {

            return (status === "ALL" || item.status === status)
                && (
                    !keyword ||
                    String(item.name).toLowerCase().includes(keyword) ||
                    String(item.empId).includes(keyword)
                );
        });

        // 5. 상단 통계 갱신
        $("div[name='allEmployees']").text(rows.length + "명");

        $("div[name='normalEmployees']").text(
            rows.filter(r => r.status === "NORMAL").length + "명"
        );

        $("div[name='lateEmployees']").text(
            rows.filter(r =>
                r.status === "LATE" || r.status === "EARLY"
            ).length + "명"
        );

        $("div[name='otherEmployees']").text(
            rows.filter(r =>
                r.status === "LEAVE" || r.status === "UNKNOWN"
            ).length + "명"
        );

        $("span[name='attendanceCount']").text(
            "총 " + rows.length + "명"
        );

        // 6. 조회된 데이터가 없는 경우
        if (rows.length === 0) {
            $tbody.append(
                $("<tr>").append(
                    $("<td>", {
                        colspan: 7,
                        "class": "dat-empty",
                        text: "조회된 근태 내역이 없습니다."
                    })
                )
            );
            return;
        }

        // 7. 실제 DB 데이터로 테이블 생성
        rows.forEach(function(item) {

            const $tr = $("<tr>");

            $tr.append($("<td>").text(item.empId));
            $tr.append($("<td>").text(item.name));
            $tr.append($("<td>").text(item.date));
            $tr.append($("<td>").text(item.clockIn || "--:--"));
            $tr.append($("<td>").text(item.clockOut || "--:--"));

            $tr.append(
                $("<td>").append(
                    $("<span>", {
                        "class": "dat-pill " +
                            (deptStatusClass[item.status] || "dat-pill-unknown"),
                        text: deptStatusText[item.status] || "미기록"
                    })
                )
            );

            $tr.append(
                $("<td>").append(
                    $("<button>", {
                        type: "button",
                        "class": "dat-btn dat-btn-small",
                        text: "상세",
                        "data-emp-id": item.empId
                    })
                )
            );

            $tbody.append($tr);
        });

    } catch (error) {

        console.error("부서 근태 조회 오류:", error);

        departmentAttendanceRows = [];

        $("div[name='allEmployees']").text("0명");
        $("div[name='normalEmployees']").text("0명");
        $("div[name='lateEmployees']").text("0명");
        $("div[name='otherEmployees']").text("0명");
        $("span[name='attendanceCount']").text("총 0명");

        $tbody.append(
            $("<tr>").append(
                $("<td>", {
                    colspan: 7,
                    "class": "dat-empty",
                    text: "근태 정보를 불러오지 못했습니다."
                })
            )
        );
    }
};


const showDepartmentAttendanceDetail = function(empId) {

    const selectedDate = $("input[name='workDate']").val();

    const item = departmentAttendanceRows.find(
    	    row => Number(row.empId) === Number(empId)
    	);

    if (!item) return;

    const details = [["사번",item.empId],["직원명",item.name],["소속 부서",item.department],["근무 일자",item.date],

        ["출근 시간",item.clockIn],["퇴근 시간",item.clockOut],["근태 상태",deptStatusText[item.status]],["비고",item.note]];

    const $content = $("dl[name='attendanceDetailContent']").empty();

    details.forEach(function(pair) { $content.append($("<dt>").text(pair[0])); $content.append($("<dd>").text(pair[1])); });

    $("div[name='attendanceDetailOverlay']").addClass("dat-open");

};

$(function() {
	
	loadDepartments().then(function() {
	    getDepartmentAttendance();
	});

    $("button[name='searchDepartmentAttendance']").on("click", getDepartmentAttendance);

    $("button[name='resetDepartmentAttendance']").on("click", function() {
		
    	$("#datDepartment").val("");
    	
        $("input[name='workDate']").val("2026-11-05");

        $("select[name='attendanceStatus']").val("ALL");

        $("input[name='attendanceKeyword']").val("");

        getDepartmentAttendance();

    });

    $("input[name='attendanceKeyword']").on("keydown", function(e) { if (e.key === "Enter") getDepartmentAttendance(); });

    $("tbody[name='departmentAttendanceRows']").on("click", "button[data-emp-id]", function() { showDepartmentAttendanceDetail(Number($(this).attr("data-emp-id"))); });

    $("button[name='closeAttendanceDetail']").on("click", function() { $("div[name='attendanceDetailOverlay']").removeClass("dat-open"); });

    $("div[name='attendanceDetailOverlay']").on("click", function(e) { if (e.target === this) $(this).removeClass("dat-open"); });

    $(document).on("keydown", function(e) { if (e.key === "Escape") $("div[name='attendanceDetailOverlay']").removeClass("dat-open"); });

});
