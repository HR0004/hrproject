// 사원 정보 수정 화면으로 이동
	function editEmployee() {

	    const empId = location.pathname.split("/").filter(Boolean).pop();

	    location.href =
	        (document.body.getAttribute("data-context-path") || "") + "/employees/"
	        + empId + "/edit";
	}


			
		

		// 사이드바의 사원 관리 메뉴 활성화
		document.addEventListener("DOMContentLoaded", function() {

			const links = document.querySelectorAll(".main-sidebar .nav-link");

			links.forEach(function(link) {

				link.classList.remove("active");

				if (link.textContent.includes("03 社員管理")) {
					link.classList.add("active");
				}

			});

		});

/* 사원 상세조회 */
	const getEmpDetail = async () => {
	    try {
	        const empId = window.location.pathname.split("/").pop();

	        const response = await fetch(
	            (document.body.getAttribute("data-context-path") || "") + "/api/employees/" + empId,
	            { method: "GET" }
	        );

	        if (!response.ok) {
	            throw new Error("社員詳細の取得に失敗しました");
	        }

	        const result = await response.json();

	    	 // 사원 요약 정보
	        $("#summaryName").text(result.ename);
	        $("#summaryEmpId").text(result.empId);
	        $("#summaryDept").text(result.department?.departmentName ?? "-");
	        $("#summaryJob").text(result.job?.jobName ?? "-");

	        // 사원 기본 정보
	        $("#detailEmpId").text(result.empId);
	        $("#detailName").text(result.ename);
	        $("#detailDept").text(result.department?.departmentName ?? "-");
	        $("#detailJob").text(result.job?.jobName ?? "-");
	        $("#detailEmail").text(result.email ?? "-");
	        $("#detailPhone").text(result.phone ?? "-");

	        const hiredate = result.hiredate
	            ? new Date(result.hiredate).toLocaleDateString("ja-JP")
	            : "-";

	        $("#detailHiredate").text(hiredate);

	        // 재직 상태
	        const status = {
	            ACTIVE: "在籍",
	            LEAVE: "休職",
	            RETIRED: "退職"
	        }[result.status] ?? "未確認";

	        $("#detailStatus").text(status);
	        $("#summaryStatus").text(status);

	        $("#detailStatusBadge")
	            .removeClass("is-active is-leave is-retired")
	            .addClass({
	                ACTIVE: "is-active",
	                LEAVE: "is-leave",
	                RETIRED: "is-retired"
	            }[result.status] ?? "");

	        console.log("社員の詳細情報:", result);

	    } catch (error) {
	        console.error("社員詳細の取得エラー:", error);
	        $(".employee-detail-summary, .employee-detail-info, .employee-detail-actions").hide();
	        $(".employee-detail-heading").after(
	            $("<section>")
	                .addClass("employee-detail-card employee-detail-not-found")
	                .text("社員情報を読み込めません。 社員番号を確認してください。")
	        );
	    }
	};

	getEmpDetail();

	// 퇴직 처리 팝업
	const showRetirePopup = (type, emp = {}) => {

	    const popups = {

	        confirm: {
	            icon: "⚠️",
	            title: "退職処理の確認",
	            message: "選択した社員の退職処理を行いますか？",
	            detail: "社員番号 " + emp.empId
	                  + " ・ 氏名 " + emp.ename
	                  + " ・ 現在の在籍状態",
	            button: "退職処理"
	        },

	        success: {
	            icon: "✅",
	            title: "退職処理が完了しました",
	            message: "在籍状態を退職に変更しました。",
	            detail: "社員の記録は削除せずに保管されます。",
	            button: "閉じる"
	        },

	        error: {
	            icon: "❗",
	            title: "退職処理できません",
	            message: "この社員はすでに退職処理済みです。",
	            detail: "現在の在籍状態を確認してください。",
	            button: "確認"
	        },

	        fail: {
	            icon: "❗",
	            title: "退職処理に失敗しました",
	            message: "退職処理中にエラーが発生しました。",
	            detail: "しばらくしてから再度お試しください。",
	            button: "確認"
	        }
	    };

	    const popup = popups[type];

	    if (!popup) return;

	    $("#retirePopupIcon").text(popup.icon);
	    $("#retirePopupTitle").text(popup.title);
	    $("#retirePopupMessage").text(popup.message);
	    $("#retirePopupDetail").text(popup.detail);
	    $("#retirePopupAction").text(popup.button);

	    // 확인 팝업에서만 취소 버튼 표시
	    $("#retirePopupCancel").toggle(type === "confirm");

	    $("#retirePopupAction").off("click").on("click", () => {

	        if (type === "confirm") {

	            // 팝업이 완전히 닫힌 후 API 요청
	            $("#retirePopup").one("hidden.bs.modal", () => {
	                executeRetire(emp.empId);
	            });

	            $("#retirePopup").modal("hide");
	            return;
	        }

	        if (type === "success") {
	            location.href =
	                (document.body.getAttribute("data-context-path") || "") + "/employees";
	            return;
	        }

	        $("#retirePopup").modal("hide");
	    });

	    $("#retirePopup").modal("show");
	};


	// 퇴직 처리 버튼 클릭
	const retireEmployee = async () => {

	    const empId = location.pathname.split("/").filter(Boolean).pop();

	    try {
	        // 최신 사원 상태 조회
	        const response = await fetch(
	            (document.body.getAttribute("data-context-path") || "") + "/api/employees/" + empId
	        );

	        if (!response.ok) {
	            throw new Error("社員情報の取得に失敗しました");
	        }

	        const emp = await response.json();

	        // 이미 퇴직한 사원
	        if (emp.status === "RETIRED") {
	            showRetirePopup("error");
	            return;
	        }

	        // 퇴직 확인 팝업
	        showRetirePopup("confirm", emp);

	    } catch (error) {
	        console.error("社員情報の取得エラー:", error);
	        showRetirePopup("fail");
	    }
	};


	// 실제 퇴직 처리 API 요청
	const executeRetire = async (empId) => {

	    $("#retireBtn").prop("disabled", true);

	    try {
	        const response = await fetch(
	            (document.body.getAttribute("data-context-path") || "") + "/api/employees/"
	            + empId + "/retire",
	            {
	                method: "PATCH"
	            }
	        );

	        // 이미 퇴직한 사원이거나 처리할 수 없는 상태
	        if (response.status === 409) {
	            showRetirePopup("error");
	            return;
	        }

	        if (!response.ok) {
	            throw new Error("退職処理に失敗しました");
	        }

	        // 퇴직 성공 팝업
	        showRetirePopup("success");

	    } catch (error) {
	        console.error("退職処理エラー:", error);
	        showRetirePopup("fail");

	    } finally {
	        $("#retireBtn").prop("disabled", false);
	    }
	};


	// 퇴직 처리 버튼 이벤트
	$(function() {
	    $("#retireBtn").on("click", retireEmployee);
	});
