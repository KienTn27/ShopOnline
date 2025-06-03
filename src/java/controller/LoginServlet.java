package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập rồi → chuyển qua Home luôn
        HttpSession session = request.getSession(false);
//        if (session != null && session.getAttribute("user") != null) {
//            response.sendRedirect("Home");
//            return;
//        }

        // Nếu chưa đăng nhập → hiển thị form login
        request.getRequestDispatcher("./view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Kiểm tra dữ liệu nhập vào có rỗng không
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {

            // Thông báo lỗi thiếu thông tin
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.login(username, password);

            if (user != null) {
                if (user.isActive()) {
                    // Đăng nhập thành công → lưu vào session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);

                    if(user.getRole().equals("Customer")){
                                            response.sendRedirect("Home");

                    }else if(user.getRole().equals("Admin") ){
                          response.sendRedirect("admin");
                    }
                } else {
                    // Tài khoản bị khóa (isActive = false)
                    request.setAttribute("errorMessage", "Tài khoản của bạn đang bị khóa. Vui lòng liên hệ quản trị viên.");
                    request.getRequestDispatcher("./view/login.jsp").forward(request, response);
                }
            } else {
                // Sai username/password
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();  // Ghi log lỗi (có thể thay bằng log framework sau này)

            // Thông báo lỗi hệ thống
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình đăng nhập. Vui lòng thử lại sau.");
            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
        }
    }
}
