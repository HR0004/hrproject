const contextPath = (document.body.getAttribute("data-context-path") || "");

const params = new URLSearchParams(location.search);
const departmentId = params.get("departmentId");


// 1. 기존 부서 정보 조회
const getDetail = async () => {

    try {
    	const response = await fetch(
    		    contextPath + "/api/departments/" + departmentId,
    		    { method: "GET" }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "부서 조회 실패");
        }

        document.getElementById("departmentCode").value =
            result.data.departmentCode;

        document.getElementById("departmentName").value =
            result.data.departmentName;

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 2. 부서명 수정
const update = async () => {

    const departmentName =
        document.getElementById("departmentName").value.trim();

    if (!departmentName) {
        alert("부서명을 입력하세요.");
        return;
    }

    try {
        const response = await fetch(
            contextPath + "/api/departments/" + departmentId, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json; charset=UTF-8"
                },
                body: JSON.stringify({
                    departmentName: departmentName
                })
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(result.message || "부서 수정 실패");
        }

        alert(result.message);

        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();
            window.close();
        } else {
            location.href = contextPath + "/departments";
        }

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 수정 버튼 이벤트
document.getElementById("editForm").addEventListener("submit", e => {
    e.preventDefault();
    update();
});


// 취소 버튼 이벤트
document.getElementById("bt-cancel").addEventListener("click", () => {
    if (window.opener && !window.opener.closed) {
        window.close();
    } else {
        location.href = contextPath + "/departments";
    }
});


// 페이지 실행 시 상세 조회
if (!departmentId || !/^[1-9]\d*$/.test(departmentId)) {
    alert("잘못된 부서 번호입니다.");
    location.href = contextPath + "/departments";
} else {
    getDetail();
}
