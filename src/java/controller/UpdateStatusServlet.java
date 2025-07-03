/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.NotificationDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Order;
import dao.UserDAO;
import model.User;
import dao.OrderDetailDAO;
import model.OrderDetailView;

/**
 *
 * @author X1 carbon Gen6
 */
public class UpdateStatusServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateStatusServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateStatusServlet at " + request.getContextPath() + "</h1>");
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
        try {
            List<Order> orders = orderDAO.getAllOrders();
            // Tạo danh sách chứa thông tin mở rộng
            java.util.List<java.util.Map<String, Object>> orderViews = new java.util.ArrayList<>();
            dao.UserDAO userDAO = new dao.UserDAO();
            dao.OrderDetailDAO orderDetailDAO = new dao.OrderDetailDAO();
            for (Order order : orders) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("orderId", order.getOrderId());
                map.put("orderDate", order.getOrderDate());
                map.put("totalAmount", order.getTotalAmount());
                map.put("status", order.getStatus());
                // Lấy tên người dùng
                model.User user = userDAO.getUserById(order.getUserId());
                map.put("userName", user != null ? user.getFullName() : "Người dùng");
                // Lấy tên sản phẩm đầu tiên
                java.util.List<model.OrderDetailView> details = orderDetailDAO.getOrderDetailViewsByOrderId(order.getOrderId());
                String productName;
                if (details.size() > 0) {
                    java.util.List<String> productNames = new java.util.ArrayList<>();
                    for (model.OrderDetailView d : details) {
                        productNames.add(d.getProductName());
                    }
                    productName = String.join(", ", productNames);
                } else {
                    productName = "";
                }
                map.put("productName", productName);
                orderViews.add(map);
            }
            request.setAttribute("orders", orderViews);
            request.getRequestDispatcher("admin/orderList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("admin/orderList.jsp").forward(request, response);
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
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        // Kiểm tra xem đơn hàng có bị hủy không
        Order order = orderDAO.getOrderById(orderId);
        if (order != null && "Cancelled".equals(order.getStatus())) {
            // Không cho phép thay đổi trạng thái đơn hàng đã bị hủy
            request.setAttribute("error", "Không thể thay đổi trạng thái đơn hàng đã bị hủy!");
            try {
                List<Order> orders = orderDAO.getAllOrders();
                request.setAttribute("orders", orders);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("admin/orderList.jsp").forward(request, response);
            return;
        }

        if (order != null && ("Shipped".equals(order.getStatus()) || "Delivered".equals(order.getStatus()))) {
            request.setAttribute("error", "Chỉ shipper được phép thao tác với các trạng thái này!");
            try {
                List<Order> orders = orderDAO.getAllOrders();
                request.setAttribute("orders", orders);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("admin/orderList.jsp").forward(request, response);
            return;
        }
        
        orderDAO.updateOrderStatus(orderId, status);
        
        int userId = orderDAO.getUserIdByOrderId(orderId);
        if(userId != -1){
            // Lấy tên người dùng
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            String userName = (user != null) ? user.getFullName() : "Người dùng";
            // Lấy tên sản phẩm (lấy sản phẩm đầu tiên trong đơn hàng)
            OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
            List<OrderDetailView> details = orderDetailDAO.getOrderDetailViewsByOrderId(orderId);
            String productName;
            if (details.size() > 0) {
                java.util.List<String> productNames = new java.util.ArrayList<>();
                for (OrderDetailView d : details) {
                    productNames.add(d.getProductName());
                }
                productName = String.join(", ", productNames);
            } else {
                productName = "Sản phẩm";
            }
            String message = "Đơn hàng của bạn với sản phẩm " + productName + " đã được cập nhật trạng thái: " + status;
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.addNotification(userId, message);
        }
        response.sendRedirect("UpdateStatusServlet");
    }
    
    private String getStatusTextVN(String status) {
        switch (status) {
            case "Pending":
                return "Chờ xác nhận";
            case "Processing":
                return "Chờ lấy hàng";
            case "Shipped":
                return "Đang giao hàng";
            case "Delivered":
                return "Đã giao";
            case "Cancelled":
                return "Đã hủy";
            default:
                return status;
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
