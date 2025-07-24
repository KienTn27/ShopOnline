package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import model.CartDTO;
import model.Order;

public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
            System.out.println("🔍 Debug CartServlet - UserId from session: " + userId);
        } catch (NumberFormatException e) {
            System.err.println("❌ Debug CartServlet - Invalid userId in session: " + userIdStr);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("🔍 Debug CartServlet - Action: " + action);

        // Debug session attributes
        System.out.println("🔍 Debug CartServlet - Session attributes:");
        System.out.println("  - userId: " + session.getAttribute("userId"));
        System.out.println("  - role: " + session.getAttribute("role"));
        System.out.println("  - user: " + session.getAttribute("user"));

        if (action == null || action.isEmpty()) {
            action = "viewCart";
        }

        switch (action) {
            case "viewCart" -> {
                try {
                    List<CartDTO> carts = cartDAO.getCartWithStockInfo(userId);
                    Map<Integer, model.ProductVariant> cartVariantsByCartId = (Map<Integer, model.ProductVariant>) session.getAttribute("cartVariantsByCartId");
                    if (cartVariantsByCartId != null) {
                        for (CartDTO cart : carts) {
                            model.ProductVariant variant = cartVariantsByCartId.get(cart.getCartId());
                            if (variant != null) {
                                cart.setVariantID(variant.getVariantID());
                                cart.setColor(variant.getColor());
                                cart.setSize(variant.getSize());
                                if (variant.getPrice() != null) {
                                    cart.setPrice(variant.getPrice().doubleValue());
                                }
                                cart.setStockQuantity(variant.getQuantity());
                            }
                        }
                    }
                    session.setAttribute("carts", carts);
                    double cartTotal = 0;
                    for (CartDTO cart : carts) {
                        cartTotal += cart.getPrice() * cart.getQuantity();
                    }
                    session.setAttribute("cartTotal", cartTotal);
                    response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                }
            }

            case "deleteCartItem" -> {
                try {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    cartDAO.deleteCartItem(cartId);
                } catch (Exception ignored) {
                }

                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
            }

            case "viewOrders" -> {
                try {
                    int page = 1;
                    int pageSize = 5;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        try {
                            page = Integer.parseInt(pageParam);
                            if (page < 1) {
                                page = 1;
                            }
                        } catch (NumberFormatException ignored) {
                        }
                    }
                    List<Order> allOrders = "Admin".equals(role)
                            ? orderDAO.getAllOrders()
                            : orderDAO.getOrdersByUserId(userId);
                    int totalOrders = allOrders.size();
                    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
                    if (page > totalPages && totalPages > 0) {
                        page = totalPages;
                    }
                    int fromIndex = (page - 1) * pageSize;
                    int toIndex = Math.min(fromIndex + pageSize, totalOrders);
                    List<Order> orders = allOrders.subList(fromIndex, toIndex);
                    session.setAttribute("orders", orders);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("pageSize", pageSize);
                    request.getRequestDispatcher("/view/order.jsp").forward(request, response);
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                }
            }

            case "viewOrderDetails" -> {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    Order order = orderDAO.getOrderById(orderId);

                    if (order == null || (!"Admin".equals(role) && order.getUserId() != userId)) {
                        response.sendRedirect(request.getContextPath() + "/view/accessDenied.jsp");
                        return;
                    }

                    OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                    session.setAttribute("orderDetails", orderDetailDAO.getOrderDetailViewsByOrderId(orderId));
                    response.sendRedirect(request.getContextPath() + "/view/orderDetail.jsp");

                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/view/order.jsp");
                }
            }

            default ->
                response.sendRedirect(request.getContextPath() + "/view/cart.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔍 Debug CartServlet - doPost called");
        System.out.println("🔍 Debug CartServlet - Request URI: " + request.getRequestURI());
        System.out.println("🔍 Debug CartServlet - Request method: " + request.getMethod());

        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        System.out.println("🔍 Debug CartServlet - Session userId: " + userIdStr);
        System.out.println("🔍 Debug CartServlet - Session role: " + role);

        if (userIdStr == null) {
            System.err.println("❌ Debug CartServlet - No userId in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "placeOrder" -> {
                try {
                    System.out.println("🔍 Debug CartServlet - Starting placeOrder process");

                    // Debug all form parameters
                    System.out.println("🔍 Debug CartServlet - All form parameters:");
                    java.util.Enumeration<String> paramNames = request.getParameterNames();
                    while (paramNames.hasMoreElements()) {
                        String paramName = paramNames.nextElement();
                        String paramValue = request.getParameter(paramName);
                        System.out.println("  - " + paramName + " = " + paramValue);
                    }

                    // Parse và validate totalAmount
                    String totalAmountStr = request.getParameter("totalAmount");
                    System.out.println("🔍 Debug CartServlet - totalAmount from form: " + totalAmountStr);

                    if (totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("Tổng tiền không được để trống");
                    }

                    double totalAmount;
                    try {
                        totalAmount = Double.parseDouble(totalAmountStr);
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Tổng tiền không hợp lệ: " + totalAmountStr);
                    }

                    String city = request.getParameter("city");
                    String province = request.getParameter("province");
                    String district = request.getParameter("district");
                    String detail = request.getParameter("detailAddress");

                    System.out.println("🔍 Debug CartServlet - Form data: totalAmount=" + totalAmount + ", city=" + city + ", province=" + province + ", district=" + district + ", detail=" + detail);

                    if (totalAmount <= 0
                            || city == null || city.trim().isEmpty()
                            || province == null || province.trim().isEmpty()
                            || district == null || district.trim().isEmpty()
                            || detail == null || detail.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin địa chỉ.");
                        request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                        return;
                    }
                    String shippingAddress = detail + ", " + district + ", " + province + ", " + city;

                    // Lấy danh sách giỏ hàng trước khi xóa
                    List<CartDTO> cartItems = cartDAO.getCartWithStockInfo(userId);

                    System.out.println("🔍 Debug CartServlet - Cart items count: " + (cartItems != null ? cartItems.size() : "null"));

                    if (cartItems == null || cartItems.isEmpty()) {
                        throw new RuntimeException("Giỏ hàng trống hoặc không thể lấy thông tin giỏ hàng");
                    }

                    // Tạo đơn hàng và lấy OrderId
                    int orderId = orderDAO.createOrder(userId, totalAmount, shippingAddress);

                    if (orderId == -1) {
                        throw new RuntimeException("Failed to create order");
                    }

                    System.out.println("🔍 Debug CartServlet - Order created with ID: " + orderId);

                    // Tạo chi tiết đơn hàng và cập nhật số lượng sản phẩm
                    OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                    ProductDAO productDAO = new ProductDAO();

                    for (CartDTO cartItem : cartItems) {
                        System.out.println("🔍 Debug CartServlet - Processing cart item: productId=" + cartItem.getProductId() + ", quantity=" + cartItem.getQuantity() + ", price=" + cartItem.getPrice());

                        // Tính totalPrice
                        double totalPrice = cartItem.getPrice() * cartItem.getQuantity();

                        // Lấy thông tin variant từ session
                        String size = null;
                        String color = null;
                        Integer variantId = null;
                        Map<Integer, model.ProductVariant> cartVariantsByCartId = (Map<Integer, model.ProductVariant>) session.getAttribute("cartVariantsByCartId");
                        if (cartVariantsByCartId != null) {
                            model.ProductVariant variant = cartVariantsByCartId.get(cartItem.getCartId());
                            if (variant != null) {
                                size = variant.getSize();
                                color = variant.getColor();
                                variantId = variant.getVariantID();
                            }
                        }

                        // Thêm chi tiết đơn hàng với đầy đủ thông tin
                        orderDetailDAO.addOrderDetail(orderId, cartItem.getProductId(), cartItem.getQuantity(),
                                cartItem.getPrice(), totalPrice, size, color);
                        // Cập nhật số lượng tồn kho của biến thể (giảm đi)
                        if (variantId != null) {
                            dao.ProductVariantDAO variantDAO = new dao.ProductVariantDAO();
                            model.ProductVariant variant = variantDAO.getProductVariantById(variantId);
                            if (variant != null) {
                                int newStock = variant.getQuantity() - cartItem.getQuantity();
                                if (newStock < 0) {
                                    newStock = 0;
                                }
                                variantDAO.updateVariantQuantity(variantId, newStock);
                                // Sau khi cập nhật tồn kho biến thể, cập nhật lại tổng tồn kho sản phẩm cha
                                dao.ProductDAO productDAO2 = new dao.ProductDAO();
                                int newTotalVariantQuantity = productDAO2.getTotalVariantQuantityByProductId(cartItem.getProductId());
                                productDAO2.updateProductQuantity(cartItem.getProductId(), newTotalVariantQuantity);
                            }
                        }
                    }

                    // Xóa giỏ hàng
                    cartDAO.clearCartByUserId(userId);
                    System.out.println("✅ Debug CartServlet - Order placed successfully");
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");

                } catch (Exception e) {
                    System.err.println("❌ Debug CartServlet - Error placing order: " + e.getMessage());
                    e.printStackTrace();

                    String errorMessage = "Lỗi đặt hàng: ";
                    if (e instanceof IllegalArgumentException) {
                        errorMessage += e.getMessage();
                    } else {
                        errorMessage += "Có lỗi xảy ra trong quá trình xử lý đơn hàng.";
                    }

                    request.setAttribute("error", errorMessage);
                    request.getRequestDispatcher("view/cart.jsp").forward(request, response);
                }
            }

            case "updateOrderStatus" -> {
                if (!"Admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/view/accessDenied.jsp");
                    return;
                }
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    orderDAO.updateOrderStatus(orderId, status);
                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewOrders");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/view/order.jsp");
                }
            }

            case "updatequantity" -> {
                try {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    String operation = request.getParameter("operation"); // "increase", "decrease", hoặc "set"

                    // Lấy thông tin giỏ hàng hiện tại
                    List<CartDTO> currentCarts = cartDAO.getCartWithStockInfo(userId);
                    CartDTO currentCart = null;
                    for (CartDTO cart : currentCarts) {
                        if (cart.getCartId() == cartId) {
                            currentCart = cart;
                            break;
                        }
                    }

                    if (currentCart != null) {
                        int newQuantity = currentCart.getQuantity();
                        // Lấy variant tồn kho từ session
                        Map<String, model.ProductVariant> cartVariants = (Map<String, model.ProductVariant>) session.getAttribute("cartVariants");
                        int stockQuantity = currentCart.getStockQuantity();
                        if (cartVariants != null) {
                            String variantKey = currentCart.getProductId() + "_" + (currentCart.getVariantID() != null ? currentCart.getVariantID() : "");
                            model.ProductVariant variant = cartVariants.get(variantKey);
                            if (variant != null) {
                                stockQuantity = variant.getQuantity();
                            }
                        }
                        if ("increase".equals(operation)) {
                            if (newQuantity + 1 > stockQuantity) {
                                session.setAttribute("errorMessage", "Số lượng vượt quá tồn kho của biến thể!");
                                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                                return;
                            }
                            newQuantity = newQuantity + 1;
                        } else if ("decrease".equals(operation)) {
                            newQuantity = Math.max(newQuantity - 1, 1);
                        } else if ("set".equals(operation)) {
                            String quantityStr = request.getParameter("quantity");
                            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                                try {
                                    int inputQuantity = Integer.parseInt(quantityStr);
                                    if (inputQuantity > stockQuantity) {
                                        session.setAttribute("errorMessage", "Số lượng vượt quá tồn kho của biến thể!");
                                        response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                                        return;
                                    }
                                    newQuantity = Math.max(1, inputQuantity);
                                } catch (NumberFormatException e) {
                                    session.setAttribute("errorMessage", "Số lượng không hợp lệ. Vui lòng nhập số từ 1 đến " + stockQuantity);
                                    response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                                    return;
                                }
                            } else {
                                session.setAttribute("errorMessage", "Vui lòng nhập số lượng");
                                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
                                return;
                            }
                        }
                        // Chỉ cập nhật nếu số lượng thay đổi
                        if (newQuantity != currentCart.getQuantity()) {
                            cartDAO.updateCartQuantity(cartId, newQuantity);
                            if (newQuantity >= stockQuantity) {
                                session.setAttribute("warningMessage", "Đã đạt giới hạn tồn kho cho sản phẩm: " + currentCart.getProductName());
                            }
                        }
                    } else {
                        session.setAttribute("errorMessage", "Không tìm thấy sản phẩm trong giỏ hàng");
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật số lượng: " + e.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
            }

            case "updateQuantityAjax" -> {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                try {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    String operation = request.getParameter("operation"); // "increase", "decrease", hoặc "set"
                    int newQuantity = -1;

                    if ("set".equals(operation)) {
                        newQuantity = Integer.parseInt(request.getParameter("quantity"));
                    }

                    // Lấy thông tin giỏ hàng hiện tại
                    List<CartDTO> currentCarts = cartDAO.getCartWithStockInfo(userId);
                    CartDTO currentCart = null;
                    for (CartDTO cart : currentCarts) {
                        if (cart.getCartId() == cartId) {
                            currentCart = cart;
                            break;
                        }
                    }

                    if (currentCart != null) {
                        int currentQuantity = currentCart.getQuantity();

                        if ("increase".equals(operation)) {
                            newQuantity = Math.min(currentQuantity + 1, currentCart.getStockQuantity());
                        } else if ("decrease".equals(operation)) {
                            newQuantity = Math.max(currentQuantity - 1, 1);
                        } else if ("set".equals(operation)) {
                            // Đảm bảo số lượng hợp lệ
                            newQuantity = Math.max(1, Math.min(newQuantity, currentCart.getStockQuantity()));
                        }

                        // Chỉ cập nhật nếu số lượng thay đổi
                        if (newQuantity != currentQuantity) {
                            cartDAO.updateCartQuantity(cartId, newQuantity);

                            // Tính lại tổng giỏ hàng
                            List<CartDTO> updatedCarts = cartDAO.getCartWithStockInfo(userId);
                            double cartTotal = 0;
                            for (CartDTO cart : updatedCarts) {
                                cartTotal += cart.getPrice() * cart.getQuantity();
                            }
                            session.setAttribute("carts", updatedCarts);
                            session.setAttribute("cartTotal", cartTotal);

                            // Trả về JSON response
                            String jsonResponse = String.format(
                                    "{\"success\": true, \"newQuantity\": %d, \"cartTotal\": %.0f, \"isMaxStock\": %s, \"isMinQuantity\": %s, \"stockQuantity\": %d}",
                                    newQuantity, cartTotal,
                                    newQuantity >= currentCart.getStockQuantity() ? "true" : "false",
                                    newQuantity <= 1 ? "true" : "false",
                                    currentCart.getStockQuantity()
                            );
                            response.getWriter().write(jsonResponse);
                        } else {
                            // Không có thay đổi
                            String jsonResponse = String.format(
                                    "{\"success\": true, \"newQuantity\": %d, \"cartTotal\": %.0f, \"isMaxStock\": %s, \"isMinQuantity\": %s, \"stockQuantity\": %d, \"noChange\": true}",
                                    currentQuantity,
                                    (Double) session.getAttribute("cartTotal"),
                                    currentQuantity >= currentCart.getStockQuantity() ? "true" : "false",
                                    currentQuantity <= 1 ? "true" : "false",
                                    currentCart.getStockQuantity()
                            );
                            response.getWriter().write(jsonResponse);
                        }
                    } else {
                        response.getWriter().write("{\"success\": false, \"error\": \"Không tìm thấy sản phẩm trong giỏ hàng\"}");
                    }
                } catch (Exception e) {
                    System.err.println("Error in updateQuantityAjax: " + e.getMessage());
                    e.printStackTrace();
                    response.getWriter().write("{\"success\": false, \"error\": \"Có lỗi xảy ra khi cập nhật số lượng\"}");
                }
                return; // Không redirect
            }

            default ->
                response.sendRedirect(request.getContextPath() + "/CartServlet?action=viewCart");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý giỏ hàng và đơn hàng.";
    }
}
