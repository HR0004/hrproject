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
                throw new Error("休暇状況の取得に失敗しました: " + response.status);
            }

            const result = await response.json();

            console.log("休暇状況の取得結果", result);

            if (result == null) {

                $("div[name='totalDays']").text("-");
                $("div[name='usedDays']").text("-");
                $("div[name='remainingDays']").text("-");

                return;
            }

            $("div[name='totalDays']").text(result.totalDays + "日");
            $("div[name='usedDays']").text(result.usedDays + "日");
            $("div[name='remainingDays']").text(result.remainingDays + "日");

        } catch (error) {

            console.error("休暇状況の取得エラー", error);

        }
    };


    // 로그인한 사원의 실제 휴가 사용 내역 조회
    const getMyUsedLeave = async () => {

        const tbody = $("tbody[name='leaveHistoryRows']");
        const count = $("div[name='leaveHistoryCount']");

        tbody.empty();
        count.text("読み込み中");

        try {

            const response = await fetch(
                (document.body.getAttribute("data-context-path") || "") + "/api/leave/my/used",
                {
                    method: "GET"
                }
            );

            if (!response.ok) {
                throw new Error("休暇取得履歴の取得に失敗しました: " + response.status);
            }

            const records = await response.json();

            console.log("休暇取得履歴の取得結果", records);

            if (!Array.isArray(records)) {
                throw new Error("休暇取得履歴のレスポンス形式エラー");
            }

            tbody.empty();

            count.text("合計 " + records.length + "件");

            // 휴가 사용 내역이 없는 경우
            if (records.length === 0) {

                const tr = $("<tr>");

                $("<td>")
                    .attr("colspan", 5)
                    .addClass("leave-empty")
                    .text("取得済みの休暇履歴がありません。")
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

                const leaveType = row.leaveType || "休暇";

                const days = row.days != null
                    ? row.days + "日"
                    : "-";

                const status = row.status === "APPROVED"
                    ? "取得済み"
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

            console.error("休暇取得履歴の取得エラー", error);

            tbody.empty();
            count.text("取得に失敗しました");

            const tr = $("<tr>");

            $("<td>")
                .attr("colspan", 5)
                .addClass("leave-empty")
                .text("休暇取得履歴を読み込めませんでした。")
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
