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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Top sản phẩm bán chạy</title>
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
    <!-- Include thanh menu -->
    <jsp:include page="menu.jsp" />

    <h2>📈 Top sản phẩm bán chạy</h2>

    <canvas id="productChart" width="800" height="400"></canvas>

    <script>
        const labels = [<% for (Iterator<TopProduct> it = topProducts.iterator(); it.hasNext(); ) {
            TopProduct p = it.next(); %>"<%= p.getProductName().replace("\"", "\\\"") %>"<%= it.hasNext() ? "," : "" %><% } %>];
        const data = {
            labels: labels,
            datasets: [{
                label: 'Số lượng bán',
                data: [<% for (Iterator<TopProduct> it = topProducts.iterator(); it.hasNext(); ) {
                    TopProduct p = it.next(); %><%= p.getSoldQuantity() %><%= it.hasNext() ? "," : "" %><% } %>],
                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                borderColor: 'rgba(75, 192, 192, 1)',
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
                        beginAtZero: true
                    }
                }
            }
        };

        new Chart(document.getElementById('productChart'), config);
    </script>

    <h3>📋 Bảng thống kê sản phẩm</h3>
    <table>
        <tr>
            <th>Tên sản phẩm</th>
            <th>Số lượng bán</th>
            <th>Tổng doanh thu</th>
        </tr>
        <% for (TopProduct p : topProducts) { %>
        <tr>
            <td><%= p.getProductName() %></td>
            <td><%= p.getSoldQuantity() %></td>
            <td><%= String.format("%,.0f", p.getRevenue()) %> đ</td>
        </tr>
        <% } %>
    </table>
</body>
</html>
