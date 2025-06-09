package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Order;

public class OrderDAO {

    private DBContext dbContext = DBContext.getInstance();

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT * FROM Orders";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setShippingAddress(rs.getString("ShippingAddress"));
                order.setStatus(rs.getString("Status"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT * FROM Orders WHERE Status = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setShippingAddress(rs.getString("ShippingAddress"));
                order.setStatus(rs.getString("Status"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT * FROM Orders WHERE OrderId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setShippingAddress(rs.getString("ShippingAddress"));
                order.setStatus(rs.getString("Status"));
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void placeOrder(int userId, int productId, int quantity) throws SQLException {
        String sql = "INSERT INTO Orders (UserID, OrderDate, Status, TotalAmount, ShippingAddress) VALUES (?, GETDATE(), ?, ?, ?)";
        String detailSql = "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
        Connection conn = dbContext.getConnection();
        try {
            conn.setAutoCommit(false);

            // Thêm đơn hàng
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setString(2, "Pending");
                stmt.setDouble(3, 0.0); // TotalAmount tạm thời
                stmt.setString(4, "Default Address");
                stmt.executeUpdate();

                ResultSet rs = stmt.getGeneratedKeys();
                int orderId = 0;
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }

                // Thêm chi tiết đơn hàng
                try (PreparedStatement detailStmt = conn.prepareStatement(detailSql)) {
                    detailStmt.setInt(1, orderId);
                    detailStmt.setInt(2, productId);
                    detailStmt.setInt(3, quantity);
                    detailStmt.setDouble(4, 0.0); // UnitPrice tạm thời
                    detailStmt.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Orders WHERE UserId = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("OrderId"));
                    order.setUserId(rs.getInt("UserId"));
                    order.setOrderDate(rs.getTimestamp("OrderDate"));
                    order.setTotalAmount(rs.getDouble("TotalAmount"));
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setStatus(rs.getString("Status"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public void createOrder(int userId, double totalAmount, String shippingAddress) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "INSERT INTO Orders (UserId, OrderDate, TotalAmount, ShippingAddress) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setDate(2, new java.sql.Date(new Date().getTime()));
            ps.setDouble(3, totalAmount);
            ps.setString(4, shippingAddress);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateOrderStatus(int orderId, String status) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
