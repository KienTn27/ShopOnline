package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;

public class CartDAO {

    public List<Cart> getCartByUserId(int userId) {
        List<Cart> carts = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT c.*, p.ProductName, p.Price FROM Carts c JOIN Products p ON c.ProductId = p.ProductId WHERE c.UserId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cart cart = new Cart();
                    cart.setCartId(rs.getInt("CartId"));
                    cart.setUserId(rs.getInt("UserId"));
                    cart.setProductId(rs.getInt("ProductId"));
                    cart.setQuantity(rs.getInt("Quantity"));
                    cart.setCreatedAt(rs.getDate("CreatedAt"));
                    cart.setPrice(rs.getDouble("Price"));
                    cart.setProductName(rs.getString("ProductName"));
                    carts.add(cart);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
