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
                roleOutput.textContent = "ロール未選択";
            }

            emptyMessage.hidden = permissions.size > 0;

            emptyMessage.textContent = !selected.length
                ? "選択したロールがありません。 保存すると既存のロールがすべて解除されます。"
                : "選択したロールに個別権限が設定されていません。";

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
                ? "権限を変更しますか？"
                : "選択したロールがありません。 既存のロールをすべて解除しますか？";

            if (!window.confirm(message)) {
                event.preventDefault();
                return;
            }

            submitting = true;
            saveButton.disabled = true;
            backButton.disabled = true;
            saveButton.textContent = "保存中。..";
        });

        window.addEventListener("pageshow", function (event) {
            if (event.persisted) {
                submitting = false;
                backButton.disabled = false;
                saveButton.textContent = "権限を保存";
                showSelection();
            }
        });

        if (form.dataset.saveCompleted === "true") {
            form.dataset.saveCompleted = "false";
            window.alert("権限を変更しました。");
        }
    }());
