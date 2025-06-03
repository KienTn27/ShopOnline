```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
</head>
<body>
    <div class="dashboard">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="header-content">
                <div class="header-text">
                    <h1 class="dashboard-title"><span>📊</span> Doanh thu trung bình/ngày</h1>
                    <p class="dashboard-subtitle">Theo dõi và phân tích doanh thu trung bình theo từng ngày</p>
                </div>
                <div class="header-actions">
                    <button class="action-btn primary" onclick="exportData()">
                        <span class="btn-icon">📥</span>
                        Xuất báo cáo
                    </button>
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
                <h2 class="section-title">📈 Tổng quan</h2>
                <p class="section-subtitle">Các chỉ số quan trọng về doanh thu</p>
            </div>
            <div class="tabs-container">
                <div class="tabs">
                    <button class="tab active" onclick="openTab(event, 'overview')">Tổng quan</button>
                    <button class="tab" onclick="openTab(event, 'details')">Chi tiết</button>
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
                <!-- Average Revenue Bar Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Doanh thu trung bình/đơn</h3>
                        <div class="chart-actions">
                            <button class="chart-btn" onclick="downloadChart('avgRevenueChart')" title="Tải xuống">
                                <span class="btn-icon">📥</span>
                            </button>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="avgRevenueChart"></canvas>
                    </div>
                </div>
                <!-- Total Revenue Line Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Tổng doanh thu theo ngày</h3>
                        <div class="chart-actions">
                            <button class="chart-btn" onclick="downloadChart('totalRevenueChart')" title="Tải xuống">
                                <span class="btn-icon">📥</span>
                            </button>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="totalRevenueChart"></canvas>
                    </div>
                </div>
                <!-- Total Orders Area Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Số đơn hàng theo ngày</h3>
                        <div class="chart-actions">
                            <button class="chart-btn" onclick="downloadChart('totalOrdersChart')" title="Tải xuống">
                                <span class="btn-icon">📥</span>
                            </button>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="totalOrdersChart"></canvas>
                    </div>
                </div>
                <!-- New Pie Chart for Revenue Contribution -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Tỷ lệ đóng góp doanh thu</h3>
                        <div class="chart-actions">
                            <button class="chart-btn" onclick="downloadChart('revenuePieChart')" title="Tải xuống">
                                <span class="btn-icon">📥</span>
                            </button>
                        </div>
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
                    <button class="tab" onclick="openTab(event, 'table-details')">Chi tiết</button>
                </div>
                <div class="tab-content" id="table-overview" style="display: block;">
                    <div class="table-card">
                        <div class="table-header">
                            <h3 class="table-title">Dữ liệu doanh thu</h3>
                            <div class="table-actions">
                                <div class="search-box">
                                    <input type="text" placeholder="Tìm kiếm..." class="search-input">
                                    <button class="search-btn">🔍</button>
                                </div>
                                <button class="table-btn" onclick="exportTable()">
                                    <span class="btn-icon">📊</span>
                                    Xuất Excel
                                </button>
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
                    </div>
                </div>
                <div class="tab-content" id="table-details" style="display: none;">
                    <p class="no-data">Chưa có dữ liệu chi tiết bổ sung để hiển thị.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        const labels = [<%= stats.stream().map(s -> "\"" + s.getLabel() + "\"").collect(java.util.stream.Collectors.joining(",")) %>];
        const avgRevenueData = [<%= stats.stream().map(s -> String.valueOf(s.getAvgRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];
        const totalRevenueData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];
        const totalOrdersData = [<%= stats.stream().map(s -> String.valueOf(s.getTotalOrders())).collect(java.util.stream.Collectors.joining(",")) %>];
        const revenueContribution = [<%= stats.stream().map(s -> String.valueOf(s.getTotalRevenue() / totalRevenue * 100)).map(v -> v + "").collect(java.util.stream.Collectors.joining(",")) %>];

        // Average Revenue Bar Chart
        new Chart(document.getElementById('avgRevenueChart'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu trung bình (VND)',
                    data: avgRevenueData,
                    backgroundColor: 'rgba(58, 134, 255, 0.6)',
                    borderColor: 'rgba(58, 134, 255, 1)',
                    borderWidth: 1,
                    borderRadius: 6,
                    maxBarThickness: 60
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
                            label: function(context) {
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
                            callback: function(value) {
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
        });

        // Total Revenue Line Chart
        new Chart(document.getElementById('totalRevenueChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Tổng doanh thu (VND)',
                    data: totalRevenueData,
                    backgroundColor: 'rgba(46, 204, 113, 0.2)',
                    borderColor: '#2ecc71',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#2ecc71',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 5
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
                            label: function(context) {
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
                            callback: function(value) {
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
        });

        // Total Orders Area Chart
        new Chart(document.getElementById('totalOrdersChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số đơn hàng',
                    data: totalOrdersData,
                    backgroundColor: 'rgba(255, 159, 64, 0.3)',
                    borderColor: '#ff9f40',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#ff9f40',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 5
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
                            label: function(context) {
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
        });

        // Revenue Contribution Pie Chart
        new Chart(document.getElementById('revenuePieChart'), {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Tỷ lệ đóng góp (%)',
                    data: revenueContribution,
                    backgroundColor: [
                        'rgba(58, 134, 255, 0.8)',
                        'rgba(46, 204, 113, 0.8)',
                        'rgba(255, 159, 64, 0.8)',
                        'rgba(16, 185, 129, 0.8)'
                    ],
                    borderColor: [
                        'rgba(58, 134, 255, 1)',
                        'rgba(46, 204, 113, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(16, 185, 129, 1)'
                    ],
                    borderWidth: 1
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
                            label: function(context) {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return label + ': ' + value.toFixed(2) + '%';
                            }
                        }
                    }
                }
            }
        });

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

        function exportTable() {
            alert('Chức năng xuất Excel đang được phát triển.');
        }
    </script>
</body>
</html>
```