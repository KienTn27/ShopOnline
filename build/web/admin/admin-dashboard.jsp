<%-- 
    Document   : admin-dashboard
    Created on : May 29, 2025, 9:32:22 AM
    Author     : HUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Import JSTL core tag library --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- Import JSTL formatting tag library for formatting numbers/dates --%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        h2 { color: #555; }
        h3 { color: #777; }
        ul { list-style-type: none; padding: 0; }
        li { padding: 8px 0; border-bottom: 1px dashed #eee; }
        li:last-child { border-bottom: none; }
        .stat-box {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .stat-box strong { color: #007bff; }
        .currency { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>

    <h1>📊 Thống kê tổng quan Dashboard</h1>

    <%-- Sử dụng EL để truy cập trực tiếp đối tượng stat từ requestScope --%>
    <div class="stat-box">
        <h2>Tổng quan</h2>
        <ul>
            <li>Tổng đơn hàng: <strong>${stat.totalOrders}</strong></li>
            <%-- Sử dụng JSTL fmt:formatNumber để định dạng số tiền --%>
            <li>Tổng doanh thu: <strong class="currency"><fmt:formatNumber value="${stat.totalRevenue}" type="currency" currencySymbol="đ" groupingUsed="true" maxFractionDigits="0"/></strong></li>
            <li>Tổng đánh giá: <strong>${stat.totalReviews}</strong></li>
        </ul>
    </div>

    <div class="stat-box">
        <h3>Trạng thái đơn hàng</h3>
        <ul>
            <%-- Sử dụng JSTL c:forEach để lặp qua Map --%>
            <c:forEach items="${stat.orderByStatus}" var="entry">
                <li>${entry.key}: ${entry.value} đơn</li>
            </c:forEach>
        </ul>
    </div>

</body>
</html>
