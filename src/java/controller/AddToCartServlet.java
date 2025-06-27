package controller;

import com.google.gson.Gson;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.Product;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/AddToCartServlet"})
public class AddToCartServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        try {
            HttpSession session = request.getSession();
            Object userObj = session.getAttribute("user");
            if (userObj == null) {
                result.put("success", false);
                result.put("message", "Bạn cần đăng nhập để thêm vào giỏ hàng.");
                out.print(new Gson().toJson(result));
                return;
            }

            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Lấy thông tin sản phẩm
            Product product = productDAO.getAllProducts().stream()
                    .filter(p -> p.getProductId() == productId)
                    .findFirst().orElse(null);
            if (product == null) {
                result.put("success", false);
                result.put("message", "Sản phẩm không tồn tại.");
                out.print(new Gson().toJson(result));
                return;
            }
            if (product.getQuantity() < quantity) {
                result.put("success", false);
                result.put("message", "Số lượng sản phẩm không đủ trong kho.");
                out.print(new Gson().toJson(result));
                return;
            }

            // Lưu vào database (CartDAO)
            model.User user = (model.User) userObj;
            int userId = user.getUserId();
            dao.CartDAO cartDAO = new dao.CartDAO();
            // Kiểm tra sản phẩm đã có trong giỏ chưa
            java.util.List<model.CartDTO> carts = cartDAO.getCartByUserId(userId);
            boolean found = false;
            for (model.CartDTO cart : carts) {
                if (cart.getProductId() == productId) {
                    // Nếu đã có, tăng số lượng
                    cartDAO.updateCartQuantity(cart.getCartId(), cart.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }
            if (!found) {
                // Nếu chưa có, thêm mới
                cartDAO.addToCart(userId, productId, quantity);
            }
            result.put("success", true);
            result.put("message", "Đã thêm sản phẩm vào giỏ hàng!");
            out.print(new Gson().toJson(result));
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
            out.print(new Gson().toJson(result));
        } finally {
            out.close();
        }
    }
} 