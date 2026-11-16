/* Administrator leave list and decisions use the existing application's DB-backed API. */
(function ($) {
    'use strict';
    const context = document.body.getAttribute('data-context-path') || '';
    const api = context + '/api/leave/admin/requests';
    const statusText = {PENDING:'承認待ち', APPROVED:'承認済み', REJECTED:'否認', CANCELED:'取消済み'};
    const statusClass = {PENDING:'alr-pill-pending', APPROVED:'alr-pill-approved', REJECTED:'alr-pill-rejected'};
    let rows = [], sequence = 0, processing = false;
    const message = text => $('#adminLeaveMessage').text(text || '');
    async function responseData(response) {
        let data = null;
        try { data = await response.json(); } catch (ignore) { /* HTML login/error responses are not success. */ }
        if (!response.ok || response.redirected || data === null) {
            throw new Error(data && (data.message || data.error || data.reason) || 'リクエストの処理に失敗しました。 (' + response.status + ')');
        }
        return data;
    }
    function render() {
        const body = $("tbody[name='leaveRequestRows']").empty();
        $("div[name='allCount']").text(rows.length + '件');
        $("div[name='pendingCount']").text(rows.filter(r => r.status === 'PENDING').length + '件');
        $("div[name='approvedCount']").text(rows.filter(r => r.status === 'APPROVED').length + '件');
        $("div[name='rejectedCount']").text(rows.filter(r => r.status === 'REJECTED').length + '件');
        $("div[name='resultCount']").text('合計 ' + rows.length + '件');
        if (!rows.length) {
            body.append($('<tr>').append($('<td>', {colspan:8, class:'alr-empty', text:'該当する休暇申請がありません。'})));
            return;
        }
        rows.forEach(item => {
            const tr = $('<tr>');
            [item.requestDate, item.department || '未設定', item.empId + ' / ' + (item.empName || ''),
                item.startDate + (item.startDate === item.endDate ? '' : ' ~ ' + item.endDate), item.days + '日'].forEach(value => tr.append($('<td>').text(value)));
            tr.append($('<td>', {class:'alr-ellipsis', title:item.reason || ''}).text(item.reason || ''));
            tr.append($('<td>').append($('<span>', {class:'alr-pill ' + (statusClass[item.status] || ''), text:statusText[item.status] || item.status})));
            const actions = $('<div>', {class:'alr-row-actions'});
            function button(action, label, primary) {
                return $('<button>', {type:'button', class:'alr-btn alr-btn-small' + (primary ? ' alr-btn-primary' : ''),
                    text:label, 'data-id':item.requestId, 'data-action':action, disabled:processing});
            }
            actions.append(button('detail', '詳細', false));
            if (item.status === 'PENDING') actions.append(button('approve', '承認', true), button('reject', '否認', false));
            tr.append($('<td>').append(actions));body.append(tr);
        });
    }
    async function loadRequests() {
        const current = ++sequence;
        const start = $("input[name='startDate']").val(), end = $("input[name='endDate']").val();
        if (start && end && start > end) { message('申請終了日は開始日以降に設定してください。'); return false; }
        const params = new URLSearchParams();
        [['departmentId', $('#alrDepartment').val()], ['startDate', start], ['endDate', end],
            ['status', $('#alrStatus').val()], ['keyword', $('#alrKeyword').val().trim()]].forEach(pair => {
            if (pair[1]) params.set(pair[0], pair[1]);
        });
        message('休暇申請を読み込んでいます。');
        try {
            const data = await responseData(await fetch(api + '?' + params.toString(), {credentials:'same-origin'}));
            if (current !== sequence) return false;
            if (!Array.isArray(data)) throw new Error('休暇一覧のレスポンス形式が正しくありません。');
            rows = data;render();message('');return true;
        } catch (error) {
            if (current === sequence) { rows = [];render();message(error.message); }
            return false;
        }
    }
    async function loadDepartments() {
        try {
            const data = await responseData(await fetch(context + '/api/departments', {credentials:'same-origin'}));
            const departments = Array.isArray(data) ? data : (data.data || data.content || []);
            const select = $('#alrDepartment').empty().append($('<option>', {value:'', text:'すべての部署'}));
            departments.forEach(dept => {
                if (dept.departmentId != null) select.append($('<option>', {value:dept.departmentId, text:dept.departmentName}));
            });
        } catch (error) { message('部署一覧を読み込めませんでした。 再読み込みしてください。'); }
    }
    function detail(id) {
        const item = rows.find(row => Number(row.requestId) === id);if (!item) return;
        const content = $("dl[name='leaveDetailContent']").empty();
        [['申請番号',item.requestId],['所属部署',item.department || '未設定'],['社員',item.empName + ' (' + item.empId + ')'],
            ['申請日',item.requestDate],['取得期間',item.startDate + ' ~ ' + item.endDate],['申請日数',item.days + '日'],
            ['申請理由',item.reason || ''],['処理状態',statusText[item.status] || item.status],
            ['処理者',item.approverName || '-'],['処理日時',item.approvedAt || '-']].forEach(pair => {
            content.append($('<dt>').text(pair[0]), $('<dd>').text(pair[1]));
        });
        $("div[name='leaveDetailOverlay']").addClass('alr-open');
    }
    async function decide(id, action) {
        if (processing || !Number.isInteger(id) || id <= 0 || !['approve','reject'].includes(action)) return;
        const label = action === 'approve' ? '承認' : '否認';
        if (!window.confirm('選択した休暇申請を ' + label + 'しますか？')) return;
        processing = true;render();message(label + ' 処理中です。');
        try {
            const headers = {};
            const token = $('meta[name="_csrf"]').attr('content'), header = $('meta[name="_csrf_header"]').attr('content');
            if (token && header) headers[header] = token;
            const data = await responseData(await fetch(api + '/' + id + '/' + action, {method:'POST', credentials:'same-origin', headers:headers}));
            const refreshed = await loadRequests();
            message(refreshed ? data.message : label + ' 処理は完了しましたが、一覧を再読み込みできませんでした。 もう一度検索してください。');
        } catch (error) { message(error.message + ' 一覧を再読み込みし、現在の処理状態を確認してください。'); }
        finally { processing = false;render(); }
    }
    $(function () {
        // Independent list/department requests; a failed department lookup does not fabricate list data.
        loadDepartments();loadRequests();
        $("button[name='searchLeaveRequests']").on('click', loadRequests);
        $("button[name='resetLeaveRequests']").on('click', function () {
            $('#alrDepartment').val('');$("input[name='startDate'], input[name='endDate']").val('');
            $('#alrStatus').val('ALL');$('#alrKeyword').val('');loadRequests();
        });
        $('#alrKeyword').on('keydown', function (event) { if (event.key === 'Enter') { event.preventDefault();loadRequests(); } });
        $("tbody[name='leaveRequestRows']").on('click', 'button[data-action]', function () {
            const id = Number($(this).attr('data-id')), action = $(this).attr('data-action');
            if (action === 'detail') detail(id);else decide(id,action);
        });
        $("button[name='closeLeaveDetail']").on('click', function () { $("div[name='leaveDetailOverlay']").removeClass('alr-open'); });
        $("div[name='leaveDetailOverlay']").on('click', function (event) { if (event.target === this) $(this).removeClass('alr-open'); });
        $(document).on('keydown', function (event) { if (event.key === 'Escape') $("div[name='leaveDetailOverlay']").removeClass('alr-open'); });
    });
}(jQuery));
