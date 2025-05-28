<%-- 
    Document   : reviews
    Created on : May 23, 2025, 11:36:39 PM
    Author     : HUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Review"%>

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    if (reviews == null) reviews = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đánh giá</title>
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
            vertical-align: top;
        }
        th {
            background-color: #f2f2f2;
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

    <h2>📝 Quản lý phản hồi đánh giá</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Người dùng</th>
            <th>Sản phẩm</th>
            <th>Số sao</th>
            <th>Nội dung</th>
            <th>Thời gian</th>
        </tr>
        <% for (Review r : reviews) { %>
        <tr>
            <td><%= r.getReviewID() %></td>
            <td><%= r.getUserName() %></td>
            <td><%= r.getProductName() %></td>
            <td><%= r.getRating() %> ★</td>
            <td><%= r.getComment() %></td>
            <td><%= r.getCreatedAt() %></td>
        </tr>
        <% } %>
    </table>
</body>
</html>
