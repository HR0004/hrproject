<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <title>ログイン</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css?v=ja-1">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/hrms-ja.js?v=ja-1"></script>
</head>
<body>

    <div class="container login-container"
         style="max-width: 400px; margin-top: 50px;">

        <h2>ログイン</h2>

        <div id="error-message"
             class="login-error"
             role="alert"
             aria-live="polite"></div>

        <form id="form1"
              action="${pageContext.request.contextPath}/login"
              method="post">

            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">

            <div class="form-group">
                <input type="text"
                       class="form-control"
                       placeholder="ログインID"
                       name="accountId"
                       aria-label="ID"
                       autocomplete="username"
                       required>
            </div>

            <div class="form-group">
                <input type="password"
                       class="form-control"
                       id="pwd"
                       placeholder="パスワード"
                       name="pwd"
                       aria-label="パスワード"
                       autocomplete="current-password"
                       required>
            </div>

            <button type="submit"
                    class="btn btn-primary btn-block"
                    id="bt-login">
                ログイン
            </button>

        </form>
    </div>

    <script>
    (function () {
        const form = document.getElementById("form1");
        const button = document.getElementById("bt-login");
        const errorMessage = document.getElementById("error-message");

        let submitting = false;

        form.addEventListener("submit", async function (event) {
            event.preventDefault();

            if (submitting) {
                return;
            }

            errorMessage.textContent = "";
            submitting = true;
            button.disabled = true;

            let navigating = false;

            try {
                const formData = new URLSearchParams(
                    new FormData(form)
                );

                const response = await fetch(form.action, {
                    method: "POST",
                    credentials: "same-origin",
                    headers: {
                        "Content-Type":
                            "application/x-www-form-urlencoded; charset=UTF-8",
                        "Accept": "application/json"
                    },
                    body: formData
                });

                if (response.status === 403) {
                    errorMessage.textContent =
                        "ログインリクエストが拒否されました。 ページを再読み込みしてから再度お試しください。";
                    return;
                }

                const contentType =
                    response.headers.get("content-type") || "";

                if (!contentType.includes("application/json")) {
                    errorMessage.textContent =
                        "サーバーのレスポンスを確認できません。 ログイン処理の設定を確認してください。";
                    return;
                }

                const json = await response.json();

                if (response.ok && json.success) {
                    const allowedTargets = [
                        "${pageContext.request.contextPath}/dashboard",
                        "${pageContext.request.contextPath}/employee/home"
                    ];

                    // サーバーで指定された2つのパスのみ許可
                    if (!allowedTargets.includes(json.redirectUrl)) {
                        errorMessage.textContent =
                            "ログイン後の移動先を確認できません。";
                        return;
                    }

                    window.location.assign(json.redirectUrl);
                    navigating = true;

                } else {
                    errorMessage.textContent =
                        json.message ||
                        "IDまたはパスワードが一致しません。";
                }

            } catch (error) {
                errorMessage.textContent =
                    "サーバーとの通信中にエラーが発生しました。";

            } finally {
                if (!navigating) {
                    submitting = false;
                    button.disabled = false;
                }
            }
        });
    }());
    </script>

</body>
</html>