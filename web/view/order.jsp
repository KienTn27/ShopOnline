<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Đơn hàng của tôi</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .order-table-container {
                background: white;
                border-radius: 18px;
                box-shadow: 0 8px 32px rgba(76, 81, 255, 0.08);
                padding: 2rem 1.5rem;
                margin-bottom: 2rem;
            }
            .order-title {
                font-size: 2.2rem;
                font-weight: 700;
                color: #4f46e5;
                margin-bottom: 1.5rem;
                text-align: center;
                letter-spacing: 1px;
            }
            .order-table th, .order-table td {
                vertical-align: middle;
            }
            .order-table th {
                font-size: 1rem;
            }
            .order-table td {
                font-size: 1.05rem;
            }
            .order-status {
                font-weight: 600;
                border-radius: 8px;
                padding: 0.4em 1em;
                display: inline-block;
            }
            .order-status-pending {
                background: #fffbe6;
                color: #bfa100;
            }
            .order-status-processing {
                background: #e0f7fa;
                color: #007b8a;
            }
            .order-status-confirmed {
                background: #e6ffed;
                color: #1e7e34;
            }
            .order-status-shipped {
                background: #ede7f6;
                color: #6f42c1;
            }
            .order-status-delivered {
                background: #e6fffa;
                color: #20c997;
            }
            .order-status-cancelled {
                background: #ffeaea;
                color: #dc3545;
            }
            .order-action-btn {
                padding: 7px 18px;
                border-radius: 7px;
                font-weight: 500;
                border: none;
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                color: white;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 2px 8px rgba(255, 107, 107, 0.15);
            }
            .order-action-btn:hover {
                background: linear-gradient(135deg, #ee5a52 0%, #ff6b6b 100%);
                transform: translateY(-2px);
            }
            .order-detail-link {
                color: #4f46e5;
                font-weight: 600;
                text-decoration: none;
                transition: color 0.2s;
            }
            .order-detail-link:hover {
                color: #764ba2;
                text-decoration: underline;
            }
            ul.pagination {
                list-style: none;
                padding-left: 0;
            }
            @media (max-width: 900px) {
                .order-table-container {
                    padding: 1rem 0.2rem;
                }
                .order-title {
                    font-size: 1.5rem;
                }
                .order-table th, .order-table td {
                    font-size: 0.95rem;
                    padding: 8px 2px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="order-table-container">
                <div class="order-title"><i class="fas fa-clipboard-list me-2"></i>Đơn hàng của tôi</div>
                <!-- Thông báo -->
                <c:if test="${not empty requestScope.successMessage}">
                    <div class="message success-message">
                        <i class="fas fa-check-circle"></i> ${requestScope.successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="message error-message">
                        <i class="fas fa-times-circle"></i> ${requestScope.errorMessage}
                    </div>
                </c:if>
                <table class="order-table" style="width:100%">
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
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>₫</strong></td>
                                        <td>${order.shippingAddress}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty order.status}">
                                                    <span class="order-status order-status-pending">Chưa xác định</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Pending'}">
                                                    <span class="order-status order-status-pending"><i class="fas fa-hourglass-half me-1"></i>Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Processing'}">
                                                    <span class="order-status order-status-processing"><i class="fas fa-cog me-1"></i>Đang xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Confirmed'}">
                                                    <span class="order-status order-status-confirmed"><i class="fas fa-check me-1"></i>Đã xác nhận</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Shipped'}">
                                                    <span class="order-status order-status-shipped"><i class="fas fa-truck me-1"></i>Đang giao</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Delivered'}">
                                                    <span class="order-status order-status-delivered"><i class="fas fa-box-open me-1"></i>Đã giao</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Cancelled'}">
                                                    <span class="order-status order-status-cancelled"><i class="fas fa-times me-1"></i>Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="order-status order-status-pending">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a class="order-detail-link" href="${pageContext.request.contextPath}/view/orderDetail.jsp?orderId=${order.orderId}">
                                                <i class="fas fa-eye"></i> Xem chi tiết
                                            </a>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'Pending' || order.status == 'Processing' || order.status == 'Confirmed'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/CancelOrderServlet" style="display: inline;">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <button type="submit" class="order-action-btn"
                                                                onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${order.orderId}?')">
                                                            <i class="fas fa-trash"></i> Hủy đơn
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
                                            <i class="fas fa-inbox fa-2x mb-2"></i><br/>
                                            Bạn chưa có đơn hàng nào
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <c:if test="${totalPages > 1}">
                    <div style="text-align:center; margin: 20px 0;">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/CartServlet?action=viewOrders&page=${currentPage - 1}" aria-label="Previous">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <!-- First page -->
                                <li class="page-item ${currentPage == 1 ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/CartServlet?action=viewOrders&page=1">1</a>
                                </li>
                                <!-- Dots if needed -->
                                <c:if test="${currentPage > 4}">
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                </c:if>
                                <!-- Pages around current -->
                                <c:forEach begin="${currentPage > 4 ? currentPage - 1 : 2}"
                                           end="${currentPage < totalPages - 3 ? currentPage + 1 : totalPages - 1}"
                                           var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/CartServlet?action=viewOrders&page=${i}">${i}</a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                <!-- Dots if needed -->
                                <c:if test="${currentPage < totalPages - 3}">
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                </c:if>
                                <!-- Last page -->
                                <li class="page-item ${currentPage == totalPages ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/CartServlet?action=viewOrders&page=${totalPages}">${totalPages}</a>
                                </li>
                                <!-- Next Button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/CartServlet?action=viewOrders&page=${currentPage + 1}" aria-label="Next">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
                <div class="links">
                    <a href="${pageContext.request.contextPath}/CartServlet?action=viewCart"><i class="fas fa-shopping-cart me-1"></i>Quay lại giỏ hàng</a>
                    <a href="${pageContext.request.contextPath}/Home" style="margin-left: 15px;"><i class="fas fa-home me-1"></i>Về trang chủ</a>
                </div>
            </div>
        </div>
    </body>
</html>
