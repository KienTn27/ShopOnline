<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.TopRevenueDay"%>
<%
    TopRevenueDay stat = (TopRevenueDay) request.getAttribute("highestRevenueStat");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ngày có doanh thu cao nhất</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px 40px;
            max-width: 400px;
            text-align: center;
        }
        h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        p {
            font-size: 18px;
            color: #555;
        }
        .highlight {
            font-size: 20px;
            color: #007bff;
            font-weight: bold;
        }
        .no-data {
            font-size: 18px;
            color: #999;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🌟 Ngày có doanh thu cao nhất</h2>
        <% if (stat != null) { %>
            <p><strong>Ngày:</strong> <span class="highlight"><%= stat.getDay() %></span></p>
            <p><strong>Tổng doanh thu:</strong> <span class="highlight"><%= String.format("%,.0f", stat.getTotalRevenue()) %> đ</span></p>
        <% } else { %>
            <p class="no-data">Không có dữ liệu để hiển thị.</p>
        <% } %>
        <a href="<%= request.getContextPath() %>/admin/menu.jsp" class="btn">Quay lại</a>
    </div>
</body>
</html>
