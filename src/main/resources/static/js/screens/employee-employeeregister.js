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

            console.error("社員登録 HTTP 状態:", response.status);
            console.error("サーバーのレスポンス:", message);

            throw new Error(
                "社員の登録に失敗しました (HTTP " + response.status + ")"
            );
        }

        showRegisterPopup("success", {
            ename: emp.ename
        });
        
    } catch (error) {

        console.error("社員登録エラー:", error);

        if (error.message.includes("すでに使用されているログイン ID")) {
            showRegisterPopup("duplicate");
        } else {
            $("#registerMessage").text(error.message);
            alert("社員の登録中にエラーが発生しました。");
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
            $(this).text().includes("03 社員管理")
        );

    });

});


//사원 등록 팝업
const showRegisterPopup = (type, data = {}) => {

    const popups = {

        confirm: {
            icon: "❔",
            title: "新規社員登録の確認",
            message: "入力した社員情報を登録しますか？",
            detail: "氏名 " + (data.ename ?? "-") + " ・ ログイン ID " + (data.loginId ?? "-"),
            button: "登録する"
        },

        duplicate: {
            icon: "❗",
            title: "ログイン ID 重複のお知らせ",
            message: "すでに使用されているログイン IDです。",
            detail: "別のログイン IDを入力してください。",
            button: "閉じる"
        },

        required: {
            icon: "❗",
            title: "必須項目の確認",
            message: "未入力の必須項目があります。",
            detail: "必須項目を確認してください。",
            button: "確認"
        },

        success: {
            icon: "✅",
            title: "社員を登録しました",
            message: "新規社員を登録しました。",
            detail: "氏名 " + (data.ename ?? "-"),
            button: "社員一覧を表示"
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
