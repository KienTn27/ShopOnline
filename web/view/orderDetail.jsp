<%@page import="model.OrderDetailView"%>
<%@page import="java.util.List"%>
<%@page import="dao.OrderDetailDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderDetail.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="page-wrapper">
            <!-- Header Section -->
            <div class="header-section">
                <div class="container">
                    <div class="header-content">
                        <h1><i class="fas fa-receipt"></i> Chi tiết đơn hàng #<%= request.getParameter("orderId") %></h1>
                        <div class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders">
                                <i class="fas fa-list"></i> Danh sách đơn hàng
                            </a>
                            <span><i class="fas fa-chevron-right"></i></span>
                            <span>Chi tiết đơn hàng</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="container">
                <%
                    Integer orderId = null;
                    try {
                        orderId = Integer.parseInt(request.getParameter("orderId"));
                    } catch (NumberFormatException e) {
                        out.println("<div class='error-message'><i class='fas fa-exclamation-triangle'></i> OrderId không hợp lệ!</div>");
                        return;
                    }

                    OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                    List<OrderDetailView> orderDetails = orderDetailDAO.getOrderDetailViewsByOrderId(orderId);
                    DecimalFormat df = new DecimalFormat("#,##0");
                    
                    double totalOrderAmount = 0;
                    if (orderDetails != null && !orderDetails.isEmpty()) {
                        for (OrderDetailView detail : orderDetails) {
                            totalOrderAmount += detail.getTotalPrice();
                        }
                    }
                %>

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
                            <span class="value total-amount"><%= df.format(totalOrderAmount) %>₫</span>
                        </div>
                    </div>
                </div>

                <div class="order-items-section">
                    <h3><i class="fas fa-box"></i> Sản phẩm trong đơn hàng</h3>

                    <div class="order-items">
                        <%
                            if (orderDetails != null && !orderDetails.isEmpty()) {
                                for (OrderDetailView detail : orderDetails) {
                        %>
                        <div class="order-item-card">
                            <div class="product-main">
                                <div class="product-image">
                                    <img src="<%= detail.getImageUrl() %>" alt="<%= detail.getProductName() %>" 
                                         onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0zNSAzNUg2NVY2NUgzNVYzNVoiIGZpbGw9IiNEREREREQiLz4KPC9zdmc+'">
                                    <div class="quantity-badge"><%= detail.getQuantity() %></div>
                                </div>
                                <div class="product-details">
                                    <h4 class="product-name"><%= detail.getProductName() %></h4>
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

                            <!-- Review Section -->
                            <div class="review-section">
                                <div class="review-header">
                                    <i class="fas fa-star"></i>
                                    <span>Đánh giá sản phẩm</span>
                                </div>
                                <form action="ReviewServlet" method="post" class="review-form">
                                    <input type="hidden" name="productId" value="<%= detail.getProductId() %>">
                                    <input type="hidden" name="orderId" value="<%= detail.getOrderId() %>">

                                    <div class="rating-container">
                                        <div class="star-rating">
                                            <% for (int i = 5; i >= 1; i--) { %>
                                            <input type="radio" id="star<%= i %>-<%= detail.getProductId() %>" 
                                                   name="rating-<%= detail.getProductId() %>" value="<%= i %>" required>
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
                        </div>
                        <%  }
                           } else {
                        %>
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
                    <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                </div>
            </div>
        </div>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            .page-wrapper {
                min-height: 100vh;
                background: rgba(255, 255, 255, 0.1);
            }

            .header-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
                padding: 2rem 0;
                margin-bottom: 2rem;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            .header-content h1 {
                color: #2c3e50;
                font-size: 2.2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .header-content h1 i {
                color: #e74c3c;
            }

            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                color: #7f8c8d;
                font-size: 0.9rem;
            }

            .breadcrumb a {
                color: #3498db;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 0.3rem;
                transition: color 0.3s ease;
            }

            .breadcrumb a:hover {
                color: #2980b9;
            }

            .order-summary {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .summary-item {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 1.5rem;
                border-radius: 15px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 1rem;
                transition: transform 0.3s ease;
            }

            .summary-item:hover {
                transform: translateY(-5px);
            }

            .summary-item i {
                font-size: 2rem;
                color: #3498db;
                width: 50px;
                text-align: center;
            }

            .summary-item .label {
                display: block;
                font-size: 0.9rem;
                color: #7f8c8d;
                margin-bottom: 0.3rem;
            }

            .summary-item .value {
                display: block;
                font-size: 1.3rem;
                font-weight: 700;
                color: #2c3e50;
            }

            .total-amount {
                color: #e74c3c !important;
            }

            .order-items-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 2rem;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }

            .order-items-section h3 {
                color: #2c3e50;
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .order-items-section h3 i {
                color: #f39c12;
            }

            .order-item-card {
                background: #fff;
                border-radius: 15px;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .order-item-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
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
                width: 120px;
                height: 120px;
                object-fit: cover;
                border-radius: 12px;
                border: 3px solid #ecf0f1;
                transition: transform 0.3s ease;
            }

            .product-image:hover img {
                transform: scale(1.05);
            }

            .quantity-badge {
                position: absolute;
                top: -8px;
                right: -8px;
                background: #e74c3c;
                color: white;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                font-weight: bold;
                box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);
            }

            .product-details {
                flex: 1;
            }

            .product-name {
                font-size: 1.3rem;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 1rem;
                line-height: 1.4;
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
                gap: 1.5rem;
                align-items: center;
            }

            .unit-price, .quantity {
                display: flex;
                align-items: center;
                gap: 0.3rem;
                color: #7f8c8d;
                font-size: 0.95rem;
            }

            .unit-price i, .quantity i {
                color: #95a5a6;
            }

            .total-price {
                text-align: right;
            }

            .total-label {
                display: block;
                font-size: 0.85rem;
                color: #7f8c8d;
                margin-bottom: 0.2rem;
            }

            .total-price strong {
                font-size: 1.4rem;
                color: #e74c3c;
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

            .no-items {
                text-align: center;
                padding: 4rem 2rem;
                color: #7f8c8d;
            }

            .no-items i {
                font-size: 4rem;
                margin-bottom: 1rem;
                color: #bdc3c7;
            }

            .no-items h3 {
                margin-bottom: 0.5rem;
                color: #95a5a6;
            }

            .action-buttons {
                text-align: center;
                padding: 2rem 0;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 1rem 2rem;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 1rem;
            }

            .btn-secondary {
                background: rgba(255, 255, 255, 0.9);
                color: #2c3e50;
                backdrop-filter: blur(10px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .btn-secondary:hover {
                background: rgba(255, 255, 255, 1);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            }

            .error-message {
                background: #e74c3c;
                color: white;
                padding: 1rem;
                border-radius: 10px;
                margin: 2rem 0;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header-content h1 {
                    font-size: 1.8rem;
                }

                .product-main {
                    flex-direction: column;
                    text-align: center;
                }

                .product-pricing {
                    flex-direction: column;
                    align-items: center;
                    gap: 0.5rem;
                }

                .price-info {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .rating-container {
                    flex-direction: column;
                    align-items: center;
                    gap: 0.5rem;
                }

                .container {
                    padding: 0 0.5rem;
                }
            }
        </style>
    </body>
</html>