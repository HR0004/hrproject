<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>休暇申請履歴</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-history.css?v=ja-1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/attendance-leave-layout.css?v=ja-1">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
        <div class="content hrms-leave-content">
<main class="lh-page hrms-page-content hrms-attendance-leave-page">
<header class="hrms-section-page-header">
<h1 class="lh-heading hrms-page-title">休暇申請履歴</h1>
<p class="lh-caption page-path">申請した休暇の期間と承認状況を確認できます。</p>
</header>
<section aria-label="休暇申請履歴の検索条件" class="lh-filter-panel">
<div class="lh-filter-controls">
<div class="lh-filter-field">
<label class="lh-filter-title" for="filterStartDate">申請
								期間</label>
<div class="lh-date-range">
<input aria-label="申請開始日" class="lh-input" id="filterStartDate" name="filterStartDate" type="date"/> <span class="lh-date-separator">~</span> <input aria-label="申請終了日" class="lh-input" id="filterEndDate" name="filterEndDate" type="date"/>
</div>
</div>
<div class="lh-filter-field lh-status-filter">
<label class="lh-filter-title" for="filterStatus">承認状態</label>
<div class="lh-select-wrap">
<select class="lh-select" id="filterStatus" name="filterStatus">
<option value="ALL">すべて</option>
<option value="APPROVED">承認済み</option>
<option value="PENDING">承認待ち</option>
<option value="REJECTED">否認</option>
<option value="CANCELED">取消済み</option>
</select>
</div>
</div>
</div>
<button class="lh-apply-btn" name="moveViewButton" type="button">休暇
						一覧</button>
<button class="lh-apply-btn" name="moveApplyButton" type="button">休暇
						申請</button>
</section>
<section aria-labelledby="lhHistoryTitle" class="lh-card card">
<div class="lh-card-head">
<h2 class="lh-card-title" id="lhHistoryTitle">申請履歴</h2>
<span class="lh-count" name="historyCount">合計 0件</span>
</div>
<div class="lh-table-scroll">
<div class="hrms-table-scroll"><table class="lh-table">
<thead>
<tr>
<th scope="col">申請日</th>
<th scope="col">休暇区分</th>
<th scope="col">休暇期間</th>
<th scope="col">日数</th>
<th scope="col">承認状態</th>
<th scope="col">備考</th>
<th scope="col">操作</th>
</tr>
</thead>
<!-- 아래 5건은 Figma 시안의 예시 데이터. REST 조회 연결 시 교체 -->
<tbody name="historyRows">
</tbody>
<tbody>
<tr id="historyEmptyRow" style="display: none">
<td class="lh-empty" colspan="7">検索結果がありません。</td>
</tr>
</tbody>
</table></div>
</div>
<div class="lh-card-bottom">
<span class="lh-footer-count" name="historyFooterCount">合計
							0件</span>
<nav aria-label="ページ移動" class="lh-pagination">
<button aria-label="前のページ" class="lh-page-btn" name="previousPage" type="button">‹</button>
<span class="lh-pagination" name="pageNumbers"></span>
<button aria-label="次のページ" class="lh-page-btn" name="nextPage" type="button">›</button>
</nav>
</div>
</section>
</main>
<div class="lh-modal-overlay" id="leaveDetailOverlay" role="presentation">
<section aria-labelledby="leaveDetailTitle" aria-modal="true" class="lh-modal" role="dialog">
<div class="lh-modal-header">
<h2 id="leaveDetailTitle">休暇申請の詳細</h2>
<button aria-label="閉じる" class="lh-modal-close" name="closeDetail" type="button">×</button>
</div>
<dl class="lh-modal-data">
<dt>申請日</dt>
<dd name="detailSubmitted">-</dd>
<dt>休暇区分</dt>
<dd name="detailType">-</dd>
<dt>休暇期間</dt>
<dd name="detailPeriod">-</dd>
<dt>取得日数</dt>
<dd name="detailDays">-</dd>
<dt>承認状態</dt>
<dd name="detailStatus">-</dd>
<dt>備考</dt>
<dd name="detailRemark">-</dd>
</dl>
<div class="lh-modal-footer">
<button class="lh-modal-ok" name="closeDetail" type="button">閉じる</button>
</div>
</section>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-history.js?v=ja-dynamic-2"></script>
</body>
</html>
