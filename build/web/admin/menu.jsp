<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Menu</title> <%-- Thêm title để trang có tiêu đề --%>
    <style>
        nav {
            background-color: #f9f9f9;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex; /* Dùng flexbox để căn chỉnh các mục */
            justify-content: flex-start; /* Căn chỉnh các mục từ trái sang */
            flex-wrap: wrap; /* Cho phép các mục xuống dòng nếu không đủ chỗ */
        }
        nav a {
            margin-right: 25px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            font-size: 16px;
            padding: 5px 0; /* Thêm padding dọc để dễ bấm hơn */
        }
        nav a:hover {
            color: #007bff;
        }
        /* Thêm style cho link đang active nếu bạn muốn */
        /* nav a.active {
            color: #007bff;
            border-bottom: 2px solid #007bff;
        } */
    </style>
</head>
<body>
    <nav>
        <%-- Sử dụng EL để lấy context path: ${pageContext.request.contextPath} --%>
        <a href="${pageContext.request.contextPath}/dashboard">📊 Dashboard</a> <%-- Đổi icon và tên cho dashboard --%>
        <a href="${pageContext.request.contextPath}/RevenueServlet">📈 Doanh thu</a>
        <a href="${pageContext.request.contextPath}/TopProductsServlet">🔥 Bán chạy</a>
        <a href="${pageContext.request.contextPath}/TopUsersServlet">👑 Người dùng chi tiêu</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet">💬 Đánh giá</a>
        <a href="${pageContext.request.contextPath}/admin/orders">📦 Quản lý đơn hàng</a> 
        <%-- Liên kết trùng lặp "💬 Đánh giá" đã được sửa hoặc loại bỏ --%>
    </nav>
</body>
</html>