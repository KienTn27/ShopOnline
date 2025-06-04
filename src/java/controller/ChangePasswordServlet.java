package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");
        UserDAO userDAO = new UserDAO();
        String message = null;
        if (!newPassword.equals(confirmNewPassword)) {
            message = "Mật khẩu mới và xác nhận mật khẩu mới không khớp.";
        } else if (!userDAO.checkPassword(user.getUserId(), currentPassword)) { // Cần bổ sung checkPassword trong UserDAO
            message = "Mật khẩu hiện tại không đúng.";
        } else {
            boolean success = userDAO.updatePassword(user.getUserId(), newPassword); // Cần bổ sung updatePassword trong UserDAO
            if (success) {
                message = "Đổi mật khẩu thành công!";
                // Cập nhật mật khẩu trong session user object (optional but good practice)
                user.setPassword(newPassword); // Lưu ý: Trong thực tế nên lưu mật khẩu đã hash
                session.setAttribute("user", user);
            } else {
                message = "Đổi mật khẩu thất bại. Vui lòng thử lại.";
            }
        }
        request.setAttribute("message", message);
        request.getRequestDispatcher("view/profile.jsp").forward(request, response);
    }
} 