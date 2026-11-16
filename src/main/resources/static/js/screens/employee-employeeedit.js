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
            throw new Error("サーバーとの通信中にエラーが発生しました。");
        }

        if (response.status === 401 || response.redirected) {
            throw new Error(
                "ログイン情報の有効期限が切れました。 再度ログインしてください。"
            );
        }

        if (response.status === 403) {
            throw new Error(
                "リクエストが拒否されました。 ページを再読み込みしてから再度お試しください。"
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
                "リクエストの処理に失敗しました。 (HTTP " +
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
                "サーバーから想定外の画面が返されました。 リクエスト先とログイン状態を確認してください。"
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
                throw new Error("社員情報のレスポンスを確認できません。");
            }

            byId("loginUser").textContent =
                (emp.ename || "ユーザー") + " 社員";

            const status = {
                ACTIVE: "在籍",
                LEAVE: "休職",
                RETIRED: "退職"
            }[emp.status] || "-";

            byId("empId").value = emp.empId ?? "";
            byId("ename").value = emp.ename ?? "";

            byId("departmentName").value =
                window.hrmsJapaneseLabel(emp.department?.departmentName ?? "");

            byId("jobName").value =
                window.hrmsJapaneseLabel(emp.job?.jobName ?? "");

            byId("hiredate").value = emp.hiredate
                ? new Date(emp.hiredate).toLocaleDateString("ja-JP")
                : "";

            byId("status").value = status;

            byId("statusBadge").textContent =
                status === "在籍" ? "在籍中" : status;

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
        cancelText = "キャンセル",
        confirmText = "確認",
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

    // 이메일・연락처 실제 저장
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
                title: "プロフィールを更新しました",
                message: "変更しました。",
                description: "変更内容はプロフィール画面に反映されます。",
                cancelText: "閉じる",
                confirmText: "プロフィールを表示",
                onCancel: () => location.reload(),
                onConfirm: () => {
                    location.href = contextPath + "/employee/home";
                }
            });

        } catch (error) {
            showInfoModal({
                type: "error",
                title: "情報の更新に失敗しました",
                message: "情報を保存できませんでした。",
                description: error.message
            });

        } finally {
            infoSaving = false;
            byId("saveMyInfoBtn").disabled = false;
        }
    }

    // 이메일・연락처 변경 전 확인
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
                title: "入力内容の確認",
                message: "メールアドレスの形式が正しくありません。",
                description: "メールアドレスをもう一度確認してください。"
            });
            return;
        }

        if (phone && !/^010-\d{4}-\d{4}$/.test(phone)) {
            showInfoModal({
                type: "error",
                title: "入力内容の確認",
                message: "電話番号の形式が正しくありません。",
                description: "010-0000-0000 形式で入力してください。"
            });
            return;
        }

        showInfoModal({
            type: "confirm",
            title: "プロフィール変更の確認",
            message: "変更しますか？",
            description: "ご自身の連絡先情報のみ変更されます。",
            confirmText: "変更を保存",
            onConfirm: () => saveMyInfo(email, phone)
        });
    });

    // 수정 취소
    byId("cancelMyEditBtn").addEventListener("click", () => {
        showInfoModal({
            type: "warning",
            title: "変更を取り消す",
            message: "保存されていない変更があります。",
            description: "この画面を離れると変更内容が失われます。",
            cancelText: "編集を続ける",
            confirmText: "変更を取り消す",
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

        passwordSaving = true;

        byId("passwordSubmitBtn").disabled = true;
        byId("closePasswordModal").disabled = true;
        byId("cancelPasswordModal").disabled = true;

        try {
            // 확인을 누르기 전에는 서버 요청을 보내지 않는다.
            const confirmed = await new Promise(resolve => {
                showInfoModal({
                    type: "confirm",
                    title: "パスワード変更の確認",
                    message: "変更しますか？",
                    description: "確認を押すとパスワードが変更されます。",
                    cancelText: "キャンセル",
                    confirmText: "確認",
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
                title: "パスワードを変更しました",
                message: "変更しました。",
                description: "次回のログインから新しいパスワードをご使用ください。",
                cancelText: "閉じる",
                confirmText: "確認"
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
