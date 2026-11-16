const contextPath = (document.body.getAttribute("data-context-path") || "");


// 부서 등록

const regist = async () => {

    const departmentName =
        document.getElementById("departmentName").value.trim();

    if (!departmentName) {
        alert("部署名を入力してください。");
        return;
    }

    try {
        const headers = {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept": "application/json"
        };

        // Spring Security CSRF
        const csrfToken = (document.querySelector('meta[name="_csrf"]').content || "");
        const csrfHeader = (document.querySelector('meta[name="_csrf_header"]').content || "");

        if (csrfToken && csrfHeader) {
            headers[csrfHeader] = csrfToken;
        }

        const response = await fetch(
            contextPath + "/api/departments", {
                method: "POST",
                headers: headers,
                body: JSON.stringify({ departmentName })
            }
        );

        const contentType =
            response.headers.get("content-type") || "";

        if (!contentType.includes("application/json")) {
            throw new Error(
                "JSON レスポンスではありません。 HTTP " + response.status
            );
        }

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "部署の登録に失敗しました");
        }

        alert(result.message);

        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();
            window.close();
        } else {
            location.href = contextPath + "/departments";
        }

    } catch (error) {
        console.error("部署登録エラー:", error);
        alert(error.message);
    }
};



// 등록 버튼 이벤트
document.getElementById("registerForm")
    .addEventListener("submit", function(e) {

        e.preventDefault();
        regist();

    });


// 취소 버튼 이벤트
document.getElementById("cancelBtn")
    .addEventListener("click", function() {

        if (window.opener && !window.opener.closed) {
            window.close();
        } else {
            location.href = contextPath + "/departments";
        }

    });
