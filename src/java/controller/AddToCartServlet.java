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
                // Lấy số lượng người dùng nhập (nếu có), mặc định là 1
                String quantityStr = request.getParameter("quantity");
                int quantity = 1;
                if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                    try {
                        quantity = Integer.parseInt(quantityStr);
                    } catch (NumberFormatException e) {
                        session.setAttribute("errorMessage", "Số lượng không hợp lệ.");
                        response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                        return;
                    }
                }

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
                // Kiểm tra tồn kho của biến thể
                if (variant.getQuantity() < quantity) {
                    session.setAttribute("errorMessage", "Số lượng sản phẩm không đủ trong kho.");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                    return;
                }

                // Lưu vào database (CartDAO)
                model.User user = (model.User) userObj;
                int userId = user.getUserId();
                dao.CartDAO cartDAO = new dao.CartDAO();
                // Kiểm tra sản phẩm đã có trong giỏ chưa (theo productId và variantId)
                java.util.List<model.CartDTO> carts = cartDAO.getCartByUserId(userId);
                boolean found = false;
                for (model.CartDTO cart : carts) {
                    // So sánh cả productId và variantID (nếu có)
                    Integer cartVariantId = cart.getVariantID();
                    if (cart.getProductId() == productId && cartVariantId != null && cartVariantId == variantId) {
                        int newQuantity = cart.getQuantity() + quantity;
                        if (variant.getQuantity() < newQuantity) {
                            session.setAttribute("errorMessage", "Số lượng sản phẩm không đủ trong kho.");
                            response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                            return;
                        }
                        cartDAO.updateCartQuantity(cart.getCartId(), newQuantity);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    // Nếu chưa có, thêm mới
                    cartDAO.addToCart(userId, productId, quantity); // Không thay đổi DB, vẫn dùng productId
                }
                // Lưu variant mapping vào session (key: cartId)
                Map<Integer, ProductVariant> cartVariantsByCartId = (Map<Integer, ProductVariant>) session.getAttribute("cartVariantsByCartId");
                if (cartVariantsByCartId == null) {
                    cartVariantsByCartId = new HashMap<>();
                }
                // Lấy lại danh sách giỏ hàng để lấy cartId vừa thêm/cập nhật
                java.util.List<model.CartDTO> updatedCarts = cartDAO.getCartByUserId(userId);
                for (model.CartDTO cart : updatedCarts) {
                    // Tìm cart đúng productId và (nếu có) variantID
                    Integer cartVariantId = cart.getVariantID();
                    if (cart.getProductId() == productId && (cartVariantId == null || cartVariantId == variantId)) {
                        cartVariantsByCartId.put(cart.getCartId(), variant);
                    }
                }
                session.setAttribute("cartVariantsByCartId", cartVariantsByCartId);

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
