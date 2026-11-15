<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>휴가 신청 내역</title>
    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leave-history.css?v=1">
</head>
<body class="hold-transition hrms-adminlte hrms-leave" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
    <div class="content-wrapper">
<nav class="px-4 pt-3" aria-label="휴가 화면 이동">
<a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/leave">휴가 현황</a>
<a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/leave/history" aria-current="page">신청 내역</a>
<a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/leave/apply">휴가 신청</a>
</nav>
        <div class="content hrms-leave-content">
<main class="lh-page">
<h1 class="lh-heading">휴가 신청 내역</h1>
<p class="lh-caption">신청한 휴가의 기간과 승인 상태를 확인할 수 있습니다.</p>
<section aria-label="휴가 신청 내역 검색 조건" class="lh-filter-panel">
<div class="lh-filter-controls">
<div class="lh-filter-field">
<label class="lh-filter-title" for="filterStartDate">신청
								기간</label>
<div class="lh-date-range">
<input aria-label="신청 시작일" class="lh-input" id="filterStartDate" name="filterStartDate" type="date"/> <span class="lh-date-separator">~</span> <input aria-label="신청 종료일" class="lh-input" id="filterEndDate" name="filterEndDate" type="date"/>
</div>
</div>
<div class="lh-filter-field lh-status-filter">
<label class="lh-filter-title" for="filterStatus">승인 상태</label>
<div class="lh-select-wrap">
<select class="lh-select" id="filterStatus" name="filterStatus">
<option value="ALL">전체</option>
<option value="APPROVED">승인 완료</option>
<option value="PENDING">승인 대기</option>
<option value="REJECTED">반려</option>
<option value="CANCELED">취소됨</option>
</select>
</div>
</div>
</div>
<button class="lh-apply-btn" name="moveViewButton" type="button">휴가
						목록</button>
<button class="lh-apply-btn" name="moveApplyButton" type="button">휴가
						신청</button>
</section>
<section aria-labelledby="lhHistoryTitle" class="lh-card card">
<div class="lh-card-head">
<h2 class="lh-card-title" id="lhHistoryTitle">신청 내역</h2>
<span class="lh-count" name="historyCount">총 0건</span>
</div>
<div class="lh-table-scroll">
<table class="lh-table">
<thead>
<tr>
<th scope="col">신청일</th>
<th scope="col">휴가 종류</th>
<th scope="col">휴가 기간</th>
<th scope="col">일수</th>
<th scope="col">승인 상태</th>
<th scope="col">비고</th>
<th scope="col">관리</th>
</tr>
</thead>
<!-- 아래 5건은 Figma 시안의 예시 데이터. REST 조회 연결 시 교체 -->
<tbody name="historyRows">
</tbody>
<tbody>
<tr id="historyEmptyRow" style="display: none">
<td class="lh-empty" colspan="7">검색 결과가 없습니다.</td>
</tr>
</tbody>
</table>
</div>
<div class="lh-card-bottom">
<span class="lh-footer-count" name="historyFooterCount">총
							0건</span>
<nav aria-label="페이지 이동" class="lh-pagination">
<button aria-label="이전 페이지" class="lh-page-btn" name="previousPage" type="button">‹</button>
<span class="lh-pagination" name="pageNumbers"></span>
<button aria-label="다음 페이지" class="lh-page-btn" name="nextPage" type="button">›</button>
</nav>
</div>
</section>
</main>
<div class="lh-modal-overlay" id="leaveDetailOverlay" role="presentation">
<section aria-labelledby="leaveDetailTitle" aria-modal="true" class="lh-modal" role="dialog">
<div class="lh-modal-header">
<h2 id="leaveDetailTitle">휴가 신청 상세</h2>
<button aria-label="닫기" class="lh-modal-close" name="closeDetail" type="button">×</button>
</div>
<dl class="lh-modal-data">
<dt>신청일</dt>
<dd name="detailSubmitted">-</dd>
<dt>휴가 종류</dt>
<dd name="detailType">-</dd>
<dt>휴가 기간</dt>
<dd name="detailPeriod">-</dd>
<dt>사용 일수</dt>
<dd name="detailDays">-</dd>
<dt>승인 상태</dt>
<dd name="detailStatus">-</dd>
<dt>비고</dt>
<dd name="detailRemark">-</dd>
</dl>
<div class="lh-modal-footer">
<button class="lh-modal-ok" name="closeDetail" type="button">닫기</button>
</div>
</section>
</div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/leave-history.js?v=1"></script>
</body>
</html>
