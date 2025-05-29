package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "loginServlet", urlPatterns = {"/Login"})
public class loginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userID = request.getParameter("userID");
        String Password = request.getParameter("Password");

        // Kiểm tra dữ liệu rỗng
        if (userID == null || userID.trim().isEmpty() || Password == null || Password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên đăng nhập và mật khẩu không được để trống.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.dangnhap(userID, Password);

        if (user != null) {
            System.out.println("Login thành công: " + user.getUserId()); // debug
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("Home");
        } else {
            System.out.println("Đăng nhập thất bại cho userID: " + userID); // debug
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Xử lý đăng nhập người dùng";
    }
}
