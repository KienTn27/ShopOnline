<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/cart.css">

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng - Clothing Store</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
    </head>
    <body>
        <h2>Giỏ hàng</h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:if test="${not empty message}">
            <p class="message">${message}</p>
        </c:if>

        <table>
            <tr>
                <th>Sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng tiền</th>
                <th>Hành động</th>
            </tr>
            <c:choose>
                <c:when test="${not empty sessionScope.carts}">
                    <c:forEach var="cart" items="${sessionScope.carts}">
                        <tr>
                            <td>${cart.productName}</td>
                            <td><fmt:formatNumber value="${cart.price}" type="number" /> VNĐ</td>
                            <td>
                                <input type="number" class="quantity-input" value="${cart.quantity}" 
                                       onchange="updateQuantity('${cart.cartId}', this.value)">
                            </td>
                            <td><fmt:formatNumber value="${cart.price * cart.quantity}" type="number" /> VNĐ</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/CartServlet?action=deleteCartItem&cartId=${cart.cartId}" 
                                   onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="3"><strong>Tổng tiền:</strong></td>
                        <td><fmt:formatNumber value="${cartTotal}" type="number" /> VNĐ</td>
                        <td><a href="javascript:void(0)" onclick="checkout()">Thanh toán</a></td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="5">Giỏ hàng trống</td></tr>
                </c:otherwise>
            </c:choose>
        </table>

        <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="checkoutForm" style="display:none;">
            <input type="hidden" name="action" value="placeOrder">
            <input type="hidden" name="totalAmount" id="totalAmount">
            <input type="hidden" name="shippingAddress" id="shippingAddress">
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders">Xem đơn hàng</a> | 
            <a href="${pageContext.request.contextPath}/HomeServlet">Quay lại trang chủ</a>
        </div>

        <script>
            function updateQuantity(cartId, quantity) {
                if (quantity > 0) {
                    window.location.href = "${pageContext.request.contextPath}/CartServlet?action=updateQuantity&cartId=" + cartId + "&quantity=" + quantity;
                } else {
                    alert("Số lượng phải lớn hơn 0!");
                }
            }

            function checkout() {
                var shippingAddress = prompt("Nhập địa chỉ giao hàng:");
                if (shippingAddress) {
                    document.getElementById("shippingAddress").value = shippingAddress;
                    document.getElementById("totalAmount").value = "${cartTotal}";
                    document.getElementById("checkoutForm").submit();
                }
            }
        </script>
    </body>
</html>