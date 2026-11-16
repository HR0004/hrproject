/* Administrator leave list and decisions use the existing application's DB-backed API. */
(function ($) {
    'use strict';
    const context = document.body.getAttribute('data-context-path') || '';
    const api = context + '/api/leave/admin/requests';
    const statusText = {PENDING:'승인 대기', APPROVED:'승인 완료', REJECTED:'반려', CANCELED:'취소됨'};
    const statusClass = {PENDING:'alr-pill-pending', APPROVED:'alr-pill-approved', REJECTED:'alr-pill-rejected'};
    let rows = [], sequence = 0, processing = false;
    const message = text => $('#adminLeaveMessage').text(text || '');
    async function responseData(response) {
        let data = null;
        try { data = await response.json(); } catch (ignore) { /* HTML login/error responses are not success. */ }
        if (!response.ok || response.redirected || data === null) {
            throw new Error(data && (data.message || data.error || data.reason) || '요청을 처리하지 못했습니다. (' + response.status + ')');
        }
        return data;
    }
    function render() {
        const body = $("tbody[name='leaveRequestRows']").empty();
        $("div[name='allCount']").text(rows.length + '건');
        $("div[name='pendingCount']").text(rows.filter(r => r.status === 'PENDING').length + '건');
        $("div[name='approvedCount']").text(rows.filter(r => r.status === 'APPROVED').length + '건');
        $("div[name='rejectedCount']").text(rows.filter(r => r.status === 'REJECTED').length + '건');
        $("div[name='resultCount']").text('총 ' + rows.length + '건');
        if (!rows.length) {
            body.append($('<tr>').append($('<td>', {colspan:8, class:'alr-empty', text:'조회된 휴가 신청이 없습니다.'})));
            return;
        }
        rows.forEach(item => {
            const tr = $('<tr>');
            [item.requestDate, item.department || '미지정', item.empId + ' / ' + (item.empName || ''),
                item.startDate + (item.startDate === item.endDate ? '' : ' ~ ' + item.endDate), item.days + '일'].forEach(value => tr.append($('<td>').text(value)));
            tr.append($('<td>', {class:'alr-ellipsis', title:item.reason || ''}).text(item.reason || ''));
            tr.append($('<td>').append($('<span>', {class:'alr-pill ' + (statusClass[item.status] || ''), text:statusText[item.status] || item.status})));
            const actions = $('<div>', {class:'alr-row-actions'});
            function button(action, label, primary) {
                return $('<button>', {type:'button', class:'alr-btn alr-btn-small' + (primary ? ' alr-btn-primary' : ''),
                    text:label, 'data-id':item.requestId, 'data-action':action, disabled:processing});
            }
            actions.append(button('detail', '상세', false));
            if (item.status === 'PENDING') actions.append(button('approve', '승인', true), button('reject', '반려', false));
            tr.append($('<td>').append(actions));body.append(tr);
        });
    }
    async function loadRequests() {
        const current = ++sequence;
        const start = $("input[name='startDate']").val(), end = $("input[name='endDate']").val();
        if (start && end && start > end) { message('신청 종료일은 시작일보다 빠를 수 없습니다.'); return false; }
        const params = new URLSearchParams();
        [['departmentId', $('#alrDepartment').val()], ['startDate', start], ['endDate', end],
            ['status', $('#alrStatus').val()], ['keyword', $('#alrKeyword').val().trim()]].forEach(pair => {
            if (pair[1]) params.set(pair[0], pair[1]);
        });
        message('휴가 신청을 조회하고 있습니다.');
        try {
            const data = await responseData(await fetch(api + '?' + params.toString(), {credentials:'same-origin'}));
            if (current !== sequence) return false;
            if (!Array.isArray(data)) throw new Error('휴가 목록 응답 형식이 올바르지 않습니다.');
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
            const select = $('#alrDepartment').empty().append($('<option>', {value:'', text:'전체 부서'}));
            departments.forEach(dept => {
                if (dept.departmentId != null) select.append($('<option>', {value:dept.departmentId, text:dept.departmentName}));
            });
        } catch (error) { message('부서 목록을 불러오지 못했습니다. 새로고침해 주세요.'); }
    }
    function detail(id) {
        const item = rows.find(row => Number(row.requestId) === id);if (!item) return;
        const content = $("dl[name='leaveDetailContent']").empty();
        [['신청 번호',item.requestId],['소속 부서',item.department || '미지정'],['사원',item.empName + ' (' + item.empId + ')'],
            ['신청일',item.requestDate],['사용 기간',item.startDate + ' ~ ' + item.endDate],['신청 일수',item.days + '일'],
            ['신청 사유',item.reason || ''],['처리 상태',statusText[item.status] || item.status],
            ['처리자',item.approverName || '-'],['처리 시각',item.approvedAt || '-']].forEach(pair => {
            content.append($('<dt>').text(pair[0]), $('<dd>').text(pair[1]));
        });
        $("div[name='leaveDetailOverlay']").addClass('alr-open');
    }
    async function decide(id, action) {
        if (processing || !Number.isInteger(id) || id <= 0 || !['approve','reject'].includes(action)) return;
        const label = action === 'approve' ? '승인' : '반려';
        if (!window.confirm('선택한 휴가 신청을 ' + label + '하시겠습니까?')) return;
        processing = true;render();message(label + ' 처리 중입니다.');
        try {
            const headers = {};
            const token = $('meta[name="_csrf"]').attr('content'), header = $('meta[name="_csrf_header"]').attr('content');
            if (token && header) headers[header] = token;
            const data = await responseData(await fetch(api + '/' + id + '/' + action, {method:'POST', credentials:'same-origin', headers:headers}));
            const refreshed = await loadRequests();
            message(refreshed ? data.message : label + ' 처리는 완료됐지만 목록을 새로 불러오지 못했습니다. 다시 조회해 주세요.');
        } catch (error) { message(error.message + ' 목록을 다시 조회해 현재 처리 상태를 확인하세요.'); }
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
