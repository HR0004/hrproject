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
            const days = ['일', '월', '화', '수', '목', '금', '토'];
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
            return Math.floor(mins / 60) + '시간 ' + String(mins % 60).padStart(2, '0') + '분';
        }

        function statusText(status) {
            const key = String(status || '').toUpperCase();
            if (key === 'NORMAL' || key === 'PRESENT' || key === 'ON_TIME') return '정상 근무';
            if (key === 'LATE') return '지각';
            if (key === 'EARLY_LEAVE' || key === 'EARLY') return '조퇴';
            if (key === 'ABSENT') return '결근';
            return String(status || '미확인');
        }

        function remarkText(row) {
            if (row.remark || row.note) return String(row.remark || row.note);
            const s = statusText(row.status);
            if (s === '지각') return '출근 지각';
            if (s === '조퇴') return '조기 퇴근';
            return '-';
        }

        /* --------------------------------------------------------
           수업에서 사용한 fetch / Promise 방식
           서버에서 JSON 목록 조회 -> jQuery로 테이블에 표시
           -------------------------------------------------------- */
        function getAttendanceList() {
            $('#att-message').text('근태 기록을 조회하고 있습니다.').removeClass('att-failure');
            $('#att-rows').empty();

            // 브라우저 미리보기에서만 사용하는 샘플 자료
            const task = Array.isArray(window.ATTENDANCE_DEMO)
                ? Promise.resolve(window.ATTENDANCE_DEMO)
                : fetch(contextPath + '/api/attendance/my', { method: 'GET' })
                    .then(response => {
                        if (!response.ok) throw new Error('근태 기록 조회 실패 (HTTP ' + response.status + ')');
                        return response.json();
                    });

            task.then(res => {
                if (!Array.isArray(res)) throw new Error('서버 응답이 목록 형태가 아닙니다.');
                attendanceList = res;
                listLoaded = true;
                //displayToday();
                displayList();
                $('#att-message').text('DB 조회 완료 · 총 ' + attendanceList.length + '건');
            }).catch(error => {
                console.error('근태 기록 조회 에러:', error);
                attendanceList = [];
                listLoaded = false;
                $('#att-rows').empty();
                $('<tr>').append($('<td>', { colspan: 6, class: 'att-empty' })
                    .text('목록 조회에 실패했습니다. 서버/API 상태를 확인하세요.'))
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
        			throw new Error("근태 조회 실패: " + response.status);
        		}

        		// JSON 데이터 받기
        		const records = await response.json();

        		console.log("DB 조회 결과", records);

        		// 오늘 날짜에 해당하는 기록 찾기
        		const record = records.find(
        			row => String(row.workDate || "").substring(0, 10) === today
        		);

        		// 오늘 근태 기록이 없다면
        		if (!record) {

        			$("span[name='attendanceStatus']").text("출근 전");
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
        			$("span[name='attendanceStatus']").text("퇴근 완료");

        		} else if (record.clockIn) {
        			$("span[name='attendanceStatus']").text("근무 중");

        		} else {
        			$("span[name='attendanceStatus']").text("출근 전");
        		}
				
        		setAttendanceButtons(record);
        		
        		} catch (error) {

        			console.error("오늘 근태 조회 오류", error);
        	}
        };
        

     // 출근·퇴근 버튼 상태 제어
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
                 throw new Error(message || "출퇴근 등록 실패");
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
                    .text('선택한 기간의 근태 기록이 없습니다.')).appendTo(tbody);
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
                    status === '지각' || status === '조퇴' || status === '결근').appendTo(tr);
                $('<td>').text(remarkText(row)).appendTo(tr);
                tbody.append(tr);
            }
        }

        function showMonthlyDetail() {
            if (!listLoaded) return;
            const list = filteredList();
            const count = value => list.filter(row => statusText(row.status) === value).length;
            $('#att-dialog-month').text($('#att-month').val() + ' 근태 요약');
            $('#att-count-total').text(list.length + '건');
            $('#att-count-normal').text(count('정상 근무') + '건');
            $('#att-count-late').text(count('지각') + '건');
            $('#att-count-early').text(count('조퇴') + '건');
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
