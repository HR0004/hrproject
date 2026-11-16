/* Japanese display labels for existing reference data; stored values are unchanged. */
(function () {
    'use strict';
    const labels = {"일반 사원":"一般社員","팀 업무 승인자":"チーム業務承認者","인사 관리자":"人事管理者","내 정보 조회":"プロフィールの閲覧","내 휴가 신청":"自分の休暇申請","내 휴가 조회":"自分の休暇の閲覧","내 팀원 조회":"所属チーム社員の閲覧","팀원 휴가 승인":"チーム社員の休暇承認","반려":"否認","전체 사원 조회":"全社員情報の閲覧","신규 사원 등록":"社員の新規登録","사원 정보 수정":"社員情報の編集","퇴직 처리":"退職処理","부서 관리":"部署管理","직급 관리":"役職管理","전체 휴가 현황 조회":"全社員の休暇状況の閲覧","계정 발급":"アカウント発行","상태 관리":"状態管理","계정 역할 부여":"アカウントへのロール付与","역할별 권한 설정":"ロール別権限設定","경영지원팀":"経営支援チーム","개발팀":"開発チーム","영업팀":"営業チーム","사원":"社員","대리":"主任","과장":"課長","차장":"次長","부장":"部長","팀장":"チームリーダー","부서장":"部署責任者","본부장":"本部長","센터장":"センター長","파트장":"パートリーダー","재직":"在籍","휴직":"休職","퇴직":"退職","명":"名","건":"件","일":"日","총":"合計","활성":"有効","비활성":"無効","수정":"編集","비활성화":"無効化","상세":"詳細","전체 부서":"すべての部署","전체":"すべて","선택":"選択","정상 출근":"通常出勤","지각":"遅刻","조퇴":"早退","휴가":"休暇","미기록":"未記録","승인 대기":"承認待ち","승인 완료":"承認済み","취소됨":"取消済み","사용 기간":"取得期間","신청 일수":"申請日数","사용 일수":"取得日数","조회 중":"読み込み中"};
    const pattern = /[가-힣]+(?:[ \t]+[가-힣]+)*/g;
    function label(value) {
        return String(value == null ? '' : value).replace(pattern, function (text) {
            return labels[text.replace(/[ \t]+/g, ' ')] || text;
        });
    }
    window.hrmsJapaneseLabel = label;
    const referenceInputs = new WeakMap();
    window.hrmsJapaneseReferenceInput = function (field, original) {
        const raw = String(original == null ? '' : original), display = label(raw);
        referenceInputs.set(field,{original:raw,display:display});field.value = display;
    };
    window.hrmsJapaneseStoredValue = function (field) {
        const saved = referenceInputs.get(field);
        return saved && field.value.trim() === saved.display.trim() ? saved.original : field.value;
    };
    function text(node) {
        if (!node.parentElement || node.parentElement.closest('script,style,textarea,[contenteditable="true"],[data-i18n="off"]')) return;
        const original = node.nodeValue, translated = label(original);
        if (translated !== original) node.nodeValue = translated;
    }
    function visit(root) {
        if (!window.document) return;
        if (root.nodeType === Node.TEXT_NODE) { text(root);return; }
        if (root.nodeType !== Node.ELEMENT_NODE || root.matches('script,style,textarea,[data-i18n="off"]')) return;
        [root].concat(Array.from(root.querySelectorAll('[title],[aria-label],[placeholder],[alt]'))).forEach(function (el) {
            ['title','aria-label','placeholder','alt'].forEach(function (attr) {
                if (el.hasAttribute(attr)) { const old = el.getAttribute(attr), next = label(old);if (old !== next) el.setAttribute(attr,next); }
            });
        });
        const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
        const nodes = [];while (walker.nextNode()) nodes.push(walker.currentNode);nodes.forEach(text);
    }
    function start() {
        if (!document.body) return;
        visit(document.body);
        new MutationObserver(function (records) {
            records.forEach(function (record) {
                if (record.type === 'characterData') text(record.target);
                else if (record.type === 'attributes') visit(record.target);
                else record.addedNodes.forEach(visit);
            });
        }).observe(document.body,{subtree:true,childList:true,characterData:true,attributes:true,attributeFilter:['title','aria-label','placeholder','alt']});
    }
    document.addEventListener('invalid', function (event) {
        const field = event.target;
        if (!field.validity || !field.setCustomValidity) return;
        const state = field.validity;
        if (state.valid || state.customError) return;
        let message = '入力内容を確認してください。';
        if (state.valueMissing) message = '必須項目を入力してください。';
        else if (state.typeMismatch && field.type === 'email') message = '有効なメールアドレスを入力してください。';
        else if (state.rangeUnderflow) message = field.min + '以上の値を入力してください。';
        else if (state.rangeOverflow) message = field.max + '以下の値を入力してください。';
        else if (state.tooLong) message = field.maxLength + '文字以内で入力してください。';
        else if (state.tooShort) message = field.minLength + '文字以上で入力してください。';
        else if (state.patternMismatch) message = '指定された形式で入力してください。';
        else if (state.stepMismatch || state.badInput) message = '有効な数値を入力してください。';
        field.setCustomValidity(message);
        field.dataset.hrmsJaValidity = 'true';
    }, true);
    function clearValidation(event) {
        const field = event.target;
        if (field.dataset && field.dataset.hrmsJaValidity) {
            field.setCustomValidity('');delete field.dataset.hrmsJaValidity;
        }
    }
    document.addEventListener('input',clearValidation,true);
    document.addEventListener('change',clearValidation,true);
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded',start);else start();
}());
