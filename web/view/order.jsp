<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Đơn hàng</title>
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
        </style>
    </head>
    <body>
        <h2>Danh sách đơn hàng</h2>
        <table>
            <tr>
                <th>Mã đơn</th>
                <th>Mã người dùng</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Địa chỉ giao</th>
                <th>Trạng thái</th>
                <th>Chi tiết</th>
            </tr>
            <% 
                List<Order> orders = (List<Order>) session.getAttribute("orders");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                if (orders != null && !orders.isEmpty()) {
                    for (Order order : orders) {
            %>
            <tr>
                <td><%= order.getOrderId() %></td>
                <td><%= order.getUserId() %></td>
                <td><%= dateFormat.format(order.getOrderDate()) %></td>
                <td><%= order.getTotalAmount() %></td>
                <td><%= order.getShippingAddress() %></td>
                <td><%= order.getStatus() != null ? order.getStatus() : "Chưa xác định" %></td>
                <td><a href="orderDetails.jsp?orderId=<%= order.getOrderId() %>">Xem chi tiết</a></td>
            </tr>
            <% 
                    }
                } else {
            %>
            <tr><td colspan="7">Không có đơn hàng</td></tr>
            <% } %>
        </table>
        <a href="CartServlet?action=viewCart">Quay lại giỏ hàng</a>
    </body>
</html>