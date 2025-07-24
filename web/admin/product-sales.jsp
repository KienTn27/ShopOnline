<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductSalesStat"%>
<%@page import="java.util.List, java.util.ArrayList, model.ProductSalesStat"%>
<%
    List<ProductSalesStat> stats = (List<ProductSalesStat>) request.getAttribute("stats");
    if (stats == null) stats = new ArrayList<>();
    Boolean showTable = (Boolean) request.getAttribute("showTable");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê bán hàng theo ngày</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f7fafc;
                min-height: 100vh;
                padding: 20px;
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

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 24px 0 rgba(60,72,88,0.08);
                overflow: hidden;
            }

            .header {
                background: linear-gradient(135deg, #e3f2fd 0%, #90cdf4 100%);
                padding: 30px;
                text-align: center;
                color: #2563eb;
            }

            .header h1 {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: none;
            }

            .header p {
                font-size: 1.1rem;
                opacity: 0.95;
                color: #4a5568;
            }

            .content {
                padding: 40px;
            }

            .chart-section {
                margin-bottom: 50px;
            }

            .section-title {
                display: flex;
                align-items: center;
                font-size: 2rem;
                color: #2563eb;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 3px solid #90cdf4;
                font-weight: 700;
            }

            .section-title i {
                margin-right: 15px;
                color: #38b2ac;
            }

            .chart-container {
                background: #fff;
                border-radius: 15px;
                padding: 30px 25px 40px 25px;
                box-shadow: 0 4px 16px rgba(72,187,255,0.10);
                border: 1px solid #e3e8f0;
                min-height: 380px;
                height: 380px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            #productSalesChart {
                width: 100% !important;
                height: 350px !important;
                min-height: 350px !important;
                background: #f7fafc;
                border-radius: 12px;
            }

            .stats-overview {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: linear-gradient(135deg, #e3f2fd 0%, #90cdf4 100%);
                color: #2d3748;
                padding: 25px;
                border-radius: 15px;
                text-align: center;
                box-shadow: 0 2px 8px rgba(144,205,244,0.10);
                transition: transform 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-card i {
                font-size: 2.5rem;
                margin-bottom: 15px;
                opacity: 0.9;
                color: #4299e1;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 1rem;
                opacity: 0.9;
            }

            .table-container {
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(144,205,244,0.10);
                border: 1px solid #e3e8f0;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th {
                background: linear-gradient(135deg, #e3f2fd 0%, #90cdf4 100%);
                color: #2563eb;
                padding: 20px 15px;
                text-align: left;
                font-weight: 700;
                font-size: 1.15rem;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #f0f0f0;
                transition: background-color 0.3s ease;
                color: #2d3748;
            }

            tr:hover td {
                background-color: #e3f2fd;
            }

            tr:last-child td {
                border-bottom: none;
            }

            .text-success {
                color: #38a169;
                font-weight: 600;
            }
            .text-warning {
                color: #f6ad55;
                font-weight: 600;
            }

            .no-data {
                text-align: center;
                padding: 50px;
                color: #666;
                font-size: 1.2rem;
            }

            .no-data i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #ccc;
            }

            .pagination {
                display: flex;
                justify-content: center;
                gap: 0.5rem;
                margin: 2rem 0 1rem 0;
            }
            .page-btn {
                border: 2px solid #2563eb;
                background: #fff;
                color: #2563eb;
                border-radius: 999px;
                padding: 6px 18px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s, color 0.2s, border 0.2s;
                margin: 0 2px;
                outline: none;
                box-shadow: none;
                text-decoration: none;
                display: inline-block;
            }
            .page-btn:hover:not(.active):not(.disabled) {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
            }
            .page-btn.active {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
                cursor: default;
            }
            .page-btn.disabled {
                background: #f1f5f9;
                color: #b0b8c9;
                border-color: #e2e8f0;
                cursor: not-allowed;
                pointer-events: none;
            }

            @media (max-width: 900px) {
                .content {
                    padding: 20px;
                }
                .section-title {
                    font-size: 1.3rem;
                }
                .stats-overview {
                    grid-template-columns: 1fr;
                }
                th, td {
                    padding: 10px 8px;
                    font-size: 0.98rem;
                }
                .chart-container, #productSalesChart {
                    min-height: 220px !important;
                    height: 220px !important;
                }
            }

            .loading {
                display: none;
                text-align: center;
                padding: 50px;
            }

            .spinner {
                border: 4px solid #f3f3f3;
                border-top: 4px solid #667eea;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                animation: spin 1s linear infinite;
                margin: 0 auto 20px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-chart-line"></i> Thống kê bán hàng</h1>
                <p>Theo dõi số lượng sản phẩm bán ra hàng ngày</p>
            </div>

            <div class="content">
                <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
                <% if (showTable == null || !showTable) { %>
                <a href="#" class="btn-summary-table" id="show-detail-btn" style="display:block;max-width:350px;margin:16px auto 0 auto;font-weight:600;font-size:1.1em;padding:12px 24px;background:#1976d2;color:#fff;border-radius:12px;text-align:center;text-decoration:none;">
                    <span style="font-size:1.3em;vertical-align:middle;">📋</span>
                    <span style="vertical-align:middle;">Xem bảng tổng hợp bán hàng</span>
                </a>
                <% } %>
                <% if (showTable != null && showTable) { %>
                <%
                    int totalProducts = 0;
                    for (ProductSalesStat s : stats) {
                        totalProducts += s.getTotalQuantity();
                    }
                    double avgDaily = stats.size() > 0 ? (double) totalProducts / stats.size() : 0;
                %>
                <div class="table-section" id="sales-table-section" style="display:block;">
                    <h2 class="section-title">
                        <i class="fas fa-table"></i>
                        Bảng chi tiết bán hàng
                    </h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th><i class="fas fa-calendar-alt"></i> Ngày bán</th>
                                    <th><i class="fas fa-shopping-cart"></i> Số lượng sản phẩm</th>
                                    <th><i class="fas fa-percentage"></i> Tỷ lệ so với trung bình</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ProductSalesStat s : stats) { 
                                    double percentage = avgDaily > 0 ? (s.getTotalQuantity() / avgDaily) * 100 : 0;
                                    String percentageClass = percentage >= 100 ? "text-success" : "text-warning";
                                %>
                                <tr>
                                    <td><%= s.getSaleDate() %></td>
                                    <td><strong><%= s.getTotalQuantity() %></strong> sản phẩm</td>
                                    <td class="<%= percentageClass %>">
                                        <%= String.format("%.1f", percentage) %>%
                                        <% if (percentage >= 100) { %>
                                        <i class="fas fa-arrow-up" style="color: green;"></i>
                                        <% } else { %>
                                        <i class="fas fa-arrow-down" style="color: orange;"></i>
                                        <% } %>
                                    </td>
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
                                    out.print("<a href='product-sales?page=" + (currentPage - 1) + "&showTable=1' class='page-btn'>Trước</a>");
                                } else {
                                    out.print("<span class='page-btn disabled'>Trước</span>");
                                }
                                // Các nút số trang
                                for (int i = 1; i <= totalPages; i++) {
                                    if (i == currentPage) {
                                        out.print("<span class='page-btn active'>" + i + "</span>");
                                    } else {
                                        out.print("<a href='product-sales?page=" + i + "&showTable=1' class='page-btn'>" + i + "</a>");
                                    }
                                }
                                // Nút Sau
                                if (currentPage < totalPages) {
                                    out.print("<a href='product-sales?page=" + (currentPage + 1) + "&showTable=1' class='page-btn'>Sau</a>");
                                } else {
                                    out.print("<span class='page-btn disabled'>Sau</span>");
                                }
                            }
                        %>
                    </div>
                </div>
                <% } else if (stats != null && !stats.isEmpty()) { %>
                <div id="dashboard-section">
                    <!-- Thống kê tổng quan -->
                    <div class="stats-overview">
                        <%
                            int totalProducts = 0;
                            int maxDaily = 0;
                            for (ProductSalesStat s : stats) {
                                totalProducts += s.getTotalQuantity();
                                if (s.getTotalQuantity() > maxDaily) {
                                    maxDaily = s.getTotalQuantity();
                                }
                            }
                            double avgDaily = stats.size() > 0 ? (double) totalProducts / stats.size() : 0;
                        %>
                        <div class="stat-card">
                            <i class="fas fa-boxes"></i>
                            <div class="stat-value"><%= totalProducts %></div>
                            <div class="stat-label">Tổng sản phẩm bán</div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-calendar-day"></i>
                            <div class="stat-value"><%= String.format("%.1f", avgDaily) %></div>
                            <div class="stat-label">Trung bình/ngày</div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-trophy"></i>
                            <div class="stat-value"><%= maxDaily %></div>
                            <div class="stat-label">Cao nhất/ngày</div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-chart-bar"></i>
                            <div class="stat-value"><%= stats.size() %></div>
                            <div class="stat-label">Số ngày có dữ liệu</div>
                        </div>
                    </div>

                    <!-- Biểu đồ -->
                    <div class="chart-section">
                        <h2 class="section-title">
                            <i class="fas fa-chart-line"></i>
                            Biểu đồ bán hàng theo ngày
                        </h2>
                        <div class="chart-container">
                            <canvas id="productSalesChart" height="100"></canvas>
                        </div>
                    </div>
                </div>
                <div class="table-section" id="sales-table-section" style="display:none;">
                    <h2 class="section-title">
                        <i class="fas fa-table"></i>
                        Bảng chi tiết bán hàng
                    </h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th><i class="fas fa-calendar-alt"></i> Ngày bán</th>
                                    <th><i class="fas fa-shopping-cart"></i> Số lượng sản phẩm</th>
                                    <th><i class="fas fa-percentage"></i> Tỷ lệ so với trung bình</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ProductSalesStat s : stats) { 
                                    double percentage = avgDaily > 0 ? (s.getTotalQuantity() / avgDaily) * 100 : 0;
                                    String percentageClass = percentage >= 100 ? "text-success" : "text-warning";
                                %>
                                <tr>
                                    <td><%= s.getSaleDate() %></td>
                                    <td><strong><%= s.getTotalQuantity() %></strong> sản phẩm</td>
                                    <td class="<%= percentageClass %>">
                                        <%= String.format("%.1f", percentage) %>%
                                        <% if (percentage >= 100) { %>
                                        <i class="fas fa-arrow-up" style="color: green;"></i>
                                        <% } else { %>
                                        <i class="fas fa-arrow-down" style="color: orange;"></i>
                                        <% } %>
                                    </td>
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
                                    out.print("<a href='product-sales?page=" + (currentPage - 1) + "&showTable=1' class='page-btn'>Trước</a>");
                                } else {
                                    out.print("<span class='page-btn disabled'>Trước</span>");
                                }
                                // Các nút số trang
                                for (int i = 1; i <= totalPages; i++) {
                                    if (i == currentPage) {
                                        out.print("<span class='page-btn active'>" + i + "</span>");
                                    } else {
                                        out.print("<a href='product-sales?page=" + i + "&showTable=1' class='page-btn'>" + i + "</a>");
                                    }
                                }
                                // Nút Sau
                                if (currentPage < totalPages) {
                                    out.print("<a href='product-sales?page=" + (currentPage + 1) + "&showTable=1' class='page-btn'>Sau</a>");
                                } else {
                                    out.print("<span class='page-btn disabled'>Sau</span>");
                                }
                            }
                        %>
                    </div>
                </div>
                <% } else { %>
                <div class="no-data">
                    <i class="fas fa-chart-line"></i>
                    <h3>Chưa có dữ liệu bán hàng</h3>
                    <p>Hiện tại chưa có thông tin về số lượng sản phẩm bán ra.</p>
                </div>
                <% } %>
            </div>
        </div>

        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Đang tải dữ liệu...</p>
        </div>

        <!-- Đặt plugin ChartDataLabels trước -->
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
        <% if (stats != null && !stats.isEmpty()) { 
            StringBuilder labelBuilder = new StringBuilder();
            StringBuilder salesBuilder = new StringBuilder();
            for (int i = 0; i < stats.size(); i++) {
                if (i > 0) {
                    labelBuilder.append(",");
                    salesBuilder.append(",");
                }
                labelBuilder.append("\"").append(stats.get(i).getSaleDate()).append("\"");
                salesBuilder.append(stats.get(i).getTotalQuantity());
            }
        %>
        <script>
            function chartProductSales() {
                const labels = [<%= labelBuilder.toString() %>];
                const salesData = [<%= salesBuilder.toString() %>];
                const ctx = document.getElementById('productSalesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                                label: 'Số sản phẩm bán ra',
                                data: salesData,
                                backgroundColor: 'rgba(144, 205, 244, 0.85)',
                                borderColor: '#4299e1',
                                borderWidth: 2,
                                borderRadius: 10,
                                hoverBackgroundColor: '#2563eb',
                                maxBarThickness: 48
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: '#fff',
                                titleColor: '#2563eb',
                                bodyColor: '#2d3748',
                                borderColor: '#90cdf4',
                                borderWidth: 1,
                                cornerRadius: 10,
                                displayColors: false,
                                callbacks: {
                                    label: function (context) {
                                        return `Số lượng: ${context.parsed.y} sản phẩm`;
                                    }
                                }
                            },
                            datalabels: {
                                anchor: 'end',
                                align: 'end',
                                color: '#2563eb',
                                font: {
                                    weight: 'bold',
                                    size: 15
                                },
                                formatter: function (value) {
                                    return value;
                                }
                            }
                        },
                        scales: {
                            x: {
                                grid: {
                                    color: '#e3e8f0',
                                    display: true
                                },
                                ticks: {
                                    font: {
                                        size: 15
                                    },
                                    color: '#2563eb',
                                    maxRotation: 45
                                }
                            },
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: '#e3e8f0',
                                    drawBorder: false
                                },
                                ticks: {
                                    font: {
                                        size: 15
                                    },
                                    color: '#2563eb',
                                    callback: function (value) {
                                        return value + ' sp';
                                    }
                                }
                            }
                        },
                        interaction: {
                            intersect: false,
                            mode: 'index'
                        },
                        animation: {
                            duration: 2000,
                            easing: 'easeInOutQuart'
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            }
        </script>
        <% } else { %>
        <script>
            function chartProductSales() {}
        </script>
        <% } %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.stat-card');
                cards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        card.style.transition = 'all 0.6s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });
                chartProductSales();
            });
        </script>
        <script>
            document.getElementById('show-detail-btn').addEventListener('click', function (e) {
                e.preventDefault();
                window.location.href = 'product-sales?page=1&showTable=1';
            });
        </script>
    </body>
</html>