<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.RevenueStat"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê doanh thu</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Roboto+Mono&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/revenue.css">
        <style>
            /* Color Scheme - Consistent Blue Theme */
            :root {
                --primary-blue: #2563eb;
                --primary-blue-dark: #1d4ed8;
                --primary-blue-light: #90cdf4;
                --primary-blue-bg: #e3f2fd;
                --primary-blue-bg-light: #f8fafc;
                --text-primary: #1e293b;
                --text-secondary: #64748b;
                --text-muted: #94a3b8;
                --border-color: #e2e8f0;
                --border-color-light: #f1f5f9;
                --shadow-light: rgba(37, 99, 235, 0.08);
                --shadow-medium: rgba(37, 99, 235, 0.15);
                --shadow-heavy: rgba(37, 99, 235, 0.25);
            }

            .btn-back-menu {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: var(--primary-blue-bg);
                color: var(--primary-blue);
                font-weight: 600;
                border: none;
                border-radius: 8px;
                padding: 0.6rem 1.2rem;
                margin-bottom: 1.2rem;
                text-decoration: none;
                box-shadow: 0 2px 8px var(--shadow-light);
                transition: all 0.3s ease;
            }
            .btn-back-menu:hover {
                background: var(--primary-blue-light);
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px var(--shadow-medium);
            }
            .btn-action {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: var(--primary-blue-bg);
                color: var(--primary-blue);
                font-weight: 600;
                border: none;
                border-radius: 999px;
                padding: 0.7rem 1.5rem;
                font-size: 1.08em;
                margin: 1.5rem 0;
                text-decoration: none;
                box-shadow: 0 2px 8px var(--shadow-light);
                transition: all 0.3s ease;
            }
            .btn-action:hover {
                background: var(--primary-blue);
                color: #fff;
                box-shadow: 0 4px 16px var(--shadow-medium);
                transform: translateY(-1px);
            }
            .btn-action i, .btn-action span[style*='vertical-align:middle'] {
                color: inherit !important;
            }

            /* Time Toggle Styles */
            .time-toggle {
                display: flex;
                gap: 0.5rem;
                margin-right: 1rem;
            }

            .toggle-btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.6rem 1.2rem;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                font-size: 0.95rem;
                transition: all 0.3s ease;
                border: 2px solid transparent;
            }

            .toggle-btn:not(.active) {
                background: var(--primary-blue-bg-light);
                color: var(--text-secondary);
                border-color: var(--border-color);
            }

            .toggle-btn.active {
                background: var(--primary-blue);
                color: white;
                border-color: var(--primary-blue-dark);
                box-shadow: 0 2px 8px var(--shadow-medium);
            }

            .toggle-btn:hover:not(.active) {
                background: var(--border-color);
                color: var(--text-primary);
                border-color: var(--text-muted);
                transform: translateY(-1px);
            }

            .toggle-btn:hover.active {
                background: var(--primary-blue-dark);
                border-color: #1e40af;
                box-shadow: 0 4px 12px var(--shadow-heavy);
                transform: translateY(-1px);
            }

            .toggle-icon {
                font-size: 1.1rem;
            }

            /* Action Button Improvements */
            .action-btn {
                background: var(--primary-blue-bg);
                color: var(--primary-blue);
                border: 2px solid var(--primary-blue-light);
                border-radius: 8px;
                padding: 0.6rem 1.2rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px var(--shadow-light);
            }

            .action-btn:hover {
                background: var(--primary-blue);
                color: white;
                border-color: var(--primary-blue);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px var(--shadow-medium);
            }

            .action-btn.secondary {
                background: var(--primary-blue-bg-light);
                color: var(--text-secondary);
                border-color: var(--border-color);
            }

            .action-btn.secondary:hover {
                background: var(--border-color);
                color: var(--text-primary);
                border-color: var(--text-muted);
            }

            /* Current View Indicator */
            .current-view-indicator {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: var(--primary-blue-bg);
                color: var(--primary-blue);
                padding: 0.5rem 1rem;
                border-radius: 6px;
                font-size: 0.9rem;
                font-weight: 500;
                margin-top: 0.5rem;
                border: 1px solid var(--primary-blue-light);
                box-shadow: 0 1px 4px var(--shadow-light);
            }

            .indicator-icon {
                font-size: 1rem;
            }

            .indicator-text {
                font-weight: 600;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .header-actions {
                    flex-direction: column;
                    gap: 1rem;
                }

                .time-toggle {
                    margin-right: 0;
                    justify-content: center;
                }

                .current-view-indicator {
                    font-size: 0.8rem;
                    padding: 0.4rem 0.8rem;
                }
            }
        </style>
    </head>
    <body>

        <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
        <%
            // Khai báo và lấy stats, type từ request
            List<RevenueStat> stats = (List<RevenueStat>) request.getAttribute("stats");
            String type = (String) request.getAttribute("type");

            // Đảm bảo stats không null
            if (stats == null) {
                stats = new ArrayList<>();
            }
            // Đảm bảo type có giá trị mặc định nếu null
            if (type == null) {
                type = "day";
            }
        %>

        <!-- Menu chung (nếu có) -->


        <div class="dashboard">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div class="header-content">
                    <div class="header-text">
                        <h1 class="dashboard-title"><span>📈</span> Thống kê doanh thu</h1>
                        <p class="dashboard-subtitle">Phân tích doanh thu theo ngày hoặc tháng</p>
                        <div class="current-view-indicator">
                            <span class="indicator-icon">📊</span>
                            <span class="indicator-text">Đang xem: <%= "day".equals(type) ? "Doanh thu theo ngày" : "Doanh thu theo tháng" %></span>
                        </div>
                    </div>
                    <div class="header-actions">
                        <!-- Time Period Toggle -->
                        <div class="time-toggle">
                            <a href="revenue?type=day" class="toggle-btn <%= "day".equals(type) ? "active" : "" %>">
                                <span class="toggle-icon">📅</span>
                                Theo ngày
                            </a>
                            <a href="revenue?type=month" class="toggle-btn <%= "month".equals(type) ? "active" : "" %>">
                                <span class="toggle-icon">📆</span>
                                Theo tháng
                            </a>
                        </div>

                        <button class="action-btn secondary" onclick="refreshData()">
                            <span class="btn-icon">🔄</span>
                            Làm mới
                        </button>
                        <a href="revenue-table<%= (type != null ? ("?type=" + type) : "") %>" class="btn-action">
                            <span style="font-size:1.3em;vertical-align:middle;">📋</span>
                            <span style="vertical-align:middle;">Xem bảng chi tiết doanh thu</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Stats Summary with Tabs -->
            <div class="stats-summary">
                <div class="section-header">
                    <h2 class="section-title">📊 Tổng quan doanh thu <%= "day".equals(type) ? "theo ngày" : "theo tháng" %></h2>
                    <p class="section-subtitle">Thống kê nhanh về doanh thu <%= "day".equals(type) ? "từng ngày" : "từng tháng" %></p>
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
                                    <%
                                        double totalRevenue = 0;
                                        if (stats != null && !stats.isEmpty()) {
                                            totalRevenue = stats.stream().mapToDouble(s -> s.getTotalRevenue()).sum();
                                        }
                                    %>
                                    <div class="stat-value"><%= totalRevenue > 0 ? String.format("%,.0f", totalRevenue) : "0" %> đ</div>
                                    <div class="stat-trend positive">+15% so với trước</div>
                                </div>
                            </div>
                            <div class="stat-card secondary">
                                <div class="stat-icon">📦</div>
                                <div class="stat-content">
                                    <div class="stat-title">Tổng số đơn</div>
                                    <%
                                        int totalOrders = 0;
                                        if (stats != null && !stats.isEmpty()) {
                                            totalOrders = stats.stream().mapToInt(s -> s.getTotalOrders()).sum();
                                        }
                                    %>
                                    <div class="stat-value"><%= totalOrders %></div>
                                    <div class="stat-trend positive">+10% so với trước</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-content" id="details" style="display: none;">
                        <p class="no-data">Chưa có dữ liệu chi tiết để hiển thị.</p>
                    </div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="chart-section">
                <div class="section-header">
                    <h2 class="section-title">📊 Biểu đồ phân tích</h2>
                    <p class="section-subtitle">Trực quan hóa doanh thu và số đơn theo <%= (type != null && type.equals("day")) ? "ngày" : "tháng" %></p>
                </div>
                <div class="charts-grid">
                    <!-- Revenue Line Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Doanh thu <%= (type != null && type.equals("day")) ? "ngày" : "tháng" %></h3>

                        </div>
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                    <!-- Orders Bar Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Số đơn hàng <%= (type != null && type.equals("day")) ? "ngày" : "tháng" %></h3>

                        </div>
                        <div class="chart-container">
                            <canvas id="ordersChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script>
            let labels = [];
            let revenueData = [];
            let ordersData = [];
            <% if (stats != null && !stats.isEmpty()) { 
    StringBuilder labelBuilder = new StringBuilder();
    StringBuilder revenueBuilder = new StringBuilder();
    StringBuilder ordersBuilder = new StringBuilder();
    for (int i = 0; i < stats.size(); i++) {
        if (i > 0) {
            labelBuilder.append(",");
            revenueBuilder.append(",");
            ordersBuilder.append(",");
        }
        labelBuilder.append("\"").append(stats.get(i).getLabel()).append("\"");
        revenueBuilder.append(stats.get(i).getTotalRevenue());
        ordersBuilder.append(stats.get(i).getTotalOrders());
    }
            %>
            labels = [<%= labelBuilder.toString() %>];
            revenueData = [<%= revenueBuilder.toString() %>];
            ordersData = [<%= ordersBuilder.toString() %>];
            <% } %>

            // Revenue Line Chart
            const revenueConfig = {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Tổng doanh thu (VND)',
                            data: revenueData,
                            fill: true,
                            borderColor: '#1abc9c', // Xanh nhạt
                            backgroundColor: 'rgba(26, 188, 156, 0.2)', // Light green fill
                            tension: 0.3
                        }, {
                            label: 'Xu hướng (dự đoán)',
                            data: revenueData.map(d => d * 1.1), // Simple trend prediction
                            borderColor: '#3498db', // Xanh dương
                            backgroundColor: 'rgba(52, 152, 219, 0.1)',
                            borderDash: [5, 5],
                            tension: 0.3,
                            fill: false
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
                                    size: 14,
                                    weight: '600'
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return context.dataset.label + ': ' + value.toLocaleString() + ' đ';
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
                                    size: 12
                                }
                            },
                            grid: {
                                drawBorder: false,
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 12
                                }
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            };

            // Orders Bar Chart
            const ordersConfig = {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Số đơn hàng',
                            data: ordersData,
                            backgroundColor: 'rgba(52, 152, 219, 0.6)', // Xanh dương nhạt
                            borderColor: 'rgba(52, 152, 219, 1)',
                            borderWidth: 1,
                            borderRadius: 6,
                            maxBarThickness: 60
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {display: false},
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let value = context.raw;
                                    return 'Số đơn: ' + value.toLocaleString();
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
                                    size: 12
                                }
                            },
                            grid: {
                                drawBorder: false,
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: "'Poppins', sans-serif",
                                    size: 12
                                }
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            };

            new Chart(document.getElementById('revenueChart'), revenueConfig);
            new Chart(document.getElementById('ordersChart'), ordersConfig);

            function openTab(event, tabName) {
                var i, tabcontent, tabs;
                tabcontent = document.getElementsByClassName("tab-content");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].style.display = "none";
                }
                tabs = document.getElementsByClassName("tab");
                for (i = 0; i < tabs.length; i++) {
                    tabs[i].className = tabs[i].className.replace(" active", "");
                }
                document.getElementById(tabName).style.display = "block";
                event.currentTarget.className += " active";
            }

            function downloadChart(chartId) {
                const chart = document.getElementById(chartId);
                const link = document.createElement('a');
                link.download = chartId + '.png';
                link.href = chart.toDataURL('image/png');
                link.click();
            }

            function exportData() {
                alert('Chức năng xuất báo cáo đang được phát triển.');
            }

            function refreshData() {
                location.reload();
            }
        </script>
    </body>
</html>