/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ReviewDAO;
import model.Review;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author X1 carbon Gen6
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/ReviewServlet"})
public class ReviewServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReviewDAO dao = new ReviewDAO();
        List<Review> reviews = dao.getAllReviews();

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra session để lấy thông tin user
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        // Lấy thông tin từ form
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String orderIdStr = request.getParameter("orderId");

        // Validate input
        if (productIdStr == null || ratingStr == null || comment == null
                || productIdStr.trim().isEmpty() || ratingStr.trim().isEmpty() || comment.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin đánh giá!");
            request.getRequestDispatcher("/view/orderDetail.jsp?orderId=" + orderIdStr).forward(request, response);
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            // Validate rating (1-5)
            if (rating < 1 || rating > 5) {
                request.setAttribute("errorMessage", "Đánh giá phải từ 1 đến 5 sao!");
                request.getRequestDispatcher("/view/orderDetail.jsp?orderId=" + orderIdStr).forward(request, response);
                return;
            }

            ReviewDAO reviewDAO = new ReviewDAO();

            // Kiểm tra xem user đã review sản phẩm này chưa
            if (reviewDAO.hasUserReviewedProduct(userId, productId)) {
                request.setAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này rồi!");
                request.getRequestDispatcher("/view/orderDetail.jsp?orderId=" + orderIdStr).forward(request, response);
                return;
            }

            // Thêm review
            boolean success = reviewDAO.addReview(userId, productId, rating, comment);

            if (success) {
                request.setAttribute("successMessage", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại!");
            }

            // Redirect về trang order detail
            response.sendRedirect(request.getContextPath() + "/view/orderDetail.jsp?orderId=" + orderIdStr);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
            request.getRequestDispatcher("/view/orderDetail.jsp?orderId=" + orderIdStr).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/orderDetail.jsp?orderId=" + orderIdStr).forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "ReviewServlet - Xử lý thêm đánh giá sản phẩm";
    }// </editor-fold>

}
