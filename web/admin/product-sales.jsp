<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductSalesStat"%>
<%@page import="java.util.List, java.util.ArrayList, model.ProductSalesStat"%>

<%
    List<ProductSalesStat> stats = (List<ProductSalesStat>) request.getAttribute("stats");
    if (stats == null) stats = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Số sản phẩm bán ra/ngày</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h2>📊 Số sản phẩm bán ra/ngày</h2>

    <!-- Biểu đồ số sản phẩm bán -->
    <canvas id="productSalesChart" width="1000" height="400"></canvas>

    <script>
        const labels = [<% for (ProductSalesStat s : stats) { %>"<%= s.getSaleDate() %>"<%= stats.indexOf(s) < stats.size() - 1 ? "," : "" %><% } %>];
        const salesData = [<% for (ProductSalesStat s : stats) { %><%= s.getTotalQuantity() %><%= stats.indexOf(s) < stats.size() - 1 ? "," : "" %><% } %>];

        new Chart(document.getElementById('productSalesChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số sản phẩm bán ra',
                    data: salesData,
                    backgroundColor: 'rgba(153, 102, 255, 0.6)',
                    borderColor: 'rgba(153, 102, 255, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>

    <!-- Bảng chi tiết -->
    <h3>📋 Bảng chi tiết</h3>
    <table border="1">
        <tr>
            <th>Ngày</th>
            <th>Tổng số sản phẩm bán</th>
        </tr>
        <% for (ProductSalesStat s : stats) { %>
        <tr>
            <td><%= s.getSaleDate() %></td>
            <td><%= s.getTotalQuantity() %></td>
        </tr>
        <% } %>
    </table>
</body>
</html>
