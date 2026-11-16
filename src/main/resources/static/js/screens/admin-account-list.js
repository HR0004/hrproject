(function () {
    var form = document.getElementById("account-selection-form");
    var next = document.getElementById("account-next-button");

    var message = document.getElementById(
        "account-selection-message"
    );

    var rows = form.querySelectorAll("[data-account-row]");

    function updateSelection() {
        var selected = form.querySelector(
            'input[name="accountId"]:checked'
        );

        next.disabled = !selected;

        message.textContent = selected
            ? "選択したユーザー: "
                + selected.getAttribute("data-user-label")
            : "ユーザーを選択してください。";

        Array.prototype.forEach.call(rows, function (row) {
            var radio = row.querySelector(
                'input[type="radio"]'
            );

            row.classList.toggle(
                "is-selected",
                radio.checked
            );
        });
    }

    form.addEventListener("change", updateSelection);

    Array.prototype.forEach.call(rows, function (row) {
        row.addEventListener("click", function (event) {
            if (event.target.closest("input, button, a, label")) {
                return;
            }

            row.querySelector(
                'input[type="radio"]'
            ).checked = true;

            updateSelection();
        });
    });

    form.addEventListener("submit", function (event) {
        event.preventDefault();

        var selected = form.querySelector(
            'input[name="accountId"]:checked'
        );

        if (!selected) {
            return;
        }

        window.location.assign(
            form.getAttribute("data-account-base")
            + encodeURIComponent(selected.value)
        );
    });

    // 검색 패널 열기/닫기
    var filterToggle = document.getElementById(
        "account-filter-toggle"
    );

    var searchPanel = document.getElementById(
        "account-search-panel"
    );

    filterToggle.addEventListener("click", function () {
        searchPanel.hidden = !searchPanel.hidden;

        filterToggle.setAttribute(
            "aria-expanded",
            String(!searchPanel.hidden)
        );

        if (!searchPanel.hidden) {
            document.getElementById("account-keyword").focus();
        }
    });

    // 계정 활성/비활성 변경
    var statusForms = document.querySelectorAll(
        ".account-status-form"
    );

    var statusButtons = document.querySelectorAll(
        ".account-status-button"
    );

    var initiallyDisabled = Array.prototype.map.call(
        statusButtons,
        function (button) {
            return button.disabled;
        }
    );

    var statusSubmitting = false;

    Array.prototype.forEach.call(statusForms, function (statusForm) {
        statusForm.addEventListener("submit", function (event) {

            var button = document.querySelector(
                'button[form="' + statusForm.id + '"]'
            );

            if (statusSubmitting || !button || button.disabled) {
                event.preventDefault();
                return;
            }

            if (!window.confirm("アカウントの状態を変更しますか？")) {
                event.preventDefault();
                return;
            }

            statusSubmitting = true;

            Array.prototype.forEach.call(statusButtons, function (item) {
                item.disabled = true;
            });
        });
    });

    // 뒤로가기로 돌아왔을 때 버튼 상태 복구
    window.addEventListener("pageshow", function (event) {
        if (event.persisted) {
            statusSubmitting = false;

            Array.prototype.forEach.call(
                statusButtons,
                function (button, index) {
                    button.disabled = initiallyDisabled[index];
                }
            );

            updateSelection();
        }
    });

    // 서버에서 전달한 변경 결과
    var feedback = document.getElementById(
        "account-status-feedback"
    );

    if (feedback && feedback.textContent.trim()) {
        window.alert(feedback.textContent.trim());
    }

    updateSelection();
})();
