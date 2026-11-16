(function () {
        const form = document.getElementById("password-form");
        const button = document.getElementById("password-submit");
        const messageBox = document.getElementById("password-message");

        let submitting = false;

        function showMessage(message, success) {
            messageBox.textContent = message;
            messageBox.className =
                "password-message " +
                (success ? "password-success" : "password-error");

            messageBox.setAttribute(
                "role",
                success ? "status" : "alert"
            );

            messageBox.hidden = false;
        }

        form.addEventListener("submit", async function (event) {
            event.preventDefault();

            if (submitting) {
                return;
            }

            messageBox.hidden = true;

            const currentPassword =
                document.getElementById("current-password").value;

            const newPassword =
                document.getElementById("new-password").value;

            const confirmPassword =
                document.getElementById("confirm-password").value;

            if (!currentPassword || !newPassword || !confirmPassword) {
                showMessage("비밀번호를 모두 입력해 주세요.", false);
                return;
            }

            if (newPassword.length < 8) {
                showMessage("새 비밀번호는 8자 이상이어야 합니다.", false);
                return;
            }

            if (newPassword !== confirmPassword) {
                showMessage(
                    "새 비밀번호와 확인 값이 일치하지 않습니다.",
                    false
                );
                return;
            }

            if (currentPassword === newPassword) {
                showMessage(
                    "현재 비밀번호와 다른 비밀번호를 입력해 주세요.",
                    false
                );
                return;
            }

            const headers = {
                "Content-Type": "application/json; charset=UTF-8",
                "Accept": "text/plain, application/json"
            };

            const csrfToken =
                document.querySelector('meta[name="_csrf"]').content;

            const csrfHeader =
                document.querySelector('meta[name="_csrf_header"]').content;

            if (csrfHeader && csrfToken) {
                headers[csrfHeader] = csrfToken;
            }

            submitting = true;
            button.disabled = true;
            button.textContent = "변경 중...";

            try {
                const response = await fetch(form.action, {
                    method: "PUT",
                    credentials: "same-origin",
                    headers: headers,
                    body: JSON.stringify({
                        currentPassword: currentPassword,
                        newPassword: newPassword
                    })
                });

                if (response.status === 401 || response.redirected) {
                    showMessage("다시 로그인한 후 변경해 주세요.", false);
                    return;
                }

                if (response.status === 403) {
                    showMessage(
                        "요청이 거부되었습니다. 페이지를 새로고침한 뒤 다시 시도해 주세요.",
                        false
                    );
                    return;
                }

                const contentType =
                    response.headers.get("content-type") || "";

                const text = await response.text();

                let result = null;

                try {
                    result = JSON.parse(text);
                } catch (ignored) {
                }

                if (!response.ok || (result && result.success === false)) {
                    let message =
                        "비밀번호를 변경하지 못했습니다. 입력 내용을 확인해 주세요.";

                    if (
                        result &&
                        typeof result.message === "string" &&
                        result.message
                    ) {
                        message = result.message;

                    } else if (
                        contentType.includes("text/plain") &&
                        text.trim()
                    ) {
                        message = text;
                    }

                    showMessage(message, false);
                    return;
                }

                if (contentType.includes("text/html")) {
                    showMessage(
                        "서버 응답을 확인할 수 없습니다. 다시 로그인한 후 시도해 주세요.",
                        false
                    );
                    return;
                }

                form.reset();
                showMessage("비밀번호가 변경되었습니다.", true);

            } catch (error) {
                showMessage("서버와의 통신 중 오류가 발생했습니다.", false);

            } finally {
                submitting = false;
                button.disabled = false;
                button.textContent = "비밀번호 변경";
            }
        });
    }());
