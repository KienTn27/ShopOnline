<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Giỏ hàng</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid black;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .message {
                color: green;
            }
            .error {
                color: red;
            }
        </style>
    </head>
    <body>
        <h2>Giỏ hàng</h2>
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) { 
        %>
        <p class="error"><%= error %></p>
        <% } %>
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) { 
        %>
        <p class="message"><%= message %></p>
        <% } %>
        <table>
            <tr>
                <th>Mã giỏ</th>
                <th>Mã người dùng</th>
                <th>Mã sản phẩm</th>
                <th>Số lượng</th>
                <th>Ngày tạo</th>
            </tr>
            <% 
                List<Cart> carts = (List<Cart>) session.getAttribute("carts");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                if (carts != null && !carts.isEmpty()) {
                    for (Cart cart : carts) {
            %>
            <!-- Trong phần hiển thị bảng -->
            <tr>
                <td><%= cart.getCartId() %></td>
                <td><%= cart.getUserId() %></td>
                <td><%= cart.getProductId() %></td>
                <td><%= cart.getQuantity() %></td>
                <td><%= dateFormat.format(cart.getCreatedAt()) %></td>
                <td><a href="CartServlet?action=deleteCartItem&cartId=<%= cart.getCartId() %>" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a></td>
            </tr>
            <% 
                    }
                } else {
            %>
            <tr><td colspan="5">Giỏ hàng trống</td></tr>
            <% } %>
        </table>
        <form action="CartServlet" method="post">
            <input type="hidden" name="action" value="placeOrder">
            <label>Tổng tiền:</label><input type="text" name="totalAmount" required><br>
            <label>Địa chỉ giao hàng:</label><input type="text" name="shippingAddress" required><br>
            <input type="submit" value="Đặt hàng">
        </form>
    </body>
</html>