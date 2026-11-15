$(function() {
			const contextPath = (document.body.getAttribute("data-context-path") || "");
			const pageSize = 5;

			let allRows = [];
			let filteredRows = [];

			let currentPage = 1;
			let lastDetailButton = null;

			// 로그인한 사원의 휴가 신청 내역 조회
			async function loadHistory() {

				try {

					const response = await
					fetch(contextPath + "/api/leave/my/requests", {
						method : "GET"
					});

					if (!response.ok) {
						throw new Error("휴가 신청 내역 조회 실패: " + response.status);
					}

					const records = await
					response.json();

					if (!Array.isArray(records)) {
						throw new Error("서버 응답 형식이 올바르지 않습니다.");
					}

					console.log("휴가 신청 내역 조회 결과", records);

					const tbody = $("tbody[name='historyRows']");
					tbody.empty();

					// 승인 상태를 한글로 변환
					const statusNames = {
						APPROVED : "승인 완료",
						PENDING : "승인 대기",
						REJECTED : "반려",
						CANCELED : "취소됨"
					};

					// DB에서 가져온 기록을 테이블에 추가
					records.forEach(function(row) {

						const submitted = row.submittedDate || "-";
						const startDate = row.startDate || "-";
						const endDate = row.endDate || "-";

						const period = startDate === endDate ? startDate
								: startDate + " ~ " + endDate;

						const leaveType = row.leaveType || "휴가";
						const days = row.days != null ? row.days + "일" : "-";
						const status = statusNames[row.status] || row.status
								|| "-";
						const remark = row.remark || "-";

						const tr = $("<tr>");

						tr.attr("data-submitted", submitted);
						tr.attr("data-status", row.status || "");

						$("<td>").text(submitted).appendTo(tr);
						$("<td>").text(leaveType).appendTo(tr);
						$("<td>").text(period).appendTo(tr);
						$("<td>").text(days).appendTo(tr);

						const statusTd = $("<td>");

						$("<span>").addClass("lh-status").text(status)
								.appendTo(statusTd);

						tr.append(statusTd);

						$("<td>").addClass("lh-remark").text(remark).appendTo(
								tr);

						const detailTd = $("<td>");

						$("<button>").attr("type", "button").attr("name",
								"detailButton").addClass("lh-detail-btn").text(
								"상세").appendTo(detailTd);

						tr.append(detailTd);
						tbody.append(tr);

					});

					// 실제 DB 데이터로 목록 갱신
					allRows = tbody.children("tr").toArray();

					$("#historyEmptyRow td").text("검색 결과가 없습니다.");

					filterHistory();

				} catch (error) {

					console.error("휴가 신청 내역 조회 오류", error);

					allRows = [];
					filteredRows = [];

					$("tbody[name='historyRows']").empty();

					$("#historyEmptyRow td").text("휴가 신청 내역을 불러오지 못했습니다.");

					renderHistory();

				}

			}

			function renderHistory() {
				const total = filteredRows.length;
				const totalPages = Math.max(1, Math.ceil(total / pageSize));
				currentPage = Math.max(1, Math.min(currentPage, totalPages));

				$("span[name='historyCount']").text("총 " + total + "건");
				$("span[name='historyFooterCount']").text("총 " + total + "건");
				$(allRows).hide();

				filteredRows.slice((currentPage - 1) * pageSize,
						currentPage * pageSize).forEach(function(row) {
					$(row).show();
				});
				$("#historyEmptyRow").toggle(total === 0);

				const pageNumberBox = $("span[name='pageNumbers']");
				pageNumberBox.empty();
				for (let page = 1; page <= totalPages; page++) {
					const button = $("<button>", {
						type : "button",
						"class" : "lh-page-btn"
								+ (page === currentPage ? " is-current" : ""),
						text : page,
						"aria-label" : page + "페이지",
						"aria-current" : page === currentPage ? "page" : null
					});
					button.on("click", function() {
						currentPage = page;
						renderHistory();
					});
					pageNumberBox.append(button);
				}
				$("button[name='previousPage']").prop("disabled",
						currentPage <= 1);
				$("button[name='nextPage']").prop("disabled",
						currentPage >= totalPages);
			}

			function filterHistory() {
				const startDate = $("input[name='filterStartDate']").val();
				const endDate = $("input[name='filterEndDate']").val();
				const status = $("select[name='filterStatus']").val();
				if (startDate && endDate && startDate > endDate) {
					alert("조회 종료일은 시작일보다 빠를 수 없습니다.");
					return;
				}
				// 현재는 Figma 예시 행을 필터링. REST API 연결 후 서버 데이터로 대체.
				filteredRows = allRows.filter(function(row) {
					const submitted = $(row).attr("data-submitted");
					const rowStatus = $(row).attr("data-status");
					return (!startDate || submitted >= startDate)
							&& (!endDate || submitted <= endDate)
							&& (status === "ALL" || status === rowStatus);
				});
				currentPage = 1;
				renderHistory();
			}

			$(
					"input[name='filterStartDate'], input[name='filterEndDate'], select[name='filterStatus']")
					.on("change", filterHistory);
			$("button[name='previousPage']").on("click", function() {
				if (currentPage > 1) {
					currentPage--;
					renderHistory();
				}
			});
			$("button[name='nextPage']").on("click", function() {
				if (currentPage < Math.ceil(filteredRows.length / pageSize)) {
					currentPage++;
					renderHistory();
				}
			});
			// 버튼 이동

			$("button[name='moveApplyButton']").on("click", function() {
				console.log("휴가 신청 버튼 클릭 성공");
				window.location.href = contextPath + "/leave/apply";
			});

			$("button[name='moveViewButton']").on("click", function() {
				console.log("휴가 목록 버튼 클릭 성공");
				window.location.href = contextPath + "/leave";
			});

			// .버튼 이용

			$("tbody[name='historyRows']").on(
					"click",
					"button[name='detailButton']",
					function() {

						lastDetailButton = this;
						const cells = $(this).closest("tr").children("td");
						$("dd[name='detailSubmitted']").text(
								$(cells[0]).text().trim());
						$("dd[name='detailType']").text(
								$(cells[1]).text().trim());
						$("dd[name='detailPeriod']").text(
								$(cells[2]).text().trim());
						$("dd[name='detailDays']").text(
								$(cells[3]).text().trim());
						$("dd[name='detailStatus']").text(
								$(cells[4]).text().trim());
						$("dd[name='detailRemark']").text(
								$(cells[5]).text().trim());
						$("#leaveDetailOverlay").addClass("is-open");
						$("button[name='closeDetail']").first()
								.trigger("focus");
					});

			function closeDetail() {
				$("#leaveDetailOverlay").removeClass("is-open");
				if (lastDetailButton)
					$(lastDetailButton).trigger("focus");
			}

			$("button[name='closeDetail']").on("click", closeDetail);

			$("#leaveDetailOverlay").on("click", function(event) {
				if (event.target === this)
					closeDetail();
			});
			$(document)
					.on(
							"keydown",
							function(event) {
								if (event.key === "Escape"
										&& $("#leaveDetailOverlay").hasClass(
												"is-open"))
									closeDetail();
							});

			loadHistory();

		});
