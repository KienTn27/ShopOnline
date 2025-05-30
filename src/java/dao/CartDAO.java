package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import java.sql.SQLException;
import model.CartDTO;

public class CartDAO {

    private DBContext dbContext = DBContext.getInstance();

    public List<CartDTO> getCartByUserId(int userId) throws SQLException {
        List<CartDTO> carts = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(
                "SELECT c.CartId, c.UserId, c.ProductId, c.Quantity, c.CreatedAt, p.Name AS ProductName, p.Price "
                + "FROM Carts c JOIN Products p ON c.ProductId = p.ProductId WHERE c.UserId = ?")) {
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

    public void updateCartQuantity(int cartId, int quantity) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "UPDATE Carts SET Quantity = ? WHERE CartId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
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
}
