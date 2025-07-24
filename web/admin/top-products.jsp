<%-- 
    Document   : top-products
    Created on : May 23, 2025, 11:14:54 PM
    Author     : HUNG
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.TopProduct"%>
<%
    List<TopProduct> topProducts = (List<TopProduct>) request.getAttribute("topProducts");
    if (topProducts == null) topProducts = new ArrayList<>();
    
    // Calculate summary statistics
    int totalSold = topProducts.stream().mapToInt(p -> p.getSoldQuantity()).sum();
    double totalRevenue = topProducts.stream().mapToDouble(p -> p.getRevenue()).sum();
    double avgRevenuePerProduct = topProducts.isEmpty() ? 0 : totalRevenue / topProducts.size();
%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Top sản phẩm bán chạy</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Roboto+Mono&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/top-products.css">
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
        <!-- Include thanh menu -->
        <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>

        <div class="dashboard">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div class="header-content">
                    <div class="header-text">
                        <h1 class="dashboard-title"><span>📈</span> Top sản phẩm bán chạy</h1>
                        <p class="dashboard-subtitle">Theo dõi các sản phẩm bán chạy nhất</p>
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
                    <p class="section-subtitle">Thống kê nhanh về sản phẩm bán chạy</p>
                </div>
                <div class="tabs-container">
                    <div class="tabs">
                        <button class="tab active" onclick="openTab(event, 'overview')">Tổng quan</button>
                    </div>
                    <div class="tab-content" id="overview" style="display: block;">
                        <div class="stats-grid">
                            <div class="stat-card primary">
                                <div class="stat-icon">📦</div>
                                <div class="stat-content">
                                    <div class="stat-title">Tổng số lượng bán</div>
                                    <div class="stat-value"><%= totalSold %></div>
                                    <div class="stat-trend positive">+12% so với tuần trước</div>
                                </div>
                            </div>
                            <div class="stat-card secondary">
                                <div class="stat-icon">💰</div>
                                <div class="stat-content">
                                    <div class="stat-title">Tổng doanh thu</div>
                                    <div class="stat-value"><%= String.format("%,.0f", totalRevenue) %> đ</div>
                                    <div class="stat-trend positive">+18% so với tháng trước</div>
                                </div>
                            </div>
                            <div class="stat-card success">
                                <div class="stat-icon">📉</div>
                                <div class="stat-content">
                                    <div class="stat-title">Doanh thu TB/sản phẩm</div>
                                    <div class="stat-value"><%= String.format("%,.0f", avgRevenuePerProduct) %> đ</div>
                                    <div class="stat-trend neutral">Ổn định</div>
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
                    <p class="section-subtitle">Trực quan hóa dữ liệu sản phẩm bán chạy</p>
                </div>
                <div class="charts-grid">
                    <!-- Sold Quantity Bar Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Số lượng bán theo sản phẩm</h3>
                            
                        </div>
                        <div class="chart-container">
                            <canvas id="productChart"></canvas>
                        </div>
                    </div>
                    <!-- Revenue Pie Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ doanh thu theo sản phẩm</h3>
                            
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
                    <h2 class="section-title">📋 Bảng chi tiết sản phẩm</h2>
                    <p class="section-subtitle">Dữ liệu chi tiết về sản phẩm bán chạy</p>
                </div>
                <div class="tabs-container">
                    <div class="tabs">
                        <button class="tab active" onclick="openTab(event, 'table-overview')">Tổng quan</button>
                    </div>
                    <div class="tab-content" id="table-overview" style="display: block;">
                        <div class="table-card">
                            <div class="table-header">
                                <h3 class="table-title">Danh sách sản phẩm</h3>
                                
                            </div>
                            <div class="table-responsive">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Tên sản phẩm</th>
                                            <th>Số lượng bán</th>
                                            <th>Tổng doanh thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (TopProduct p : topProducts) { %>
                                        <tr>
                                            <td class="product-name-cell"><%= p.getProductName() %></td>
                                            <td class="quantity-cell"><%= p.getSoldQuantity() %></td>
                                            <td class="currency revenue-cell"><%= String.format("%,.0f", p.getRevenue()) %> đ</td>
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
            const labels = [<% for (Iterator<TopProduct> it = topProducts.iterator(); it.hasNext(); ) {
            TopProduct p = it.next(); %>"<%= p.getProductName().replace("\"", "\\\"") %>"<%= it.hasNext() ? "," : "" %><% } %>];
                    const soldData = [<% for (Iterator<TopProduct> it = topProducts.iterator(); it.hasNext(); ) {
            TopProduct p = it.next(); %><%= p.getSoldQuantity() %><%= it.hasNext() ? "," : "" %><% } %>];
            const revenueData = [<% for (Iterator<TopProduct> it = topProducts.iterator(); it.hasNext(); ) {
            TopProduct p = it.next(); %><%= p.getRevenue() %><%= it.hasNext() ? "," : "" %><% } %>];
            const totalRevenue = <%= totalRevenue %>;

            // Sold Quantity Bar Chart
            new Chart(document.getElementById('productChart'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Số lượng bán',
                            data: soldData,
                            backgroundColor: 'rgba(118, 199, 224, 0.6)',
                            borderColor: 'rgba(118, 199, 224, 1)',
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
                                    return 'Số lượng: ' + value.toLocaleString();
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
            });

            // Revenue Pie Chart
            new Chart(document.getElementById('revenuePieChart'), {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Tỷ lệ doanh thu (%)',
                            data: revenueData.map(r => r / totalRevenue * 100),
                            backgroundColor: [
                                'rgba(118, 199, 224, 0.8)',
                                'rgba(46, 204, 113, 0.8)',
                                'rgba(255, 159, 64, 0.8)',
                                'rgba(16, 185, 129, 0.8)'
                            ],
                            borderColor: [
                                'rgba(118, 199, 224, 1)',
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
                                label: function (context) {
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