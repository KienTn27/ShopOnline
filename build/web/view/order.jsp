<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đơn hàng - Clothing Store</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid black;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách đơn hàng</h2>
    <c:if test="${not empty error}"><p class="error">${error}</p></c:if>
    <c:if test="${not empty message}"><p class="message">${message}</p></c:if>

    <table>
        <tr>
            <th>Mã đơn</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Địa chỉ giao</th>
            <th>Trạng thái</th>
            <th>Chi tiết</th>
        </tr>
        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    <td><fmt:formatNumber value="${order.totalAmount}" type="number" /> VNĐ</td>
                    <td>${order.shippingAddress}</td>
                    <td>${order.status}</td>
                    <td><a href="${pageContext.request.contextPath}/OrderServlet?id=${order.orderId}">Xem chi tiết</a></td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="6">Không có đơn hàng</td></tr>
            </c:otherwise>
        </c:choose>
    </table>
    <c:if test="${sessionScope.role == 'admin'}">
        <form action="${pageContext.request.contextPath}/OrderServlet" method="post">
            <input type="hidden" name="action" value="updateStatus">
            <label>Order ID:</label><input type="text" name="orderId" required>
            <label>Trạng thái:</label>
            <select name="status">
                <option value="Pending">Pending</option>
                <option value="Shipped">Shipped</option>
                <option value="Delivered">Delivered</option>
            </select>
            <input type="submit" value="Cập nhật">
        </form>
    </c:if>
    <a href="${pageContext.request.contextPath}/CartServlet?action=viewCart">Quay lại giỏ hàng</a> | 
    <a href="${pageContext.request.contextPath}/HomeServlet">Quay lại trang chủ</a>
</body>
</html>