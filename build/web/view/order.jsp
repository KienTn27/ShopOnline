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
        <div class="container">
            <h2>📦 Danh sách đơn hàng</h2>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty requestScope.successMessage}">
                <div class="message success-message">
                    ✅ ${requestScope.successMessage}
                </div>
            </c:if>
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="message error-message">
                    ❌ ${requestScope.errorMessage}
                </div>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Địa chỉ giao</th>
                        <th>Trạng thái</th>
                        <th>Chi tiết</th>
                        <th class="action-column">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty sessionScope.orders}">
                            <c:forEach var="order" items="${sessionScope.orders}">
                                <tr>
                                    <td><strong>#${order.orderId}</strong></td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>₫</strong></td>
                                    <td>${order.shippingAddress}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty order.status}">
                                                <span class="status-pending">Chưa xác định</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Pending'}">
                                                <span class="status-pending">⏳ Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Processing'}">
                                                <span class="status-processing">⚙️ Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Confirmed'}">
                                                <span class="status-confirmed">✅ Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Shipped'}">
                                                <span class="status-shipped">🚚 Đang giao</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Delivered'}">
                                                <span class="status-delivered">📦 Đã giao</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Cancelled'}">
                                                <span class="status-cancelled">❌ Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pending">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/view/orderDetail.jsp?orderId=${order.orderId}">
                                            👁️ Xem chi tiết
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'Pending' || order.status == 'Processing' || order.status == 'Confirmed'}">
                                                <form method="post" action="${pageContext.request.contextPath}/CancelOrderServlet" style="display: inline;">
                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                    <button type="submit" class="cancel-btn" 
                                                            onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${order.orderId}?')">
                                                        🗑️ Hủy đơn
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${order.status == 'Cancelled'}">
                                                <span style="color: #6c757d; font-style: italic;">Đã hủy</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Shipped' || order.status == 'Delivered'}">
                                                <span style="color: #28a745; font-style: italic;">Đã giao</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d; font-style: italic;">Không thể hủy</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="text-align:center; padding: 40px;">
                                    <div style="color: #6c757d; font-size: 1.1rem;">
                                        📭 Bạn chưa có đơn hàng nào
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="links">
                <a href="${pageContext.request.contextPath}/CartServlet?action=viewCart">🛒 Quay lại giỏ hàng</a>
                <a href="${pageContext.request.contextPath}/Home" style="margin-left: 15px;">🏠 Về trang chủ</a>
            </div>
        </div>
    </body>
</html>
