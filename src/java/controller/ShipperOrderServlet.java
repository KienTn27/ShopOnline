package controller;

import dao.NotificationDAO;
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
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "ShipperOrderServlet", urlPatterns = {"/shipper-order"})
public class ShipperOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();
    private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User shipper = (User) session.getAttribute("user");
        
        // Kiểm tra quyền shipper
        if (!"Shipper".equals(shipper.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String note = request.getParameter("note"); // Ghi chú của shipper

            // Kiểm tra xem đơn hàng có bị hủy không
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && "Cancelled".equals(order.getStatus())) {
                request.setAttribute("error", "Không thể thay đổi trạng thái đơn hàng đã bị hủy!");
                response.sendRedirect(request.getContextPath() + "/shipper");
                return;
            }

            // Cập nhật trạng thái đơn hàng
            orderDAO.updateOrderStatus(orderId, status);
            
            // Lấy thông tin khách hàng để gửi thông báo
            int customerId = orderDAO.getUserIdByOrderId(orderId);
            if (customerId != -1) {
                User customer = userDAO.getUserById(customerId);
                String customerName = (customer != null) ? customer.getFullName() : "Khách hàng";
                
                // Lấy tên sản phẩm
                List<OrderDetailView> details = orderDetailDAO.getOrderDetailViewsByOrderId(orderId);
                String productName;
                if (details.size() > 0) {
                    List<String> productNames = new ArrayList<>();
                    for (OrderDetailView detail : details) {
                        productNames.add(detail.getProductName());
                    }
                    productName = String.join(", ", productNames);
                } else {
                    productName = "Sản phẩm";
                }
                
                // Tạo thông báo cho khách hàng
                String message = "Đơn hàng của bạn với sản phẩm " + productName + " đã được cập nhật trạng thái: " + getStatusTextVN(status);
                if (note != null && !note.trim().isEmpty()) {
                    message += " - Ghi chú: " + note;
                }
                
                notificationDAO.addNotification(customerId, message);
            }
            
            // Thông báo thành công
            request.setAttribute("success", "Cập nhật trạng thái đơn hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/shipper");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái đơn hàng");
            response.sendRedirect(request.getContextPath() + "/shipper");
        }
    }

    private String getStatusText(String status) {
        switch (status) {
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
} 