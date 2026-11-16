// 실제 프로젝트의 Context Path: /HR_PROJECT 또는 빈 문자열
        const contextPath = document.body.getAttribute("data-context-path") || "";
        let attendanceList = [];
        let listLoaded = false;

        // 날짜/시간/상태 출력용 함수
        function todayKorea() {
            return new Date(Date.now() + 9 * 60 * 60 * 1000).toISOString().substring(0, 10);
        }

        function displayDate(raw) {
            const iso = String(raw || '').substring(0, 10);
            if (!/^\d{4}-\d{2}-\d{2}$/.test(iso)) return '-';
            const dayIndex = new Date(iso + 'T00:00:00Z').getUTCDay();
            const days = ['日', '月', '火', '水', '木', '金', '土'];
            return iso + ' (' + days[dayIndex] + ')';
        }

        function displayTime(raw) {
            if (!raw) return '--:--';
            const match = String(raw).match(/\b(\d{2}):(\d{2})\b/);
            return match ? match[1] + ':' + match[2] : '--:--';
        }

        // 임시 표시용 계산. 실제 근무시간과 휴게시간 공제는 Service에서 계산해야 함
        function displayDuration(clockIn, clockOut) {
            const start = displayTime(clockIn);
            const end = displayTime(clockOut);
            if (start === '--:--' || end === '--:--') return '-';
            const a = start.split(':').map(Number);
            const b = end.split(':').map(Number);
            let mins = (b[0] * 60 + b[1]) - (a[0] * 60 + a[1]);
            if (mins < 0) mins += 24 * 60;
            return Math.floor(mins / 60) + '時間 ' + String(mins % 60).padStart(2, '0') + '分';
        }

        function statusText(status) {
            const key = String(status || '').toUpperCase();
            if (key === 'NORMAL' || key === 'PRESENT' || key === 'ON_TIME') return '通常勤務';
            if (key === 'LATE') return '遅刻';
            if (key === 'EARLY_LEAVE' || key === 'EARLY') return '早退';
            if (key === 'ABSENT') return '欠勤';
            return String(status || '未確認');
        }

        function remarkText(row) {
            if (row.remark || row.note) return String(row.remark || row.note);
            const s = statusText(row.status);
            if (s === '遅刻') return '遅刻による出勤';
            if (s === '早退') return '早期退勤';
            return '-';
        }

        /* --------------------------------------------------------
           수업에서 사용한 fetch / Promise 방식
           서버에서 JSON 목록 조회 -> jQuery로 테이블에 표시
           -------------------------------------------------------- */
        function getAttendanceList() {
            $('#att-message').text('勤怠記録を読み込んでいます。').removeClass('att-failure');
            $('#att-rows').empty();

            // 브라우저 미리보기에서만 사용하는 샘플 자료
            const task = Array.isArray(window.ATTENDANCE_DEMO)
                ? Promise.resolve(window.ATTENDANCE_DEMO)
                : fetch(contextPath + '/api/attendance/my', { method: 'GET' })
                    .then(response => {
                        if (!response.ok) throw new Error('勤怠記録の取得に失敗しました (HTTP ' + response.status + ')');
                        return response.json();
                    });

            task.then(res => {
                if (!Array.isArray(res)) throw new Error('サーバーのレスポンスが一覧形式ではありません。');
                attendanceList = res;
                listLoaded = true;
                //displayToday();
                displayList();
                $('#att-message').text('DB 読み込みが完了しました ・ 合計 ' + attendanceList.length + '件');
            }).catch(error => {
                console.error('勤怠記録の取得エラー:', error);
                attendanceList = [];
                listLoaded = false;
                $('#att-rows').empty();
                $('<tr>').append($('<td>', { colspan: 6, class: 'att-empty' })
                    .text('一覧の取得に失敗しました。 サーバー/API 状態を確認してください。'))
                    .appendTo('#att-rows');
                $('#att-message').addClass('att-failure').text(error.message);
            });
        }

        // 오늘의 출퇴근 카드
        const getTodayAttendance = async () => {

        	// 오늘 날짜 표시
        	const today = todayKorea();

        	$("div[name='workDate']").text(displayDate(today));

        	try {

        		// REST Controller에서 근태 목록 가져오기
        		const response = await fetch(
        			(document.body.getAttribute("data-context-path") || "") + "/api/attendance/my",
        	    	{
        	    		method: "GET"
        	    	}
        		);

        		if (!response.ok) {
        			throw new Error("勤怠情報の取得に失敗しました: " + response.status);
        		}

        		// JSON 데이터 받기
        		const records = await response.json();

        		console.log("DB 検索結果", records);

        		// 오늘 날짜에 해당하는 기록 찾기
        		const record = records.find(
        			row => String(row.workDate || "").substring(0, 10) === today
        		);

        		// 오늘 근태 기록이 없다면
        		if (!record) {

        			$("span[name='attendanceStatus']").text("出勤前");
        	    	$("div[name='clockIn']").text("--:--");
        	    	$("div[name='clockOut']").text("--:--");
        	    	
        	    	setAttendanceButtons(null);

        	    	return;
        		}

  				// 출퇴근 시간 출력
        		$("div[name='clockIn']").text(displayTime(record.clockIn));
        		$("div[name='clockOut']").text(displayTime(record.clockOut));

        		// 현재 상태 출력
        		if (record.clockOut) {
        			$("span[name='attendanceStatus']").text("退勤済み");

        		} else if (record.clockIn) {
        			$("span[name='attendanceStatus']").text("勤務中");

        		} else {
        			$("span[name='attendanceStatus']").text("出勤前");
        		}
				
        		setAttendanceButtons(record);
        		
        		} catch (error) {

        			console.error("本日の勤怠取得エラー", error);
        	}
        };
        

     // 출근・퇴근 버튼 상태 제어
     const setAttendanceButtons = (record) => {

         const checkedIn = !!(record && record.clockIn);
         const checkedOut = !!(record && record.clockOut);

         $("button[name='clockInButton']")
             .prop("disabled", checkedIn);

         $("button[name='clockOutButton']")
             .prop("disabled", !checkedIn || checkedOut);
     };

     // 요청 진행 중 버튼 비활성화
     const disableAttendanceButtons = () => {

         $("button[name='clockInButton']").prop("disabled", true);
         $("button[name='clockOutButton']").prop("disabled", true);
     };

     // 출근 및 퇴근 요청
     const submitAttendance = async (action) => {

         disableAttendanceButtons();

         try {

             const response = await fetch(
                 (document.body.getAttribute("data-context-path") || "") + "/api/attendance/" + action,
                 {
                     method: "POST"
                 }
             );

             const message = await response.text();

             if (!response.ok) {
                 throw new Error(message || "出退勤の打刻に失敗しました");
             }

             alert(message);

         } catch (error) {

             alert(error.message);

         } finally {

             await getTodayAttendance();
             getAttendanceList();

         }
     };


        // 월 선택에 따라 현재 받아온 JSON 데이터를 필터링
        function filteredList() {
            const month = $('#att-month').val();
            return attendanceList.filter(row => String(row.workDate || '').substring(0, 7) === month);
        }

        function displayList() {
            const list = filteredList();
            const tbody = $('#att-rows');
            tbody.empty();

            if (list.length === 0) {
                $('<tr>').append($('<td>', { colspan: 6, class: 'att-empty' })
                    .text('選択した期間の勤怠記録がありません。')).appendTo(tbody);
                return;
            }

            // HTML 문자열 직접 조합 대신 .text()로 DB 값을 안전하게 출력
            for (let i = 0; i < list.length; i++) {
                const row = list[i];
                const status = statusText(row.status);
                const tr = $('<tr>');
                $('<td>').text(displayDate(row.workDate)).appendTo(tr);
                $('<td>').text(displayTime(row.clockIn)).appendTo(tr);
                $('<td>').text(displayTime(row.clockOut)).appendTo(tr);
                $('<td>').text(displayDuration(row.clockIn, row.clockOut)).appendTo(tr);
                $('<td>').text(status).toggleClass('att-emphasis',
                    status === '遅刻' || status === '早退' || status === '欠勤').appendTo(tr);
                $('<td>').text(remarkText(row)).appendTo(tr);
                tbody.append(tr);
            }
        }

        function showMonthlyDetail() {
            if (!listLoaded) return;
            const list = filteredList();
            const count = value => list.filter(row => statusText(row.status) === value).length;
            $('#att-dialog-month').text($('#att-month').val() + ' 勤怠サマリー');
            $('#att-count-total').text(list.length + '件');
            $('#att-count-normal').text(count('通常勤務') + '件');
            $('#att-count-late').text(count('遅刻') + '件');
            $('#att-count-early').text(count('早退') + '件');
            $('#att-dialog-overlay').prop('hidden', false);
        }

        $(function () {
            // JSP 로드 완료 후 목록 조회 (수업에서 사용하던 $(function(){}) 방식)
            $('#att-month').val(todayKorea().substring(0, 7));
			
            getTodayAttendance();
            getAttendanceList();
            
            $('#att-search').click(function () { if (listLoaded) displayList(); });
            
            
            //$('#att-monthly-detail').click(showMonthlyDetail);
            
            
            $('#att-dialog-close').click(function () { $('#att-dialog-overlay').prop('hidden', true); });
            $('#att-dialog-overlay').click(function (event) {
                if (event.target === this) $(this).prop('hidden', true);
            });
            $(document).keydown(function (event) {
                if (event.key === 'Escape') $('#att-dialog-overlay').prop('hidden', true);
            });

            $("button[name='moveMonthlyView']").on("click", function() {
				window.location.href = contextPath + "/attendance/monthly";
			});
            

            $("button[name='clockInButton']").on("click", function() {

                submitAttendance("clock-in");

            });

            $("button[name='clockOutButton']").on("click", function() {

                submitAttendance("clock-out");

            });

            
        });
