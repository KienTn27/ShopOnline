<%--
    Document   : top-users (Enhanced Version)
    Created on : May 26, 2025, 10:38:46 PM
    Author     : HUNG
    Updated    : Enhanced with modern UI/UX features
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.TopUser"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Lấy dữ liệu từ request attribute
    List<TopUser> topUsers = (List<TopUser>) request.getAttribute("topUsers");
    if (topUsers == null) {
        topUsers = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📊 Thống kê người dùng VIP - Dashboard Analytics</title>
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="Phân tích chi tiết về những khách hàng chi tiêu nhiều nhất với biểu đồ trực quan và thống kê đầy đủ">
    <meta name="keywords" content="thống kê, khách hàng VIP, analytics, dashboard">
    
    <!-- Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>📊</text></svg>">

    <!-- Preconnect to improve loading performance -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">

    <!-- Google Fonts: Inter with additional weights -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Font Awesome 6 với latest version -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer">

    <!-- Chart.js với latest version -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/top-users.css">
    
    <!-- Loading styles -->
    <style>
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.5s ease;
        }
        
        .loader-content {
            text-align: center;
            color: white;
        }
        
        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .stat-card:hover::before {
            left: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #6b7280;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .table-wrapper {
            overflow-x: auto;
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .export-btn {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }
        
        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3);
        }
        
        .chart-controls {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        
        .chart-toggle {
            background: rgba(255, 255, 255, 0.8);
            border: 2px solid rgba(102, 126, 234, 0.3);
            color: #667eea;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }
        
        .chart-toggle.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .chart-toggle:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
    </style>
</head>
<body>
    <!-- Page Loader -->
    <div class="page-loader" id="pageLoader" style="display:none;">
        <div class="loader-content">
            <div class="spinner"></div>
            <h3>Đang tải dữ liệu...</h3>
            <p>Vui lòng chờ trong giây lát</p>
        </div>
    </div>

    <div class="container">
        <header class="header-section">
            <div class="header-title">Top Users Analytics</div>
            <div class="header-description">Khách hàng chi tiêu nhiều nhất và hoạt động nổi bật trên hệ thống</div>
        </header>
        <nav>
            <a href="../RevenueServlet"><i class="fas fa-chart-line"></i> Doanh thu</a>
            <a href="../TopUsersServlet" class="active"><i class="fas fa-users"></i> Top Users</a>
            <a href="../TopProductServlet"><i class="fas fa-star"></i> Top Sản phẩm</a>
        </nav>
        <section class="stats-cards">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-value"><%= topUsers.size() %></div>
                <div class="stat-label">Tổng số người dùng VIP</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-crown"></i></div>
                <div class="stat-value">
                    <fmt:formatNumber value="${topUsers[0].totalSpent}" type="currency" currencySymbol="₫"/>
                </div>
                <div class="stat-label">Người chi tiêu cao nhất</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-value">
                    <fmt:formatNumber value="${topUsers[0].totalOrders}"/>
                </div>
                <div class="stat-label">Đơn hàng nhiều nhất</div>
            </div>
        </section>
        <section class="chart-section" style="margin-bottom:3rem;">
            <div class="chart-title">Biểu đồ chi tiêu của Top Users</div>
            <div style="display:flex;justify-content:center;align-items:center;gap:2rem;flex-wrap:wrap;">
                <canvas id="topUsersChart" style="max-width:600px;min-width:320px;width:100%;height:350px;"></canvas>
            </div>
        </section>
        <section class="table-section">
            <div class="table-title">Bảng xếp hạng người dùng VIP</div>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Hạng</th>
                            <th>Tên khách hàng</th>
                            <th>Email</th>
                            <th>Tổng chi tiêu</th>
                            <th>Số đơn hàng</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty topUsers}">
                            <c:forEach var="user" items="${topUsers}" varStatus="status">
                                <tr>
                                    <td style="text-align:center;font-weight:700;">
                                        <span style="color:#6366f1;font-size:1.1rem;">
                                            <i class="fas fa-trophy"></i> ${status.index+1}
                                        </span>
                                    </td>
                                    <td><b>${user.name}</b></td>
                                    <td>${user.email}</td>
                                    <td><fmt:formatNumber value="${user.totalSpent}" type="currency" currencySymbol="₫"/></td>
                                    <td style="text-align:center;">${user.totalOrders}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="5" class="empty-state"><i class="fas fa-user-slash"></i><br>Không có dữ liệu</td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>

    <script>
        // Hide loader when page loads
        window.addEventListener('load', function() {
            const loader = document.getElementById('pageLoader');
            loader.style.opacity = '0';
            setTimeout(() => {
                loader.style.display = 'none';
            }, 500);
        });

        // Chart.js rendering
        window.addEventListener('DOMContentLoaded', function() {
            var ctx = document.getElementById('topUsersChart').getContext('2d');
            var names = [
                <c:forEach var="user" items="${topUsers}" varStatus="status">
                    "${user.name}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            var spent = [
                <c:forEach var="user" items="${topUsers}" varStatus="status">
                    ${user.totalSpent}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: names,
                    datasets: [{
                        label: 'Tổng chi tiêu (₫)',
                        data: spent,
                        backgroundColor: 'rgba(99,102,241,0.7)',
                        borderColor: '#6366f1',
                        borderWidth: 2,
                        borderRadius: 8,
                        maxBarThickness: 40
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Tổng chi tiêu: ' + context.raw.toLocaleString() + ' ₫';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) { return value.toLocaleString() + ' ₫'; },
                                font: { family: 'Inter', size: 12 }
                            },
                            grid: { color: 'rgba(0,0,0,0.05)' }
                        },
                        x: {
                            ticks: { font: { family: 'Inter', size: 12 } },
                            grid: { display: false }
                        }
                    }
                }
            });
        });

        // Export functions
        function exportData() {
            // Simple CSV export
            let csvContent = "data:text/csv;charset=utf-8,";
            csvContent += "Tên khách hàng,Số đơn hàng,Tổng chi tiêu\n";
            
            <c:forEach var="user" items="${topUsers}">
                csvContent += "${user.name},${user.totalOrders},${user.totalSpent}\n";
            </c:forEach>
            
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "khach-hang-vip.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function printReport() {
            window.print();
        }

        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Animate numbers
            const numbers = document.querySelectorAll('.stat-value');
            numbers.forEach(num => {
                const finalValue = num.textContent;
                if (!isNaN(finalValue.replace(/[^0-9]/g, ''))) {
                    let currentValue = 0;
                    const increment = Math.ceil(parseInt(finalValue.replace(/[^0-9]/g, '')) / 100);
                    const timer = setInterval(() => {
                        currentValue += increment;
                        if (currentValue >= parseInt(finalValue.replace(/[^0-9]/g, ''))) {
                            currentValue = parseInt(finalValue.replace(/[^0-9]/g, ''));
                            clearInterval(timer);
                        }
                        num.textContent = finalValue.replace(/[0-9]/g, '').charAt(0) + currentValue.toLocaleString('vi-VN') + finalValue.slice(-1);
                    }, 20);
                }
            });
        });
    </script>
</body>
</html>