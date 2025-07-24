<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List, java.util.ArrayList, model.RevenueStat"%>
<%
    List<RevenueStat> stats = (List<RevenueStat>) request.getAttribute("stats");
    if (stats == null) stats = new ArrayList<>();
    
    // Calculate summary statistics
    double totalRevenue = stats.stream().mapToDouble(s -> s.getTotalRevenue()).sum();
    int totalOrders = stats.stream().mapToInt(s -> s.getTotalOrders()).sum();
    double avgRevenueAll = totalOrders > 0 ? totalRevenue / totalOrders : 0;
    double maxAvgRevenue = stats.stream().mapToDouble(s -> s.getAvgRevenue()).max().orElse(0);
%>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh thu trung bình/ngày</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Roboto+Mono&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/average-revenue.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #e3f0ff;
            color: #1a237e;
            margin: 0;
            padding: 0;
        }

        .dashboard {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .dashboard-title {
            font-size: 2rem;
            font-weight: 600;
        }

        .header-actions .action-btn {
            background-color: #4a90e2;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .header-actions .action-btn.secondary {
            background-color: #f39c12;
        }

        .header-actions .action-btn:hover {
            background-color: #357ab8;
        }

        .header-actions .action-btn.secondary:hover {
            background-color: #e67e22;
        }

        .stats-summary {
            margin-bottom: 2rem;
        }

        .section-header {
            margin-bottom: 28px;
        }

        .section-title {
            font-size: 2.2rem;
            font-weight: 800;
            color: #2563eb;
            letter-spacing: 1px;
        }

        .section-subtitle {
            color: #5c6bc0;
            font-size: 1.2rem;
            margin-top: 8px;
        }

        .tabs-container {
            margin-bottom: 1rem;
        }

        .tabs {
            display: flex;
            border-bottom: 2px solid #ddd;
        }

        .tab {
            padding: 1rem;
            cursor: pointer;
            font-weight: 500;
            border: none;
            background: transparent;
            transition: border-bottom 0.3s;
        }

        .tab.active {
            border-bottom: 2px solid #4a90e2;
            color: #4a90e2;
        }

        .tab-content {
            padding: 1rem;
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            background: #f9f9f9;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .stat-card {
            background: #fff;
            border-radius: 0.5rem;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .chart-section {
            margin-bottom: 2rem;
        }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2.5rem;
        }
        @media (max-width: 900px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }
        .chart-card {
            background: #fff;
            border-radius: 0.5rem;
            padding: 0.7rem 0.7rem 1rem 0.7rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }
        .chart-container {
            width: 100%;
            height: 180px;
            min-height: 140px;
        }
        .chart-container canvas {
            width: 100% !important;
            height: 160px !important;
            min-height: 140px !important;
        }
        .chart-title {
            font-size: 1.35rem;
            font-weight: 700;
            margin-bottom: 1.2rem;
        }
        .chart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.7rem;
        }
        .chart-actions {
            display: flex;
            gap: 0.5rem;
        }
        .chart-btn {
            background: #e3f2fd;
            color: #2563eb;
            border: none;
            border-radius: 6px;
            padding: 0.5rem 0.9rem;
            font-size: 1.15rem;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }
        .chart-btn:hover {
            background: #90cdf4;
            color: #fff;
        }

        .table-section {
            max-width: 1200px;
            margin: 48px auto 0 auto;
            background: #fff;
            border-radius: 32px;
            box-shadow: 0 8px 32px rgba(60, 100, 180, 0.10);
            padding: 48px 36px 36px 36px;
        }
        .table-card {
            background: #f6faff;
            border-radius: 20px;
            box-shadow: 0 4px 16px rgba(60, 100, 180, 0.07);
            padding: 32px 18px 18px 18px;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }
        .table-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2563eb;
        }
        .table-actions {
            display: flex;
            gap: 10px;
        }
        .search-box {
            display: flex;
            align-items: center;
            background: #e3eafc;
            border-radius: 6px;
            padding: 2px 8px;
        }
        .search-input {
            border: none;
            background: transparent;
            outline: none;
            font-size: 1rem;
            padding: 6px 4px;
        }
        .search-btn {
            background: none;
            border: none;
            color: #2563eb;
            font-size: 1.1rem;
            cursor: pointer;
        }
        .table-btn {
            background: #e3eafc;
            color: #2563eb;
            border: none;
            border-radius: 6px;
            padding: 6px 16px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }
        .table-btn:hover {
            background: #2563eb;
            color: #fff;
        }
        .table-responsive {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #f6faff;
            border-radius: 16px;
            overflow: hidden;
            font-size: 1.18rem;
        }
        th, td {
            padding: 22px 16px;
            text-align: left;
        }
        th {
            background: #b6d4fe;
            color: #2563eb;
            font-weight: 700;
            font-size: 1.18rem;
            border-bottom: 3px solid #2563eb;
        }
        tr:nth-child(even) {
            background: #e3f0ff;
        }
        tr:nth-child(odd) {
            background: #f6faff;
        }
        .currency {
            font-weight: 600;
            color: #2563eb;
        }
        .highlight {
            background: #e0f2fe;
            border-radius: 8px;
        }
        .no-data {
            text-align: center;
            color: #888;
            padding: 32px 0;
            font-size: 1.2rem;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 2.5rem;
        }
        .page-btn {
            background: #b6d4fe;
            color: #2563eb;
            border: none;
            border-radius: 32px;
            padding: 14px 32px;
            font-size: 1.18rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(60, 100, 180, 0.07);
        }
        .page-btn:hover {
            background: #2563eb;
            color: #fff;
            box-shadow: 0 4px 16px rgba(60, 100, 180, 0.13);
        }
        .page-btn.active {
            background: #2563eb;
            color: #fff;
            font-weight: 800;
        }
        .page-btn.disabled {
            background: #e0e0e0;
            color: #999;
            cursor: not-allowed;
        }
        @media (max-width: 1200px) {
            .table-section {
                padding: 18px 2px 18px 2px;
            }
            .table-card {
                padding: 10px 2px 10px 2px;
            }
            th, td {
                padding: 10px 4px;
            }
        }
        @media (max-width: 700px) {
            .section-title {
                font-size: 1.3rem;
            }
            .table-section {
                padding: 2px;
            }
            .table-card {
                padding: 2px;
            }
            th, td {
                padding: 6px 2px;
                font-size: 1rem;
            }
        }
        .btn-back-menu {
            display: inline-flex;
            align-items: center;
            gap: 0.7rem;
            background: #b6d4fe;
            color: #2563eb;
            font-weight: 700;
            font-size: 1rem;
            border: none;
            border-radius: 32px;
            padding: 8px 18px;
            margin: 16px 0 24px 0;
            text-decoration: none;
            box-shadow: 0 2px 12px rgba(60, 100, 180, 0.10);
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .btn-back-menu i {
            font-size: 1.1em;
        }
        .btn-back-menu:hover {
            background: #2563eb;
            color: #fff;
            box-shadow: 0 4px 18px rgba(60, 100, 180, 0.18);
        }
        @media (max-width: 700px) {
            .btn-back-menu {
                font-size: 0.95rem;
                padding: 6px 12px;
            }
        }
    </style>
</head>
<body>
    <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
    <div class="table-section" id="table-section">
        <div class="section-header">
            <h2 class="section-title">📋 Bảng chi tiết doanh thu</h2>
            <p class="section-subtitle">Dữ liệu chi tiết về doanh thu và đơn hàng</p>
        </div>
        <div class="tabs-container">
            <div class="tabs">
                <button class="tab active" onclick="openTab(event, 'table-overview')">Tổng quan</button>
                
            </div>
            <div class="tab-content" id="table-overview" style="display: block;">
                <div class="table-card">
                    <div class="table-header">
                        <h3 class="table-title">Dữ liệu doanh thu</h3>
                        <div class="table-actions">
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Ngày</th>
                                    <th>Số đơn hàng</th>
                                    <th>Tổng doanh thu</th>
                                    <th>Doanh thu trung bình</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (RevenueStat s : stats) { %>
                                <tr>
                                    <td class="date-cell"><%= s.getLabel() %></td>
                                    <td class="order-cell"><%= s.getTotalOrders() %></td>
                                    <td class="currency revenue-cell"><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
                                    <td class="currency avg-revenue-cell highlight"><%= String.format("%,.0f", s.getAvgRevenue()) %> đ</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <!-- PHÂN TRANG -->
                    <div class="pagination">
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages != null && totalPages > 1) {
        // Nút Trước
        if (currentPage > 1) {
            out.print("<a href='average-revenue?page=" + (currentPage - 1) + "' class='page-btn'>Trước</a>");
        } else {
            out.print("<span class='page-btn disabled'>Trước</span>");
        }
        // Các nút số trang
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) {
                out.print("<span class='page-btn active'>" + i + "</span>");
            } else {
                out.print("<a href='average-revenue?page=" + i + "' class='page-btn'>" + i + "</a>");
            }
        }
        // Nút Sau
        if (currentPage < totalPages) {
            out.print("<a href='average-revenue?page=" + (currentPage + 1) + "' class='page-btn'>Sau</a>");
        } else {
            out.print("<span class='page-btn disabled'>Sau</span>");
        }
    }
%>
                    </div>
                </div>
            </div>
            <div class="tab-content" id="table-details" style="display: none;">
                <p class="no-data">Chưa có dữ liệu chi tiết bổ sung để hiển thị.</p>
=======
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doanh thu trung bình/ngày</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Roboto+Mono&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/average-revenue.css">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f4f7fa;
                color: #333;
                margin: 0;
                padding: 0;
            }

            .dashboard {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
                background: white;
                border-radius: 1rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }

            .dashboard-title {
                font-size: 2rem;
                font-weight: 600;
            }

            .header-actions .action-btn {
                background-color: #4a90e2;
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 0.5rem;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .header-actions .action-btn.secondary {
                background-color: #f39c12;
            }

            .header-actions .action-btn:hover {
                background-color: #357ab8;
            }

            .header-actions .action-btn.secondary:hover {
                background-color: #e67e22;
            }

            .stats-summary {
                margin-bottom: 2rem;
            }

            .section-header {
                margin-bottom: 1rem;
            }

            .section-title {
                font-size: 1.5rem;
                font-weight: 600;
            }

            .tabs-container {
                margin-bottom: 1rem;
            }

            .tabs {
                display: flex;
                border-bottom: 2px solid #ddd;
            }

            .tab {
                padding: 1rem;
                cursor: pointer;
                font-weight: 500;
                border: none;
                background: transparent;
                transition: border-bottom 0.3s;
            }

            .tab.active {
                border-bottom: 2px solid #4a90e2;
                color: #4a90e2;
            }

            .tab-content {
                padding: 1rem;
                border: 1px solid #ddd;
                border-radius: 0.5rem;
                background: #f9f9f9;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
            }

            .stat-card {
                background: #fff;
                border-radius: 0.5rem;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
                transition: transform 0.3s;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-icon {
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .chart-section {
                margin-bottom: 2rem;
            }

            .charts-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 2.5rem;
            }
            @media (max-width: 900px) {
                .charts-grid {
                    grid-template-columns: 1fr;
                }
            }
            .chart-card {
                background: #fff;
                border-radius: 0.5rem;
                padding: 0.7rem 0.7rem 1rem 0.7rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                min-height: 200px;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
            }
            .chart-container {
                width: 100%;
                height: 180px;
                min-height: 140px;
            }
            .chart-container canvas {
                width: 100% !important;
                height: 160px !important;
                min-height: 140px !important;
            }
            .chart-title {
                font-size: 1.35rem;
                font-weight: 700;
                margin-bottom: 1.2rem;
            }
            .chart-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 0.7rem;
            }
            .chart-actions {
                display: flex;
                gap: 0.5rem;
            }
            .chart-btn {
                background: #e3f2fd;
                color: #2563eb;
                border: none;
                border-radius: 6px;
                padding: 0.5rem 0.9rem;
                font-size: 1.15rem;
                cursor: pointer;
                transition: background 0.2s, color 0.2s;
            }
            .chart-btn:hover {
                background: #90cdf4;
                color: #fff;
            }

            .table-section {
                margin-bottom: 2rem;
            }

            .table-card {
                background: #fff;
                border-radius: 0.5rem;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .table-responsive {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 1rem;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                background: #f1f1f1;
                font-weight: 600;
            }

            .no-data {
                text-align: center;
                color: #999;
            }

            .btn-back-menu {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: #e3f2fd;
                color: #2563eb;
                font-weight: 600;
                border: none;
                border-radius: 8px;
                padding: 0.6rem 1.2rem;
                margin-bottom: 1.2rem;
                text-decoration: none;
                box-shadow: 0 2px 8px rgba(72,187,255,0.08);
                transition: background 0.2s, color 0.2s;
            }
            .btn-back-menu:hover {
                background: #90cdf4;
                color: #fff;
            }

            @media (max-width: 768px) {
                .dashboard {
                    padding: 1rem;
                }

                .dashboard-title {
                    font-size: 1.5rem;
                }

                .header-actions .action-btn {
                    padding: 0.5rem 1rem;
                }
            }
        </style>
    </head>
    <body>
        <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
        <div class="dashboard">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <h1 class="dashboard-title"><span>📊</span> Doanh thu trung bình/ngày</h1>
            </div>

            <!-- Stats Summary with Tabs -->
            <div class="stats-summary">
                <div class="section-header">
                    <h2 class="section-title">📈 Tổng quan</h2>
                    <p class="section-subtitle">Các chỉ số quan trọng về doanh thu</p>
                </div>
                <div class="tabs-container">
                    <div class="tabs">
                        <button class="tab active" onclick="openTab(event, 'overview')">Tổng quan</button>
                    </div>
                    <div class="tab-content" id="overview" style="display: block;">
                        <div class="stats-grid">
                            <div class="stat-card primary">
                                <div class="stat-icon">💰</div>
                                <div class="stat-content">
                                    <div class="stat-title">Tổng doanh thu</div>
                                    <div class="stat-value"><%= String.format("%,.0f", totalRevenue) %> đ</div>
                                    <div class="stat-trend positive">+15% so với tháng trước</div>
                                </div>
                            </div>
                            <div class="stat-card secondary">
                                <div class="stat-icon">📦</div>
                                <div class="stat-content">
                                    <div class="stat-title">Tổng đơn hàng</div>
                                    <div class="stat-value"><%= totalOrders %></div>
                                    <div class="stat-trend positive">+10% so với tuần trước</div>
                                </div>
                            </div>
                            <div class="stat-card success">
                                <div class="stat-icon">📈</div>
                                <div class="stat-content">
                                    <div class="stat-title">Doanh thu trung bình/đơn</div>
                                    <div class="stat-value"><%= String.format("%,.0f", avgRevenueAll) %> đ</div>
                                    <div class="stat-trend neutral">Ổn định</div>
                                </div>
                            </div>
                            <div class="stat-card warning">
                                <div class="stat-icon">🏆</div>
                                <div class="stat-content">
                                    <div class="stat-title">Doanh thu TB cao nhất</div>
                                    <div class="stat-value"><%= String.format("%,.0f", maxAvgRevenue) %> đ</div>
                                    <div class="stat-trend positive">Kỷ lục mới</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-content" id="details" style="display: none;">
                        <p class="no-data">Chưa có dữ liệu chi tiết để hiển thị. Vui lòng làm mới hoặc thêm dữ liệu.</p>
                    </div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="chart-section">
                <div class="section-header">
                    <h2 class="section-title">📊 Biểu đồ phân tích</h2>
                    <p class="section-subtitle">Trực quan hóa dữ liệu doanh thu và đơn hàng</p>
                </div>
                <div class="charts-grid">
                    <!-- Chart 1: Doanh thu trung bình/đơn -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Doanh thu trung bình/đơn</h3>
                            
                        </div>
                        <div class="chart-container">
                            <canvas id="avgRevenueChart"></canvas>
                        </div>
                    </div>
                    <!-- Chart 2: Tổng doanh thu theo ngày -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Tổng doanh thu theo ngày</h3>
                            
                        </div>
                        <div class="chart-container">
                            <canvas id="totalRevenueChart"></canvas>
                        </div>
                    </div>
                    <!-- Chart 3: Số đơn hàng theo ngày -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Số đơn hàng theo ngày</h3>
                            
                        </div>
                        <div class="chart-container">
                            <canvas id="totalOrdersChart"></canvas>
                        </div>
                    </div>
                    <!-- Chart 4: Tỷ lệ đóng góp doanh thu -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ đóng góp doanh thu</h3>
                            
                        </div>
                        <div class="chart-container">
                            <canvas id="revenuePieChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section with Tabs -->
            <div class="table-section">
                <div class="section-header">
                    <h2 class="section-title">📋 Bảng chi tiết doanh thu</h2>
                    <p class="section-subtitle">Dữ liệu chi tiết về doanh thu và đơn hàng</p>
                </div>
                <div class="tabs-container">
                    <div class="tabs">
                        <button class="tab active" onclick="openTab(event, 'table-overview')">Tổng quan</button>
                    </div>
                    <div class="tab-content" id="table-overview" style="display: block;">
                        <div class="table-card">
                            <div class="table-header">
                                <h3 class="table-title">Dữ liệu doanh thu</h3>
                            </div>
                            <div class="table-responsive">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Ngày</th>
                                            <th>Số đơn hàng</th>
                                            <th>Tổng doanh thu</th>
                                            <th>Doanh thu trung bình</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (RevenueStat s : stats) { %>
                                        <tr>
                                            <td class="date-cell"><%= s.getLabel() %></td>
                                            <td class="order-cell"><%= s.getTotalOrders() %></td>
                                            <td class="currency revenue-cell"><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
                                            <td class="currency avg-revenue-cell highlight"><%= String.format("%,.0f", s.getAvgRevenue()) %> đ</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="tab-content" id="table-details" style="display: none;">
                        <p class="no-data">Chưa có dữ liệu chi tiết bổ sung để hiển thị.</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Sinh dữ liệu JS và vẽ chart trong cùng scope
            const labels = [<%= stats.stream().map(s -> "\"" + s.getLabel() + "\"").collect(java.util.stream.Collectors.joining(",")) %>];
            const avgRevenueData = [<%= stats.stream().map(s -> String.valueOf(s.getAvgRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];
            const totalRevenueData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];
            const totalOrdersData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalOrders())).collect(java.util.stream.Collectors.joining(",")) %>];
            <% if (stats.size() > 0 && totalRevenue > 0) { %>
            const revenueContribution = [<%= stats.stream().map(s -> String.valueOf((s.getTotalRevenue() / totalRevenue) * 100)).collect(java.util.stream.Collectors.joining(",")) %>];
            <% } else { %>
            const revenueContribution = [];
            <% } %>

            // Pastel but rõ nét hơn
            const pastelBlue = 'rgba(80, 130, 255, 0.85)';
            const pastelGreen = 'rgba(60, 190, 170, 0.55)';
            const pastelPurple = 'rgba(140, 120, 255, 0.45)';
            const pastelYellow = 'rgba(255, 220, 80, 0.55)';
            const pastelGray = 'rgba(180, 190, 200, 0.18)';
            const pastelBorder = 'rgba(80, 130, 255, 1)';
            const pastelPie = [
                'rgba(80, 130, 255, 0.85)',
                'rgba(60, 190, 170, 0.7)',
                'rgba(140, 120, 255, 0.7)',
                'rgba(255, 220, 80, 0.7)',
                'rgba(180, 190, 200, 0.7)'
            ];

            // Chart 1: Doanh thu trung bình/đơn
            new Chart(document.getElementById('avgRevenueChart'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Doanh thu trung bình (VND)',
                            data: avgRevenueData,
                            backgroundColor: pastelBlue,
                            borderColor: pastelBorder,
                            borderWidth: 3,
                            borderRadius: 12,
                            maxBarThickness: 80
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 16,
                                    weight: '700'
                                },
                                color: '#2d3748'
                            }
                        },
                        tooltip: {
                            backgroundColor: '#fff',
                            borderColor: pastelBorder,
                            borderWidth: 1.5,
                            titleColor: '#2563eb',
                            bodyColor: '#2d3748',
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return 'Doanh thu TB: ' + value.toLocaleString() + ' đ';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value.toLocaleString() + ' đ';
                                },
                                font: {
                                    family: "'Roboto Mono', monospace",
                                    size: 14
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                drawBorder: false,
                                color: pastelGray
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 13
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            // Chart 2: Tổng doanh thu theo ngày
            new Chart(document.getElementById('totalRevenueChart'), {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Tổng doanh thu (VND)',
                            data: totalRevenueData,
                            backgroundColor: pastelGreen,
                            borderColor: pastelBorder,
                            borderWidth: 4,
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: pastelBorder,
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2.5,
                            pointRadius: 7
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 16,
                                    weight: '700'
                                },
                                color: '#2d3748'
                            }
                        },
                        tooltip: {
                            backgroundColor: '#fff',
                            borderColor: pastelBorder,
                            borderWidth: 1.5,
                            titleColor: '#2563eb',
                            bodyColor: '#2d3748',
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return 'Tổng doanh thu: ' + value.toLocaleString() + ' đ';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value.toLocaleString() + ' đ';
                                },
                                font: {
                                    family: "'Roboto Mono', monospace",
                                    size: 14
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                drawBorder: false,
                                color: pastelGray
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 13
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            // Chart 3: Số đơn hàng theo ngày
            new Chart(document.getElementById('totalOrdersChart'), {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Số đơn hàng',
                            data: totalOrdersData,
                            backgroundColor: pastelPurple,
                            borderColor: pastelGreen,
                            borderWidth: 4,
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: pastelBorder,
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2.5,
                            pointRadius: 7
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 16,
                                    weight: '700'
                                },
                                color: '#2d3748'
                            }
                        },
                        tooltip: {
                            backgroundColor: '#fff',
                            borderColor: pastelBorder,
                            borderWidth: 1.5,
                            titleColor: '#2563eb',
                            bodyColor: '#2d3748',
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return 'Số đơn hàng: ' + value.toLocaleString();
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value.toLocaleString();
                                },
                                font: {
                                    family: "'Roboto Mono', monospace",
                                    size: 14
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                drawBorder: false,
                                color: pastelGray
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 13
                                },
                                color: '#2d3748'
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            // Chart 4: Tỷ lệ đóng góp doanh thu
            new Chart(document.getElementById('revenuePieChart'), {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Tỷ lệ đóng góp',
                            data: revenueContribution,
                            backgroundColor: pastelPie,
                            borderColor: '#fff',
                            borderWidth: 3
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 15
                                },
                                color: '#2d3748'
                            }
                        },
                        tooltip: {
                            backgroundColor: '#fff',
                            borderColor: pastelBorder,
                            borderWidth: 1.5,
                            titleColor: '#2563eb',
                            bodyColor: '#2d3748',
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return value.toLocaleString(undefined, {maximumFractionDigits: 2}) + '%';
                                }
                            }
                        }
                    }
                }

            }
        });

        document.getElementById('show-detail-btn').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('table-section').style.display = 'block';
            document.getElementById('show-detail-btn').style.display = 'none';
            document.getElementById('dashboard-section').style.display = 'none';
            document.getElementById('table-section').scrollIntoView({behavior: 'smooth'});
        });
    </script>
</body>

            });
        </script>
    </body>

</html>
