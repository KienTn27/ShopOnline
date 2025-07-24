//package controller;
//
//import dao.CartDAO;
//import dao.UserDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import model.CartDTO;
//import model.User;
//
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
//public class LoginServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        // Nếu đã đăng nhập rồi → chuyển qua Home luôn
//        if (session != null && session.getAttribute("user") != null) {
//            response.sendRedirect(request.getContextPath() + "/Home");
//            return;
//        }
//        // Nếu chưa đăng nhập → hiển thị form login
//        request.getRequestDispatcher("./view/login.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//
//        if (username == null || username.trim().isEmpty()
//                || password == null || password.trim().isEmpty()) {
//            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
//            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            UserDAO userDAO = new UserDAO();
//            User user = userDAO.login(username, password);
//
//            if (user != null) {
//                if (user.isActive()) {
//                    HttpSession session = request.getSession();
//                    session.setAttribute("user", user);
//                    session.setAttribute("userId", String.valueOf(user.getUserId()));
//                    session.setAttribute("role", user.getRole());
//
//                    // Load giỏ hàng vào session
//                    CartDAO cartDAO = new CartDAO();
//                    List<CartDTO> carts = cartDAO.getCartByUserId(user.getUserId());
//                    session.setAttribute("carts", carts);
//
//                    double cartTotal = 0;
//                    for (CartDTO cart : carts) {
//                        cartTotal += cart.getPrice() * cart.getQuantity();
//                    }
//                    session.setAttribute("cartTotal", cartTotal);
//
//                    // Chuyển hướng theo role
//                    if (user.getRole().equals("Customer")) {
//                        response.sendRedirect(request.getContextPath() + "/Home");
//                    } else if (user.getRole().equals("Admin")) {
//                        response.sendRedirect(request.getContextPath() + "/admin");
//                    } else {
//                        // Mặc định
//                        response.sendRedirect(request.getContextPath() + "/Home");
//                    }
//                } else {
//                    request.setAttribute("errorMessage", "Tài khoản của bạn đang bị khóa. Vui lòng liên hệ quản trị viên.");
//                    request.getRequestDispatcher("./view/login.jsp").forward(request, response);
//                }
//            } else {
//                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
//                request.getRequestDispatcher("./view/login.jsp").forward(request, response);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình đăng nhập. Vui lòng thử lại sau.");
//            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
//        }
//    }
//}
package controller;

import dao.CartDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartDTO;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Nếu đã đăng nhập rồi → chuyển qua Home luôn
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/Home");
            return;
        }
        // Nếu chưa đăng nhập → hiển thị form login
        request.getRequestDispatcher("./view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.login(username, password);

            if (user != null) {
                // Kiểm tra nếu tài khoản đã bị xóa mềm (is_deleted = 1)
                // (userDAO.login đã lọc is_deleted = 0, nên nếu null thì có thể do bị xóa mềm)
                // Tuy nhiên, để thông báo rõ ràng, cần kiểm tra lại trong trường hợp user == null
                if (user.isActive()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userId", String.valueOf(user.getUserId()));
                    session.setAttribute("role", user.getRole());

                    // Load giỏ hàng vào session
                    CartDAO cartDAO = new CartDAO();
                    List<CartDTO> carts = cartDAO.getCartByUserId(user.getUserId());
                    session.setAttribute("carts", carts);

                    double cartTotal = 0;
                    for (CartDTO cart : carts) {
                        cartTotal += cart.getPrice() * cart.getQuantity();
                    }
                    session.setAttribute("cartTotal", cartTotal);

                    // Chuyển hướng theo role
                    if (user.getRole().equals("Customer")) {
                        response.sendRedirect(request.getContextPath() + "/Home");
                    } else if (user.getRole().equals("Admin")) {
                        response.sendRedirect(request.getContextPath() + "/Home");
                    } else if (user.getRole().equals("Shipper")){
                        response.sendRedirect(request.getContextPath() + "/shipper");
                    } else {
                        // Mặc định
                        response.sendRedirect(request.getContextPath() + "/Home");
                    }
                } else {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đang bị khóa. Vui lòng liên hệ quản trị viên.");
                    request.getRequestDispatcher("./view/login.jsp").forward(request, response);
                }
            } else {
                // Kiểm tra tài khoản có tồn tại nhưng bị xóa mềm không
                if (userDAO.isUsernameExists(username)) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị xóa khỏi hệ thống. Vui lòng liên hệ quản trị viên nếu đây là nhầm lẫn.");
                } else {
                    request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
                }
                request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình đăng nhập. Vui lòng thử lại sau.");
            request.getRequestDispatcher("./view/login.jsp").forward(request, response);
        }
    }
}
