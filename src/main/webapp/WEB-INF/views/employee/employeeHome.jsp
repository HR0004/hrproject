
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 社員マイページ</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeehome.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeehome employee-home-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="employee-home-content hrms-page-content"><span class="sr-only" id="loginUser"></span>
<!-- 페이지 제목 -->
<div class="employee-home-heading">
<h1 class="hrms-page-title">マイページ</h1>
<p>ご自身の人事情報と勤務状況を確認できます。</p>
</div>
<!-- 상단 요약 카드 -->
<section class="employee-home-summary">
<div class="employee-home-summary-card">
<p>在籍状態</p>
<h2 id="summaryStatus">-</h2>
</div>
<div class="employee-home-summary-card">
<p>所属部署</p>
<h2 id="summaryDept">-</h2>
</div>
<div class="employee-home-summary-card">
<p>役職</p>
<h2 id="summaryJob">-</h2>
</div>
<div class="employee-home-summary-card">
<p>入社日</p>
<h2 id="summaryHiredate">-</h2>
</div>
</section>
<!-- 중간 영역 -->
<section class="employee-home-middle">
<!-- 내 기본 정보 -->
<div class="employee-home-card">
<div class="employee-home-card-heading">
<h3>自分の基本情報</h3>
<button class="employee-home-edit-btn" id="editRequestBtn" onclick="location.href='${pageContext.request.contextPath}/employee/myedit'" type="button">
                            情報変更を依頼
                        </button>
</div>
<div class="employee-home-info-grid">
<div class="employee-home-info-item">
<label>社員番号</label>
<span id="myEmpId">-</span>
</div>
<div class="employee-home-info-item">
<label>氏名</label>
<span id="myName">-</span>
</div>
<div class="employee-home-info-item">
<label>メールアドレス</label>
<span id="myEmail">-</span>
</div>
<div class="employee-home-info-item">
<label>電話番号</label>
<span id="myPhone">-</span>
</div>
<div class="employee-home-info-item">
<label>部署</label>
<span id="myDept">-</span>
</div>
<div class="employee-home-info-item">
<label>役職</label>
<span id="myJob">-</span>
</div>
</div>
</div>
<!-- 바로가기 -->
<div class="employee-home-card">
<h3>クイックリンク</h3>
<div class="employee-home-shortcut">
<strong>出退勤記録を表示</strong>
<p>日別の出退勤記録</p>
<span>›</span>
</div>
<div class="employee-home-shortcut">
<strong>休暇申請 / 履歴</strong>
<p>休暇申請と承認状況</p>
<span>›</span>
</div>
<div class="employee-home-shortcut">
<strong>給与明細を表示</strong>
<p>月別の給与履歴を確認</p>
<span>›</span>
</div>
</div>
</section>
<!-- 하단 영역 -->
<section class="employee-home-bottom">
<!-- 최근 근태 내역 -->
<div class="employee-home-card">
<h3>最近の勤怠履歴</h3>
<div class="employee-home-table-head">
<span>勤務日</span>
<span>出勤</span>
<span>退勤</span>
<span>状態</span>
</div>
<div class="employee-home-empty" id="recentAttendance">
                        勤怠情報はまだ読み込まれていません。
                    </div>
<div class="employee-home-bottom-link">
                        勤怠記録をすべて表示
                    </div>
</div>
<!-- 최근 휴가 신청 -->
<div class="employee-home-card">
<h3>最近の休暇申請</h3>
<div class="employee-home-table-head leave">
<span>休暇区分</span>
<span>期間</span>
<span>承認状態</span>
</div>
<div class="employee-home-empty" id="recentLeave">
                        休暇情報はまだ読み込まれていません。
                    </div>
<div class="employee-home-bottom-link">
                        休暇申請履歴を表示
                    </div>
</div>
</section>
<!-- 하단 안내 -->
<p class="employee-home-footer">
                ※ 勤怠・休暇履歴は機能の連携後に表示されます。
            </p>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeehome.js?v=ja-1"></script>
</body></html>
