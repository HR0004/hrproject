const contextPath = (document.body.getAttribute("data-context-path") || "");


// 부서 등록

const regist = async () => {

    const departmentName =
        document.getElementById("departmentName").value.trim();

    if (!departmentName) {
        alert("부서명을 입력하세요.");
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
                "JSON 응답이 아닙니다. HTTP " + response.status
            );
        }

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "부서 등록 실패");
        }

        alert(result.message);

        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();
            window.close();
        } else {
            location.href = contextPath + "/departments";
        }

    } catch (error) {
        console.error("부서 등록 오류:", error);
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
