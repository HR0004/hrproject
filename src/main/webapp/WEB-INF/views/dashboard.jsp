
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>HRMS Admin - ダッシュボード</title>

    <%@ include file="/WEB-INF/views/common/adminlte-head.jspf" %>

    <!-- 대시보드 내부 전용 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dashboard.css?v=ja-1">
</head>

<body class="hold-transition hrms-adminlte">

<div class="wrapper">

    <!-- AdminLTE 공통 사이드바 -->
    <%@ include file="/WEB-INF/views/common/adminlte-sidebar.jspf" %>

    <!-- AdminLTE 공통 헤더 -->
    <%@ include file="/WEB-INF/views/common/adminlte-header.jspf" %>

    <!-- 대시보드 메인 영역 -->
    <div class="content-wrapper">

        <section class="content-header">
            <div class="container-fluid">

                <!-- 페이지 제목 -->
                <div class="dashboard-heading">

                    <h1 class="dashboard-heading-title">
                        管理者ダッシュボード
                    </h1>

                    <p class="dashboard-heading-desc">
                        人事管理システム全体の状況を確認できます。
                    </p>

                </div>

            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- =========================
                     1. 사원 현황 카드
                ========================== -->
                <div class="dashboard-stats">

                    <!-- 전체 사원 -->
                    <a href="${pageContext.request.contextPath}/employees"
                       class="dashboard-stat-link">

                        <div class="dashboard-stat-card">

                            <div class="dashboard-stat-label">
                                社員総数
                            </div>

                            <div class="dashboard-stat-value">
                                ${stats.totalEmp}
                            </div>

                        </div>

                    </a>

                    <!-- 재직 -->
                    <a href="${pageContext.request.contextPath}/employees?status=ACTIVE"
                       class="dashboard-stat-link">

                        <div class="dashboard-stat-card">

                            <div class="dashboard-stat-label">
                                在籍
                            </div>

                            <div class="dashboard-stat-value">
                                ${stats.activeEmp}
                            </div>

                        </div>

                    </a>

                    <!-- 휴직 -->
                    <a href="${pageContext.request.contextPath}/employees?status=LEAVE"
                       class="dashboard-stat-link">

                        <div class="dashboard-stat-card">

                            <div class="dashboard-stat-label">
                                休職
                            </div>

                            <div class="dashboard-stat-value">
                                ${stats.leaveEmp}
                            </div>

                        </div>

                    </a>

                    <!-- 퇴직 -->
                    <a href="${pageContext.request.contextPath}/employees?status=RESIGN"
                       class="dashboard-stat-link">

                        <div class="dashboard-stat-card">

                            <div class="dashboard-stat-label">
                                退職
                            </div>

                            <div class="dashboard-stat-value">
                                ${stats.resignEmp}
                            </div>

                        </div>

                    </a>

                </div>

                <!-- =========================
                     2. 시스템 현황 요약
                ========================== -->
                <div class="dashboard-system">

                    <h2 class="dashboard-system-title">
                        システム状況サマリー
                    </h2>

                    <div class="dashboard-table-scroll">

                        <div class="hrms-table-scroll"><table class="dashboard-system-table">

                            <thead>
                                <tr>
                                    <th>区分</th>
                                    <th>状態</th>
                                    <th>備考</th>
                                </tr>
                            </thead>

                            <tbody>

                                <tr>
                                    <td>データベース接続</td>
                                    <td>正常 (MySQL)</td>
                                    <td>MyBatis 連携完了</td>
                                </tr>

                                <tr>
                                    <td>セキュリティとルーティング</td>
                                    <td>コントローラーのマッピング完了</td>
                                    <td>
                                        社員・部署・勤怠・休暇・権限モジュール連携
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

<%@ include file="/WEB-INF/views/common/adminlte-scripts.jspf" %>

</body>
</html>
