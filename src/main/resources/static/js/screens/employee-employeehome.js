// 로그인한 사원 정보 조회
    const loadMyInfo = async () => {

        try {
            const response = await fetch(
                (document.body.getAttribute("data-context-path") || "") + "/api/employees/me"
            );

            if (!response.ok) {
                throw new Error("내 정보 조회 실패: " + response.status);
            }

            const emp = await response.json();

            // 상단 사용자
            $("#loginUser").text(emp.ename + " 사원");

            // 재직 상태
            const status = {
                ACTIVE: "재직",
                LEAVE: "휴직",
                RETIRED: "퇴직"
            }[emp.status] ?? "-";

            // 요약 카드
            $("#summaryStatus").text(status);
            $("#summaryDept").text(
                emp.department?.departmentName ?? "-"
            );
            $("#summaryJob").text(
                emp.job?.jobName ?? "-"
            );

            const hiredate = emp.hiredate
                ? new Date(emp.hiredate).toLocaleDateString("ko-KR")
                : "-";

            $("#summaryHiredate").text(hiredate);

            // 내 기본 정보
            $("#myEmpId").text(emp.empId ?? "-");
            $("#myName").text(emp.ename ?? "-");
            $("#myEmail").text(emp.email ?? "-");
            $("#myPhone").text(emp.phone ?? "-");
            $("#myDept").text(
                emp.department?.departmentName ?? "-"
            );
            $("#myJob").text(
                emp.job?.jobName ?? "-"
            );

        } catch (error) {
            console.error("마이페이지 조회 오류:", error);
        }
    };

    // 페이지 로딩 시 로그인 사원 정보 조회
    document.addEventListener("DOMContentLoaded", loadMyInfo);
