(function () {
        var form = document.getElementById("roleForm");
        if (!form) return;

        var selection = document.getElementById("roleSelection");
        var preview = document.getElementById("rolePreview");

        var previewButton = document.getElementById("previewButton");
        var backButton = document.getElementById("backButton");
        var saveButton = document.getElementById("saveButton");

        var roleOutput = document.getElementById("previewRoles");
        var permissionOutput =
            document.getElementById("previewPermissions");

        var emptyMessage = document.getElementById("previewEmpty");
        var tableWrap = document.getElementById("permissionTableWrap");

        var previewValid = false;
        var submitting = false;

        function showSelection() {
            previewValid = false;
            selection.hidden = false;
            preview.hidden = true;
            saveButton.disabled = true;
        }

        previewButton.addEventListener("click", function () {
            if (submitting || previewButton.disabled) return;

            var selected = form.querySelectorAll(
                'input[name="roleIds"]:checked'
            );

            var permissions = new Map();

            roleOutput.textContent = "";
            permissionOutput.textContent = "";

            Array.prototype.forEach.call(selected, function (input) {
                var badge = document.createElement("span");
                badge.className = "role-badge";

                badge.textContent =
                    input.dataset.roleName || input.dataset.roleCode;

                roleOutput.appendChild(badge);

                var source = input.closest("label").querySelectorAll(
                    "[data-permission-code]"
                );

                Array.prototype.forEach.call(source, function (item) {
                    var code = item.dataset.permissionCode;

                    if (code) {
                        permissions.set(
                            code,
                            item.dataset.permissionName || code
                        );
                    }
                });
            });

            permissions.forEach(function (name, code) {
                var row = document.createElement("tr");
                var nameCell = document.createElement("td");
                var codeCell = document.createElement("td");

                nameCell.textContent = name;
                codeCell.textContent = code;

                row.appendChild(nameCell);
                row.appendChild(codeCell);
                permissionOutput.appendChild(row);
            });

            if (!selected.length) {
                roleOutput.textContent = "선택된 역할 없음";
            }

            emptyMessage.hidden = permissions.size > 0;

            emptyMessage.textContent = !selected.length
                ? "선택된 역할이 없습니다. 저장하면 기존 역할이 모두 해제됩니다."
                : "선택한 역할에 연결된 세부 권한이 없습니다.";

            tableWrap.hidden = permissions.size === 0;

            selection.hidden = true;
            preview.hidden = false;
            previewValid = true;
            saveButton.disabled = false;

            document.getElementById("previewTitle").focus();
        });

        backButton.addEventListener("click", function () {
            if (submitting) return;

            showSelection();
            previewButton.focus();
        });

        form.addEventListener("change", function () {
            if (!submitting) {
                showSelection();
            }
        });

        form.addEventListener("submit", function (event) {
            if (submitting || !previewValid) {
                event.preventDefault();
                return;
            }

            var selected = form.querySelectorAll(
                'input[name="roleIds"]:checked'
            );

            var message = selected.length
                ? "권한을 변경하시겠습니까?"
                : "선택한 역할이 없습니다. 기존 역할을 모두 해제하시겠습니까?";

            if (!window.confirm(message)) {
                event.preventDefault();
                return;
            }

            submitting = true;
            saveButton.disabled = true;
            backButton.disabled = true;
            saveButton.textContent = "저장 중...";
        });

        window.addEventListener("pageshow", function (event) {
            if (event.persisted) {
                submitting = false;
                backButton.disabled = false;
                saveButton.textContent = "권한 저장하기";
                showSelection();
            }
        });

        if (form.dataset.saveCompleted === "true") {
            form.dataset.saveCompleted = "false";
            window.alert("권한이 변경되었습니다.");
        }
    }());
