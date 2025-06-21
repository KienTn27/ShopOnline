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
        String query = "INSERT INTO Carts (UserId, ProductId, Quantity, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        } catch (Exception e) {
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
                return rs.getInt("Quantity");
            }
        } catch (Exception e) {
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
                }
            }
        }
        return carts;
    }
}
