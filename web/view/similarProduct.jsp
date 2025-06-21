<%-- 
    Document   : similarProduct
    Created on : Jun 3, 2025, 9:13:38 PM
    Author     : X1 carbon Gen6
--%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sản phẩm tương tự</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/similar.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <!-- Header Section -->
            <header class="page-header">
                <div class="header-content">
                    <i class="fas fa-heart header-icon"></i>
                    <h1>Sản phẩm tương tự</h1>
                    <p class="header-subtitle">Khám phá những sản phẩm có thể bạn quan tâm</p>
                </div>
            </header>

            <!-- Products Grid -->
            <main class="main-content">
                <div class="products-grid">
                    <c:forEach var="p" items="${similarProducts}">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="${p.imageUrl}" alt="${p.name}" loading="lazy">
                                <div class="product-overlay">
                                    <i class="fas fa-eye view-icon"></i>
                                </div>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${p.name}</h3>
                                <p class="product-description">${p.description}</p>
                                <div class="product-price">
                                    <span class="price-amount">
                                        <fmt:formatNumber value="${p.price}" type="number"/> VND
                                    </span>
                                </div>
                                <button class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i>
                                    Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Empty State -->
                <c:if test="${empty similarProducts}">
                    <div class="empty-state">
                        <i class="fas fa-box-open empty-icon"></i>
                        <h3>Không có sản phẩm tương tự</h3>
                        <p>Hiện tại chưa có sản phẩm tương tự nào được tìm thấy.</p>
                    </div>
                </c:if>
            </main>

            <!-- Navigation Section -->
            <footer class="page-footer">
                <a href="${pageContext.request.contextPath}/view/cart.jsp" class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại Giỏ hàng
                </a>
            </footer>
        </div>
    </body>
</html>