<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Order Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-4">
            <h2>Order List</h2>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>User ID</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Update</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td>${order.userId}</td>
                            <td>${order.orderDate}</td>
                            <td>${order.totalAmount}</td>
                            <td>${order.status}</td>
                            <td>
                                <form action="UpdateStatusServlet" method="post" class="d-flex">
                                    <input type="hidden" name="orderId" value="${order.orderId}" />
                                    <select name="status" class="form-select form-select-sm me-1">
                                        <option ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                        <option ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                        <option ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                        <option ${order.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                        <option ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
