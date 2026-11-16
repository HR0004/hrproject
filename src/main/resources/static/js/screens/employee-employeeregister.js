/* 사원 신규 등록 */
const registerEmployee = async () => {

    const emp = {
        ename: $("#ename").val().trim(),
        email: $("#email").val().trim(),
        phone: $("#phone").val().trim(),
        hiredate: $("#hiredate").val(),
        departmentId: Number($("#departmentId").val()),
        jobId: Number($("#jobId").val()),
        status: $("#status").val()
    };
    
    const account = {
    		emp:emp, loginId:$("#loginId").val().trim(),
    		password : $("#password").val()
    };

    try {
        $("#registerBtn").prop("disabled", true);

        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/employees/register",
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(account)
            }
        );

        if (!response.ok) {

            const message = await response.text();

            console.error("사원 등록 HTTP 상태:", response.status);
            console.error("서버 응답:", message);

            throw new Error(
                "사원 등록 실패 (HTTP " + response.status + ")"
            );
        }

        showRegisterPopup("success", {
            ename: emp.ename
        });
        
    } catch (error) {

        console.error("사원 등록 오류:", error);

        if (error.message.includes("이미 사용중인 로그인 ID")) {
            showRegisterPopup("duplicate");
        } else {
            $("#registerMessage").text(error.message);
            alert("사원 등록 중 오류가 발생했습니다.");
        }

    
       

    } finally {
        $("#registerBtn").prop("disabled", false);
    }
};
/* 등록 버튼 */
$("#employeeRegisterForm").on("submit", function(event) {

    event.preventDefault();

    // 필수 입력값 검사
    if (!this.checkValidity()) {
        showRegisterPopup("required");
        return;
    }

    // 입력한 사원 정보
    const ename = $("#ename").val().trim();
    const loginId = $("#loginId").val().trim();

    if (!ename || !loginId) {
        showRegisterPopup("required");
        return;
    }

    // 등록 확인 팝업
    showRegisterPopup("confirm", {
        ename: ename,
        loginId: loginId,
        onConfirm: registerEmployee
    });
});

/* 사이드바 사원 관리 메뉴 활성화 */
$(function() {

    $(".main-sidebar .nav-link").each(function() {

        $(this).toggleClass(
            "active",
            $(this).text().includes("03 사원 관리")
        );

    });

});


//사원 등록 팝업
const showRegisterPopup = (type, data = {}) => {

    const popups = {

        confirm: {
            icon: "❔",
            title: "신규 사원 등록 확인",
            message: "입력한 사원 정보를 등록하시겠습니까?",
            detail: "성명 " + (data.ename ?? "-") + " · 로그인 ID " + (data.loginId ?? "-"),
            button: "등록하기"
        },

        duplicate: {
            icon: "❗",
            title: "로그인 ID 중복 안내",
            message: "이미 사용 중인 로그인 ID입니다.",
            detail: "다른 로그인 ID를 입력해 주세요.",
            button: "닫기"
        },

        required: {
            icon: "❗",
            title: "필수 입력 항목 확인",
            message: "입력하지 않은 필수 항목이 있습니다.",
            detail: "필수 입력 항목을 확인해 주세요.",
            button: "확인"
        },

        success: {
            icon: "✅",
            title: "사원 등록 완료",
            message: "신규 사원이 정상적으로 등록되었습니다.",
            detail: "성명 " + (data.ename ?? "-"),
            button: "사원 목록 보기"
        }
    };

    const popup = popups[type];

    if (!popup) return;

    $("#popupIcon").text(popup.icon);
    $("#popupTitle").text(popup.title);
    $("#popupMessage").text(popup.message);
    $("#popupDetail").text(popup.detail);
    $("#popupAction").text(popup.button);

    // 확인 팝업과 완료 팝업만 보조 버튼 표시
    $("#popupCancel").toggle(
        type === "confirm" || type === "success"
    );

    $("#popupAction").off("click").on("click", () => {

        // 등록 확인 팝업
        if (type === "confirm") {

            // 팝업이 완전히 닫힌 다음 등록 실행
            $("#registerPopup").one("hidden.bs.modal", () => {
                if (data.onConfirm) {
                    data.onConfirm();
                }
            });

            $("#registerPopup").modal("hide");
            return;
        }

        // 등록 완료 팝업
        if (type === "success") {
            location.href =
                (document.body.getAttribute("data-context-path") || "") + "/employees";
            return;
        }

        // 중복 오류, 필수값 오류 팝업
        $("#registerPopup").modal("hide");

    });
    $("#registerPopup").modal("show");
};
