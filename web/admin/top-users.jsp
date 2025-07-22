<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.TopUser "%>
<%
    List<TopUser > topUsers = (List<TopUser >) request.getAttribute("topUsers");
    if (topUsers == null) topUsers = new ArrayList<>();
    // Prepare JS arrays for chart
    StringBuilder userLabels = new StringBuilder();
    StringBuilder userSpent = new StringBuilder();
    for (Iterator<TopUser> it = topUsers.iterator(); it.hasNext(); ) {
        TopUser u = it.next();
        userLabels.append("\"").append(u.getFullName().replace("\"", "\\\"")).append("\"");
        userSpent.append(String.format("%.0f", u.getTotalSpent()));
        if (it.hasNext()) {
            userLabels.append(", ");
            userSpent.append(", ");
        }
    }
    String userLabelsArray = "[" + userLabels.toString() + "]";
    String userSpentArray = "[" + userSpent.toString() + "]";
    if (userLabels.length() == 0) userLabelsArray = "[]";
    if (userSpent.length() == 0) userSpentArray = "[]";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê người dùng chi tiêu nhiều</title>
    <link rel="stylesheet" href="../css/top-users.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .main-bg {
            background: #f4f8fb;
            min-height: 100vh;
            padding: 0;
        }
        .section-card {
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 24px 0 rgba(60,72,88,0.08);
            margin-bottom: 2.5rem;
            padding: 2.5rem 2rem 2rem 2rem;
        }
        .section-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.7rem;
        }
        .section-title i {
            color: #4fd1c5;
            font-size: 1.5rem;
        }
        .section-desc {
            color: #718096;
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }
        .chart-section {
            padding-bottom: 2rem;
        }
        .table-section {
            padding-top: 1.5rem;
        }
        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 0.8rem;
            background: #fff;
            box-shadow: 0 2px 8px 0 rgba(60,72,88,0.04);
            font-size: 1rem;
        }
        thead th {
            background: #e6fffa;
            color: #319795;
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 700;
            font-size: 1rem;
            border-bottom: 2px solid #b2f5ea;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        tbody tr {
            background: #fff;
            transition: background 0.2s, box-shadow 0.2s;
        }
        tbody tr:nth-child(even) {
            background: #f7fafc;
        }
        tbody tr:hover {
            background: #e6fffa;
        }
        tbody td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            color: #4a5568;
            font-size: 1rem;
            font-weight: 500;
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
        td:nth-child(1) {
            font-weight: 700;
            color: #2d3748;
        }
        td:nth-child(2) {
            text-align: center;
            font-weight: 600;
            color: #38b2ac;
        }
        td:nth-child(3) {
            text-align: right;
            font-weight: 700;
            color: #2d3748;
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
            max-width: 1200px !important;
            padding: 3.5rem 2.5rem !important;
        }
        .section-card {
            padding: 3rem 2.5rem 2.5rem 2.5rem !important;
        }
        .section-title {
            font-size: 2.5rem !important;
        }
        .section-desc {
            font-size: 1.3rem !important;
        }
        .chart-section {
            padding-bottom: 2.5rem !important;
        }
        .table-section {
            padding-top: 2rem !important;
        }
        table {
            font-size: 1.2rem !important;
        }
        thead th {
            font-size: 1.2rem !important;
            padding: 1.3rem 2rem !important;
        }
        tbody td {
            font-size: 1.15rem !important;
            padding: 1.2rem 2rem !important;
        }
        canvas {
            height: 480px !important;
        }
        @media (max-width: 900px) {
            .container { padding: 1.2rem !important; }
            .section-title { font-size: 1.5rem !important; }
            .section-desc { font-size: 1.05rem !important; }
            table, thead th, tbody td { font-size: 1rem !important; }
            canvas { height: 300px !important; }
        }
    </style>
</head>
<body class="main-bg">
    <div class="container" style="max-width: 900px; margin: 0 auto; padding-top: 2.5rem;">
        <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
        <div class="section-card">
            <div class="section-title"><i class="fa-solid fa-crown"></i>Người dùng chi tiêu nhiều nhất</div>
            <div class="section-desc">Danh sách những khách hàng có tổng chi tiêu cao nhất trên hệ thống của bạn.</div>
        </div>
        <div class="section-card chart-section">
            <div class="section-title"><i class="fa-solid fa-chart-bar"></i>Biểu đồ chi tiêu người dùng</div>
            <canvas id="userChart"></canvas>
        </div>
        <div class="section-card table-section">
            <div class="section-title"><i class="fa-solid fa-table"></i>Bảng chi tiết người dùng</div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Tên người dùng</th>
                            <th>Số đơn hàng</th>
                            <th>Tổng chi tiêu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (TopUser  u : topUsers) { %>
                        <tr>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getTotalOrders() %></td>
                            <td><%= String.format("%,.0f", u.getTotalSpent()) %> đ</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        const labels = <%= userLabelsArray %>;
        const data = {
            labels: labels,
            datasets: [{
                label: 'Tổng chi tiêu (VND)',
                data: <%= userSpentArray %>,
                backgroundColor: 'rgba(72, 187, 255, 0.7)', // pastel blue
                borderColor: '#38b2ac', // accent teal
                borderWidth: 2,
                borderRadius: 10,
                hoverBackgroundColor: 'rgba(56, 178, 172, 0.9)'
            }]
        };
        const config = {
            type: 'bar',
            data: data,
            options: {
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        ticks: { color: '#2d3748', font: { weight: 'bold' } },
                        grid: { color: '#e2e8f0' }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            color: '#2d3748',
                            font: { weight: 'bold' },
                            callback: function(value) {
                                return value.toLocaleString() + ' đ';
                            }
                        },
                        grid: { color: '#e2e8f0' }
                    }
                }
            }
        };
        new Chart(document.getElementById('userChart'), config);
    </script>
</body>
</html>