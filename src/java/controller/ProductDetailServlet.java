package controller; // Hoặc package của bạn

import dao.ProductDAO;
import dao.ProductVariantDAO;
import dao.ReviewDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import java.io.IOException;
import java.util.List;
import model.Product1;
import model.ProductVariant;
import model.Review;


// Đặt một URL rõ ràng cho servlet này
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        
          HttpSession session = request.getSession(false); // false = không tạo mới nếu chưa có
        if (session == null || session.getAttribute("user") == null) {
                        request.setAttribute("errorMessage", "Vui lòng nhập truớc khi xem chi tiết.");

        request.getRequestDispatcher("./view/login.jsp").forward(request, response);
            return;
        }

        
        try {
            // 1. Lấy productID từ parameter
            String productIdStr = request.getParameter("id");
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                throw new NumberFormatException("Product ID không được cung cấp.");
            }
            int productID = Integer.parseInt(productIdStr);

            // 2. Gọi DAO để lấy dữ liệu
            ProductDAO productDAO = new ProductDAO();
            ProductVariantDAO v = new ProductVariantDAO();
            Product1 product = productDAO.getProductById(productID);
            List<ProductVariant> list = v.getProductVariantsByProductId(productID);
             ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getReviewsByProductId(productID);
            
            
            // 3. Kiểm tra sản phẩm có tồn tại không
            if (product == null) {
                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm với ID: " + productID);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 4. Đặt thẳng đối tượng Product (đã chứa list variants) vào request
            // KHÔNG cần chuyển đổi sang JSON
            request.setAttribute("product", product);
                        request.setAttribute("reviews", reviews);

                        request.setAttribute("list", list);


            // 5. Forward tới file JSP mới
            RequestDispatcher dispatcher = request.getRequestDispatcher("view/productDetail.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID sản phẩm không hợp lệ: " + e.getMessage());
                       request.getRequestDispatcher("error.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug
            request.setAttribute("errorMessage", "Đã có lỗi hệ thống xảy ra.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
