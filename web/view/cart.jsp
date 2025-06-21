<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ Hàng - ShopOnline</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <style>
            :root {
                --primary-color: #6366f1;
                --secondary-color: #64748b;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --info-color: #06b6d4;
                --dark-color: #1e293b;
                --light-bg: #f8fafc;
                --border-color: #e2e8f0;
                --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                line-height: 1.6;
            }

            .main-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                margin: 2rem auto;
                overflow: hidden;
                max-width: 1200px;
            }

            .header-section {
                background: linear-gradient(135deg, var(--primary-color), #8b5cf6);
                color: white;
                padding: 2.5rem 2rem;
                position: relative;
                overflow: hidden;
            }

            .header-section::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
                background-size: 30px 30px;
                animation: float 20s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                50% {
                    transform: translateY(-20px) rotate(180deg);
                }
            }

            .header-content {
                position: relative;
                z-index: 2;
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .cart-stats {
                display: flex;
                gap: 2rem;
                align-items: center;
            }

            .stat-item {
                text-align: center;
                background: rgba(255, 255, 255, 0.2);
                padding: 1rem 1.5rem;
                border-radius: 15px;
                backdrop-filter: blur(10px);
                min-width: 100px;
            }

            .stat-number {
                font-size: 1.5rem;
                font-weight: bold;
                display: block;
            }

            .stat-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .content-section {
                padding: 2rem;
            }

            .alert-modern {
                border: none;
                border-radius: 15px;
                padding: 1.25rem 1.5rem;
                margin-bottom: 2rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                font-weight: 500;
                box-shadow: var(--card-shadow);
            }

            .alert-warning {
                background: linear-gradient(135deg, #fef3c7, #fde68a);
                color: #92400e;
                border-left: 4px solid var(--warning-color);
            }

            .alert-danger {
                background: linear-gradient(135deg, #fef2f2, #fee2e2);
                color: #991b1b;
                border-left: 4px solid var(--danger-color);
            }

            .cart-item {
                background: white;
                border-radius: 20px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: var(--card-shadow);
                transition: all 0.3s ease;
                border: 1px solid var(--border-color);
                position: relative;
                overflow: hidden;
            }

            .cart-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, var(--primary-color), #8b5cf6);
            }

            .cart-item:hover {
                transform: translateY(-2px);
                box-shadow: var(--card-shadow-hover);
            }

            .product-image {
                width: 120px;
                height: 120px;
                object-fit: cover;
                border-radius: 15px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .product-image:hover {
                transform: scale(1.05);
            }

            .product-info {
                flex: 1;
                padding: 0 1.5rem;
            }

            .product-name {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 0.5rem;
                line-height: 1.4;
            }

            .product-price {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--danger-color);
                margin-bottom: 1rem;
            }

            .quantity-controls {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 1rem;
                background: var(--light-bg);
                padding: 0.5rem;
                border-radius: 50px;
                width: fit-content;
            }

            .btn-quantity {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                border: 2px solid var(--primary-color);
                background: white;
                color: var(--primary-color);
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .btn-quantity:hover:not(:disabled) {
                background: var(--primary-color);
                color: white;
                transform: scale(1.1);
            }

            .btn-quantity:disabled {
                opacity: 0.4;
                cursor: not-allowed;
                transform: none;
            }

            .quantity-input {
                width: 60px;
                text-align: center;
                font-weight: bold;
                border: 2px solid var(--border-color);
                border-radius: 10px;
                padding: 0.5rem;
                background: white;
                font-size: 1rem;
            }

            .stock-info {
                font-size: 0.9rem;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1rem;
            }

            .stock-normal {
                background: linear-gradient(135deg, #dcfce7, #bbf7d0);
                color: #15803d;
            }

            .stock-warning {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #991b1b;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.02);
                }
            }

            .subtotal {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--success-color);
                background: linear-gradient(135deg, #f0fdf4, #dcfce7);
                padding: 0.75rem 1rem;
                border-radius: 10px;
                display: inline-block;
            }

            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
                align-items: flex-end;
            }

            .btn-modern {
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 600;
                border: none;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
                font-size: 0.9rem;
            }

            .btn-delete {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #991b1b;
                border: 1px solid #f87171;
            }

            .btn-delete:hover {
                background: linear-gradient(135deg, #dc2626, #ef4444);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(220, 38, 38, 0.3);
            }

            .btn-similar {
                background: linear-gradient(135deg, #e0f2fe, #b3e5fc);
                color: #0277bd;
                border: 1px solid #29b6f6;
            }

            .btn-similar:hover {
                background: linear-gradient(135deg, #0277bd, #0288d1);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(2, 119, 189, 0.3);
            }

            .cart-summary {
                background: white;
                border-radius: 20px;
                padding: 2rem;
                box-shadow: var(--card-shadow);
                border: 1px solid var(--border-color);
                margin: 2rem 0;
                position: relative;
                overflow: hidden;
            }

            .cart-summary::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, var(--success-color), #34d399);
            }

            .total-amount {
                font-size: 2rem;
                font-weight: 700;
                color: var(--success-color);
                text-align: center;
                margin-bottom: 1.5rem;
                padding: 1rem;
                background: linear-gradient(135deg, #f0fdf4, #dcfce7);
                border-radius: 15px;
            }

            .shipping-form {
                background: white;
                border-radius: 20px;
                padding: 2rem;
                box-shadow: var(--card-shadow);
                border: 1px solid var(--border-color);
                margin: 2rem 0;
            }

            .shipping-form h3 {
                color: var(--dark-color);
                margin-bottom: 1.5rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-label {
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 0.5rem;
                display: block;
            }

            .form-control {
                border: 2px solid var(--border-color);
                border-radius: 12px;
                padding: 0.75rem 1rem;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: white;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.25);
                outline: none;
            }

            .form-control::placeholder {
                color: #9ca3af;
            }

            .btn-checkout {
                background: linear-gradient(135deg, var(--success-color), #34d399);
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 15px;
                font-size: 1.1rem;
                font-weight: 600;
                width: 100%;
                transition: all 0.3s ease;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.75rem;
            }

            .btn-checkout:hover {
                background: linear-gradient(135deg, #059669, var(--success-color));
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(16, 185, 129, 0.3);
            }

            .empty-cart {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--secondary-color);
            }

            .empty-cart i {
                font-size: 5rem;
                margin-bottom: 1.5rem;
                opacity: 0.5;
            }

            .empty-cart h3 {
                font-size: 1.5rem;
                margin-bottom: 1rem;
                color: var(--dark-color);
            }

            .navigation-links {
                display: flex;
                justify-content: center;
                gap: 2rem;
                margin-top: 2rem;
                flex-wrap: wrap;
            }

            .nav-link {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: 2px solid var(--border-color);
                background: white;
                color: var(--dark-color);
            }

            .nav-link:hover {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(99, 102, 241, 0.3);
            }

            .loading {
                opacity: 0.6;
                pointer-events: none;
                position: relative;
            }

            .loading::after {
                content: '';
                position: absolute;
                top: 50%;
                right: 10px;
                width: 20px;
                height: 20px;
                margin-top: -10px;
                border: 2px solid #f3f3f3;
                border-top: 2px solid var(--primary-color);
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .main-container {
                    margin: 1rem;
                    border-radius: 15px;
                }

                .header-section {
                    padding: 2rem 1.5rem;
                }

                .page-title {
                    font-size: 2rem;
                }

                .cart-stats {
                    flex-direction: column;
                    gap: 1rem;
                    width: 100%;
                }

                .stat-item {
                    width: 100%;
                }

                .content-section {
                    padding: 1.5rem;
                }

                .cart-item {
                    flex-direction: column;
                    text-align: center;
                }

                .product-info {
                    padding: 1rem 0;
                }

                .action-buttons {
                    flex-direction: row;
                    justify-content: center;
                    width: 100%;
                }

                .quantity-controls {
                    justify-content: center;
                    width: 100%;
                }

                .navigation-links {
                    flex-direction: column;
                    align-items: center;
                }

                .nav-link {
                    width: 100%;
                    justify-content: center;
                    max-width: 300px;
                }
            }
        </style>
    </head>
    <body>
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-content">
                    <h1 class="page-title">
                        <i class="fas fa-shopping-cart"></i>
                        Giỏ Hàng
                    </h1>
                    <div class="cart-stats">
                        <div class="stat-item">
                            <span class="stat-number">${not empty sessionScope.carts ? sessionScope.carts.size() : 0}</span>
                            <span class="stat-label">Sản phẩm</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">
                                <c:set var="totalItems" value="0"/>
                                <c:forEach var="cart" items="${sessionScope.carts}">
                                    <c:set var="totalItems" value="${totalItems + cart.quantity}"/>
                                </c:forEach>
                                ${totalItems}
                            </span>
                            <span class="stat-label">Tổng số lượng</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Section -->
            <div class="content-section">
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.warningMessage}">
                    <div class="alert-modern alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>${sessionScope.warningMessage}</span>
                    </div>
                    <% session.removeAttribute("warningMessage"); %>
                </c:if>

                <c:if test="${not empty requestScope.error}">
                    <div class="alert-modern alert-danger">
                        <i class="fas fa-times-circle"></i>
                        <span>${requestScope.error}</span>
                    </div>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert-modern alert-danger">
                        <i class="fas fa-times-circle"></i>
                        <span>${sessionScope.errorMessage}</span>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>

                <!-- Cart Items -->
                <c:choose>
                    <c:when test="${not empty sessionScope.carts}">
                        <!-- Cart Items List -->
                        <div class="cart-items">
                            <c:forEach var="cart" items="${sessionScope.carts}">
                                <div class="cart-item d-flex align-items-center">
                                    <img src="${cart.imageURL}" class="product-image" alt="${cart.productName}">

                                    <div class="product-info">
                                        <h5 class="product-name">${cart.productName}</h5>
                                        <div class="product-price">
                                            <fmt:formatNumber value="${cart.price}" type="number" />₫
                                        </div>

                                        <div class="quantity-controls">
                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="d-inline">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="operation" value="decrease"/>
                                                <button type="submit" class="btn-quantity" ${cart.quantity <= 1 ? 'disabled' : ''}>
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                            </form>

                                            <input type="text" class="quantity-input" value="${cart.quantity}" readonly />

                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="d-inline">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="operation" value="increase"/>
                                                <button type="submit" class="btn-quantity" ${cart.quantity >= cart.stockQuantity ? 'disabled' : ''}>
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </form>
                                        </div>

                                        <div class="stock-info ${cart.quantity >= cart.stockQuantity ? 'stock-warning' : 'stock-normal'}">
                                            <c:choose>
                                                <c:when test="${cart.quantity >= cart.stockQuantity}">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    Đã đạt giới hạn tồn kho (${cart.stockQuantity})
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-boxes"></i>
                                                    Còn ${cart.stockQuantity - cart.quantity} sản phẩm trong kho
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="subtotal">
                                            <i class="fas fa-calculator me-1"></i>
                                            Thành tiền: <fmt:formatNumber value="${cart.price * cart.quantity}" type="number"/>₫
                                        </div>
                                    </div>

                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/CartServlet?action=deleteCartItem&cartId=${cart.cartId}" 
                                           class="btn-modern btn-delete">
                                            <i class="fas fa-trash"></i>
                                            Xóa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/SimilarProductServlet?categoryId=${cart.categoryId}" 
                                           class="btn-modern btn-similar">
                                            <i class="fas fa-search"></i>
                                            Tương tự
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Cart Summary -->
                        <div class="cart-summary">
                            <div class="total-amount">
                                <i class="fas fa-receipt me-3"></i>
                                Tổng cộng: <fmt:formatNumber value="${cartTotal}" type="number" />₫
                            </div>
                        </div>

                        <!-- Shipping Form -->
                        <div class="shipping-form">
                            <h3>
                                <i class="fas fa-shipping-fast"></i>
                                Thông tin giao hàng
                            </h3>
                            <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                                <input type="hidden" name="action" value="placeOrder">
                                <input type="hidden" name="totalAmount" value="${cartTotal}">

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="city" class="form-label">
                                                <i class="fas fa-city me-2"></i>Thành phố
                                            </label>
                                            <input type="text" id="city" name="city" class="form-control" 
                                                   placeholder="VD: TP. Hồ Chí Minh, Hà Nội..." required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="province" class="form-label">
                                                <i class="fas fa-map-marker-alt me-2"></i>Quận/Huyện
                                            </label>
                                            <input type="text" id="province" name="province" class="form-control" 
                                                   placeholder="VD: Quận 1, Huyện Bình Chánh..." required>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="district" class="form-label">
                                        <i class="fas fa-location-dot me-2"></i>Phường/Xã
                                    </label>
                                    <input type="text" id="district" name="district" class="form-control" 
                                           placeholder="VD: Phường Cát Linh, Trung Văn..." required>
                                </div>

                                <div class="form-group">
                                    <label for="detailAddress" class="form-label">
                                        <i class="fas fa-home me-2"></i>Địa chỉ cụ thể
                                    </label>
                                    <textarea id="detailAddress" name="detailAddress" class="form-control" rows="3"
                                              placeholder="Số nhà, tên đường, landmark..." required></textarea>
                                </div>

                                <button type="submit" class="btn-checkout">
                                    <i class="fas fa-credit-card"></i>
                                    Đặt hàng ngay
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>Giỏ hàng trống</h3>
                            <p>Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá và thêm những sản phẩm yêu thích!</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Navigation Links -->
                <div class="navigation-links">
                    <a href="${pageContext.request.contextPath}/Home" class="nav-link">
                        <i class="fas fa-home"></i>
                        Trang chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders" class="nav-link">
                        <i class="fas fa-clipboard-list"></i>
                        Đơn hàng của tôi
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide alert messages after 8 seconds
            const alertMessages = document.querySelectorAll('.alert-modern');
                    alertMessages.forEach(msg => {
                    setTimeout(() => {
                    msg.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                            msg.style.opacity = '0';
                            msg.style.transform = 'translateY(-20px)';
                            setTimeout(() => {
                            msg.remove();
                            }, 500);
                    }, 8000);
                    });
                    // Form submission loading state
                    const forms = document.querySelectorAll('form');
                    forms.forEach(form => {
                    form.addEventListener('submit', function(e) {
                    const submitButton = form.querySelector('button[type="submit"]');
                            if (submitButton) {
                    const originalText = submitButton.innerHTML;
                            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                            submitButton.disabled = true;
                            // Re-enable after 5 seconds in case of error
                            setTimeout(() => {
                            submitButton.innerHTML = originalText;
                                    submitButton.disabled = false;
                            }, 5000);
                    }
                    });
        </script>