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
            throw new Error(result.message || "部署情報の取得に失敗しました");
        }

        document.getElementById("departmentCode").value =
            result.data.departmentCode;

        window.hrmsJapaneseReferenceInput(document.getElementById("departmentName"), result.data.departmentName);

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
};


// 2. 부서명 수정
const update = async () => {

    const departmentName =
        window.hrmsJapaneseStoredValue(document.getElementById("departmentName")).trim();

    if (!departmentName) {
        alert("部署名を入力してください。");
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
            throw new Error(result.message || "部署情報の更新に失敗しました");
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
    alert("部署番号が正しくありません。");
    location.href = contextPath + "/departments";
} else {
    getDetail();
}
