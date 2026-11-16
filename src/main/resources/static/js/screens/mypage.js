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
                showMessage("パスワードをすべて入力してください。", false);
                return;
            }

            if (newPassword.length < 8) {
                showMessage("新しいパスワードは 8文字以上である必要があります。", false);
                return;
            }

            if (newPassword !== confirmPassword) {
                showMessage(
                    "新しいパスワードと確認用パスワードが一致しません。",
                    false
                );
                return;
            }

            if (currentPassword === newPassword) {
                showMessage(
                    "現在のパスワードとは異なるパスワードを入力してください。",
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
            button.textContent = "変更中。..";

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
                    showMessage("再度ログインしてから変更してください。", false);
                    return;
                }

                if (response.status === 403) {
                    showMessage(
                        "リクエストが拒否されました。 ページを再読み込みしてから再度お試しください。",
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
                        "パスワードを変更できませんでした。 入力内容を確認してください。";

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
                        "サーバーのレスポンスを確認できません。 再度ログインしてからお試しください。",
                        false
                    );
                    return;
                }

                form.reset();
                showMessage("パスワードを変更しました。", true);

            } catch (error) {
                showMessage("サーバーとの通信中にエラーが発生しました。", false);

            } finally {
                submitting = false;
                button.disabled = false;
                button.textContent = "パスワード変更";
            }
        });
    }());
