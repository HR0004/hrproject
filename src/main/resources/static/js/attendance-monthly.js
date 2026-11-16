$(function() {

			const contextPath = document.body.getAttribute("data-context-path") || "";

			// 시연용 기본 퇴근 시각: 18:00
			const standardEndMinutes = 18 * 60;

			// 로그인한 사원의 근태 기록
			let attendanceRecords = [];

			// YYYY-MM 문자열 생성
			function monthKey(date) {
				return date.getFullYear() + "-"
						+ String(date.getMonth() + 1).padStart(2, "0");
			}

			// YYYY년 MM월 문자열 생성
			function monthLabel(month) {
				const parts = month.split("-");
				return parts[0] + "年 " + parts[1] + "月";
			}

			// 이번 달부터 지난 11개월까지 선택 목록 구성
			function initMonthSelect() {

				const select = $("select[name='selectedMonth']");
				const today = new Date();

				select.empty();

				for (let i = 0; i < 12; i++) {

					const date = new Date(today.getFullYear(), today.getMonth()
							- i, 1);

					const key = monthKey(date);

					$("<option>").val(key).text(monthLabel(key)).appendTo(
							select);
				}
			}

			// HH:mm 형식을 분으로 변환
			function toMinutes(time) {

				const match = String(time || "").match(/^(\d{1,2}):(\d{2})/);

				if (!match) {
					return null;
				}

				const hours = Number(match[1]);
				const minutes = Number(match[2]);

				if (hours > 23 || minutes > 59) {
					return null;
				}

				return hours * 60 + minutes;
			}

			// 분을 "N시간 N분"으로 표시
			function formatMinutes(total) {

				const hours = Math.floor(total / 60);
				const minutes = total % 60;

				return hours + "時間 " + minutes + "分";
			}

			// 해당 월의 실제 근태 통계 계산
			function calculateMonth(month) {

				const records = attendanceRecords.filter(function(row) {

					return String(row.workDate || "").startsWith(month);
				});

				// 날짜별 중복 기록 방지
				const byDate = new Map();

				records.forEach(function(row) {

					const date = String(row.workDate || "");
					const existing = byDate.get(date);

					if (!existing || (!existing.clockOut && row.clockOut)) {

						byDate.set(date, row);
					}
				});

				const rows = Array.from(byDate.values());

				let workDays = 0;
				let lateCount = 0;
				let earlyCount = 0;
				let absentCount = 0;
				let overtimeMinutes = 0;

				rows.forEach(function(row) {

					const status = String(row.status || "").toUpperCase();

					if (row.clockIn) {
						workDays++;
					}

					if (status === "LATE") {
						lateCount++;
					}

					if (status === "ABSENT") {
						absentCount++;
					}

					const clockOutMinutes = toMinutes(row.clockOut);

					if (clockOutMinutes !== null && row.clockIn) {

						if (clockOutMinutes < standardEndMinutes) {
							earlyCount++;
						}

						if (clockOutMinutes > standardEndMinutes) {

							overtimeMinutes += clockOutMinutes
									- standardEndMinutes;
						}
					}
				});

				return {
					month : month,
					recordCount : rows.length,
					workDays : workDays,
					late : lateCount,
					early : earlyCount,
					absent : absentCount,
					overtimeMinutes : overtimeMinutes
				};
			}

			// 상단 통계 카드 및 월별 근태 요약 출력
			function renderMonthlyAttendance() {

				const selectedMonth = $("select[name='selectedMonth']").val();

				if (!selectedMonth) {
					return;
				}

				const summary = calculateMonth(selectedMonth);

				$("div[name='totalWorkDays']").text(summary.workDays + "日");

				$("div[name='lateEarlyCount']").text(
						"遅刻 " + summary.late + "回 / 早退 " + summary.early + "回");

				// 결근은 현재 별도 집계 기능이 없으므로
				// 명시적인 ABSENT 기록이 있을 때만 표시
				$("div[name='absentDays']").text(
						summary.absent > 0 ? summary.absent + "日" : "未集計");

				$("div[name='overtimeTotal']").text(
						formatMinutes(summary.overtimeMinutes));

				const tbody = $("tbody[name='monthlyAttendanceRows']");

				tbody.empty();

				const parts = selectedMonth.split("-");
				const year = Number(parts[0]);
				const month = Number(parts[1]);

				let displayed = 0;

				// 선택 월을 포함한 최근 6개월
				for (let i = 0; i < 6; i++) {

					const date = new Date(year, month - 1 - i, 1);
					const key = monthKey(date);

					const row = calculateMonth(key);

					// DB에 기록이 없는 월은 건너뛰기
					if (row.recordCount === 0) {
						continue;
					}

					const tr = $("<tr>");

					$("<td>").text(monthLabel(row.month)).appendTo(tr);

					$("<td>").text(row.workDays + "日").appendTo(tr);

					$("<td>").text(row.late + "回").appendTo(tr);

					$("<td>").text(row.early + "回").appendTo(tr);

					$("<td>").text(row.absent > 0 ? row.absent + "日" : "未集計")
							.appendTo(tr);

					$("<td>").text(formatMinutes(row.overtimeMinutes))
							.appendTo(tr);

					// DB에 정산 전송 상태가 없으므로 임의 표시 금지
					$("<td>").text("未連携").appendTo(tr);

					tbody.append(tr);

					displayed++;
				}

				if (displayed === 0) {

					$("<tr>").append(
							$("<td>").attr("colspan", 7).addClass("ma-empty")
									.text("この期間の勤怠記録がありません。")).appendTo(
							tbody);
				}
			}

			// 로그인한 사원의 실제 근태 기록 API 조회
			async function loadAttendance() {

				try {

					const response = await
					fetch(contextPath + "/api/attendance/my", {
						method : "GET"
					});

					if (!response.ok) {
						throw new Error("勤怠情報の取得に失敗しました: " + response.status);
					}

					const result = await
					response.json();

					if (!Array.isArray(result)) {
						throw new Error("勤怠取得レスポンスの形式エラー");
					}

					console.log("自分の勤怠記録:", result);

					attendanceRecords = result;

					renderMonthlyAttendance();

				} catch (error) {

					console.error("月次勤怠の取得エラー:", error);

					$("div[name='totalWorkDays']").text("-");
					$("div[name='lateEarlyCount']").text("-");
					$("div[name='absentDays']").text("-");
					$("div[name='overtimeTotal']").text("-");

					$("tbody[name='monthlyAttendanceRows']").empty().append(
							$("<tr>").append(
									$("<td>").attr("colspan", 7).addClass(
											"ma-empty").text(
											"勤怠記録を読み込めませんでした。")));
				}
			}

			// 월 변경 시 화면 다시 계산
			$("select[name='selectedMonth']").on("change",
					renderMonthlyAttendance);

			// 근태 현황 페이지 이동
			$("button[name='moveAttendanceButton']").on("click", function() {

				window.location.href = contextPath + "/attendance";
			});

			// 처음 페이지 열릴 때
			initMonthSelect();
			loadAttendance();

		});
