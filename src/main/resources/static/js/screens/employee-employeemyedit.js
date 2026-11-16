// ========================================
// 1. 로그인한 사원 정보 불러오기
// ========================================

const loadMyEditInfo = async () => {

    try {
        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/employees/me"
        );

        if (!response.ok) {
            throw new Error("社員情報の取得に失敗しました: " + response.status);
        }

        const emp = await response.json();

        document.getElementById("loginUser").textContent =
            emp.ename + " 社員";

        const status = {
            ACTIVE: "在籍",
            LEAVE: "休職",
            RETIRED: "退職"
        }[emp.status] ?? "-";

        // 수정 불가능한 정보
        document.getElementById("empId").value = emp.empId ?? "";
        document.getElementById("ename").value = emp.ename ?? "";

        document.getElementById("departmentName").value =
            window.hrmsJapaneseLabel(emp.department?.departmentName ?? "");

        document.getElementById("jobName").value =
            window.hrmsJapaneseLabel(emp.job?.jobName ?? "");

        document.getElementById("hiredate").value = emp.hiredate
            ? new Date(emp.hiredate).toLocaleDateString("ja-JP")
            : "";

        document.getElementById("status").value = status;
        document.getElementById("statusBadge").textContent =
            status === "在籍" ? "在籍中" : status;

        // 수정 가능한 정보
        document.getElementById("email").value = emp.email ?? "";
        document.getElementById("phone").value = emp.phone ?? "";

    } catch (error) {
        console.error("プロフィールの取得エラー:", error);

        document.getElementById("myEditMessage").textContent =
            "社員情報を読み込めませんでした。";
    }
};

document.addEventListener("DOMContentLoaded", loadMyEditInfo);


// ========================================
// 2. 공통 팝업
// ========================================

const showInfoModal = ({
    type = "confirm",
    title,
    message,
    description,
    cancelText = "キャンセル",
    confirmText = "確認",
    onCancel,
    onConfirm
}) => {

    const modal = document.getElementById("myInfoModal");
    const icon = document.getElementById("infoModalIcon");
    const cancelBtn = document.getElementById("infoModalCancel");
    const confirmBtn = document.getElementById("infoModalConfirm");

    const icons = {
        confirm: "?",
        success: "✓",
        warning: "!",
        error: "!"
    };

    icon.textContent = icons[type];
    icon.className = "info-modal-icon " + type;

    document.getElementById("infoModalTitle").textContent = title;
    document.getElementById("infoModalMessage").textContent = message;
    document.getElementById("infoModalDescription").textContent = description;

    cancelBtn.textContent = cancelText;
    confirmBtn.textContent = confirmText;

    // 오류 팝업은 확인 버튼만 표시
    cancelBtn.style.display = type === "error" ? "none" : "";

    modal.classList.add("show");

    const closeModal = () => {
        modal.classList.remove("show");
    };

    cancelBtn.onclick = () => {
        closeModal();

        if (onCancel) {
            onCancel();
        }
    };

    confirmBtn.onclick = () => {
        closeModal();

        if (onConfirm) {
            onConfirm();
        }
    };
};


// ========================================
// 3. 내 정보 수정 - 저장 확인
// ========================================

const myInfoForm = document.getElementById("myInfoEditForm");

myInfoForm.noValidate = true;

myInfoForm.addEventListener("submit", (event) => {
    event.preventDefault();

    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();

    // 이메일 검사
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailRegex.test(email) || email.length > 40) {

        showInfoModal({
            type: "error",
            title: "入力内容の確認",
            message: "メールアドレスの形式が正しくありません。",
            description: "メールアドレスをもう一度確認してください。"
        });
        return;
    }

    // 연락처 검사
    if (phone && !/^010-\d{4}-\d{4}$/.test(phone)) {

        showInfoModal({
            type: "error",
            title: "入力内容の確認",
            message: "電話番号の形式が正しくありません。",
            description: "010-0000-0000 形式で入力してください。"
        });
        return;
    }

    // 저장 확인 팝업
    showInfoModal({
        type: "confirm",
        title: "プロフィール変更の確認",
        message: "変更したメールアドレスと電話番号を保存しますか？",
        description: "ご自身の連絡先情報のみ変更されます。",
        cancelText: "キャンセル",
        confirmText: "変更を保存",
        onConfirm: () => saveMyInfo(email, phone)
    });
});


// ========================================
// 4. 실제 DB 저장
// ========================================

const saveMyInfo = async (email, phone) => {

    const saveBtn = document.getElementById("saveMyInfoBtn");
    saveBtn.disabled = true;

    try {
        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/employees/me",
            {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    email: email,
                    phone: phone
                })
            }
        );

        if (!response.ok) {
            const errorResponse = await response.json();

            throw new Error(
                errorResponse.message || "リクエストの処理に失敗しました。"
            );
        }

        // 저장 완료 팝업
        showInfoModal({
            type: "success",
            title: "プロフィールを更新しました",
            message: "個人情報を更新しました。",
            description: "変更内容はプロフィール画面に反映されます。",
            cancelText: "閉じる",
            confirmText: "プロフィールを表示",
            onCancel: () => location.reload(),
            onConfirm: () => {
                location.href =
                    (document.body.getAttribute("data-context-path") || "") + "/employee/home";
            }
        });

    } catch (error) {
        console.error("情報更新エラー:", error);

        showInfoModal({
            type: "error",
            title: "情報の更新に失敗しました",
            message: "情報の更新に失敗しました",
            description: error.message
        });

    } finally {
        saveBtn.disabled = false;
    }
};


// ========================================
// 5. 변경사항 취소 팝업
// ========================================

document.getElementById("cancelMyEditBtn")
    .addEventListener("click", () => {

        showInfoModal({
            type: "warning",
            title: "変更を取り消す",
            message: "保存されていない変更があります。",
            description: "この画面を離れると変更内容が失われます。",
            cancelText: "編集を続ける",
            confirmText: "変更を取り消す",
            onConfirm: () => {
                location.href =
                    (document.body.getAttribute("data-context-path") || "") + "/employee/home";
            }
        });
    });


// ========================================
// 6. 비밀번호 변경 팝업
// ========================================

const passwordModal = document.getElementById("passwordModal");
const passwordForm = document.getElementById("passwordChangeForm");
const passwordMessage = document.getElementById("passwordMessage");

// 팝업 닫기
const closePasswordPopup = () => {
    passwordModal.classList.remove("show");
    passwordForm.reset();
    passwordMessage.textContent = "";
};

// 팝업 열기
document.getElementById("passwordChangeBtn")
    .addEventListener("click", () => {
        passwordModal.classList.add("show");
    });

// X 버튼
document.getElementById("closePasswordModal")
    .addEventListener("click", closePasswordPopup);

// 취소 버튼
document.getElementById("cancelPasswordModal")
    .addEventListener("click", closePasswordPopup);


// ========================================
// 7. 비밀번호 변경 API
// ========================================

passwordForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    const current =
        document.getElementById("currentPassword").value;

    const newPassword =
        document.getElementById("newPassword").value;

    const confirm =
        document.getElementById("confirmPassword").value;

    passwordMessage.style.color = "#bc3545";
    passwordMessage.textContent = "";

    // 입력값 검사
    if (!current || !newPassword || !confirm) {
        passwordMessage.textContent =
            "すべての項目を入力してください。";
        return;
    }

    if (newPassword.length < 8) {
        passwordMessage.textContent =
            "新しいパスワードは 8文字以上で入力してください。";
        return;
    }

    if (newPassword !== confirm) {
        passwordMessage.textContent =
            "新しいパスワードが一致しません。";
        return;
    }

    if (current === newPassword) {
        passwordMessage.textContent =
            "現在のパスワードとは異なるパスワードを入力してください。";
        return;
    }

    const submitBtn =
        passwordForm.querySelector('button[type="submit"]');

    submitBtn.disabled = true;

    try {
        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/accounts/me/password",
            {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    currentPassword: current,
                    newPassword: newPassword
                })
            }
        );

        if (!response.ok) {
            const errorResponse = await response.json();

            throw new Error(
                errorResponse.message || "リクエストの処理に失敗しました。"
            );
        }

        closePasswordPopup();

        // 비밀번호 변경 완료 팝업
        showInfoModal({
            type: "success",
            title: "パスワードを変更しました",
            message: "パスワードを変更しました。",
            description: "次回のログインから新しいパスワードをご使用ください。",
            cancelText: "閉じる",
            confirmText: "確認"
        });

    } catch (error) {
        console.error("パスワード変更エラー:", error);
        passwordMessage.textContent = error.message;

    } finally {
        submitBtn.disabled = false;
    }
});
