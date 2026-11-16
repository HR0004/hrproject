(function () {
        var form =
            document.getElementById("rolePermissionForm");

        var button =
            document.getElementById("rolePermissionSave");

        var busy = false;

        if (form) {
            form.addEventListener("submit", function (event) {
                if (
                    busy ||
                    !window.confirm("권한을 변경하시겠습니까?")
                ) {
                    event.preventDefault();
                    return;
                }

                busy = true;
                button.disabled = true;
                button.textContent = "저장 중...";
            });

            window.addEventListener("pageshow", function (event) {
                if (event.persisted) {
                    busy = false;
                    button.disabled = false;
                    button.textContent = "권한 저장";
                }
            });
        }

        var message =
            document.getElementById("rolePermissionMessage");

        if (message) {
            window.alert(message.textContent.trim());
        }
    }());
