
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 사원 조회 · 검색</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/employee-employeesearch.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-employee-employeesearch" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<div class="employee-search-page hrms-page-content">
<section class="content-header">
<div class="container-fluid">
<h1 class="employee-page-title hrms-page-title">사원 조회 · 검색</h1>
<p class="employee-page-desc">
                    사번, 성명, 부서, 직급 및 재직 상태로 사원을 검색합니다.
                </p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 검색 조건 -->
<div class="search-panel">
<h2 class="search-section-title">검색 조건</h2>
<div class="search-grid">
<div class="search-field">
<label for="searchKeyword">사번 / 성명</label>
<input class="search-input" id="searchKeyword" placeholder="사번 또는 이름" type="text"/>
</div>
<div class="search-field">
<label for="searchDept">부서</label>
<select class="search-input" id="searchDept">
<option value="">전체 부서</option>
</select>
</div>
<div class="search-field">
<label for="searchJob">직급</label>
<select class="search-input" id="searchJob">
<option value="">전체 직급</option>
</select>
</div>
<div class="search-field">
<label for="searchStatus">재직 상태</label>
<select class="search-input" id="searchStatus">
<option value="">전체</option>
<option value="ACTIVE">재직</option>
<option value="LEAVE">휴직</option>
<option value="RETIRED">퇴직</option>
</select>
</div>
</div>
<div class="search-bottom">
<div class="search-field search-date-field">
<label for="startDate">입사일</label>
<div class="date-range">
<input class="search-input" id="startDate" type="date"/>
<span class="date-separator">~</span>
<input aria-label="입사일 종료일" class="search-input" id="endDate" type="date"/>
</div>
</div>
<div class="search-actions">
<button class="search-btn" id="resetBtn" type="button">
                                초기화
                            </button>
<button class="search-btn search-btn-primary" id="searchBtn" type="button">
                                검색
                            </button>
</div>
</div>
</div>
<!-- 검색 결과 -->
<div class="search-results">
<div class="search-result-header">
<h2 class="search-result-title">
                            검색 결과
                            <span id="resultCount">0명</span>
</h2>
<a class="back-list-btn" href="${pageContext.request.contextPath}/employees">
                            전체 사원 보기
                        </a>
</div>
<div class="search-table-wrap">
<div class="hrms-table-scroll"><table class="employee-table">
<thead>
<tr>
<th>사번</th>
<th>성명</th>
<th>부서</th>
<th>직급</th>
<th>이메일</th>
<th>입사일</th>
<th>재직 상태</th>
<th>관리</th>
</tr>
</thead>
<tbody id="searchResultBody">
<tr>
<td class="empty-message" colspan="8">
                                        검색 조건을 입력하고 검색 버튼을 눌러주세요.
                                    </td>
</tr>
</tbody>
</table></div>
</div>
</div>
</div>
</section>
</div>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/employee-employeesearch.js?v=1"></script>
</body></html>
