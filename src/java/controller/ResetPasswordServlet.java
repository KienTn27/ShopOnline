package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDAO userDAO = new UserDAO();
        boolean valid = userDAO.isValidResetToken(token);

        if (!valid) {
            request.setAttribute("message", "Token không hợp lệ hoặc đã hết hạn!");
            request.setAttribute("token", token); // Để form không bị lỗi nếu có logic kiểm tra
            request.getRequestDispatcher("./view/reset_password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("token", token);
        request.getRequestDispatcher("./view/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");

        HttpSession session = request.getSession();

        try {
            UserDAO userDAO = new UserDAO();

            boolean success = userDAO.updatePasswordByToken(token, newPassword);

            if (success) {
                session.setAttribute("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
                response.sendRedirect("login");
            } else {
                session.setAttribute("message", "Token không hợp lệ hoặc đã hết hạn!");
                response.sendRedirect("reset-password?token=" + token);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Lỗi hệ thống! Vui lòng thử lại.");
            response.sendRedirect("reset-password?token=" + token);
        }
    }
}
