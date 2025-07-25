<%@page import="model.OrderDetailView"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@page import="dao.OrderDetailDAO"%>
<%@page import="dao.OrderDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="dao.ReviewDAO" %>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #4f46e5;
                --primary-hover: #4338ca;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --info-color: #06b6d4;
                --dark-color: #1f2937;
                --light-bg: #f8fafc;
                --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                --border-radius: 12px;
            }

            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .admin-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                padding: 1.5rem 0;
                margin-bottom: 2rem;
                box-shadow: var(--card-shadow);
            }

            .admin-title {
                color: var(--dark-color);
                font-weight: 700;
                font-size: 2rem;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .admin-title i {
                color: var(--primary-color);
                font-size: 1.8rem;
            }

            .order-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: var(--border-radius);
                box-shadow: var(--card-shadow);
                border: 1px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .order-header {
                background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
                color: white;
                padding: 1.5rem;
                margin: 0;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .order-summary {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1.5rem;
                padding: 1.5rem;
                background: var(--light-bg);
            }

            .summary-item {
                background: white;
                padding: 1rem;
                border-radius: 8px;
                text-align: center;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .summary-item i {
                font-size: 1.5rem;
                color: var(--primary-color);
                margin-bottom: 0.5rem;
            }

            .summary-item .label {
                display: block;
                font-size: 0.8rem;
                color: #6b7280;
                margin-bottom: 0.3rem;
            }

            .summary-item .value {
                display: block;
                font-size: 1.2rem;
                font-weight: 700;
                color: var(--dark-color);
            }

            .order-items-section {
                padding: 1.5rem;
            }

            .order-items-section h3 {
                color: var(--dark-color);
                font-size: 1.3rem;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .order-item-card {
                background: white;
                border-radius: 12px;
                margin-bottom: 1rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                transition: transform 0.2s ease;
            }

            .order-item-card:hover {
                transform: translateY(-2px);
            }

            .product-main {
                display: flex;
                padding: 1.5rem;
                gap: 1.5rem;
                align-items: center;
            }

            .product-image {
                position: relative;
                flex-shrink: 0;
            }

            .product-image img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid #e5e7eb;
            }

            .quantity-badge {
                position: absolute;
                top: -8px;
                right: -8px;
                background: var(--danger-color);
                color: white;
                border-radius: 50%;
                width: 25px;
                height: 25px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.7rem;
                font-weight: bold;
            }

            .product-details {
                flex: 1;
            }

            .product-name {
                font-size: 1.2rem;
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 0.8rem;
            }

            .product-variants {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                margin-bottom: 0.8rem;
            }

            .variant-badge {
                background: #ecf0f1;
                color: #34495e;
                padding: 0.3rem 0.6rem;
                border-radius: 15px;
                font-size: 0.7rem;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 0.3rem;
            }

            .size-badge {
                background: linear-gradient(135deg, #f39c12, #e67e22);
                color: white;
            }

            .color-badge {
                background: linear-gradient(135deg, #3498db, #2980b9);
                color: white;
            }

            .product-pricing {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .price-info {
                display: flex;
                gap: 1rem;
                align-items: center;
            }

            .unit-price, .quantity {
                display: flex;
                align-items: center;
                gap: 0.3rem;
                color: #6b7280;
                font-size: 0.9rem;
            }

            .total-price {
                text-align: right;
            }

            .total-label {
                display: block;
                font-size: 0.8rem;
                color: #6b7280;
                margin-bottom: 0.2rem;
            }

            .total-price strong {
                font-size: 1.2rem;
                color: var(--danger-color);
            }

            .review-section {
                background: #f8f9fa;
                border-top: 1px solid #ecf0f1;
                padding: 2rem;
            }

            .review-header {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1.5rem;
                font-weight: 600;
                color: #2c3e50;
                font-size: 1.1rem;
            }

            .review-header i {
                color: #f39c12;
            }

            .rating-container {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                gap: 0.2rem;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                cursor: pointer;
                font-size: 1.8rem;
                color: #ddd;
                transition: all 0.2s ease;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #f39c12;
                transform: scale(1.1);
            }

            .star-rating input[type="radio"]:checked ~ label {
                color: #f39c12;
            }

            .rating-text {
                color: #7f8c8d;
                font-size: 0.9rem;
            }

            .comment-container textarea {
                width: 100%;
                min-height: 100px;
                padding: 1rem;
                border: 2px solid #ecf0f1;
                border-radius: 10px;
                font-family: inherit;
                font-size: 0.95rem;
                resize: vertical;
                transition: border-color 0.3s ease;
                margin-bottom: 1rem;
            }

            .comment-container textarea:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .submit-review-btn {
                background: linear-gradient(45deg, #3498db, #2980b9);
                color: white;
                border: none;
                padding: 0.8rem 2rem;
                border-radius: 25px;
                font-size: 0.95rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .submit-review-btn:hover {
                background: linear-gradient(45deg, #2980b9, #21618c);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
            }

            .action-buttons {
                padding: 1.5rem;
                text-align: center;
                background: var(--light-bg);
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.2s ease;
            }

            .btn-secondary {
                background: #6b7280;
                color: white;
            }

            .btn-secondary:hover {
                background: #4b5563;
                color: white;
            }

            /* Order Status Section */
            .order-status-section {
                margin-bottom: 2rem;
            }

            .status-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                padding: 1.5rem;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .status-header {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1rem;
                font-weight: 600;
                color: var(--dark-color);
                font-size: 1.1rem;
            }

            .status-header i {
                color: var(--primary-color);
            }

            .status-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .status-badge {
                padding: 0.75rem 1.5rem;
                border-radius: 25px;
                font-weight: 600;
                font-size: 0.9rem;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-pending {
                background: #fef3c7;
                color: #92400e;
            }

            .status-processing {
                background: #dbeafe;
                color: #1e40af;
            }

            .status-shipped {
                background: #d1fae5;
                color: #065f46;
            }

            .status-delivered {
                background: #dcfce7;
                color: #166534;
            }

            .status-cancelled {
                background: #fee2e2;
                color: #991b1b;
            }

            .order-info {
                color: #6b7280;
                font-size: 0.9rem;
            }

            .order-info p {
                margin-bottom: 0.3rem;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="admin-header">
            <div class="container">
                <h1 class="admin-title">
                    <i class="fas fa-receipt"></i>
                    Chi tiết đơn hàng
                </h1>
            </div>
        </div>

        <div class="container">
            <%
                Integer orderId = null;
                try {
                    orderId = Integer.parseInt(request.getParameter("orderId"));
                } catch (NumberFormatException e) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle'></i> OrderId không hợp lệ!</div>");
                    return;
                }

                OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                OrderDAO orderDAO = new OrderDAO();
                List<OrderDetailView> orderDetails = orderDetailDAO.getOrderDetailViewsByOrderId(orderId);
                Order order = orderDAO.getOrderById(orderId);
                DecimalFormat df = new DecimalFormat("#,##0");
                
                double totalOrderAmount = 0;
                if (orderDetails != null && !orderDetails.isEmpty()) {
                    for (OrderDetailView detail : orderDetails) {
                        totalOrderAmount += detail.getTotalPrice();
                    }
                }
                
                // Hiển thị thông báo thành công/lỗi
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
            %>

            <% if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="alert alert-success" style="margin-bottom: 20px; border-radius: 10px; padding: 15px; background: #d4edda; border: 1px solid #c3e6cb; color: #155724;">
                <i class="fas fa-check-circle"></i>
                <%= successMessage %>
            </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger" style="margin-bottom: 20px; border-radius: 10px; padding: 15px; background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24;">
                <i class="fas fa-exclamation-triangle"></i>
                <%= errorMessage %>
            </div>
            <% } %>

            <div class="order-container">
                <h3 class="order-header">
                    <i class="fas fa-box"></i>
                    Thông tin đơn hàng
                </h3>

                <!-- Order Status Section -->
                <% if (order != null) { %>
                <div class="order-status-section">
                    <div class="status-card">
                        <div class="status-header">
                            <i class="fas fa-info-circle"></i>
                            <span>Trạng thái đơn hàng</span>
                        </div>
                        <div class="status-content">
                            <div class="status-badge status-<%= order.getStatus().toLowerCase() %>">
                                <% if ("Pending".equals(order.getStatus())) { %>
                                <i class="fas fa-clock"></i> Chờ xác nhận
                                <% } else if ("Processing".equals(order.getStatus())) { %>
                                <i class="fas fa-spinner"></i> Đang xử lý
                                <% } else if ("Shipped".equals(order.getStatus())) { %>
                                <i class="fas fa-truck"></i> Đang giao hàng
                                <% } else if ("Delivered".equals(order.getStatus())) { %>
                                <i class="fas fa-check-circle"></i> Đã giao hàng
                                <% } else if ("Cancelled".equals(order.getStatus())) { %>
                                <i class="fas fa-times-circle"></i> Đã hủy
                                <% } else { %>
                                <i class="fas fa-question-circle"></i> <%= order.getStatus() %>
                                <% } %>
                            </div>
                            <div class="order-info">
                                <p><strong>Ngày đặt:</strong> <%= order.getOrderDate() %></p>
                                <p><strong>Địa chỉ giao:</strong> <%= order.getShippingAddress() %></p>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <div class="order-summary">
                    <div class="summary-item">
                        <i class="fas fa-shopping-bag"></i>
                        <div>
                            <span class="label">Số sản phẩm</span>
                            <span class="value"><%= orderDetails != null ? orderDetails.size() : 0 %></span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <i class="fas fa-money-bill-wave"></i>
                        <div>
                            <span class="label">Tổng tiền</span>
                            <span class="value"><%= df.format(totalOrderAmount) %>₫</span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <i class="fas fa-calendar"></i>
                        <div>
                            <span class="label">Mã đơn hàng</span>
                            <span class="value">#<%= orderId %></span>
                        </div>
                    </div>
                </div>

                <div class="order-items-section">
                    <h3><i class="fas fa-box"></i> Sản phẩm trong đơn hàng</h3>

                    <%
                        User currentUser = (User) session.getAttribute("user");
                        int currentUserId = currentUser != null ? currentUser.getUserId() : -1;
                        ReviewDAO reviewDAO = new ReviewDAO();
                    %>
                    <% if (order != null && !orderDetails.isEmpty()) {
                        for (OrderDetailView detail : orderDetails) {
                            String imageUrl = detail.getImageUrl();
                            String finalImageUrl;
                            if (imageUrl != null && !imageUrl.isEmpty()) {
                                if (imageUrl.startsWith("http")) {
                                    finalImageUrl = imageUrl;
                                } else {
                                    finalImageUrl = request.getContextPath() + "/" + imageUrl;
                                }
                            } else {
                                finalImageUrl = request.getContextPath() + "/images/no-image.png";
                            }
                    %>
                    <div class="order-item-card">
                        <div class="product-main">
                            <div class="product-image">
                                <img src="<%= finalImageUrl %>" alt="<%= detail.getProductName() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/no-image.png'">  
                                <div class="quantity-badge"><%= detail.getQuantity() %></div>
                            </div>
                            <div class="product-details">
                                <h4 class="product-name"><%= detail.getProductName() %></h4>

                                <!-- Hiển thị Size và Color -->
                                <div class="product-variants">
                                    <% if (detail.getSize() != null && !detail.getSize().trim().isEmpty()) { %>
                                    <span class="variant-badge size-badge">
                                        <i class="fas fa-ruler"></i>
                                        Size: <%= detail.getSize() %>
                                    </span>
                                    <% } %>
                                    <% if (detail.getColor() != null && !detail.getColor().trim().isEmpty()) { %>
                                    <span class="variant-badge color-badge">
                                        <i class="fas fa-palette"></i>
                                        Màu: <%= detail.getColor() %>
                                    </span>
                                    <% } %>
                                </div>

                                <div class="product-pricing">
                                    <div class="price-info">
                                        <span class="unit-price">
                                            <i class="fas fa-tag"></i> 
                                            <%= df.format(detail.getUnitPrice()) %>₫
                                        </span>
                                        <span class="quantity">
                                            <i class="fas fa-times"></i> 
                                            <%= detail.getQuantity() %>
                                        </span>
                                    </div>
                                    <div class="total-price">
                                        <span class="total-label">Thành tiền:</span>
                                        <strong><%= df.format(detail.getTotalPrice()) %>₫</strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% if (order != null && "Delivered".equals(order.getStatus())) { 
                        boolean hasReviewed = reviewDAO.hasUserReviewedProduct(currentUserId, detail.getProductId());
                        if (hasReviewed) { %>
                    <div class="review-section" style="background: #f8f9fa; border-top: 1px solid #ecf0f1; padding: 1.5rem; text-align: center;">
                        <div style="color: #28a745; font-size: 1.1rem;">
                            <i class="fas fa-check-circle"></i>
                            Bạn đã đánh giá sản phẩm này rồi.
                        </div>
                    </div>
                    <% } else { %>
                    <div class="review-section">
                        <div class="review-header">
                            <i class="fas fa-star"></i>
                            <span>Đánh giá sản phẩm</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/ReviewServlet" method="post" class="review-form">
                            <input type="hidden" name="productId" value="<%= detail.getProductId() %>">
                            <input type="hidden" name="orderId" value="<%= detail.getOrderId() %>">
                            <div class="rating-container">
                                <div class="star-rating">
                                    <% for (int i = 5; i >= 1; i--) { %>
                                    <input type="radio" id="star<%= i %>-<%= detail.getProductId() %>" 
                                           name="rating" value="<%= i %>" required>
                                    <label for="star<%= i %>-<%= detail.getProductId() %>">
                                        <i class="fas fa-star"></i>
                                    </label>
                                    <% } %>
                                </div>
                                <span class="rating-text">Chọn số sao</span>
                            </div>
                            <div class="comment-container">
                                <textarea name="comment" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm..." required></textarea>
                            </div>
                            <button type="submit" class="submit-review-btn">
                                <i class="fas fa-paper-plane"></i>
                                Gửi đánh giá
                            </button>
                        </form>
                    </div>
                    <% } 
                    } else if (order != null && !"Delivered".equals(order.getStatus())) { %>
                    <div class="review-section" style="background: #f8f9fa; border-top: 1px solid #ecf0f1; padding: 1.5rem; text-align: center;">
                        <div style="color: #6c757d; font-size: 0.9rem;">
                            <i class="fas fa-info-circle"></i>
                            <span>Bạn chỉ có thể đánh giá sản phẩm sau khi đơn hàng đã được giao thành công.</span>
                        </div>
                    </div>
                    <% } %>
                    <%  }
                   } else { %>
                    <div class="no-items">
                        <i class="fas fa-inbox"></i>
                        <h3>Không có sản phẩm nào</h3>
                        <p>Đơn hàng này không có chi tiết sản phẩm.</p>
                    </div>
                    <% } %>
                </div>
            </div>


            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/view/order.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại danh sách
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 