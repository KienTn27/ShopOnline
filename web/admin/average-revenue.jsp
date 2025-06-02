<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, model.RevenueStat"%>
<%
    List<RevenueStat> stats = (List<RevenueStat>) request.getAttribute("stats");
    if (stats == null) stats = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doanh thu trung bình/ngày</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #aaa;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        canvas {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>📊 Doanh thu trung bình/ngày</h2>

    <!-- Biểu đồ doanh thu -->
    <canvas id="avgRevenueChart" width="1000" height="400"></canvas>

    <script>
        const labels = [<%= stats.stream().map(s -> "\"" + s.getLabel() + "\"").collect(java.util.stream.Collectors.joining(",")) %>];
        const avgRevenueData = [<%= stats.stream().map(s -> String.valueOf(s.getAvgRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];

        new Chart(document.getElementById('avgRevenueChart'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu trung bình (VND)',
                    data: avgRevenueData,
                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + ' đ';
                            }
                        }
                    }
                }
            }
        });
    </script>

    <!-- Bảng chi tiết -->
    <h3>📋 Bảng chi tiết doanh thu</h3>
    <table>
        <tr>
            <th>Ngày</th>
            <th>Số đơn hàng</th>
            <th>Tổng doanh thu</th>
            <th>Doanh thu trung bình</th>
        </tr>
        <% for (RevenueStat s : stats) { %>
        <tr>
            <td><%= s.getLabel() %></td>
            <td><%= s.getTotalOrders() %></td>
            <td><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
            <td><%= String.format("%,.0f", s.getAvgRevenue()) %> đ</td>
        </tr>
        <% } %>
    </table>
</body>
</html>
