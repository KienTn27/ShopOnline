package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

@WebServlet(name = "HomeControl", urlPatterns = {"/Home"})
public class HomeControl extends HttpServlet {

    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
  // Lấy tham số trang từ request
        try {
            // Lấy tham số trang từ request
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Số sản phẩm trên mỗi trang
            int productsPerPage = 8;
            
            ProductDAO dao = new ProductDAO();
                    
            
            // Tính offset
            int offset = (currentPage - 1) * productsPerPage;
            
            // Lấy danh sách sản phẩm với phân trang
            List<Product> productList = dao.getProductsWithPagination(offset, productsPerPage);
            
            // Lấy tổng số sản phẩm để tính số trang
            int totalProducts = dao.getTotalProductCount();
            int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
            
            // Đảm bảo currentPage không vượt quá totalPages
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                // Redirect về trang cuối cùng
                response.sendRedirect("home?page=" + totalPages);
                return;
            }
            
            // Lấy sản phẩm nổi bật (4 sản phẩm đầu tiên)
            List<Product> featuredProducts = dao.getFeaturedProducts(4);
            
            // Set attributes
            request.setAttribute("productList", productList);
            request.setAttribute("featuredProducts", featuredProducts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("productsPerPage", productsPerPage);
            
            // Thông tin phân trang bổ sung
            int startProduct = (currentPage - 1) * productsPerPage + 1;
            int endProduct = Math.min(currentPage * productsPerPage, totalProducts);
            request.setAttribute("startProduct", startProduct);
            request.setAttribute("endProduct", endProduct);
                    request.getRequestDispatcher("./view/home.jsp").forward(request, response);

            // Forward đến home.jsp
//            request.getRequestDispatcher("home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi - chuyển về trang lỗi hoặc trang chủ
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu sản phẩm.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // false = không tạo mới nếu chưa có
        if (session == null || session.getAttribute("user") == null) {
        request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            return;
        }

        try {
            // Nếu đã đăng nhập, gọi xử lý chính
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(HomeControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(HomeControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "HomeControl - kiểm tra đăng nhập trước khi hiển thị sản phẩm";
    }
}
