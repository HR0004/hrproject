<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Collections" %>
<%@ page import="com.hexagon.hrproject.domain.Account" %>
<%@ page import="com.hexagon.hrproject.domain.HrRole" %>

<%!
    private String accountListEscape(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    Object accountListValue =
        request.getAttribute("accountList");

    List<Account> accounts = accountListValue instanceof List
        ? (List<Account>) accountListValue
        : Collections.<Account>emptyList();

    String searchKeyword =
        accountListEscape(request.getAttribute("keyword"));

    int enabledCount = 0;
    int disabledCount = 0;
    int unassignedCount = 0;

    for (Account item : accounts) {
        if (item.getEnabled() == 1) {
            enabledCount++;
        } else {
            disabledCount++;
        }

        if (item.getRoles() == null || item.getRoles().isEmpty()) {
            unassignedCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 권한 관리</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/admin-account-list.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-admin-account-list" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="employee-page account-list-page hrms-page-content">
<!-- 페이지 제목 -->
<section class="content-header">
<div class="container-fluid">
<h1 class="employee-page-title hrms-page-title">
                    권한 관리
                </h1>
<p class="employee-page-desc">
                    계정 조회 · 역할 부여 · 활성/비활성 관리
                </p>
</div>
</section>
<section class="content">
<div class="container-fluid">
<!-- 계정 상태 변경 결과 -->
                <% if (request.getAttribute("accountStatusMessage") != null) { %>

                <p class="account-status-feedback" id="account-status-feedback" role="alert"><%=accountListEscape(request.getAttribute("accountStatusMessage"))%></p>

                <% } %>

                <!-- 조회된 계정 통계 -->
<div aria-label="조회된 계정 현황" class="employee-stats">
<div class="employee-stat-card">
<div class="employee-stat-label">
                            조회 계정
                        </div>
<div class="employee-stat-number">
                            <%=accounts.size()%>
                        </div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">
                            사용 중
                        </div>
<div class="employee-stat-number">
                            <%=enabledCount%>
                        </div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">
                            사용 중지
                        </div>
<div class="employee-stat-number">
                            <%=disabledCount%>
                        </div>
</div>
<div class="employee-stat-card">
<div class="employee-stat-label">
                            역할 미지정
                        </div>
<div class="employee-stat-number">
                            <%=unassignedCount%>
                        </div>
</div>
</div>
<!-- 목록 제목과 작업 버튼 -->
<div class="employee-toolbar">
<h2 class="employee-list-title">
                        권한 부여 대상 선택
                    </h2>
<div class="employee-toolbar-actions">
<button aria-controls="account-search-panel" aria-expanded="true" class="employee-btn account-filter-toggle" id="account-filter-toggle" type="button">
<i aria-hidden="true" class="fas fa-search"></i>

                            검색/필터
                        </button>
<button class="employee-register-btn" disabled="" form="account-selection-form" id="account-next-button" type="submit">
                            다음 · 역할 선택
                        </button>
</div>
</div>
<!-- 검색 폼 -->
<form action="${pageContext.request.contextPath}/admin/accounts" class="account-search-form" id="account-search-panel" method="get">
<label class="account-sr-only" for="account-keyword">
                        이름 또는 로그인 아이디
                    </label>
<input id="account-keyword" maxlength="100" name="keyword" placeholder="이름 또는 로그인 아이디 검색" type="search" value="<%=searchKeyword%>"/>
<button class="employee-search-btn account-search-submit" type="submit">
                        검색
                    </button>
<a class="account-reset-link" href="${pageContext.request.contextPath}/admin/accounts">
                        초기화
                    </a>
</form>
<!-- 계정 선택 폼 -->
<form action="${pageContext.request.contextPath}/admin/accounts" data-account-base="${pageContext.request.contextPath}/admin/accounts/" id="account-selection-form" method="get">
<div class="employee-table-wrap">
<div class="hrms-table-scroll"><table class="employee-table account-select-table">
<caption class="account-sr-only">
                                권한 관리 대상 계정 목록
                            </caption>
<thead>
<tr>
<th scope="col">선택</th>
<th scope="col">이름</th>
<th scope="col">로그인 아이디</th>
<th scope="col">현재 역할</th>
<th scope="col">계정 상태</th>
<th scope="col">상태 변경</th>
</tr>
</thead>
<tbody>

                            <%
                            for (Account item : accounts) {

                                String employeeName =
                                    item.getEmp() != null
                                        ? item.getEmp().getEname()
                                        : null;

                                if (employeeName == null
                                        || employeeName.trim().isEmpty()) {
                                    employeeName = "사원 정보 없음";
                                }

                                boolean isOwnAccount =
                                    request.getUserPrincipal() != null
                                    && item.getLoginId() != null
                                    && item.getLoginId().equals(
                                        request.getUserPrincipal().getName()
                                    );

                                boolean blockSelfDisable =
                                    isOwnAccount && item.getEnabled() == 1;
                            %>

                                <tr data-account-row="">
<td>
<input aria-label="<%=accountListEscape(employeeName)%> 선택" data-user-label="<%=accountListEscape(employeeName + " (" + item.getLoginId() + ")")%>" name="accountId" type="radio" value="<%=item.getAccountId()%>"/>
</td>
<td>
                                        <%=accountListEscape(employeeName)%>
                                    </td>
<td>
                                        <%=accountListEscape(item.getLoginId())%>
                                    </td>
<td>
                                    <%
                                        boolean hasRole = false;

                                        if (item.getRoles() != null) {
                                            for (HrRole role : item.getRoles()) {
                                                if (role == null) continue;

                                                hasRole = true;
                                    %>

                                        <span class="account-role-badge">
                                            <%=accountListEscape(
                                                role.getRoleName() != null
                                                    ? role.getRoleName()
                                                    : role.getRoleCode()
                                            )%>
                                        </span>

                                    <%
                                            }
                                        }

                                        if (!hasRole) {
                                    %>

                                        <span class="account-muted">
                                            미지정
                                        </span>

                                    <%
                                        }
                                    %>
                                    </td>
<td>
<span class="employee-status <%=item.getEnabled() == 1 ? "status-active" : "status-retired"%>">
                                            <%=item.getEnabled() == 1
                                                ? "사용 중"
                                                : "사용 중지"%>
                                        </span>
</td>
<td>
<button class="account-status-button <%=item.getEnabled() == 1 ? "account-disable" : "account-enable"%>" form="account-status-<%=item.getAccountId()%>" <%=blockSelfDisable ? "disabled" : ""%> type="submit">

                                            <%=blockSelfDisable
                                                ? "본인 계정"
                                                : (item.getEnabled() == 1
                                                    ? "비활성화"
                                                    : "활성화")%>

                                        </button>
</td>
</tr>

                            <%
                            }

                            if (accounts.isEmpty()) {
                            %>

                                <tr>
<td class="account-empty-list" colspan="6">
                                        조회된 계정이 없습니다.
                                        검색어를 바꾸거나 초기화해 주세요.
                                    </td>
</tr>

                            <%
                            }
                            %>

                            </tbody>
</table></div>
</div>
</form>
<!-- 상태 변경 폼: 선택 폼 밖에 배치 -->
                <% for (Account statusAccount : accounts) { %>

                <form action="${pageContext.request.contextPath}/admin/accounts/<%=statusAccount.getAccountId()%>/status" class="account-status-form" hidden="" id="account-status-<%=statusAccount.getAccountId()%>" method="post">
<input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}"/>
<input name="enabled" type="hidden" value="<%=statusAccount.getEnabled() == 1 ? 0 : 1%>"/>
<input name="keyword" type="hidden" value="<%=searchKeyword%>"/>
</form>

                <% } %>

                <p class="employee-notice" id="account-selection-message" role="status">
                    사용자를 선택해 주세요.
                </p>
<p class="account-scope-note">
                    ※ 상단 숫자는 현재 검색 결과를 기준으로 표시합니다.
                    사용자를 선택한 뒤 다음 버튼으로 역할 관리 화면에 이동합니다.
                </p>
</div>
</section>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/admin-account-list.js?v=1"></script>
</body></html>
