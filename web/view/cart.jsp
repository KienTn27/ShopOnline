<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
    </head>
    <body>
        <div class="container my-4">
            <h2 class="mb-4"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng của bạn</h2>

            <c:choose>
                <c:when test="${not empty sessionScope.carts}">
                    <div class="row g-3">
                        <c:forEach var="cart" items="${sessionScope.carts}">
                            <div class="col-md-12">
                                <div class="card p-3 shadow-sm d-flex flex-row align-items-center">
                                    <img src="${cart.imageURL}" class="img-thumbnail me-3" style="width: 100px; height: auto;" alt="${cart.productName}">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${cart.productName}</h5>
                                        <p class="mb-1 text-danger fw-bold"><fmt:formatNumber value="${cart.price}" type="number" />₫</p>

                                        <div class="d-flex align-items-center mb-2">
                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="me-2">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="quantity" value="${cart.quantity - 1}"/>
                                                <button class="btn btn-outline-secondary btn-sm">−</button>
                                            </form>

                                            <input type="text" class="form-control form-control-sm text-center mx-1" value="${cart.quantity}" style="width: 50px;" readonly />

                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="ms-2">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="quantity" value="${cart.quantity + 1}"/>
                                                <button class="btn btn-outline-secondary btn-sm">+</button>
                                            </form>
                                        </div>

                                        <div>Thành tiền: <strong><fmt:formatNumber value="${cart.price * cart.quantity}" type="number"/>₫</strong></div>
                                    </div>

                                    <div class="text-end ms-3">
                                        <a href="${pageContext.request.contextPath}/CartServlet?action=deleteCartItem&cartId=${cart.cartId}" class="btn btn-outline-danger btn-sm mb-1">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </a>
                                        <br/>
                                        <a href="${pageContext.request.contextPath}/SimilarProductServlet?categoryId=${cart.categoryId}" class="btn btn-outline-primary btn-sm">
                                            <i class="fa-solid fa-magnifying-glass"></i> Tìm tương tự
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Tổng tiền -->
                    <div class="mt-4 text-end">
                        <h4>Tổng cộng: <span class="text-danger"><fmt:formatNumber value="${cartTotal}" type="number" />₫</span></h4>
                    </div>
                    <!-- Địa chỉ giao hàng -->
                    <div class="shipping-form mt-4">
                        <h3>📦 Nhập địa chỉ giao hàng</h3>
                        <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                            <input type="hidden" name="action" value="placeOrder">
                            <input type="hidden" name="totalAmount" value="${cartTotal}">

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="city">Thành phố:</label>
                                    <input type="text" id="city" name="city" class="form-control" placeholder="TP. Hồ Chí Minh, Hà Nội..." required>
                                </div>
                                <div class="col-md-6">
                                    <label for="province">Quận/Huyện:</label>
                                    <input type="text" id="province" name="province" class="form-control" placeholder="Quận 1, Huyện Bình Chánh..." required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="district">Phường/Xã:</label>
                                <input type="text" id="district" name="district" class="form-control" placeholder="Phường Cát Linh, Trung Văn ..." required>
                            </div>

                            <div class="mb-3">
                                <label for="detailAddress">Địa chỉ cụ thể:</label>
                                <textarea id="detailAddress" name="detailAddress" class="form-control" rows="2"
                                          placeholder="Số nhà, tên đường..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-success">
                                <i class="fa-solid fa-money-bill"></i> Thanh toán ngay
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty-message">Giỏ hàng của bạn đang trống 😢</p>
                </c:otherwise>
            </c:choose>

            <div class="links">
                <a href="${pageContext.request.contextPath}/Home">⬅️ Quay lại trang chủ</a>
                <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders">📦 Đơn hàng</a>
            </div>
        </div>
    </body>
</html>
