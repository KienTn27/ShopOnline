<%@page import="model.OrderDetailView"%>
<%@page import="java.util.List"%>
<%@page import="dao.OrderDetailDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderDetail.css">
    </head>
    <body>
        <div class="container">
            <h2>Chi tiết đơn hàng</h2>

            <%
                Integer orderId = null;
                try {
                    orderId = Integer.parseInt(request.getParameter("orderId"));
                } catch (NumberFormatException e) {
                    out.println("<p class='error'>OrderId không hợp lệ!</p>");
                    return;
                }

                OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                List<OrderDetailView> orderDetails = orderDetailDAO.getOrderDetailViewsByOrderId(orderId);
                DecimalFormat df = new DecimalFormat("#,##0.00");
            %>

            <div class="order-items">
                <%
                    if (orderDetails != null && !orderDetails.isEmpty()) {
                        for (OrderDetailView detail : orderDetails) {
                %>
                <div class="order-item">
                    <div class="product-image">
                        <img src="<%= detail.getImageUrl() %>" alt="Ảnh sản phẩm">
                    </div>
                    <div class="product-info">
                        <div class="product-name"><%= detail.getProductName() %></div>
                        <div class="product-meta">
                            <span>Số lượng: <%= detail.getQuantity() %></span> |
                            <span>Đơn giá: <%= df.format(detail.getUnitPrice()) %>₫</span> |
                            <span class="total-price">Thành tiền: <strong><%= df.format(detail.getTotalPrice()) %>₫</strong></span>
                        </div>
                    </div>
                </div>

                <!-- PHẦN ĐÁNH GIÁ -->
                <div class="review-section">
                    <form action="ReviewServlet" method="post">
                        <input type="hidden" name="productId" value="<%= detail.getProductId() %>">
                        <input type="hidden" name="orderId" value="<%= detail.getOrderId() %>">
                        <div class="star-rating">
                            <label>Đánh giá:</label>
                            <% for (int i = 1; i <= 5; i++) { %>
                            <input type="radio" id="star<%= i %>-<%= detail.getProductId() %>" name="rating-<%= detail.getProductId() %>" value="<%= i %>" required>
                            <label for="star<%= i %>-<%= detail.getProductId() %>">★</label>
                            <% } %>
                        </div>
                        <textarea name="comment" placeholder="Viết đánh giá..." required></textarea>
                        <button type="submit">Gửi đánh giá</button>
                    </form>
                </div>
                <%  }
                   } else {
                %>
                <p class="no-items">Không có chi tiết đơn hàng.</p>
                <% } %>
            </div>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders">← Quay lại danh sách đơn hàng</a>
            </div>
        </div>
    </body>
</html>
