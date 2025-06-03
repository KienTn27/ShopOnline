package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu có message trong session → lấy ra
        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("registerMessage");
        session.removeAttribute("registerMessage");

        request.setAttribute("message", message);

        // Hiển thị trang đăng ký
        request.getRequestDispatcher("./view/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession();

        try {
            UserDAO userDAO = new UserDAO();

            // Kiểm tra mật khẩu khớp
            if (!password.equals(confirmPassword)) {
                session.setAttribute("registerMessage", "Mật khẩu và Nhập lại mật khẩu không khớp!");
                response.sendRedirect("register");
                return;
            }

            // Kiểm tra username đã tồn tại
            if (userDAO.isUsernameExists(username)) {
                session.setAttribute("registerMessage", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
                response.sendRedirect("register");
                return;
            }

            // Tạo User object
            User user = new User();
            user.setFullName(fullName);
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole("Customer");
            user.setIsActive(true);
            user.setCreateAt(Timestamp.valueOf(LocalDateTime.now()));

            boolean success = userDAO.register(user);

            if (success) {
                // Đăng ký thành công → chuyển sang login.jsp
                session.setAttribute("registerMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect("login");
            } else {
                // Đăng ký thất bại
                session.setAttribute("registerMessage", "Đăng ký thất bại. Vui lòng thử lại.");
                response.sendRedirect("register");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("registerMessage", "Lỗi hệ thống! Vui lòng thử lại sau.");
            response.sendRedirect("register");
        }
    }
}
