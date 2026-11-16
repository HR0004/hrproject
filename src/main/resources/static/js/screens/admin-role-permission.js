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
                    !window.confirm("権限を変更しますか？")
                ) {
                    event.preventDefault();
                    return;
                }

                busy = true;
                button.disabled = true;
                button.textContent = "保存中。..";
            });

            window.addEventListener("pageshow", function (event) {
                if (event.persisted) {
                    busy = false;
                    button.disabled = false;
                    button.textContent = "権限の保存";
                }
            });
        }

        var message =
            document.getElementById("rolePermissionMessage");

        if (message) {
            window.alert(message.textContent.trim());
        }
    }());
