<%@page import="model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@page import="dao.OrderDetailDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Chi tiết đơn hàng</h2>
    <% 
        // Lấy OrderId từ request (giả sử truyền qua tham số)
        Integer orderId = null;
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
        } catch (NumberFormatException e) {
            out.println("<p style='color: red;'>OrderId không hợp lệ!</p>");
            return;
        }

        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
        DecimalFormat df = new DecimalFormat("#,##0.00"); // Định dạng tiền tệ
    %>
    <table>
        <tr>
            <th>Mã chi tiết</th>
            <th>Mã đơn hàng</th>
            <th>Mã sản phẩm</th>
            <th>Số lượng</th>
            <th>Đơn giá</th>
            <th>Thành tiền</th>
        </tr>
        <% 
            if (orderDetails != null && !orderDetails.isEmpty()) {
                for (OrderDetail detail : orderDetails) {
        %>
            <tr>
                <td><%= detail.getOrderDetailId() %></td>
                <td><%= detail.getOrderId() %></td>
                <td><%= detail.getProductId() %></td>
                <td><%= detail.getQuantity() %></td>
                <td><%= df.format(detail.getUnitPrice()) %> VND</td>
                <td><%= df.format(detail.getTotalPrice()) %> VND</td>
            </tr>
        <% 
                }
            } else {
        %>
            <tr><td colspan="6">Không có chi tiết đơn hàng</td></tr>
        <% } %>
    </table>
    <a href="CartServlet?action=viewOrders">Quay lại danh sách đơn hàng</a>
</body>
</html>
