(function () {
    const contextPath = (document.body.getAttribute("data-context-path") || "");
    const byId = id => document.getElementById(id);

    let infoSaving = false;
    let passwordSaving = false;

    async function requestApi(path, method = "GET", body) {
        const headers = {
            "Accept": "text/plain, application/json"
        };

        const options = {
            method: method,
            credentials: "same-origin",
            headers: headers
        };

        if (body !== undefined) {
            headers["Content-Type"] =
                "application/json; charset=UTF-8";

            options.body = JSON.stringify(body);
        }

        if (!/^(GET|HEAD|OPTIONS)$/i.test(method)) {
            const token =
                document.querySelector('meta[name="_csrf"]').content;

            const header =
                document.querySelector('meta[name="_csrf_header"]').content;

            if (token && header) {
                headers[header] = token;
            }
        }

        let response;

        try {
            response = await fetch(contextPath + path, options);
        } catch (error) {
            throw new Error("서버와의 통신 중 오류가 발생했습니다.");
        }

        if (response.status === 401 || response.redirected) {
            throw new Error(
                "로그인 정보가 만료되었습니다. 다시 로그인해 주세요."
            );
        }

        if (response.status === 403) {
            throw new Error(
                "요청이 거부되었습니다. 페이지를 새로고침한 뒤 다시 시도해 주세요."
            );
        }

        const contentType =
            response.headers.get("content-type") || "";

        const text = await response.text();
        let data = null;

        if (contentType.includes("json")) {
            try {
                data = JSON.parse(text);
            } catch (ignored) {
            }
        }

        if (!response.ok || (data && data.success === false)) {
            let message =
                "요청 처리에 실패했습니다. (HTTP " +
                response.status + ")";

            if (
                data &&
                typeof data.message === "string" &&
                data.message
            ) {
                message = data.message;

            } else if (
                contentType.includes("text/plain") &&
                text.trim()
            ) {
                message = text;
            }

            throw new Error(message);
        }

        if (contentType.includes("text/html")) {
            throw new Error(
                "서버에서 예상하지 못한 화면을 반환했습니다. 요청 주소와 로그인 상태를 확인해 주세요."
            );
        }

        return data !== null ? data : text;
    }

    // 내 정보 조회
    async function loadMyEditInfo() {
        try {
            const emp = await requestApi("/api/employees/me");

            if (
                !emp ||
                typeof emp !== "object" ||
                Array.isArray(emp)
            ) {
                throw new Error("사원 정보 응답을 확인할 수 없습니다.");
            }

            byId("loginUser").textContent =
                (emp.ename || "사용자") + " 사원";

            const status = {
                ACTIVE: "재직",
                LEAVE: "휴직",
                RETIRED: "퇴직"
            }[emp.status] || "-";

            byId("empId").value = emp.empId ?? "";
            byId("ename").value = emp.ename ?? "";

            byId("departmentName").value =
                emp.department?.departmentName ?? "";

            byId("jobName").value =
                emp.job?.jobName ?? "";

            byId("hiredate").value = emp.hiredate
                ? new Date(emp.hiredate).toLocaleDateString("ko-KR")
                : "";

            byId("status").value = status;

            byId("statusBadge").textContent =
                status === "재직" ? "재직 중" : status;

            byId("email").value = emp.email ?? "";
            byId("phone").value = emp.phone ?? "";

        } catch (error) {
            byId("myEditMessage").textContent = error.message;
        }
    }

    // 공통 팝업
    function showInfoModal({
        type = "confirm",
        title,
        message,
        description = "",
        cancelText = "취소",
        confirmText = "확인",
        onCancel,
        onConfirm
    }) {
        const modal = byId("myInfoModal");
        const icon = byId("infoModalIcon");
        const cancelBtn = byId("infoModalCancel");
        const confirmBtn = byId("infoModalConfirm");

        icon.textContent = {
            confirm: "?",
            success: "✓",
            warning: "!",
            error: "!"
        }[type];

        icon.className = "info-modal-icon " + type;

        byId("infoModalTitle").textContent = title;
        byId("infoModalMessage").textContent = message;
        byId("infoModalDescription").textContent = description;

        cancelBtn.textContent = cancelText;
        confirmBtn.textContent = confirmText;

        cancelBtn.style.display =
            type === "error" ? "none" : "";

        modal.classList.add("show");

        cancelBtn.onclick = () => {
            modal.classList.remove("show");

            if (onCancel) {
                onCancel();
            }
        };

        confirmBtn.onclick = () => {
            modal.classList.remove("show");

            if (onConfirm) {
                onConfirm();
            }
        };
    }

    // 이메일·연락처 실제 저장
    async function saveMyInfo(email, phone) {
        if (infoSaving) {
            return;
        }

        infoSaving = true;
        byId("saveMyInfoBtn").disabled = true;

        try {
            await requestApi(
                "/api/employees/me",
                "PUT",
                { email, phone }
            );

            showInfoModal({
                type: "success",
                title: "내 정보 수정 완료",
                message: "변경이 완료되었습니다.",
                description: "변경된 정보는 내 정보 화면에 반영됩니다.",
                cancelText: "닫기",
                confirmText: "내 정보 보기",
                onCancel: () => location.reload(),
                onConfirm: () => {
                    location.href = contextPath + "/employee/home";
                }
            });

        } catch (error) {
            showInfoModal({
                type: "error",
                title: "정보 수정 실패",
                message: "정보를 저장하지 못했습니다.",
                description: error.message
            });

        } finally {
            infoSaving = false;
            byId("saveMyInfoBtn").disabled = false;
        }
    }

    // 이메일·연락처 변경 전 확인
    byId("myInfoEditForm").addEventListener("submit", event => {
        event.preventDefault();

        if (infoSaving) {
            return;
        }

        const email = byId("email").value.trim();
        const phone = byId("phone").value.trim();

        if (
            !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ||
            email.length > 40
        ) {
            showInfoModal({
                type: "error",
                title: "입력 정보 확인",
                message: "이메일 형식이 올바르지 않습니다.",
                description: "이메일 주소를 다시 확인해 주세요."
            });
            return;
        }

        if (phone && !/^010-\d{4}-\d{4}$/.test(phone)) {
            showInfoModal({
                type: "error",
                title: "입력 정보 확인",
                message: "연락처 형식이 올바르지 않습니다.",
                description: "010-0000-0000 형식으로 입력해 주세요."
            });
            return;
        }

        showInfoModal({
            type: "confirm",
            title: "내 정보 변경 확인",
            message: "변경하시겠습니까?",
            description: "본인 계정의 연락처 정보만 변경됩니다.",
            confirmText: "변경사항 저장",
            onConfirm: () => saveMyInfo(email, phone)
        });
    });

    // 수정 취소
    byId("cancelMyEditBtn").addEventListener("click", () => {
        showInfoModal({
            type: "warning",
            title: "변경사항 취소",
            message: "저장하지 않은 변경사항이 있습니다.",
            description: "이 화면에서 나가면 변경 내용이 사라집니다.",
            cancelText: "계속 수정",
            confirmText: "변경 취소",
            onConfirm: () => {
                location.href = contextPath + "/employee/home";
            }
        });
    });

    const passwordModal = byId("passwordModal");
    const passwordForm = byId("passwordChangeForm");
    const passwordMessage = byId("passwordMessage");

    function closePasswordPopup() {
        passwordModal.classList.remove("show");
        passwordForm.reset();
        passwordMessage.textContent = "";
    }

    byId("passwordChangeBtn").addEventListener("click", () => {
        if (passwordSaving) {
            return;
        }

        passwordForm.reset();
        passwordMessage.textContent = "";
        passwordModal.classList.add("show");
    });

    byId("closePasswordModal").addEventListener(
        "click",
        closePasswordPopup
    );

    byId("cancelPasswordModal").addEventListener(
        "click",
        closePasswordPopup
    );

    // 비밀번호 변경
    passwordForm.addEventListener("submit", async event => {
        event.preventDefault();

        if (passwordSaving) {
            return;
        }

        const current = byId("currentPassword").value;
        const newPassword = byId("newPassword").value;
        const confirm = byId("confirmPassword").value;

        passwordMessage.textContent = "";

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

        passwordSaving = true;

        byId("passwordSubmitBtn").disabled = true;
        byId("closePasswordModal").disabled = true;
        byId("cancelPasswordModal").disabled = true;

        try {
            // 확인을 누르기 전에는 서버 요청을 보내지 않는다.
            const confirmed = await new Promise(resolve => {
                showInfoModal({
                    type: "confirm",
                    title: "비밀번호 변경 확인",
                    message: "변경하시겠습니까?",
                    description: "확인을 누르면 비밀번호가 변경됩니다.",
                    cancelText: "취소",
                    confirmText: "확인",
                    onCancel: () => resolve(false),
                    onConfirm: () => resolve(true)
                });
            });

            if (!confirmed) {
                return;
            }

            await requestApi(
                "/api/accounts/me/password",
                "PUT",
                {
                    currentPassword: current,
                    newPassword: newPassword
                }
            );

            closePasswordPopup();

            showInfoModal({
                type: "success",
                title: "비밀번호 변경 완료",
                message: "변경이 완료되었습니다.",
                description: "다음 로그인부터 새 비밀번호를 사용해 주세요.",
                cancelText: "닫기",
                confirmText: "확인"
            });

        } catch (error) {
            passwordMessage.textContent = error.message;

        } finally {
            passwordSaving = false;

            byId("passwordSubmitBtn").disabled = false;
            byId("closePasswordModal").disabled = false;
            byId("cancelPasswordModal").disabled = false;
        }
    });

    if (document.readyState === "loading") {
        document.addEventListener(
            "DOMContentLoaded",
            loadMyEditInfo
        );
    } else {
        loadMyEditInfo();
    }
}());
