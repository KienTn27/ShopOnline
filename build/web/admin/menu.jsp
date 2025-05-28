<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- admin/menu.jsp -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        nav {
            background-color: #f9f9f9;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        nav a {
            margin-right: 25px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            font-size: 16px;
        }
        nav a:hover {
            color: #007bff;
        }
    </style>
</head>
<body>
    <nav>
        <a href="<%= request.getContextPath() %>/RevenueServlet">📈 Doanh thu</a>
        <a href="<%= request.getContextPath() %>/TopProductsServlet">🔥 Bán chạy</a>
        <a href="<%= request.getContextPath() %>/TopUsersServlet">👑 Người dùng chi tiêu</a>
        <a href="<%= request.getContextPath() %>/ReviewServlet">💬 Đánh giá</a>
    </nav>
</body>
</html>
