<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map,java.util.Collections,java.util.Objects" %>
<%@ page import="com.hexagon.hrproject.domain.Account" %>
<%@ page import="com.hexagon.hrproject.domain.HrRole" %>

<%!
    private String rolePreviewEscape(Object value) {
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
    Account managedAccount =
        (Account) request.getAttribute("account");

    List<HrRole> roleOptions =
        (List<HrRole>) request.getAttribute("roleList");

    if (roleOptions == null) {
        roleOptions = Collections.<HrRole>emptyList();
    }

    List<HrRole> assignedRoles = managedAccount == null
        ? null
        : managedAccount.getRoles();

    List<Map<String, Object>> permissionRows =
        (List<Map<String, Object>>)
            request.getAttribute("rolePermissions");

    boolean permissionDataReady = permissionRows != null;

    if (permissionRows == null) {
        permissionRows =
            Collections.<Map<String, Object>>emptyList();
    }

    boolean hasRoleOption = false;

    for (HrRole option : roleOptions) {
        if (option != null) {
            hasRoleOption = true;
            break;
        }
    }

    boolean saveCompleted =
        Boolean.TRUE.equals(
            request.getAttribute("roleSaveSuccess")
        );
%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 권한 부여</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/admin-account-manage.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-admin-account-manage account-manage-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<div class="breadcrumb">HRMS / 권한 관리</div>
<h1 class="hrms-page-title">사원 계정 및 역할(Role) 설정</h1>
</div>
</div>
<section class="content-card">

            <% if (managedAccount != null) { %>

            <h2 class="account-info-title">
                계정 정보:
                <%=rolePreviewEscape(managedAccount.getLoginId())%>

                (<%=rolePreviewEscape(
                    managedAccount.getEmp() == null
                        ? ""
                        : managedAccount.getEmp().getEname()
                )%>)
            </h2>

            <% if (!permissionDataReady) { %>
            <p class="empty-message" role="alert">
                권한 정보를 불러오지 못했습니다.
                컨트롤러 적용 여부를 확인해 주세요.
            </p>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/accounts/<%=managedAccount.getAccountId()%>/roles" data-save-completed="<%=saveCompleted%>" id="roleForm" method="post">
<input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}"/>
<!-- 역할 선택 -->
<section aria-labelledby="roleSelectionTitle" id="roleSelection">
<h3 class="section-subtitle" id="roleSelectionTitle">
                        부여할 역할 선택
                    </h3>
<div class="role-list-container">

                        <%
                        for (HrRole option : roleOptions) {
                            if (option == null) continue;

                            boolean checked = false;

                            if (assignedRoles != null) {
                                for (HrRole assigned : assignedRoles) {
                                    if (assigned != null
                                            && Objects.equals(
                                                assigned.getHrRoleId(),
                                                option.getHrRoleId())) {

                                        checked = true;
                                        break;
                                    }
                                }
                            }
                        %>

                        <label class="role-label">
<input data-role-code="<%=rolePreviewEscape(option.getRoleCode())%>" data-role-name="<%=rolePreviewEscape(option.getRoleName())%>" <%=checked ? "checked" : ""%> name="roleIds" type="checkbox" value="<%=option.getHrRoleId()%>"/>
<span>
<strong>
                                    <%=rolePreviewEscape(option.getRoleName())%>
                                </strong>
                                (<%=rolePreviewEscape(option.getRoleCode())%>)
                            </span>
<!-- DB에서 조회한 역할별 권한 정보 -->
<span class="role-permission-data" hidden="">
                                <%
                                for (Map<String, Object> permissionRow
                                        : permissionRows) {

                                    if (!String.valueOf(
                                            option.getHrRoleId()
                                        ).equals(String.valueOf(
                                            permissionRow.get("roleId")
                                        ))) {
                                        continue;
                                    }
                                %>

                                <span data-permission-code="<%=rolePreviewEscape(permissionRow.get("permissionCode"))%>" data-permission-name="<%=rolePreviewEscape(permissionRow.get("permissionName"))%>">
</span>

                                <% } %>
                            </span>
</label>

                        <% } %>

                        <% if (!hasRoleOption) { %>
                        <p class="empty-message">
                            선택 가능한 역할이 없습니다.
                        </p>
                        <% } %>

                    </div>
<button class="btn-save" id="previewButton" <%=hasRoleOption && permissionDataReady
                                ? ""
                                : "disabled"%> type="button">
                        다음 · 권한 미리보기
                    </button>
</section>
<!-- 저장 전 미리보기 -->
<section aria-labelledby="previewTitle" hidden="" id="rolePreview">
<h3 class="section-subtitle" id="previewTitle" tabindex="-1">
                        저장 전 권한 미리보기
                    </h3>
<dl class="preview-summary">
<div>
<dt>사원</dt>
<dd>
                                <%=rolePreviewEscape(
                                    managedAccount.getEmp() == null
                                        ? "사원 정보 없음"
                                        : managedAccount.getEmp().getEname()
                                )%>
                            </dd>
</div>
<div>
<dt>로그인 아이디</dt>
<dd>
                                <%=rolePreviewEscape(
                                    managedAccount.getLoginId()
                                )%>
                            </dd>
</div>
<div>
<dt>선택한 역할</dt>
<dd id="previewRoles"></dd>
</div>
</dl>
<h4 class="section-subtitle">
                        선택한 역할에 연결된 권한
                    </h4>
<p class="empty-message" hidden="" id="previewEmpty" role="status">
</p>
<div class="preview-table-wrap" id="permissionTableWrap">
<div class="hrms-table-scroll"><table class="preview-table">
<thead>
<tr>
<th scope="col">권한 이름</th>
<th scope="col">권한 코드</th>
</tr>
</thead>
<tbody id="previewPermissions"></tbody>
</table></div>
</div>
<p class="preview-note">
                        중복 권한은 한 번만 표시합니다.
                        변경된 권한은 대상 계정이 다시 로그인한 뒤 적용됩니다.
                    </p>
<div class="form-actions">
<button class="btn-list" id="backButton" type="button">
                            이전 · 역할 수정
                        </button>
<button class="btn-save" disabled="" id="saveButton" type="submit">
                            권한 저장하기
                        </button>
</div>
</section>
</form>

            <% } else { %>

            <p class="empty-message">
                조회된 계정 정보가 없습니다.
            </p>

            <% } %>

            <div class="list-navigation">
<a class="btn-list" href="${pageContext.request.contextPath}/admin/accounts">
                    목록으로
                </a>
</div>
</section>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/admin-account-manage.js?v=1"></script>
</body></html>
