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
                    List<CartDTO> carts = cartDAO.getCartByUserId(userId);
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
                    String shippingAddress = request.getParameter("shippingAddress");

                    if (totalAmount <= 0 || shippingAddress == null || shippingAddress.trim().isEmpty()) {
                        request.setAttribute("error", "Tổng tiền hoặc địa chỉ không hợp lệ.");
                        request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                        return;
                    }

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
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    if (quantity < 1) {
                        quantity = 1; // Không cho phép < 1
                    }
                    cartDAO.updateCartQuantity(cartId, quantity);
                } catch (Exception ignored) {
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
