<%-- 
    Document   : top-users
    Created on : May 26, 2025, 10:38:46 PM
    Author     : HUNG
--%>
<%-- 
    Document   : top-users
    Created on : May 23, 2025, 11:27:45 PM
    Author     : HUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.TopUser"%>
<%
    List<TopUser> topUsers = (List<TopUser>) request.getAttribute("topUsers");
    if (topUsers == null) topUsers = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê người dùng chi tiêu nhiều</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h2, h3 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
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
        nav {
            background-color: #f0f0f0;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        nav a {
            margin-right: 15px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        nav a:hover {
            color: #007bff;
        }
    </style>
</head>
<body>
    <!-- Include menu điều hướng -->
    <jsp:include page="menu.jsp" />

    <h2>📊 Người dùng chi tiêu nhiều nhất</h2>

    <canvas id="userChart" width="1000" height="400"></canvas>

    <script>
        const labels = [<% for (Iterator<TopUser> it = topUsers.iterator(); it.hasNext(); ) {
            TopUser u = it.next(); %>"<%= u.getFullName().replace("\"", "\\\"") %>"<%= it.hasNext() ? "," : "" %><% } %>];
        const data = {
            labels: labels,
            datasets: [{
                label: 'Tổng chi tiêu (VND)',
                data: [<% for (Iterator<TopUser> it = topUsers.iterator(); it.hasNext(); ) {
                    TopUser u = it.next(); %><%= u.getTotalSpent() %><%= it.hasNext() ? "," : "" %><% } %>],
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
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

        new Chart(document.getElementById('userChart'), config);
    </script>

    <h3>📋 Bảng chi tiết người dùng</h3>
    <table>
        <tr>
            <th>Tên người dùng</th>
            <th>Số đơn hàng</th>
            <th>Tổng chi tiêu</th>
        </tr>
        <% for (TopUser u : topUsers) { %>
        <tr>
            <td><%= u.getFullName() %></td>
            <td><%= u.getTotalOrders() %></td>
            <td><%= String.format("%,.0f", u.getTotalSpent()) %> đ</td>
        </tr>
        <% } %>
    </table>
</body>
</html>

