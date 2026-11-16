// ========================================
// 1. 로그인한 사원 정보 불러오기
// ========================================

const loadMyEditInfo = async () => {

    try {
        const response = await fetch(
            (document.body.getAttribute("data-context-path") || "") + "/api/employees/me"
        );

        if (!response.ok) {
            throw new Error("사원 정보 조회 실패: " + response.status);
        }

        const emp = await response.json();

        document.getElementById("loginUser").textContent =
            emp.ename + " 사원";

        const status = {
            ACTIVE: "재직",
            LEAVE: "휴직",
            RETIRED: "퇴직"
        }[emp.status] ?? "-";

        // 수정 불가능한 정보
        document.getElementById("empId").value = emp.empId ?? "";
        document.getElementById("ename").value = emp.ename ?? "";

        document.getElementById("departmentName").value =
            emp.department?.departmentName ?? "";

        document.getElementById("jobName").value =
            emp.job?.jobName ?? "";

        document.getElementById("hiredate").value = emp.hiredate
            ? new Date(emp.hiredate).toLocaleDateString("ko-KR")
            : "";

        document.getElementById("status").value = status;
        document.getElementById("statusBadge").textContent =
            status === "재직" ? "재직 중" : status;

        // 수정 가능한 정보
        document.getElementById("email").value = emp.email ?? "";
        document.getElementById("phone").value = emp.phone ?? "";

    } catch (error) {
        console.error("내 정보 조회 오류:", error);

        document.getElementById("myEditMessage").textContent =
            "사원 정보를 불러오지 못했습니다.";
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
    cancelText = "취소",
    confirmText = "확인",
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
            title: "입력 정보 확인",
            message: "이메일 형식이 올바르지 않습니다.",
            description: "이메일 주소를 다시 확인해 주세요."
        });
        return;
    }

    // 연락처 검사
    if (phone && !/^010-\d{4}-\d{4}$/.test(phone)) {

        showInfoModal({
            type: "error",
            title: "입력 정보 확인",
            message: "연락처 형식이 올바르지 않습니다.",
            description: "010-0000-0000 형식으로 입력해 주세요."
        });
        return;
    }

    // 저장 확인 팝업
    showInfoModal({
        type: "confirm",
        title: "내 정보 변경 확인",
        message: "수정한 이메일과 연락처를 저장하시겠습니까?",
        description: "본인 계정의 연락처 정보만 변경됩니다.",
        cancelText: "취소",
        confirmText: "변경사항 저장",
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
                errorResponse.message || "요청 처리에 실패했습니다."
            );
        }

        // 저장 완료 팝업
        showInfoModal({
            type: "success",
            title: "내 정보 수정 완료",
            message: "개인정보가 정상적으로 변경되었습니다.",
            description: "변경된 정보는 내 정보 화면에 반영됩니다.",
            cancelText: "닫기",
            confirmText: "내 정보 보기",
            onCancel: () => location.reload(),
            onConfirm: () => {
                location.href =
                    (document.body.getAttribute("data-context-path") || "") + "/employee/home";
            }
        });

    } catch (error) {
        console.error("정보 수정 오류:", error);

        showInfoModal({
            type: "error",
            title: "정보 수정 실패",
            message: "정보 수정 실패",
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
            title: "변경사항 취소",
            message: "저장하지 않은 변경사항이 있습니다.",
            description: "이 화면에서 나가면 변경 내용이 사라집니다.",
            cancelText: "계속 수정",
            confirmText: "변경 취소",
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
            "모든 항목을 입력해 주세요.";
        return;
    }

    if (newPassword.length < 8) {
        passwordMessage.textContent =
            "새 비밀번호는 8자 이상 입력해 주세요.";
        return;
    }

    if (newPassword !== confirm) {
        passwordMessage.textContent =
            "새 비밀번호가 일치하지 않습니다.";
        return;
    }

    if (current === newPassword) {
        passwordMessage.textContent =
            "현재 비밀번호와 다른 비밀번호를 입력해 주세요.";
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
                errorResponse.message || "요청 처리에 실패했습니다."
            );
        }

        closePasswordPopup();

        // 비밀번호 변경 완료 팝업
        showInfoModal({
            type: "success",
            title: "비밀번호 변경 완료",
            message: "비밀번호가 정상적으로 변경되었습니다.",
            description: "다음 로그인부터 새 비밀번호를 사용해 주세요.",
            cancelText: "닫기",
            confirmText: "확인"
        });

    } catch (error) {
        console.error("비밀번호 변경 오류:", error);
        passwordMessage.textContent = error.message;

    } finally {
        submitBtn.disabled = false;
    }
});
