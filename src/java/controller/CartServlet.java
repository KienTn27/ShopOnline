package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartDTO;
import model.Order;

public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "viewCart";
        }

        switch (action) {
            case "viewCart" -> {
                try {
                    List<CartDTO> carts = cartDAO.getCartWithStockInfo(userId);
                    session.setAttribute("carts", carts);

                    double cartTotal = 0;
                    for (CartDTO cart : carts) {
                        cartTotal += cart.getPrice() * cart.getQuantity();
                    }
                    session.setAttribute("cartTotal", cartTotal);
                    response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                }
            }

            case "deleteCartItem" -> {
                try {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    cartDAO.deleteCartItem(cartId);
                } catch (Exception ignored) {
                }

                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
            }

            case "viewOrders" -> {
                try {
                    List<Order> orders = "Admin".equals(role)
                            ? orderDAO.getAllOrders()
                            : orderDAO.getOrdersByUserId(userId);
                    session.setAttribute("orders", orders);
                    response.sendRedirect(request.getContextPath() + "/view/order.jsp");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                }
            }

            case "viewOrderDetails" -> {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    Order order = orderDAO.getOrderById(orderId);

                    if (order == null || (!"Admin".equals(role) && order.getUserId() != userId)) {
                        response.sendRedirect(request.getContextPath() + "/view/accessDenied.jsp");
                        return;
                    }

                    OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                    session.setAttribute("orderDetails", orderDetailDAO.getOrderDetailViewsByOrderId(orderId));
                    response.sendRedirect(request.getContextPath() + "/view/orderDetail.jsp");

                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/view/order.jsp");
                }
            }

            default ->
                response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "placeOrder" -> {
                try {
                    double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
                    String city = request.getParameter("city");
                    String province = request.getParameter("province");
                    String district = request.getParameter("district");
                    String detail = request.getParameter("detailAddress");
                    if (totalAmount <= 0
                            || city == null || city.trim().isEmpty()
                            || province == null || province.trim().isEmpty()
                            || district == null || district.trim().isEmpty()
                            || detail == null || detail.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin địa chỉ.");
                        request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                        return;
                    }
                    String shippingAddress = detail + ", " + district + ", " + province + ", " + city;

                    orderDAO.createOrder(userId, totalAmount, shippingAddress);
                    cartDAO.clearCartByUserId(userId);
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");

                } catch (Exception e) {
                    request.setAttribute("error", "Lỗi đặt hàng.");
                    request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                }
            }

            case "updateOrderStatus" -> {
                if (!"Admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/view/accessDenied.jsp");
                    return;
                }
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    orderDAO.updateOrderStatus(orderId, status);
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/view/order.jsp");
                }
            }

            case "updatequantity" -> {
                try {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    String operation = request.getParameter("operation"); // "increase" hoặc "decrease"

                    System.out.println("Debug - CartID: " + cartId + ", Operation: " + operation);

                    // Lấy thông tin giỏ hàng hiện tại
                    List<CartDTO> currentCarts = cartDAO.getCartWithStockInfo(userId);
                    CartDTO currentCart = null;
                    for (CartDTO cart : currentCarts) {
                        if (cart.getCartId() == cartId) {
                            currentCart = cart;
                            break;
                        }
                    }

                    if (currentCart != null) {
                        int newQuantity = currentCart.getQuantity();

                        System.out.println("Debug - Current quantity: " + newQuantity + ", Stock: " + currentCart.getStockQuantity());

                        if ("increase".equals(operation)) {
                            newQuantity = Math.min(newQuantity + 1, currentCart.getStockQuantity());
                            System.out.println("Debug - After increase: " + newQuantity);
                        } else if ("decrease".equals(operation)) {
                            newQuantity = Math.max(newQuantity - 1, 1);
                            System.out.println("Debug - After decrease: " + newQuantity);
                        }

                        // Chỉ cập nhật nếu số lượng thay đổi
                        if (newQuantity != currentCart.getQuantity()) {
                            System.out.println("Debug - Updating quantity from " + currentCart.getQuantity() + " to " + newQuantity);
                            cartDAO.updateCartQuantity(cartId, newQuantity);

                            // Thêm thông báo nếu đạt giới hạn
                            if (newQuantity >= currentCart.getStockQuantity()) {
                                session.setAttribute("warningMessage", "Đã đạt giới hạn tồn kho cho sản phẩm: " + currentCart.getProductName());
                            }
                        } else {
                            System.out.println("Debug - No change in quantity");
                        }
                    } else {
                        System.out.println("Debug - Cart not found for ID: " + cartId);
                    }
                } catch (Exception e) {
                    System.err.println("Error in updatequantity: " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật số lượng: " + e.getMessage());
                }

                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
            }

            default ->
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý giỏ hàng và đơn hàng.";
    }
}
