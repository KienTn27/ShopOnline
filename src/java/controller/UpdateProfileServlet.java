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

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile"})
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        // Cập nhật thông tin user
        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        boolean success = false;
        try {
            UserDAO userDAO = new UserDAO();
            success = userDAO.updateUserProfile(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        session.setAttribute("user", user);
        if (success) {
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("message", "Cập nhật thất bại. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("view/profile.jsp").forward(request, response);
    }
} 