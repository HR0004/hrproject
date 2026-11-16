<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map,java.util.Set" %>

<%!
    private String rolePermissionText(Object value) {
        return org.springframework.web.util.HtmlUtils.htmlEscape(
            value == null ? "" : String.valueOf(value)
        );
    }
%>

<%
    List<Map<String, Object>> rpRoles =
        (List<Map<String, Object>>) request.getAttribute("roles");

    List<Map<String, Object>> rpPermissions =
        (List<Map<String, Object>>) request.getAttribute("permissions");

    Long rpRoleId =
        (Long) request.getAttribute("selectedRoleId");

    Set<Long> rpSelected =
        (Set<Long>) request.getAttribute("selectedPermissionIds");
%>

<!DOCTYPE html>
<html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 역할별 권한 설정</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/admin-role-permission.css?v=job-unified-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-admin-role-permission role-permission-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<p class="tools-location">HRMS / 권한 관리</p>
<h1 class="hrms-page-title">역할별 권한 설정</h1>
</div>
</div>

        <% if (request.getAttribute("rolePermissionMessage") != null) { %>

        <p class="tools-message" id="rolePermissionMessage" role="alert"><%=rolePermissionText(request.getAttribute("rolePermissionMessage"))%></p>

        <% } %>

        <div class="tools-navigation">
<a href="${pageContext.request.contextPath}/admin/accounts">
                사용자별 역할 부여
            </a>
</div>
<section class="tools-card">
<h2>역할에 사용할 수 있는 기능 지정</h2>
<p class="tools-description">
                역할을 선택한 뒤 조회해 주세요.
                변경된 권한은 해당 사용자가 재로그인한 뒤 적용됩니다.
            </p>
<!-- 역할 조회 -->
<form action="${pageContext.request.contextPath}/admin/roles/permissions" class="tools-role-picker" method="get">
<label for="roleSelect">역할</label>
<select id="roleSelect" name="roleId">
                    <%
                    for (Map<String, Object> row : rpRoles) {
                        long id =
                            ((Number) row.get("roleId")).longValue();
                    %>

                    <option <%=rpRoleId != null
                                && rpRoleId.longValue() == id
                                ? "selected" : ""%> value="<%=id%>">

                        <%=rolePermissionText(row.get("roleName"))%>
                        (<%=rolePermissionText(row.get("roleCode"))%>)
                    </option>

                    <% } %>
                </select>
<button class="tools-secondary" type="submit">
                    조회
                </button>
</form>

            <% if (rpRoleId != null) { %>

            <!-- 권한 저장 -->
<form action="${pageContext.request.contextPath}/admin/roles/permissions" id="rolePermissionForm" method="post">
<input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}"/>
<input name="roleId" type="hidden" value="<%=rpRoleId%>"/>
<div class="tools-permissions">

                    <%
                    for (Map<String, Object> row : rpPermissions) {
                        long id = ((Number) row.get(
                            "permissionId"
                        )).longValue();
                    %>

                    <label class="tools-permission">
<input <%=rpSelected.contains(id)
                                   ? "checked" : ""%> name="permissionIds" type="checkbox" value="<%=id%>"/>
<span>
<strong>
                                <%=rolePermissionText(
                                    row.get("permissionName")
                                )%>
                            </strong>
<small>
                                <%=rolePermissionText(
                                    row.get("permissionCode")
                                )%>
                            </small>
</span>
</label>

                    <% } %>

                </div>
<p class="tools-description">
                    인사 관리자 역할의 계정 관리·역할 부여·역할별 권한 설정
                    권한은 유지해야 합니다.
                </p>
<button class="tools-button" id="rolePermissionSave" type="submit">
                    권한 저장
                </button>
</form>

            <% } else { %>

            <p class="tools-description">
                설정할 역할이 없습니다.
            </p>

            <% } %>

        </section>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/admin-role-permission.js?v=1"></script>
</body></html>
