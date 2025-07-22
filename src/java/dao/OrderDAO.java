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

    public int createOrder(int userId, double totalAmount, String shippingAddress) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "INSERT INTO Orders (UserId, OrderDate, TotalAmount, ShippingAddress, Status) VALUES (?, ?, ?, ?, 'Pending')";
        try (PreparedStatement ps = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setDate(2, new java.sql.Date(new Date().getTime()));
            ps.setDouble(3, totalAmount);
            ps.setString(4, shippingAddress);
            
            System.out.println("🔍 Debug OrderDAO - Creating order: userId=" + userId + ", totalAmount=" + totalAmount + ", shippingAddress=" + shippingAddress);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("🔍 Debug OrderDAO - Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        System.out.println("✅ Debug OrderDAO - Order created successfully with ID: " + orderId);
                        return orderId;
                    }
                }
            }
            
            System.err.println("❌ Debug OrderDAO - Failed to get generated order ID");
            return -1;
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDAO - Error creating order: " + e.getMessage());
            e.printStackTrace();
            return -1;
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

    public int getUserIdByOrderId(int orderId) {
        int userId = -1;
        try (Connection conn = dbContext.getConnection()) {
            String sql = "SELECT UserID FROM Orders WHERE OrderID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("userId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userId;
    }

    public boolean cancelOrder(int orderId, int userId) {
        Connection conn = DBContext.getInstance().getConnection();

        String checkQuery = "SELECT Status FROM Orders WHERE OrderID = ? AND UserID = ?";
        try (PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {
            checkPs.setInt(1, orderId);
            checkPs.setInt(2, userId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                String status = rs.getString("Status");
                // Chỉ cho phép hủy khi đơn hàng chưa được giao
                if ("Pending".equals(status) || "Processing".equals(status) || "Confirmed".equals(status)) {
                    // Cập nhật trạng thái đơn hàng thành "Cancelled"
                    String updateQuery = "UPDATE Orders SET Status = 'Cancelled' WHERE OrderID = ? AND UserID = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                        updatePs.setInt(1, orderId);
                        updatePs.setInt(2, userId);
                        int rowsAffected = updatePs.executeUpdate();
                        return rowsAffected > 0;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean canCancelOrder(int orderId, int userId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT Status FROM Orders WHERE OrderID = ? AND UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("Status");
                // Chỉ cho phép hủy khi đơn hàng chưa được giao
                return "Pending".equals(status) || "Processing".equals(status) || "Confirmed".equals(status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean orderExists(int orderId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT COUNT(*) FROM Orders WHERE OrderId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDAO - Error checking order existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int getLastOrderId(int userId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT TOP 1 OrderID FROM Orders WHERE UserID = ? ORDER BY OrderID DESC";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("OrderID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Kiểm tra đơn hàng có thuộc về user không
     */
    public boolean orderBelongsToUser(int orderId, int userId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT COUNT(*) FROM Orders WHERE OrderID = ? AND UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy trạng thái đơn hàng
     */
    public String getOrderStatus(int orderId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT Status FROM Orders WHERE OrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Status");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
