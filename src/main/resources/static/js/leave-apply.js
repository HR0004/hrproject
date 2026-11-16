$(function () {
	const contextPath = (document.body.getAttribute("data-context-path") || "");

    // 신청 사유 글자 수 표시
    $("textarea[name='reason']").on("input", function () {
        $("span[name='reasonCount']").text($(this).val().length + " / 50");
    });

    // 종료일은 시작일보다 빠를 수 없음
    $("input[name='startDate']").on("change", function () {
        const startDate = $(this).val();
        const endDate = $("input[name='endDate']");
        endDate.attr("min", startDate || null);
        if (startDate && endDate.val() && endDate.val() < startDate) endDate.val(startDate);
        if ($("input[name='halfDayType']:checked").val() !== "FULL") endDate.val(startDate);
    });

    // 반차는 시작일과 종료일이 같아야 함
    $("input[name='halfDayType']").on("change", function () {
        const halfDay = $(this).val() !== "FULL";
        const endDate = $("input[name='endDate']");
        if (halfDay) endDate.val($("input[name='startDate']").val());
        endDate.prop("disabled", halfDay);
    });

    $("button[name='cancelButton']").on("click", function () {
        window.location.href = contextPath + "/leave";
    });

    // 입력 검증 후 기존 휴가 신청 API로 저장

 // 휴가 신청 DB 저장
 $("#leaveApplyForm").on("submit", async function(event) {

     event.preventDefault();

     const startDate = $("input[name='startDate']").val();

     const halfDayType =
         $("input[name='halfDayType']:checked").val();

     const endDate = halfDayType === "FULL"
         ? $("input[name='endDate']").val()
         : startDate;

     const reason =
         $("textarea[name='reason']").val().trim();

     if (!startDate || !endDate) {
         alert("休暇期間を選択してください。");
         return;
     }

     if (endDate < startDate) {
         alert("終了日を確認してください。");
         return;
     }

     if (!reason || reason.length > 50) {
         alert("申請理由を 1~50文字で入力してください。");
         return;
     }

     const button = $("button[name='applyButton']");

     if (button.prop("disabled")) {
         return;
     }

     button.prop("disabled", true);

     try {

         const response = await fetch(
             contextPath + "/api/leave/my/requests",
             {
                 method: "POST",
                 headers: {
                     "Content-Type": "application/json"
                 },
                 body: JSON.stringify({
                     startDate: startDate,
                     endDate: endDate,
                     halfDayType: halfDayType,
                     reason: reason
                 })
             }
         );

         if (!response.ok) {
             throw new Error(
                 "申請に失敗しました (HTTP " + response.status + ")"
             );
         }

         alert("休暇を申請しました。");

         window.location.href =
             contextPath + "/leave/history";

     } catch (error) {

         console.error(error);
         alert(error.message);

     } finally {

         button.prop("disabled", false);

     }

 });

});
