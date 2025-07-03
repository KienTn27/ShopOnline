package controller;

import dao.OrderDAO;
import dao.UserDAO;
import dao.OrderDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetailView;
import model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ShipperServlet", urlPatterns = {"/shipper"})
public class ShipperServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();
    private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền shipper
        if (!"Shipper".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Lấy danh sách đơn hàng có thể giao (Processing, Shipped)
            List<Order> orders = orderDAO.getOrdersByStatus("Processing");
            orders.addAll(orderDAO.getOrdersByStatus("Shipped"));
            
            // Tạo danh sách chứa thông tin mở rộng
            List<Map<String, Object>> orderViews = new ArrayList<>();
            
            for (Order order : orders) {
                Map<String, Object> map = new HashMap<>();
                map.put("orderId", order.getOrderId());
                map.put("orderDate", order.getOrderDate());
                map.put("totalAmount", order.getTotalAmount());
                map.put("status", order.getStatus());
                map.put("shippingAddress", order.getShippingAddress());
                
                // Lấy thông tin người dùng
                User customer = userDAO.getUserById(order.getUserId());
                map.put("customerName", customer != null ? customer.getFullName() : "Khách hàng");
                map.put("customerPhone", customer != null ? customer.getPhone() : "");
                map.put("customerEmail", customer != null ? customer.getEmail() : "");
                
                // Lấy danh sách sản phẩm
                List<OrderDetailView> details = orderDetailDAO.getOrderDetailViewsByOrderId(order.getOrderId());
                List<String> productNames = new ArrayList<>();
                for (OrderDetailView detail : details) {
                    productNames.add(detail.getProductName() + " (x" + detail.getQuantity() + ")");
                }
                map.put("productNames", String.join(", ", productNames));
                
                orderViews.add(map);
            }
            
            request.setAttribute("orders", orderViews);
            request.getRequestDispatcher("staff/shipper-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu đơn hàng");
            request.getRequestDispatcher("staff/shipper-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 