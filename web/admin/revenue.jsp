<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.RevenueStat"%>
<%
    List<RevenueStat> stats = (List<RevenueStat>) request.getAttribute("stats");
    String type = (String) request.getAttribute("type");
    if (stats == null) stats = new ArrayList<>();
    if (type == null) type = "day";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê doanh thu</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h2 {
            color: #333;
        }
        form {
            margin: 20px 0;
        }
        select {
            padding: 5px;
            font-size: 14px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #aaa;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

    <!-- Menu chung (nếu có) -->
    <jsp:include page="menu.jsp" />

    <h2>📈 Thống kê doanh thu theo <%= type.equals("day") ? "ngày" : "tháng" %></h2>

    <form method="get" action="revenue">
        <label>Chọn loại:</label>
        <select name="type" onchange="this.form.submit()">
            <option value="day" <%= "day".equals(type) ? "selected" : "" %>>Theo ngày</option>
            <option value="month" <%= "month".equals(type) ? "selected" : "" %>>Theo tháng</option>
        </select>
    </form>

    <canvas id="revenueChart" width="1000" height="400"></canvas>

    <script>
        const labels = [<%= stats.stream().map(s -> "\"" + s.getLabel() + "\"").collect(java.util.stream.Collectors.joining(",")) %>];
        const data = [<%= stats.stream().map(s -> String.valueOf(s.getTotalRevenue())).collect(java.util.stream.Collectors.joining(",")) %>];

        const config = {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Tổng doanh thu (VND)',
                    data: data,
                    fill: true,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.3
                }]
            },
            options: {
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
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
        };

        new Chart(document.getElementById('revenueChart'), config);
    </script>

    <h3>📋 Bảng tổng hợp doanh thu</h3>
    <table>
        <tr>
            <th><%= type.equals("day") ? "Ngày" : "Tháng" %></th>
            <th>Số đơn hàng</th>
            <th>Tổng doanh thu</th>
        </tr>
        <% for (RevenueStat s : stats) { %>
        <tr>
            <td><%= s.getLabel() %></td>
            <td><%= s.getTotalOrders() %></td>
            <td><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
        </tr>
        <% } %>
    </table>
</body>
</html>
