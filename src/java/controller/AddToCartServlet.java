    package controller;

    import com.google.gson.Gson;
    import dao.ProductDAO;
    import dao.ProductVariantDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;
    import model.Cart;
    import model.Product;
    import model.ProductVariant;

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
        private ProductVariantDAO productVariantDAO = new ProductVariantDAO();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            try {
                HttpSession session = request.getSession();
                Object userObj = session.getAttribute("user");
                if (userObj == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                String variantIdStr = request.getParameter("variantID");
                if (variantIdStr == null || variantIdStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Vui lòng chọn phiên bản sản phẩm.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                    return;
                }

                int variantId = Integer.parseInt(variantIdStr);
                int quantity = 1; // Mặc định số lượng là 1

                // Lấy thông tin variant
                ProductVariant variant = productVariantDAO.getProductVariantById(variantId);
                if (variant == null) {
                    session.setAttribute("errorMessage", "Phiên bản sản phẩm không tồn tại.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                    return;
                }

                // Kiểm tra productId parameter
                String productIdStr = request.getParameter("productId");
                if (productIdStr == null || productIdStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Thông tin sản phẩm không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                    return;
                }

                int productId = Integer.parseInt(productIdStr);

                // Lấy thông tin sản phẩm
                Product product = productDAO.getAllProducts().stream()
                        .filter(p -> p.getProductId() == productId)
                        .findFirst().orElse(null);
                if (product == null) {
                    session.setAttribute("errorMessage", "Sản phẩm không tồn tại.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                    return;
                }
                if (variant.getQuantity() < quantity) {
                    session.setAttribute("errorMessage", "Số lượng sản phẩm không đủ trong kho.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
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
                Map<Integer, ProductVariant> cartVariants = (Map<Integer, ProductVariant>) session.getAttribute("cartVariants");
                if (cartVariants == null) {
                    cartVariants = new HashMap<>();
                }
                cartVariants.put(productId, variant);
                session.setAttribute("cartVariants", cartVariants);

                // Chuyển hướng sang trang giỏ hàng với thông báo thành công
                session.setAttribute("successMessage", "Đã thêm sản phẩm vào giỏ hàng!");
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");

            } catch (Exception e) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
            }
        }
    }
