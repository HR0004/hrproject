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
<html lang="ja"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>HRMS - 権限の付与</title>

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome-6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/screens/admin-account-manage.css?v=ja-1">
</head><body class="hold-transition hrms-adminlte hrms-screen-admin-account-manage account-manage-page" data-context-path="${pageContext.request.contextPath}">
<div class="wrapper">
<%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>
<%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>
<div class="content-wrapper">
<main class="hrms-page-content">
<div class="hrms-page-heading">
<div class="page-title-area">
<div class="breadcrumb">HRMS / 権限管理</div>
<h1 class="hrms-page-title">社員アカウントとロール(Role) 設定</h1>
</div>
</div>
<section class="content-card">

            <% if (managedAccount != null) { %>

            <h2 class="account-info-title">
                アカウント情報:
                <%=rolePreviewEscape(managedAccount.getLoginId())%>

                (<%=rolePreviewEscape(
                    managedAccount.getEmp() == null
                        ? ""
                        : managedAccount.getEmp().getEname()
                )%>)
            </h2>

            <% if (!permissionDataReady) { %>
            <p class="empty-message" role="alert">
                権限情報を読み込めませんでした。
                コントローラーの適用状態を確認してください。
            </p>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/accounts/<%=managedAccount.getAccountId()%>/roles" data-save-completed="<%=saveCompleted%>" id="roleForm" method="post">
<input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}"/>
<!-- 역할 선택 -->
<section aria-labelledby="roleSelectionTitle" id="roleSelection">
<h3 class="section-subtitle" id="roleSelectionTitle">
                        付与するロールを選択
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
                            選択可能なロールがありません。
                        </p>
                        <% } %>

                    </div>
<button class="btn-save" id="previewButton" <%=hasRoleOption && permissionDataReady
                                ? ""
                                : "disabled"%> type="button">
                        次へ ・ 権限プレビュー
                    </button>
</section>
<!-- 저장 전 미리보기 -->
<section aria-labelledby="previewTitle" hidden="" id="rolePreview">
<h3 class="section-subtitle" id="previewTitle" tabindex="-1">
                        保存前の権限プレビュー
                    </h3>
<dl class="preview-summary">
<div>
<dt>社員</dt>
<dd>
                                <%=rolePreviewEscape(
                                    managedAccount.getEmp() == null
                                        ? "社員情報なし"
                                        : managedAccount.getEmp().getEname()
                                )%>
                            </dd>
</div>
<div>
<dt>ログインID</dt>
<dd>
                                <%=rolePreviewEscape(
                                    managedAccount.getLoginId()
                                )%>
                            </dd>
</div>
<div>
<dt>選択したロール</dt>
<dd id="previewRoles"></dd>
</div>
</dl>
<h4 class="section-subtitle">
                        選択したロールに紐付く権限
                    </h4>
<p class="empty-message" hidden="" id="previewEmpty" role="status">
</p>
<div class="preview-table-wrap" id="permissionTableWrap">
<div class="hrms-table-scroll"><table class="preview-table">
<thead>
<tr>
<th scope="col">権限名</th>
<th scope="col">権限コード</th>
</tr>
</thead>
<tbody id="previewPermissions"></tbody>
</table></div>
</div>
<p class="preview-note">
                        重複する権限は一度だけ表示します。
                        変更した権限は対象ユーザーが再ログインした後に適用されます。
                    </p>
<div class="form-actions">
<button class="btn-list" id="backButton" type="button">
                            前へ ・ ロール編集
                        </button>
<button class="btn-save" disabled="" id="saveButton" type="submit">
                            権限を保存
                        </button>
</div>
</section>
</form>

            <% } else { %>

            <p class="empty-message">
                該当するアカウント情報がありません。
            </p>

            <% } %>

            <div class="list-navigation">
<a class="btn-list" href="${pageContext.request.contextPath}/admin/accounts">
                    一覧へ
                </a>
</div>
</section>
</main>
</div>
</div>
<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>
<script src="${pageContext.request.contextPath}/static/js/screens/admin-account-manage.js?v=ja-1"></script>
</body></html>
