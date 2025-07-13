package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import java.sql.SQLException;
import model.CartDTO;
import model.Product;

public class CartDAO {

    private DBContext dbContext = DBContext.getInstance();

    public List<CartDTO> getCartByUserId(int userId) throws SQLException {
        List<CartDTO> carts = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(
                "SELECT c.CartId, c.UserId, c.ProductId, c.Quantity, c.CreatedAt, "
                + "p.Name AS ProductName, p.Price, p.ImageURL, p.CategoryID "
                + "FROM Carts c JOIN Products p ON c.ProductId = p.ProductId "
                + "WHERE c.UserId = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartDTO cart = new CartDTO();
                    cart.setCartId(rs.getInt("CartId"));
                    cart.setUserId(rs.getInt("UserId"));
                    cart.setProductId(rs.getInt("ProductId"));
                    cart.setQuantity(rs.getInt("Quantity"));
                    cart.setCreatedAt(rs.getDate("CreatedAt"));
                    cart.setProductName(rs.getString("ProductName"));
                    cart.setPrice(rs.getDouble("Price"));
                    cart.setImageURL(rs.getString("ImageURL"));
                    cart.setCategoryId(rs.getInt("CategoryID")); // ✅ dòng quan trọng
                    carts.add(cart);
                }
            }
        }
        return carts;
    }

    public void clearCartByUserId(int userId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "DELETE FROM Carts WHERE UserId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addToCart(int userId, int productId, int quantity) {
        Connection conn = DBContext.getInstance().getConnection();
        
        System.out.println("Debug CartDAO - Adding to cart: UserId=" + userId + ", ProductId=" + productId + ", Quantity=" + quantity);
        
        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        String checkQuery = "SELECT CartId, Quantity FROM Carts WHERE UserId = ? AND ProductId = ?";
        String insertQuery = "INSERT INTO Carts (UserId, ProductId, Quantity, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        String updateQuery = "UPDATE Carts SET Quantity = ? WHERE CartId = ?";
        
        try (PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {
            checkPs.setInt(1, userId);
            checkPs.setInt(2, productId);
            
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Sản phẩm đã có trong giỏ hàng, cập nhật số lượng
                    int cartId = rs.getInt("CartId");
                    int currentQuantity = rs.getInt("Quantity");
                    int newQuantity = currentQuantity + quantity;
                    
                    System.out.println("Debug CartDAO - Product exists in cart: CartId=" + cartId + ", CurrentQty=" + currentQuantity + ", NewQty=" + newQuantity);
                    
                    // Kiểm tra số lượng tồn kho
                    int stockQuantity = getProductStock(productId);
                    if (newQuantity > stockQuantity) {
                        newQuantity = stockQuantity;
                        System.out.println("Debug CartDAO - Adjusted quantity to stock limit: " + newQuantity);
                    }
                    
                    try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                        updatePs.setInt(1, newQuantity);
                        updatePs.setInt(2, cartId);
                        updatePs.executeUpdate();
                        System.out.println("Debug CartDAO - Updated cart quantity successfully");
                    }
                } else {
                    // Sản phẩm chưa có trong giỏ hàng, thêm mới
                    System.out.println("Debug CartDAO - Product not in cart, adding new item");
                    
                    // Kiểm tra số lượng tồn kho trước khi thêm
                    int stockQuantity = getProductStock(productId);
                    if (quantity > stockQuantity) {
                        quantity = stockQuantity;
                        System.out.println("Debug CartDAO - Adjusted quantity to stock limit: " + quantity);
                    }
                    
                    try (PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, productId);
                        insertPs.setInt(3, quantity);
                        insertPs.executeUpdate();
                        System.out.println("Debug CartDAO - Added new cart item successfully");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Debug CartDAO - Error in addToCart: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteCartItem(int cartId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "DELETE FROM Carts WHERE CartId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateCartQuantity(int cartId, int quantity) {
        Connection conn = DBContext.getInstance().getConnection();

        // Kiểm tra số lượng tồn kho trước khi cập nhật
        String checkStockQuery = "SELECT p.Quantity AS StockQuantity, c.Quantity AS CurrentQuantity "
                + "FROM Carts c "
                + "JOIN Products p ON c.ProductId = p.ProductId "
                + "WHERE c.CartId = ?";

        try (PreparedStatement checkPs = conn.prepareStatement(checkStockQuery)) {
            checkPs.setInt(1, cartId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int stockQuantity = rs.getInt("StockQuantity");
                int currentQuantity = rs.getInt("CurrentQuantity");

                // Kiểm tra giới hạn
                if (quantity < 1) {
                    quantity = 1; // Không cho phép < 1
                } else if (quantity > stockQuantity) {
                    quantity = stockQuantity; // Không cho phép vượt quá tồn kho
                }

                // Cập nhật số lượng
                String updateQuery = "UPDATE Carts SET Quantity = ? WHERE CartId = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                    updatePs.setInt(1, quantity);
                    updatePs.setInt(2, cartId);
                    updatePs.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy số lượng tồn kho của sản phẩm
     *
     * @param productId ID của sản phẩm
     * @return Số lượng tồn kho
     */
    public int getProductStock(int productId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT Quantity FROM Products WHERE ProductId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int stock = rs.getInt("Quantity");
                System.out.println("Debug CartDAO - getProductStock: ProductId=" + productId + ", Stock=" + stock);
                return stock;
            }
        } catch (Exception e) {
            System.err.println("Debug CartDAO - Error in getProductStock: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy thông tin chi tiết giỏ hàng bao gồm số lượng tồn kho
     *
     * @param userId ID của người dùng
     * @return Danh sách giỏ hàng với thông tin tồn kho
     */
    public List<CartDTO> getCartWithStockInfo(int userId) throws SQLException {
        List<CartDTO> carts = new ArrayList<>();
        System.out.println("🔍 Debug CartDAO - Getting cart with stock info for userId: " + userId);
        
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(
                "SELECT c.CartId, c.UserId, c.ProductId, c.Quantity, c.CreatedAt, "
                + "p.Name AS ProductName, p.Price, p.ImageURL, p.CategoryID, p.Quantity AS StockQuantity "
                + "FROM Carts c JOIN Products p ON c.ProductId = p.ProductId "
                + "WHERE c.UserId = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartDTO cart = new CartDTO();
                    cart.setCartId(rs.getInt("CartId"));
                    cart.setUserId(rs.getInt("UserId"));
                    cart.setProductId(rs.getInt("ProductId"));
                    cart.setQuantity(rs.getInt("Quantity"));
                    cart.setCreatedAt(rs.getDate("CreatedAt"));
                    cart.setProductName(rs.getString("ProductName"));
                    cart.setPrice(rs.getDouble("Price"));
                    cart.setImageURL(rs.getString("ImageURL"));
                    cart.setCategoryId(rs.getInt("CategoryID"));
                    cart.setStockQuantity(rs.getInt("StockQuantity")); // Thêm thông tin tồn kho
                    carts.add(cart);
                    System.out.println("🔍 Debug CartDAO - Added cart item: CartId=" + cart.getCartId() + ", ProductId=" + cart.getProductId() + ", Quantity=" + cart.getQuantity());
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Debug CartDAO - Error in getCartWithStockInfo: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        System.out.println("🔍 Debug CartDAO - Total cart items found: " + carts.size());
        return carts;
    }

    /**
     * Kiểm tra sản phẩm đã có trong giỏ hàng chưa
     * @param userId ID của người dùng
     * @param productId ID của sản phẩm
     * @return true nếu sản phẩm đã có trong giỏ hàng, false nếu chưa
     */
    public boolean isProductInCart(int userId, int productId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT COUNT(*) FROM Carts WHERE UserId = ? AND ProductId = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("Debug CartDAO - isProductInCart: UserId=" + userId + ", ProductId=" + productId + ", Count=" + count);
                    return count > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Debug CartDAO - Error in isProductInCart: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy số lượng sản phẩm trong giỏ hàng
     * @param userId ID của người dùng
     * @param productId ID của sản phẩm
     * @return Số lượng sản phẩm trong giỏ hàng, 0 nếu không có
     */
    public int getProductQuantityInCart(int userId, int productId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT Quantity FROM Carts WHERE UserId = ? AND ProductId = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int quantity = rs.getInt("Quantity");
                    System.out.println("Debug CartDAO - getProductQuantityInCart: UserId=" + userId + ", ProductId=" + productId + ", Quantity=" + quantity);
                    return quantity;
                }
            }
        } catch (Exception e) {
            System.err.println("Debug CartDAO - Error in getProductQuantityInCart: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
