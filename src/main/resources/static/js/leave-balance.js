// 나의 휴가 잔액 조회
    const getLeaveBalance = async () => {

        try {

            const response = await fetch(
                (document.body.getAttribute("data-context-path") || "") + "/api/leave/my/balance",
                {
                    method: "GET"
                }
            );

            if (!response.ok) {
                throw new Error("휴가 현황 조회 실패: " + response.status);
            }

            const result = await response.json();

            console.log("휴가 현황 조회 결과", result);

            if (result == null) {

                $("div[name='totalDays']").text("-");
                $("div[name='usedDays']").text("-");
                $("div[name='remainingDays']").text("-");

                return;
            }

            $("div[name='totalDays']").text(result.totalDays + "일");
            $("div[name='usedDays']").text(result.usedDays + "일");
            $("div[name='remainingDays']").text(result.remainingDays + "일");

        } catch (error) {

            console.error("휴가 현황 조회 오류", error);

        }
    };


    // 로그인한 사원의 실제 휴가 사용 내역 조회
    const getMyUsedLeave = async () => {

        const tbody = $("tbody[name='leaveHistoryRows']");
        const count = $("div[name='leaveHistoryCount']");

        tbody.empty();
        count.text("조회 중");

        try {

            const response = await fetch(
                (document.body.getAttribute("data-context-path") || "") + "/api/leave/my/used",
                {
                    method: "GET"
                }
            );

            if (!response.ok) {
                throw new Error("휴가 사용 내역 조회 실패: " + response.status);
            }

            const records = await response.json();

            console.log("휴가 사용 내역 조회 결과", records);

            if (!Array.isArray(records)) {
                throw new Error("휴가 사용 내역 응답 형식 오류");
            }

            tbody.empty();

            count.text("총 " + records.length + "건");

            // 휴가 사용 내역이 없는 경우
            if (records.length === 0) {

                const tr = $("<tr>");

                $("<td>")
                    .attr("colspan", 5)
                    .addClass("leave-empty")
                    .text("사용한 휴가 내역이 없습니다.")
                    .appendTo(tr);

                tbody.append(tr);

                return;
            }

            // 휴가 사용 내역을 한 건씩 출력
            records.forEach(function(row) {

                const startDate = row.startDate || "-";
                const endDate = row.endDate || "-";

                const period = startDate === endDate
                    ? startDate
                    : startDate + " ~ " + endDate;

                const leaveType = row.leaveType || "휴가";

                const days = row.days != null
                    ? row.days + "일"
                    : "-";

                const status = row.status === "APPROVED"
                    ? "사용 완료"
                    : row.status || "-";

                const tr = $("<tr>");

                $("<td>").text(startDate).appendTo(tr);
                $("<td>").text(leaveType).appendTo(tr);
                $("<td>").text(period).appendTo(tr);
                $("<td>").text(days).appendTo(tr);
                $("<td>").text(status).appendTo(tr);

                tbody.append(tr);

            });

        } catch (error) {

            console.error("휴가 사용 내역 조회 오류", error);

            tbody.empty();
            count.text("조회 실패");

            const tr = $("<tr>");

            $("<td>")
                .attr("colspan", 5)
                .addClass("leave-empty")
                .text("휴가 사용 내역을 불러오지 못했습니다.")
                .appendTo(tr);

            tbody.append(tr);

        }
    };


    // 페이지 로딩 완료
    $(function() {

        // 휴가 현황 조회
        getLeaveBalance();

        // 실제 휴가 사용 내역 조회
        getMyUsedLeave();

        // 휴가 신청 내역 페이지 이동
        $("button[name='leaveHistoryButton']").on("click", function() {

            window.location.href =
                (document.body.getAttribute("data-context-path") || "") + "/leave/history";

        });

        // 휴가 신청 페이지 이동
        $("button[name='leaveApplyButton']").on("click", function() {

            window.location.href =
                (document.body.getAttribute("data-context-path") || "") + "/leave/apply";

        });

    });
