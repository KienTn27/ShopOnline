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
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "viewCart";
        }

        if ("viewCart".equals(action)) {
            try {
                List<CartDTO> carts = cartDAO.getCartByUserId(userId);
                session.setAttribute("carts", carts);

                double cartTotal = 0;
                if (carts != null) {
                    for (CartDTO cart : carts) {
                        cartTotal += cart.getPrice() * cart.getQuantity();
                    }
                }
                session.setAttribute("cartTotal", cartTotal);

                response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi tải giỏ hàng: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/HomeServlet");
            }
        } else if ("deleteCartItem".equals(action)) {
            int cartId;
            try {
                cartId = Integer.parseInt(request.getParameter("cartId"));
                cartDAO.deleteCartItem(cartId);
                List<CartDTO> carts = cartDAO.getCartByUserId(userId);
                session.setAttribute("carts", carts);

                double cartTotal = 0;
                if (carts != null) {
                    for (CartDTO cart : carts) {
                        cartTotal += cart.getPrice() * cart.getQuantity();
                    }
                }
                session.setAttribute("cartTotal", cartTotal);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "CartId không hợp lệ!");
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi xóa mục giỏ hàng: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
        }
        if ("viewOrders".equals(action)) {
            try {
                String statusFilter = request.getParameter("statusFilter");
                List<Order> orders;
                if ("Admin".equals(role)) {
                    if (statusFilter != null && !statusFilter.isEmpty()) {
                        orders = orderDAO.getOrdersByStatus(statusFilter);
                    } else {
                        orders = orderDAO.getAllOrders();
                    }
                } else {
                    orders = orderDAO.getOrdersByUserId(userId);
                }
                session.setAttribute("orders", orders);
                response.sendRedirect(request.getContextPath() + "/view/order.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi lấy danh sách đơn hàng: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/HomeServlet");
            }
        } else if ("viewOrderDetails".equals(action)) {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "OrderId không hợp lệ!");
                request.getRequestDispatcher("view/order.jsp").forward(request, response);
                return;
            }
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("error", "Đơn hàng không tồn tại!");
                request.getRequestDispatcher("view/order.jsp").forward(request, response);
                return;
            }
            if (!"Admin".equals(role) && order.getUserId() != userId) {
                request.setAttribute("error", "Bạn không có quyền xem chi tiết đơn hàng này!");
                request.getRequestDispatcher("view/accessDenied.jsp").forward(request, response);
                return;
            }
            OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
            session.setAttribute("orderDetails", orderDetailDAO.getOrderDetailsByOrderId(orderId));
            response.sendRedirect(request.getContextPath() + "/view/orderDetails.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");

        if ("placeOrder".equals(action)) {
            try {
                double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
                String shippingAddress = request.getParameter("shippingAddress");
                if (totalAmount <= 0 || shippingAddress == null || shippingAddress.trim().isEmpty()) {
                    request.setAttribute("error", "Tổng tiền hoặc địa chỉ giao hàng không hợp lệ!");
                    request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                    return;
                }
                orderDAO.createOrder(userId, totalAmount, shippingAddress);
                cartDAO.clearCartByUserId(userId);
                request.setAttribute("message", "Đặt hàng thành công!");
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Định dạng tổng tiền không hợp lệ!");
                request.getRequestDispatcher("view/cart.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi đặt hàng: " + e.getMessage());
                request.getRequestDispatcher("view/cart.jsp").forward(request, response);
            }
        } else if ("updateOrderStatus".equals(action)) {
            if (!"Admin".equals(role)) {
                request.setAttribute("error", "Bạn không có quyền cập nhật trạng thái đơn hàng!");
                request.getRequestDispatcher("view/accessDenied.jsp").forward(request, response);
                return;
            }
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                orderDAO.updateOrderStatus(orderId, status);
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "OrderId không hợp lệ!");
                request.getRequestDispatcher("view/order.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
                request.getRequestDispatcher("view/order.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý giỏ hàng và đơn hàng.";
    }
}
