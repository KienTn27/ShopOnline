package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/user-management")
public class UserManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !("Admin".equals(currentUser.getRole()) || "SuperAdmin".equals(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        UserDAO userDAO = new UserDAO();
        try {
            List<User> userList = userDAO.getAllUsers();
            request.setAttribute("userList", userList);
            request.setAttribute("currentUser", currentUser);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi lấy danh sách người dùng");
        }
        request.getRequestDispatcher("/admin/adminUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !("Admin".equals(currentUser.getRole()) || "SuperAdmin".equals(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDAO userDAO = new UserDAO();
        String error = null;
        try {
            User targetUser = userDAO.getUserById(userId);
            boolean isSelf = (userId == currentUser.getUserId());
            boolean isTargetAdmin = targetUser != null && "Admin".equals(targetUser.getRole());
            boolean isTargetSuperAdmin = targetUser != null && "SuperAdmin".equals(targetUser.getRole());
            boolean isTargetCustomer = targetUser != null && "Customer".equals(targetUser.getRole());
            switch (action) {
                case "block":
                    if (isSelf) {
                        error = "Bạn không thể block chính mình!";
                    } else if ("SuperAdmin".equals(currentUser.getRole())) {
                        if (isTargetSuperAdmin) {
                            error = "Không thể block super admin khác!";
                        } else {
                            userDAO.blockUser(userId);
                        }
                    } else if ("Admin".equals(currentUser.getRole())) {
                        if (isTargetCustomer) {
                            userDAO.blockUser(userId);
                        } else {
                            error = "Admin chỉ có thể block customer!";
                        }
                    }
                    break;
                case "unblock":
                    if ("SuperAdmin".equals(currentUser.getRole())) {
                        if (isTargetSuperAdmin) {
                            error = "Không thể mở khóa super admin khác!";
                        } else {
                            userDAO.unblockUser(userId);
                        }
                    } else if ("Admin".equals(currentUser.getRole())) {
                        if (isTargetCustomer) {
                            userDAO.unblockUser(userId);
                        } else {
                            error = "Admin chỉ có thể mở khóa customer!";
                        }
                    }
                    break;
                case "delete":
                    if (isSelf) {
                        error = "Bạn không thể xóa chính mình!";
                    } else if ("SuperAdmin".equals(currentUser.getRole())) {
                        if (isTargetSuperAdmin) {
                            error = "Không thể xóa super admin khác!";
                        } else {
                            userDAO.softDeleteUser(userId);
                        }
                    } else {
                        error = "Chỉ super admin mới có thể xóa tài khoản!";
                    }
                    break;
                case "createAdmin":
                    if (!"SuperAdmin".equals(currentUser.getRole())) {
                        error = "Chỉ super admin mới có thể thêm admin!";
                    } else {
                        // Logic tạo admin sẽ được xử lý ở nơi khác (form riêng)
                    }
                    break;
                default:
                    error = "Hành động không hợp lệ";
            }
        } catch (Exception e) {
            error = "Lỗi thao tác: " + e.getMessage();
        }
        if (error != null) request.setAttribute("error", error);
        doGet(request, response);
    } 
} 