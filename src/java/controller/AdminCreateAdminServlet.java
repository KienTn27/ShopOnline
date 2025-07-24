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
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "AdminCreateAdminServlet", urlPatterns = {"/admin/create-admin"})
public class AdminCreateAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cho phép super admin truy cập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"SuperAdmin".equals(((User) session.getAttribute("user")).getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cho phép super admin truy cập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"SuperAdmin".equals(((User) session.getAttribute("user")).getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            UserDAO userDAO = new UserDAO();

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp!");
                request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
                return;
            }
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
                return;
            }
            // Kiểm tra trùng email
            if (userDAO.getUserIdByEmail(email) != null) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
                return;
            }
            // Kiểm tra trùng phone
            boolean phoneExists = false;
            try (Connection conn = userDAO.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT UserID FROM Users WHERE Phone = ?")) {
                ps.setString(1, phone);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) phoneExists = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (phoneExists) {
                request.setAttribute("error", "Số điện thoại đã tồn tại!");
                request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setFullName(fullName);
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password); // UserDAO.register sẽ tự mã hóa nếu đã có logic mã hóa
            user.setRole("Admin");
            user.setIsActive(true);
            user.setCreateAt(Timestamp.valueOf(LocalDateTime.now()));

            boolean success = userDAO.register(user);
            if (success) {
                request.setAttribute("success", "Tạo tài khoản admin thành công!");
            } else {
                request.setAttribute("error", "Tạo tài khoản admin thất bại. Vui lòng thử lại!");
            }
            request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống! Vui lòng thử lại sau.");
            request.getRequestDispatcher("/admin/createAdmin.jsp").forward(request, response);
        }
    }
} 