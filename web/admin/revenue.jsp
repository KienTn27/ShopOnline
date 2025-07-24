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
                    </div>
                    <div class="header-actions">
                        
                        <button class="action-btn secondary" onclick="refreshData()">
                            <span class="btn-icon">🔄</span>
                            Làm mới
                        </button>
                    </div>
                </div>
            </div>

            <!-- Stats Summary with Tabs -->
            <div class="stats-summary">
                <div class="section-header">
                    <h2 class="section-title">📊 Tổng quan</h2>
                    <p class="section-subtitle">Thống kê nhanh về doanh thu</p>
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

            <!-- Filter and Table Section -->
            <div class="table-section">
                <div class="section-header">
                    <h2 class="section-title">📋 Bảng tổng hợp doanh thu</h2>
                    <p class="section-subtitle">Dữ liệu chi tiết theo <%= (type != null && type.equals("day")) ? "ngày" : "tháng" %></p>
                </div>
                <div class="tabs-container">
                    <div class="tabs">
                        <button class="tab active" onclick="openTab(event, 'table-overview')">Tổng quan</button>
                    </div>
                    <div class="tab-content" id="table-overview" style="display: block;">
                        <div class="table-card">
                            <div class="table-header">
                                <form method="get" action="revenue" class="filter-form">
                                    <label for="type">Chọn loại:</label>
                                    <select id="type" name="type" onchange="this.form.submit()">
                                        <option value="day" <%= (type != null && "day".equals(type)) ? "selected" : "" %>>Theo ngày</option>
                                        <option value="month" <%= (type != null && "month".equals(type)) ? "selected" : "" %>>Theo tháng</option>
                                    </select>
                                </form>
                            </div>
                            <div class="table-responsive">
                                <table>
                                    <thead>
                                        <tr>
                                            <th><%= (type != null && type.equals("day")) ? "Ngày" : "Tháng" %></th>
                                            <th>Số đơn hàng</th>
                                            <th>Tổng doanh thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (stats != null) {
                                        for (RevenueStat s : stats) { %>
                                        <tr>
                                            <td><%= s.getLabel() %></td>
                                            <td><%= s.getTotalOrders() %></td>
                                            <td class="currency"><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
                                        </tr>
                                        <% }
                                    } else { %>
                                        <tr><td colspan="3" class="no-data">Không có dữ liệu</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let labels = [];
            let revenueData = [];
            let ordersData = [];
            <% if (stats != null && !stats.isEmpty()) { %>
            labels = [<%= stats.stream().map(s -> "\"" + s.getLabel() + "\"").collect(java.util.stream.Collectors.joining(",")) %>];
            revenueData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];
            ordersData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalOrders())).collect(java.util.stream.Collectors.joining(",")) %>];
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