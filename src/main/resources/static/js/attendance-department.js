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
            throw new Error("部署一覧の取得に失敗しました: " + response.status);
        }

        const result = await response.json();

        console.log("部署一覧 API レスポンス:", result);

        // API가 배열 또는 data/content에 배열을 반환하는 경우 처리
        const departments = Array.isArray(result)
            ? result
            : (Array.isArray(result.data)
                ? result.data
                : (Array.isArray(result.content) ? result.content : []));

        select.empty();

        select.append(
            $("<option>").val("").text("すべての部署")
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

        console.error("部署情報の取得エラー:", error);

        select.empty().append(
            $("<option>")
                .val("")
                .text("部署情報の取得に失敗しました")
        );
    }
}


// DB 조회 결과를 부서/날짜 조건에 맞게 표시합니다.

let departmentAttendanceRows = [];

const deptStatusText = {NORMAL:"通常出勤", LATE:"遅刻", EARLY:"早退", LEAVE:"休暇", UNKNOWN:"未記録"};

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
            throw new Error("勤怠情報の取得に失敗しました: " + response.status);
        }

        // 3. 서버에서 받은 실제 근태 데이터
        const data = await response.json();

        if (!Array.isArray(data)) {
            throw new Error("勤怠データの形式が正しくありません。");
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
             : "部署情報なし";
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
        $("div[name='allEmployees']").text(rows.length + "名");

        $("div[name='normalEmployees']").text(
            rows.filter(r => r.status === "NORMAL").length + "名"
        );

        $("div[name='lateEmployees']").text(
            rows.filter(r =>
                r.status === "LATE" || r.status === "EARLY"
            ).length + "名"
        );

        $("div[name='otherEmployees']").text(
            rows.filter(r =>
                r.status === "LEAVE" || r.status === "UNKNOWN"
            ).length + "名"
        );

        $("span[name='attendanceCount']").text(
            "合計 " + rows.length + "名"
        );

        // 6. 조회된 데이터가 없는 경우
        if (rows.length === 0) {
            $tbody.append(
                $("<tr>").append(
                    $("<td>", {
                        colspan: 7,
                        "class": "dat-empty",
                        text: "該当する勤怠記録がありません。"
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
                        text: deptStatusText[item.status] || "未記録"
                    })
                )
            );

            $tr.append(
                $("<td>").append(
                    $("<button>", {
                        type: "button",
                        "class": "dat-btn dat-btn-small",
                        text: "詳細",
                        "data-emp-id": item.empId
                    })
                )
            );

            $tbody.append($tr);
        });

    } catch (error) {

        console.error("部署別勤怠の取得エラー:", error);

        departmentAttendanceRows = [];

        $("div[name='allEmployees']").text("0名");
        $("div[name='normalEmployees']").text("0名");
        $("div[name='lateEmployees']").text("0名");
        $("div[name='otherEmployees']").text("0名");
        $("span[name='attendanceCount']").text("合計 0名");

        $tbody.append(
            $("<tr>").append(
                $("<td>", {
                    colspan: 7,
                    "class": "dat-empty",
                    text: "勤怠情報を読み込めませんでした。"
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

    const details = [["社員番号",item.empId],["社員名",item.name],["所属部署",item.department],["勤務日",item.date],

        ["出勤時刻",item.clockIn],["退勤時刻",item.clockOut],["勤怠状態",deptStatusText[item.status]],["備考",item.note]];

    const $content = $("dl[name='attendanceDetailContent']").empty();

    details.forEach(function(pair) { $content.append($("<dt>").text(pair[0])); $content.append($("<dd>").text(pair[1])); });

    $("div[name='attendanceDetailOverlay']").addClass("dat-open");

};

function currentAttendanceDate() {
    const now = new Date();
    return now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, "0") + "-" + String(now.getDate()).padStart(2, "0");
}
$(function() {
    $("input[name='workDate']").val(currentAttendanceDate());
	
	loadDepartments().then(function() {
	    getDepartmentAttendance();
	});

    $("button[name='searchDepartmentAttendance']").on("click", getDepartmentAttendance);

    $("button[name='resetDepartmentAttendance']").on("click", function() {
		
    	$("#datDepartment").val("");
    	
        $("input[name='workDate']").val(currentAttendanceDate());

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
