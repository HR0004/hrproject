const contextPath = (document.body.getAttribute("data-context-path") || "");

// 직급 등록
const registJob = async (event) => {

    event.preventDefault();

    const jobName = document.getElementById("jobName").value.trim();
    const registerBtn = document.getElementById("registerBtn");

    if (!jobName) {
        alert("役職名を入力してください。");
        return;
    }

    registerBtn.disabled = true;

    try {

        const headers = {
            "Content-Type": "application/json",
            "Accept": "application/json"
        };

        // Spring Security CSRF 처리
        const csrfToken = (document.querySelector('meta[name="_csrf"]').content || "");
        const csrfHeader = (document.querySelector('meta[name="_csrf_header"]').content || "");

        if (csrfToken && csrfHeader) {
            headers[csrfHeader] = csrfToken;
        }

        const response = await fetch(contextPath + "/api/jobs", {
            method: "POST",
            headers: headers,
            body: JSON.stringify({
                jobName: jobName
            })
        });

        const contentType = response.headers.get("content-type") || "";

        if (!contentType.includes("application/json")) {
            throw new Error("サーバーエラーが発生しました。 HTTP " + response.status);
        }

        const result = await response.json();

        if (!response.ok || result.success === false) {
            throw new Error(result.message || "役職の登録に失敗しました。");
        }

        alert("役職を登録しました。");

        location.href = contextPath + "/jobs";

    } catch (error) {

        console.error("役職登録エラー:", error);
        alert(error.message);

    } finally {
        registerBtn.disabled = false;
    }
};

// 폼 제출 이벤트
document.getElementById("jobRegisterForm")
    .addEventListener("submit", registJob);
