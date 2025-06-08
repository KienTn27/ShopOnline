package controller;

import dao.UserDAO;
import utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form quên mật khẩu
        request.getRequestDispatcher("./view/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        try {
            UserDAO userDAO = new UserDAO();

            Integer userId = userDAO.getUserIdByEmail(email);
            if (userId == null) {
                session.setAttribute("message", "Email không tồn tại!");
                response.sendRedirect("forgot-password");
                return;
            }

            // Tạo token
            String token = UUID.randomUUID().toString();
            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(30);

            // Lưu token vào DB
            userDAO.savePasswordResetToken(userId, token, Timestamp.valueOf(expiryTime));

            // Gửi email
            String resetLink = "http://localhost:9999/Shop/reset-password?token=" + token;
            String subject = "Yêu cầu đặt lại mật khẩu";
            String content = "<p>Chào bạn,</p>"
                    + "<p>Bạn vừa yêu cầu đặt lại mật khẩu. Click vào link bên dưới để thực hiện:</p>"
                    + "<p><a href='" + resetLink + "'>Đặt lại mật khẩu</a></p>"
                    + "<p>Link có hiệu lực trong 30 phút.</p>";

            EmailUtils.sendEmail(email, subject, content);

            session.setAttribute("email", email); // Lưu email vào session nếu cần
            response.sendRedirect("view/notify_check_mail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Lỗi hệ thống! Vui lòng thử lại.");
            response.sendRedirect("forgot-password");
        }
    }
}
