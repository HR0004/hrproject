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

				if (link.textContent.includes("03 사원 관리")) {
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
	            throw new Error("사원 상세조회 실패");
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
	            ? new Date(result.hiredate).toLocaleDateString("ko-KR")
	            : "-";

	        $("#detailHiredate").text(hiredate);

	        // 재직 상태
	        const status = {
	            ACTIVE: "재직",
	            LEAVE: "휴직",
	            RETIRED: "퇴직"
	        }[result.status] ?? "미확인";

	        $("#detailStatus").text(status);
	        $("#summaryStatus").text(status);

	        $("#detailStatusBadge")
	            .removeClass("is-active is-leave is-retired")
	            .addClass({
	                ACTIVE: "is-active",
	                LEAVE: "is-leave",
	                RETIRED: "is-retired"
	            }[result.status] ?? "");

	        console.log("사원 상세정보:", result);

	    } catch (error) {
	        console.error("사원 상세조회 오류:", error);
	        $(".employee-detail-summary, .employee-detail-info, .employee-detail-actions").hide();
	        $(".employee-detail-heading").after(
	            $("<section>")
	                .addClass("employee-detail-card employee-detail-not-found")
	                .text("사원 정보를 불러올 수 없습니다. 사번을 확인해 주세요.")
	        );
	    }
	};

	getEmpDetail();

	// 퇴직 처리 팝업
	const showRetirePopup = (type, emp = {}) => {

	    const popups = {

	        confirm: {
	            icon: "⚠️",
	            title: "퇴직 처리 확인",
	            message: "선택한 사원을 퇴직 처리하시겠습니까?",
	            detail: "사번 " + emp.empId
	                  + " · 성명 " + emp.ename
	                  + " · 현재 상태 재직",
	            button: "퇴직 처리"
	        },

	        success: {
	            icon: "✅",
	            title: "퇴직 처리 완료",
	            message: "재직 상태가 퇴직으로 변경되었습니다.",
	            detail: "사원 기록은 삭제되지 않고 보관됩니다.",
	            button: "닫기"
	        },

	        error: {
	            icon: "❗",
	            title: "퇴직 처리 불가",
	            message: "이미 퇴직 처리된 사원입니다.",
	            detail: "현재 재직 상태를 확인해 주세요.",
	            button: "확인"
	        },

	        fail: {
	            icon: "❗",
	            title: "퇴직 처리 실패",
	            message: "퇴직 처리 중 오류가 발생했습니다.",
	            detail: "잠시 후 다시 시도해 주세요.",
	            button: "확인"
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
	            throw new Error("사원 조회 실패");
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
	        console.error("사원 조회 오류:", error);
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
	            throw new Error("퇴직 처리 실패");
	        }

	        // 퇴직 성공 팝업
	        showRetirePopup("success");

	    } catch (error) {
	        console.error("퇴직 처리 오류:", error);
	        showRetirePopup("fail");

	    } finally {
	        $("#retireBtn").prop("disabled", false);
	    }
	};


	// 퇴직 처리 버튼 이벤트
	$(function() {
	    $("#retireBtn").on("click", retireEmployee);
	});
