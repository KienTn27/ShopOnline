<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <head>
        <title>Đơn hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
    </head>
    <body>
        <h2>Danh sách đơn hàng</h2>
        <table>
            <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Mã người dùng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Địa chỉ giao</th>
                    <th>Trạng thái</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty sessionScope.orders}">
                        <c:forEach var="order" items="${sessionScope.orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.userId}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatNumber value="${order.totalAmount}" type="number"/>₫</td>
                                <td>${order.shippingAddress}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty order.status}">Chưa xác định</c:when>
                                        <c:otherwise>${order.status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/view/orderDetail.jsp?orderId=${order.orderId}">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" style="text-align:center;">Không có đơn hàng nào</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="links">
            <a href="${pageContext.request.contextPath}/CartServlet?action=viewCart">⬅ Quay lại giỏ hàng</a>
        </div>
    </body>
</html>
