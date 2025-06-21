package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/CancelOrderServlet"})
public class CancelOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy thông tin đơn hàng.");
            request.getRequestDispatcher("./view/order.jsp").forward(request, response);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            // Kiểm tra xem đơn hàng có thể hủy được không
            if (!orderDAO.canCancelOrder(orderId, user.getUserId())) {
                request.setAttribute("errorMessage", "Không thể hủy đơn hàng này. Đơn hàng có thể đã được giao hoặc không thuộc về bạn.");
                request.getRequestDispatcher("./view/order.jsp").forward(request, response);
                return;
            }

            // Thực hiện hủy đơn hàng
            boolean success = orderDAO.cancelOrder(orderId, user.getUserId());
            
            if (success) {
                request.setAttribute("successMessage", "Đã hủy đơn hàng #" + orderId + " thành công!");
                
                // Cập nhật lại danh sách đơn hàng trong session
                session.setAttribute("orders", orderDAO.getOrdersByUserId(user.getUserId()));
            } else {
                request.setAttribute("errorMessage", "Không thể hủy đơn hàng. Vui lòng thử lại sau.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Thông tin đơn hàng không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình hủy đơn hàng.");
        }

        // Chuyển hướng về trang danh sách đơn hàng
        request.getRequestDispatcher("./view/order.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang danh sách đơn hàng nếu truy cập bằng GET
        response.sendRedirect(request.getContextPath() + "/view/order.jsp");
    }
} 