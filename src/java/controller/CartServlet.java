/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Order;
import model.User;

/**
 *
 * @author X1 carbon Gen6
 */
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("viewCart".equals(action)) {
            session.setAttribute("carts", cartDAO.getCartByUserId(user.getUserId()));
            response.sendRedirect("view/cart.jsp");
        } else if ("deleteCartItem".equals(action)) {
            int cartId;
            try {
                cartId = Integer.parseInt(request.getParameter("cartId"));
                cartDAO.deleteCartItem(cartId);
                session.setAttribute("carts", cartDAO.getCartByUserId(user.getUserId()));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "CartId không hợp lệ!");
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi xóa mục giỏ hàng: " + e.getMessage());
            }
            response.sendRedirect("view/cart.jsp");
        } else if ("viewOrders".equals(action)) {
            String statusFilter = request.getParameter("statusFilter");
            List<Order> orders;
            if ("Admin".equals(user.getRole())) {
                // Admin có thể xem tất cả đơn hàng
                if (statusFilter != null && !statusFilter.isEmpty()) {
                    orders = orderDAO.getOrdersByStatus(statusFilter);
                } else {
                    orders = orderDAO.getAllOrders();
                }
            } else {
                // User chỉ xem đơn hàng của mình
                orders = orderDAO.getOrdersByUserId(user.getUserId());
            }
            session.setAttribute("orders", orders);
            response.sendRedirect("view/orders.jsp");
        } else if ("viewOrderDetails".equals(action)) {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "OrderId không hợp lệ!");
                request.getRequestDispatcher("view/orders.jsp").forward(request, response);
                return;
            }
            // Kiểm tra quyền: Admin hoặc User sở hữu đơn hàng
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("error", "Đơn hàng không tồn tại!");
                request.getRequestDispatcher("view/orders.jsp").forward(request, response);
                return;
            }
            if (!"Admin".equals(user.getRole()) && order.getUserId() != user.getUserId()) {
                request.setAttribute("error", "Bạn không có quyền xem chi tiết đơn hàng này!");
                request.getRequestDispatcher("view/accessDenied.jsp").forward(request, response);
                return;
            }
            OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
            session.setAttribute("orderDetails", orderDetailDAO.getOrderDetailsByOrderId(orderId));
            response.sendRedirect("view/orderDetails.jsp");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("placeOrder".equals(action)) {
            try {
                double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
                String shippingAddress = request.getParameter("shippingAddress");
                if (totalAmount <= 0 || shippingAddress == null || shippingAddress.trim().isEmpty()) {
                    request.setAttribute("error", "Invalid total amount or shipping address");
                    request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                    return;
                }
                orderDAO.createOrder(user.getUserId(), totalAmount, shippingAddress);
                // Xóa giỏ hàng của user sau khi đặt hàng
                cartDAO.clearCartByUserId(user.getUserId());
                request.setAttribute("message", "Đặt hàng thành công!");
                response.sendRedirect("CartServlet?action=viewOrders");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid total amount format");
                request.getRequestDispatcher("view/cart.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error placing order: " + e.getMessage());
                request.getRequestDispatcher("view/cart.jsp").forward(request, response);
            }
        } else if ("updateOrderStatus".equals(action)) {
            // Chỉ Admin mới được cập nhật trạng thái
            if (!"Admin".equals(user.getRole())) {
                request.setAttribute("error", "Bạn không có quyền cập nhật trạng thái đơn hàng!");
                request.getRequestDispatcher("view/accessDenied.jsp").forward(request, response);
                return;
            }
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                orderDAO.updateOrderStatus(orderId, status);
                response.sendRedirect("CartServlet?action=viewOrders");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "OrderId không hợp lệ!");
                request.getRequestDispatcher("view/orders.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
                request.getRequestDispatcher("view/orders.jsp").forward(request, response);
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
