<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipper Dashboard - Quản lý đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2f80ed;
            --primary-hover: #1e6fd9;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .shipper-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            margin: 20px;
            overflow: hidden;
        }

        .shipper-header {
            background: linear-gradient(135deg, var(--primary-color), #56ccf2);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .shipper-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .shipper-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 30px;
            background: var(--light-color);
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            color: #6c757d;
            font-weight: 500;
        }

        .orders-section {
            padding: 30px;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .order-card {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .order-card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 10px 25px rgba(47, 128, 237, 0.15);
        }

        .order-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .order-id {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .order-date {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .status-processing {
            background: #fff3cd;
            color: #856404;
        }

        .status-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-delivered {
            background: #d4edda;
            color: #155724;
        }

        .customer-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .customer-name {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 5px;
        }

        .customer-contact {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .product-list {
            margin-bottom: 20px;
        }

        .product-item {
            background: white;
            padding: 10px 15px;
            border-radius: 8px;
            border-left: 4px solid var(--primary-color);
            margin-bottom: 8px;
        }

        .total-amount {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--success-color);
            text-align: right;
        }

        .update-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-top: 15px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 5px;
        }

        .status-select {
            width: 100%;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .status-select:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(47, 128, 237, 0.1);
        }

        .note-input {
            width: 100%;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            resize: vertical;
            min-height: 80px;
        }

        .btn-update {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-update:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(47, 128, 237, 0.3);
            color: white;
        }

        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .no-orders {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .no-orders i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        .loading-spinner {
            display: none;
            margin-left: 8px;
        }

        .form-updating .loading-spinner {
            display: inline-block;
        }

        .form-updating .btn-update {
            opacity: 0.7;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .shipper-container {
                margin: 10px;
            }

            .shipper-title {
                font-size: 2rem;
            }

            .stats-cards {
                grid-template-columns: 1fr;
                padding: 20px;
            }

            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .update-form {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="shipper-container">
        <!-- Header -->
        <div class="shipper-header">
            <h1 class="shipper-title">
                <i class="fas fa-truck"></i>
                Shipper Dashboard
            </h1>
            <p class="shipper-subtitle">Quản lý đơn hàng và cập nhật trạng thái giao hàng</p>
        </div>

        <!-- Stats Cards -->
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-icon text-primary">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-number">${orders.size()}</div>
                <div class="stat-label">Tổng đơn hàng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon text-warning">
                    <i class="fas fa-spinner"></i>
                </div>
                <div class="stat-number">
                    <c:set var="processingCount" value="0" />
                    <c:forEach var="order" items="${orders}">
                        <c:if test="${order.status == 'Processing'}">
                            <c:set var="processingCount" value="${processingCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${processingCount}
                </div>
                <div class="stat-label">Chờ lấy hàng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon text-info">
                    <i class="fas fa-shipping-fast"></i>
                </div>
                <div class="stat-number">
                    <c:set var="shippedCount" value="0" />
                    <c:forEach var="order" items="${orders}">
                        <c:if test="${order.status == 'Shipped'}">
                            <c:set var="shippedCount" value="${shippedCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${shippedCount}
                </div>
                <div class="stat-label">Đang giao hàng</div>
            </div>
        </div>

        <!-- Orders Section -->
        <div class="orders-section">
            <h2 class="section-title">
                <i class="fas fa-list"></i>
                Danh sách đơn hàng cần giao
            </h2>

            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="no-orders">
                        <i class="fas fa-box-open"></i>
                        <h3>Không có đơn hàng nào cần giao</h3>
                        <p>Tất cả đơn hàng đã được xử lý hoặc chưa có đơn hàng mới.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <div class="order-id">#${order.orderId}</div>
                                    <div class="order-date">
                                        <i class="fas fa-calendar"></i>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <span class="status-badge status-${order.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${order.status == 'Processing'}">
                                            <i class="fas fa-spinner"></i>Chờ lấy hàng
                                        </c:when>
                                        <c:when test="${order.status == 'Shipped'}">
                                            <i class="fas fa-truck"></i>Đang giao hàng
                                        </c:when>
                                        <c:when test="${order.status == 'Delivered'}">
                                            <i class="fas fa-check-circle"></i>Đã giao
                                        </c:when>
                                    </c:choose>
                                </span>
                            </div>

                            <!-- Customer Information -->
                            <div class="customer-info">
                                <div class="customer-name">
                                    <i class="fas fa-user"></i>
                                    ${order.customerName}
                                </div>
                                <div class="customer-contact">
                                    <i class="fas fa-phone"></i>
                                    ${order.customerPhone} | 
                                    <i class="fas fa-envelope"></i>
                                    ${order.customerEmail}
                                </div>
                                <div class="customer-contact mt-2">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}
                                </div>
                            </div>

                            <!-- Products -->
                            <div class="product-list">
                                <h6><i class="fas fa-box"></i> Sản phẩm:</h6>
                                <div class="product-item">
                                    ${order.productNames}
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/staff/shipper-orderDetail.jsp?orderId=${order.orderId}" 
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i>
                                            Xem chi tiết sản phẩm
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="total-amount">
                                <i class="fas fa-money-bill-wave"></i>
                                Tổng tiền: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ" groupingUsed="true" maxFractionDigits="0"/>
                            </div>

                            <!-- Update Form -->
                            <div class="update-form">
                                <form action="${pageContext.request.contextPath}/shipper-order" method="post" onsubmit="showLoading(this)">
                                    <input type="hidden" name="orderId" value="${order.orderId}" />
                                    
                                    <div class="form-group">
                                        <label class="form-label">Cập nhật trạng thái:</label>
                                        <select name="status" class="status-select" required>
                                            <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Chờ lấy hàng</option>
                                            <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Đang giao hàng</option>
                                            <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Đã giao</option>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn-update">
                                        <i class="fas fa-sync-alt"></i>
                                        Cập nhật trạng thái
                                        <div class="loading-spinner">
                                            <i class="fas fa-spinner fa-spin"></i>
                                        </div>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showLoading(form) {
            form.classList.add('form-updating');
            const button = form.querySelector('.btn-update');
            button.disabled = true;
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html> 