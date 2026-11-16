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
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - ロール別権限設定</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/admin-role-permission.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-admin-role-permission role-permission-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<p class="tools-location">HRMS / 権限管理</p>
<h1 class="hrms-page-title">ロール別権限設定</h1>
</div>
</div>

        <% if (request.getAttribute("rolePermissionMessage") != null) { %>

        <p class="tools-message" id="rolePermissionMessage" role="alert"><%=rolePermissionText(request.getAttribute("rolePermissionMessage"))%></p>

        <% } %>

        <div class="tools-navigation">
<a href="${pageContext.request.contextPath}/admin/accounts">
                ユーザー別ロール設定
            </a>
</div>
<section class="tools-card">
<h2>ロールで利用できる機能を指定</h2>
<p class="tools-description">
                ロールを選択して検索してください。
                変更した権限は対象ユーザーが再ログインした後に適用されます。
            </p>
<!-- 역할 조회 -->
<form action="${pageContext.request.contextPath}/admin/roles/permissions" class="tools-role-picker" method="get">
<label for="roleSelect">ロール</label>
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
                    検索
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
                    人事管理者ロールのアカウント管理・ロールの付与・ロール別権限設定
                    権限を保持する必要があります。
                </p>
<button class="tools-button" id="rolePermissionSave" type="submit">
                    権限の保存
                </button>
</form>

            <% } else { %>

            <p class="tools-description">
                設定可能なロールがありません。
            </p>

            <% } %>

        </section>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/admin-role-permission.js?v=ja-1"></script>
</body></html>
