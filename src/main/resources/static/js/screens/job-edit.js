const contextPath = (document.body.getAttribute("data-context-path") || "");

// 직급 등록
const registJob = async (event) => {

    event.preventDefault();

    const jobName = document.getElementById("jobName").value.trim();
    const registerBtn = document.getElementById("registerBtn");

    if (!jobName) {
        alert("직급명을 입력하세요.");
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

        if (!response.ok) {
            throw new Error("직급 등록 실패 (HTTP " + response.status + ")");
        }

        alert("직급이 등록되었습니다.");

        location.href = contextPath + "/jobs";

    } catch (error) {

        console.error("직급 등록 오류:", error);
        alert(error.message);

    } finally {
        registerBtn.disabled = false;
    }
};

// 폼 제출 이벤트
document.getElementById("jobRegisterForm")
    .addEventListener("submit", registJob);
