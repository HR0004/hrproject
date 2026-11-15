// 개발용 예시. 실제 구현에서는 REST API 응답으로 교체합니다.
const adminLeaveDemo = [
    {requestId:101, empId:1, empName:"김민준", department:"개발팀", requestDate:"2026-11-05", startDate:"2026-11-17", endDate:"2026-11-18", days:2, reason:"개인 일정", status:"PENDING"},
    {requestId:102, empId:4, empName:"이서연", department:"개발팀", requestDate:"2026-11-04", startDate:"2026-11-12", endDate:"2026-11-12", days:0.5, reason:"오전 병원 진료", status:"PENDING"},
    {requestId:103, empId:7, empName:"박지훈", department:"개발팀", requestDate:"2026-11-03", startDate:"2026-11-10", endDate:"2026-11-10", days:1, reason:"가족 행사 참석", status:"APPROVED"},
    {requestId:104, empId:9, empName:"최유진", department:"개발팀", requestDate:"2026-10-29", startDate:"2026-11-06", endDate:"2026-11-07", days:2, reason:"개인 사정", status:"REJECTED"},
    {requestId:105, empId:11, empName:"정도현", department:"개발팀", requestDate:"2026-10-27", startDate:"2026-11-21", endDate:"2026-11-21", days:1, reason:"연차 사용", status:"APPROVED"},
    {requestId:106, empId:13, empName:"한지민", department:"개발팀", requestDate:"2026-10-20", startDate:"2026-10-24", endDate:"2026-10-24", days:1, reason:"개인 일정", status:"APPROVED"}
];
const adminLeaveStatusText = {PENDING:"승인 대기", APPROVED:"승인 완료", REJECTED:"반려"};
const adminLeaveStatusClass = {PENDING:"alr-pill-pending", APPROVED:"alr-pill-approved", REJECTED:"alr-pill-rejected"};
const displayLeaveRequests = function() {
    const start = $("input[name='startDate']").val();
    const end = $("input[name='endDate']").val();
    const status = $("select[name='statusFilter']").val();
    const keyword = $("input[name='keyword']").val().trim().toLowerCase();
    if (start && end && start > end) { alert("신청 종료일은 시작일보다 빠를 수 없습니다."); return; }
    const rows = adminLeaveDemo.filter(function(item) {
        return (!start || item.requestDate >= start) && (!end || item.requestDate <= end)
            && (status === "ALL" || item.status === status)
            && (!keyword || item.empName.toLowerCase().includes(keyword) || String(item.empId).includes(keyword));
    }).sort(function(a,b) { return b.requestDate.localeCompare(a.requestDate); });
    const $body = $("tbody[name='leaveRequestRows']").empty();
    $("div[name='allCount']").text(rows.length + "건");
    $("div[name='pendingCount']").text(rows.filter(r => r.status === "PENDING").length + "건");
    $("div[name='approvedCount']").text(rows.filter(r => r.status === "APPROVED").length + "건");
    $("div[name='rejectedCount']").text(rows.filter(r => r.status === "REJECTED").length + "건");
    $("div[name='resultCount']").text("총 " + rows.length + "건");
    if (rows.length === 0) {
        $body.append($("<tr>").append($("<td>", {colspan:7, "class":"alr-empty", text:"조회된 휴가 신청이 없습니다."})));
        return;
    }
    rows.forEach(function(item) {
        const $tr = $("<tr>");
        $tr.append($("<td>").text(item.requestDate));
        $tr.append($("<td>").text(item.empId + " / " + item.empName));
        $tr.append($("<td>").text(item.startDate + (item.startDate === item.endDate ? "" : " ~ " + item.endDate)));
        $tr.append($("<td>").text(item.days + "일"));
        $tr.append($("<td>", {"class":"alr-ellipsis", title:item.reason}).text(item.reason));
        $tr.append($("<td>").append($("<span>", {"class":"alr-pill " + adminLeaveStatusClass[item.status], text:adminLeaveStatusText[item.status]})));
        const $actions = $("<div>", {"class":"alr-row-actions"});
        $actions.append($("<button>", {type:"button", "class":"alr-btn alr-btn-small", text:"상세", "data-id":item.requestId, "data-action":"detail"}));
        if (item.status === "PENDING") {
            $actions.append($("<button>", {type:"button", "class":"alr-btn alr-btn-small alr-btn-primary", text:"승인", "data-id":item.requestId, "data-action":"approve"}));
            $actions.append($("<button>", {type:"button", "class":"alr-btn alr-btn-small", text:"반려", "data-id":item.requestId, "data-action":"reject"}));
        }
        $tr.append($("<td>").append($actions));
        $body.append($tr);
    });
};
const showLeaveDetail = function(id) {
    const item = adminLeaveDemo.find(row => row.requestId === id);
    if (!item) return;
    const details = [
        ["신청 번호", item.requestId], ["사원", item.empName + " (" + item.empId + ")"],
        ["소속 부서", item.department], ["신청일", item.requestDate],
        ["사용 기간", item.startDate + " ~ " + item.endDate], ["사용 일수", item.days + "일"],
        ["신청 사유", item.reason], ["처리 상태", adminLeaveStatusText[item.status]]
    ];
    const $content = $("dl[name='leaveDetailContent']").empty();
    details.forEach(function(pair) {
        $content.append($("<dt>").text(pair[0]));
        $content.append($("<dd>").text(pair[1]));
    });
    $("div[name='leaveDetailOverlay']").addClass("alr-open");
};
$(function() {
    displayLeaveRequests();
    $("button[name='searchLeaveRequests']").on("click", displayLeaveRequests);
    $("button[name='resetLeaveRequests']").on("click", function() {
        $("input[name='startDate']").val("2026-10-01");
        $("input[name='endDate']").val("2026-11-30");
        $("select[name='statusFilter']").val("ALL");
        $("input[name='keyword']").val("");
        displayLeaveRequests();
    });
    $("input[name='keyword']").on("keydown", function(e) { if (e.key === "Enter") displayLeaveRequests(); });
    $("tbody[name='leaveRequestRows']").on("click", "button[data-action]", function() {
        const action = $(this).attr("data-action");
        const id = Number($(this).attr("data-id"));
        if (action === "detail") { showLeaveDetail(id); return; }
        // 승인·반려는 실제 서버 검증과 DB 트랜잭션이 필요합니다. 화면에서만 성공 처리하지 않습니다.
        alert((action === "approve" ? "승인" : "반려") + " 기능은 아직 DB에 연결되지 않았습니다. 화면 예시입니다.");
    });
    $("button[name='closeLeaveDetail']").on("click", function() { $("div[name='leaveDetailOverlay']").removeClass("alr-open"); });
    $("div[name='leaveDetailOverlay']").on("click", function(e) { if (e.target === this) $(this).removeClass("alr-open"); });
    $(document).on("keydown", function(e) { if (e.key === "Escape") $("div[name='leaveDetailOverlay']").removeClass("alr-open"); });
});
