<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.TopRevenueDay"%>
<%
    TopRevenueDay stat = (TopRevenueDay) request.getAttribute("lowestRevenueStat");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ngày có doanh thu thấp nhất</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/lowest-revenue.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"></script>
</head>
<body>
    <!-- Background Animation -->
    <div class="background-animation">
        <div class="floating-shape shape-1"></div>
        <div class="floating-shape shape-2"></div>
        <div class="floating-shape shape-3"></div>
        <div class="floating-shape shape-4"></div>
    </div>

    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <div class="header-icon">
                <div class="icon-container">
                    <span class="icon">📉</span>
                    <div class="icon-glow"></div>
                </div>
            </div>
            <h2 class="title">Ngày có doanh thu thấp nhất</h2>
            <p class="subtitle">Phân tích và đánh giá chi tiết</p>
        </div>

        <!-- Main Content -->
        <div class="content">
            <% if (stat != null) { %>
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <!-- Date Card -->
                    <div class="stat-card date-card">
                        <div class="card-header">
                            <div class="card-icon">📅</div>
                            <h3>Ngày thấp điểm</h3>
                        </div>
                        <div class="card-content">
                            <div class="stat-value"><%= stat.getDay() %></div>
                            <div class="stat-label">
                                <%= new java.text.SimpleDateFormat("EEEE", new java.util.Locale("vi", "VN")).format(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(stat.getDay())) %>
                            </div>
                        </div>
                        <div class="mini-chart-container">
                            <canvas id="dateProgressChart" width="100" height="40"></canvas>
                        </div>
                    </div>

                    <!-- Revenue Card -->
                    <div class="stat-card revenue-card">
                        <div class="card-header">
                            <div class="card-icon">💰</div>
                            <h3>Tổng doanh thu</h3>
                        </div>
                        <div class="card-content">
                            <div class="stat-value"><%= String.format("%,.0f", stat.getTotalRevenue()) %></div>
                            <div class="stat-currency">VNĐ</div>
                        </div>
                        <div class="mini-chart-container">
                            <canvas id="revenueSparkline" width="100" height="40"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Alert Badge -->
                <div class="alert-section">
                    <div class="alert-badge">
                        <div class="badge-icon">⚠️</div>
                        <div class="badge-content">
                            <div class="badge-title">Cảnh báo doanh thu thấp</div>
                            <div class="badge-subtitle">Cần phân tích nguyên nhân</div>
                        </div>
                        <div class="badge-sparkle">❗</div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="charts-section">
                    <div class="section-header">
                        <h3 class="section-title">📊 Phân tích chi tiết</h3>
                        <div class="chart-controls">
                            <button class="chart-btn active" data-chart="comparison">So sánh</button>
                            <button class="chart-btn" data-chart="trend">Xu hướng</button>
                            <button class="chart-btn" data-chart="analysis">Phân tích</button>
                        </div>
                    </div>

                    <div class="charts-grid">
                        <!-- Comparison Chart -->
                        <div class="chart-container" id="comparisonContainer">
                            <div class="chart-header">
                                <h4>So sánh doanh thu 7 ngày</h4>
                                <div class="chart-actions">
                                    <button class="action-btn" onclick="toggleChartType('comparisonChart')">
                                        <span class="btn-icon">🔄</span>
                                    </button>
                                    <button class="action-btn" onclick="downloadChart('comparisonChart')">
                                        <span class="btn-icon">📥</span>
                                    </button>
                                </div>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="comparisonChart"></canvas>
                            </div>
                        </div>

                        <!-- Trend Chart -->
                        <div class="chart-container hidden" id="trendContainer">
                            <div class="chart-header">
                                <h4>Xu hướng doanh thu 30 ngày</h4>
                                <div class="chart-actions">
                                    <button class="action-btn" onclick="downloadChart('trendChart')">
                                        <span class="btn-icon">📥</span>
                                    </button>
                                </div>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="trendChart"></canvas>
                            </div>
                        </div>

                        <!-- Analysis Chart -->
                        <div class="chart-container hidden" id="analysisContainer">
                            <div class="chart-header">
                                <h4>Phân tích nguyên nhân</h4>
                                <div class="chart-actions">
                                    <button class="action-btn" onclick="downloadChart('analysisChart')">
                                        <span class="btn-icon">📥</span>
                                    </button>
                                </div>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="analysisChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Secondary Charts -->
                    <div class="secondary-charts">
                        <!-- Hourly Performance -->
                        <div class="small-chart-container">
                            <div class="chart-header">
                                <h4>Doanh thu theo giờ</h4>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="hourlyChart"></canvas>
                            </div>
                        </div>

                        <!-- Performance Metrics -->
                        <div class="metrics-container">
                            <div class="metric-item">
                                <div class="metric-icon">🎯</div>
                                <div class="metric-content">
                                    <div class="metric-value">45%</div>
                                    <div class="metric-label">Đạt mục tiêu</div>
                                </div>
                                <div class="metric-chart">
                                    <canvas id="targetChart" width="60" height="60"></canvas>
                                </div>
                            </div>

                            <div class="metric-item">
                                <div class="metric-icon">📊</div>
                                <div class="metric-content">
                                    <div class="metric-value">-35%</div>
                                    <div class="metric-label">So với trung bình</div>
                                </div>
                                <div class="metric-chart">
                                    <canvas id="averageChart" width="60" height="60"></canvas>
                                </div>
                            </div>

                            <div class="metric-item">
                                <div class="metric-icon">🔍</div>
                                <div class="metric-content">
                                    <div class="metric-value">65%</div>
                                    <div class="metric-label">Tỷ lệ khách hàng</div>
                                </div>
                                <div class="metric-chart">
                                    <canvas id="customerChart" width="60" height="60"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Insights Section -->
                <div class="insights-section">
                    <h3 class="section-title">💡 Phân tích nguyên nhân</h3>
                    <div class="insights-grid">
                        <div class="insight-card">
                            <div class="insight-icon">🌧️</div>
                            <div class="insight-content">
                                <h4>Yếu tố thời tiết</h4>
                                <p>Thời tiết xấu có thể ảnh hưởng đến lượng khách hàng đến cửa hàng, giảm doanh số bán hàng.</p>
                            </div>
                        </div>
                        <div class="insight-card">
                            <div class="insight-icon">📆</div>
                            <div class="insight-content">
                                <h4>Yếu tố thời gian</h4>
                                <p>Ngày trong tuần và thời điểm trong tháng có thể ảnh hưởng đến hành vi mua sắm của khách hàng.</p>
                            </div>
                        </div>
                        <div class="insight-card">
                            <div class="insight-icon">🏪</div>
                            <div class="insight-content">
                                <h4>Hoạt động cạnh tranh</h4>
                                <p>Khuyến mãi từ đối thủ cạnh tranh có thể thu hút khách hàng tiềm năng của bạn.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recommendations Section -->
                <div class="recommendations-section">
                    <h3 class="section-title">🚀 Đề xuất cải thiện</h3>
                    <div class="recommendations-grid">
                        <div class="recommendation-card">
                            <div class="recommendation-icon">📣</div>
                            <div class="recommendation-content">
                                <h4>Tăng cường marketing</h4>
                                <p>Đẩy mạnh quảng cáo và khuyến mãi vào những ngày có xu hướng doanh thu thấp.</p>
                            </div>
                        </div>
                        <div class="recommendation-card">
                            <div class="recommendation-icon">💼</div>
                            <div class="recommendation-content">
                                <h4>Điều chỉnh nhân sự</h4>
                                <p>Tối ưu hóa lịch làm việc của nhân viên dựa trên lưu lượng khách hàng.</p>
                            </div>
                        </div>
                        <div class="recommendation-card">
                            <div class="recommendation-icon">🎁</div>
                            <div class="recommendation-content">
                                <h4>Chương trình khuyến mãi</h4>
                                <p>Tạo các ưu đãi đặc biệt cho khách hàng vào những ngày có doanh thu thấp.</p>
                            </div>
                        </div>
                    </div>
                </div>

            <% } else { %>
                <!-- No Data State -->
                <div class="no-data-state">
                    <div class="no-data-icon">
                        <span class="icon">📊</span>
                        <div class="icon-bg"></div>
                    </div>
                    <h3 class="no-data-title">Không có dữ liệu</h3>
                    <p class="no-data-message">Hiện tại chưa có thông tin về ngày có doanh thu thấp nhất.</p>
                    <div class="no-data-suggestions">
                        <div class="suggestion">
                            <span class="suggestion-icon">💡</span>
                            <span>Kiểm tra kết nối cơ sở dữ liệu</span>
                        </div>
                        <div class="suggestion">
                            <span class="suggestion-icon">🔄</span>
                            <span>Thử tải lại trang</span>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Action Buttons -->
        <div class="actions">
            <a href="<%= request.getContextPath() %>/admin/menu.jsp" class="btn btn-primary">
                <span class="btn-icon">🏠</span>
                <span class="btn-text">Quay lại</span>
            </a>
            <% if (stat != null) { %>
                <button class="btn btn-secondary" onclick="exportAllCharts()">
                    <span class="btn-icon">📊</span>
                    <span class="btn-text">Xuất biểu đồ</span>
                </button>
                <button class="btn btn-outline" onclick="printReport()">
                    <span class="btn-icon">🖨️</span>
                    <span class="btn-text">In báo cáo</span>
                </button>
            <% } %>
        </div>

        <!-- Footer -->
        <div class="footer">
            <div class="footer-info">
                <span class="footer-icon">🕐</span>
                <span>Cập nhật: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></span>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Chart configurations and data
        const chartColors = {
            primary: '#ef4444',
            secondary: '#f97316',
            warning: '#f59e0b',
            info: '#3b82f6',
            muted: '#9ca3af'
        };

        // Sample data for charts
        const sampleData = {
            weeklyRevenue: [
                { date: '2024-01-01', revenue: 850000, isLowest: false },
                { date: '2024-01-02', revenue: 920000, isLowest: false },
                { date: '2024-01-03', revenue: 780000, isLowest: false },
                { date: '2024-01-04', revenue: <%= stat != null ? stat.getTotalRevenue() : 450000 %>, isLowest: true },
                { date: '2024-01-05', revenue: 890000, isLowest: false },
                { date: '2024-01-06', revenue: 950000, isLowest: false },
                { date: '2024-01-07', revenue: 870000, isLowest: false }
            ],
            monthlyTrend: Array.from({length: 30}, (_, i) => ({
                date: new Date(2024, 0, i + 1).toISOString().split('T')[0],
                revenue: Math.floor(Math.random() * 500000) + 600000 - (i === 3 ? 300000 : 0)
            })),
            hourlyData: Array.from({length: 24}, (_, i) => ({
                hour: i,
                revenue: Math.floor(Math.random() * 50000) + 10000
            })),
            causeAnalysis: [
                { cause: 'Thời tiết xấu', percentage: 35 },
                { cause: 'Ngày trong tuần', percentage: 25 },
                { cause: 'Khuyến mãi đối thủ', percentage: 20 },
                { cause: 'Thiếu hàng', percentage: 15 },
                { cause: 'Khác', percentage: 5 }
            ]
        };

        // Initialize charts when page loads
        document.addEventListener('DOMContentLoaded', function() {
            <% if (stat != null) { %>
                initializeCharts();
                setupChartControls();
                addAnimations();
            <% } %>
        });

        function initializeCharts() {
            // Mini charts in stat cards
            createMiniChart('dateProgressChart', 'line');
            createMiniChart('revenueSparkline', 'bar');

            // Main charts
            createComparisonChart();
            createTrendChart();
            createAnalysisChart();
            createHourlyChart();

            // Metric charts
            createMetricChart('targetChart', 45, chartColors.warning);
            createMetricChart('averageChart', 35, chartColors.primary);
            createMetricChart('customerChart', 65, chartColors.info);
        }

        function createMiniChart(canvasId, type) {
            const ctx = document.getElementById(canvasId).getContext('2d');
            const data = type === 'line' ? 
                sampleData.weeklyRevenue.map(d => d.revenue) :
                sampleData.weeklyRevenue.slice(-5).map(d => d.revenue);

            new Chart(ctx, {
                type: type,
                data: {
                    labels: Array.from({length: data.length}, (_, i) => i + 1),
                    datasets: [{
                        data: data,
                        borderColor: chartColors.primary,
                        backgroundColor: type === 'bar' ? chartColors.primary + '80' : chartColors.primary + '20',
                        borderWidth: 2,
                        fill: type === 'line',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { display: false },
                        y: { display: false }
                    },
                    elements: { point: { radius: 0 } }
                }
            });
        }

        function createComparisonChart() {
            const ctx = document.getElementById('comparisonChart').getContext('2d');
            window.comparisonChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: sampleData.weeklyRevenue.map(d => new Date(d.date).toLocaleDateString('vi-VN')),
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: sampleData.weeklyRevenue.map(d => d.revenue),
                        backgroundColor: sampleData.weeklyRevenue.map(d => 
                            d.isLowest ? chartColors.primary + 'CC' : chartColors.info + '80'
                        ),
                        borderColor: sampleData.weeklyRevenue.map(d => 
                            d.isLowest ? chartColors.primary : chartColors.info
                        ),
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: 'white',
                            bodyColor: 'white',
                            borderColor: chartColors.primary,
                            borderWidth: 1,
                            cornerRadius: 8,
                            callbacks: {
                                label: function(context) {
                                    const value = new Intl.NumberFormat('vi-VN').format(context.parsed.y);
                                    const isLowest = sampleData.weeklyRevenue[context.dataIndex].isLowest;
                                    return `${value} VNĐ${isLowest ? ' ⚠️' : ''}`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        notation: 'compact',
                                        compactDisplay: 'short'
                                    }).format(value);
                                }
                            },
                            grid: { color: 'rgba(0, 0, 0, 0.1)' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }

        function createTrendChart() {
            const ctx = document.getElementById('trendChart').getContext('2d');
            window.trendChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: sampleData.monthlyTrend.map(d => new Date(d.date).toLocaleDateString('vi-VN')),
                    datasets: [{
                        label: 'Xu hướng doanh thu',
                        data: sampleData.monthlyTrend.map(d => d.revenue),
                        borderColor: chartColors.info,
                        backgroundColor: `linear-gradient(to bottom, ${chartColors.info}40, ${chartColors.info}10)`,
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: function(context) {
                            const index = context.dataIndex;
                            const value = context.dataset.data[index];
                            const min = Math.min(...context.dataset.data);
                            return value === min ? chartColors.primary : chartColors.info;
                        },
                        pointBorderColor: 'white',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: 'white',
                            bodyColor: 'white',
                            borderColor: chartColors.info,
                            borderWidth: 1,
                            cornerRadius: 8
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        notation: 'compact'
                                    }).format(value);
                                }
                            },
                            grid: { color: 'rgba(0, 0, 0, 0.1)' }
                        },
                        x: {
                            grid: { display: false },
                            ticks: { maxTicksLimit: 10 }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }

        function createAnalysisChart() {
            const ctx = document.getElementById('analysisChart').getContext('2d');
            window.analysisChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: sampleData.causeAnalysis.map(item => item.cause),
                    datasets: [{
                        data: sampleData.causeAnalysis.map(item => item.percentage),
                        backgroundColor: [
                            chartColors.primary,
                            chartColors.secondary,
                            chartColors.warning,
                            chartColors.info,
                            chartColors.muted
                        ],
                        borderColor: 'white',
                        borderWidth: 2,
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: { size: 14 }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: 'white',
                            bodyColor: 'white',
                            borderColor: chartColors.primary,
                            borderWidth: 1,
                            cornerRadius: 8,
                            callbacks: {
                                label: function(context) {
                                    return `${context.label}: ${context.parsed}%`;
                                }
                            }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }

        function createHourlyChart() {
            const ctx = document.getElementById('hourlyChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: sampleData.hourlyData.map(d => `${d.hour}:00`),
                    datasets: [{
                        label: 'Doanh thu theo giờ',
                        data: sampleData.hourlyData.map(d => d.revenue),
                        borderColor: chartColors.secondary,
                        backgroundColor: chartColors.secondary + '20',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        notation: 'compact'
                                    }).format(value);
                                }
                            },
                            grid: { color: 'rgba(0, 0, 0, 0.1)' }
                        },
                        x: {
                            grid: { display: false },
                            ticks: { maxTicksLimit: 8 }
                        }
                    }
                }
            });
        }

        function createMetricChart(canvasId, percentage, color) {
            const ctx = document.getElementById(canvasId).getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    datasets: [{
                        data: [percentage, 100 - percentage],
                        backgroundColor: [color, color + '20'],
                        borderWidth: 0,
                        cutout: '70%'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    animation: {
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }

        function setupChartControls() {
            const chartButtons = document.querySelectorAll('.chart-btn');
            chartButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const chartType = this.dataset.chart;
                    
                    // Update active button
                    chartButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    // Show/hide chart containers
                    document.querySelectorAll('.chart-container').forEach(container => {
                        container.classList.add('hidden');
                    });
                    document.getElementById(chartType + 'Container').classList.remove('hidden');
                });
            });
        }

        function toggleChartType(chartId) {
            const chart = window[chartId];
            if (chart) {
                chart.config.type = chart.config.type === 'bar' ? 'line' : 'bar';
                chart.update();
            }
        }

        function downloadChart(chartId) {
            const chart = window[chartId];
            if (chart) {
                const url = chart.toBase64Image();
                const link = document.createElement('a');
                link.download = `${chartId}.png`;
                link.href = url;
                link.click();
            }
        }

        function exportAllCharts() {
            const charts = ['comparisonChart', 'trendChart', 'analysisChart'];
            charts.forEach(chartId => {
                if (window[chartId]) {
                    setTimeout(() => downloadChart(chartId), 500);
                }
            });
            showNotification('Đang xuất tất cả biểu đồ...');
        }

        function printReport() {
            window.print();
        }

        function addAnimations() {
            // Add entrance animations
            const animatedElements = document.querySelectorAll('.stat-card, .chart-container, .insight-card, .recommendation-card');
            animatedElements.forEach((element, index) => {
                element.style.animationDelay = `${index * 0.1}s`;
                element.classList.add('animate-in');
            });

            // Floating shapes animation
            const shapes = document.querySelectorAll('.floating-shape');
            shapes.forEach(shape => {
                shape.style.animationDelay = `${Math.random() * 2}s`;
            });
        }

        function showNotification(message) {
            const notification = document.createElement('div');
            notification.className = 'notification';
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => notification.classList.add('show'), 100);
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => document.body.removeChild(notification), 300);
            }, 3000);
        }

        // Add hover effects to cards
        document.querySelectorAll('.stat-card, .insight-card, .recommendation-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>
