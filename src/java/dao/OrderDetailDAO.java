/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetail;
import model.OrderDetailView;

/**
 * DAO cho bảng OrderDetails
 */
public class OrderDetailDAO {

    /**
     * Lấy danh sách OrderDetailView theo OrderId (với thông tin sản phẩm)
     */
    public List<OrderDetailView> getOrderDetailViewsByOrderId(int orderId) {
        List<OrderDetailView> orderDetails = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT od.OrderDetailId, od.OrderId, od.ProductId, "
                + "p.Name AS ProductName, p.ImageURL AS ImageUrl, "
                + "od.Quantity, od.UnitPrice, od.TotalPrice, od.Size, od.Color "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.ProductId = p.ProductId "
                + "WHERE od.OrderId = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetailView detail = new OrderDetailView();
                detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                detail.setOrderId(rs.getInt("OrderId"));
                detail.setProductId(rs.getInt("ProductId"));
                detail.setProductName(rs.getString("ProductName"));
                detail.setImageUrl(rs.getString("ImageUrl"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setTotalPrice(rs.getDouble("TotalPrice"));
                detail.setSize(rs.getString("Size"));
                detail.setColor(rs.getString("Color"));
                orderDetails.add(detail);
            }
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error in getOrderDetailViewsByOrderId: " + e.getMessage());
            e.printStackTrace();
        }

        return orderDetails;
    }

    /**
     * Lấy danh sách OrderDetail theo OrderId
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT OrderDetailId, OrderId, ProductId, Quantity, UnitPrice, TotalPrice, Size, Color "
                + "FROM OrderDetails WHERE OrderId = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                detail.setOrderId(rs.getInt("OrderId"));
                detail.setProductId(rs.getInt("ProductId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setTotalPrice(rs.getDouble("TotalPrice"));
                detail.setSize(rs.getString("Size"));
                detail.setColor(rs.getString("Color"));
                orderDetails.add(detail);
            }
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error in getOrderDetailsByOrderId: " + e.getMessage());
            e.printStackTrace();
        }

        return orderDetails;
    }

    /**
     * Kiểm tra sản phẩm có tồn tại không
     */
    public boolean productExists(int productId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT COUNT(*) FROM Products WHERE ProductId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error checking product existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm OrderDetail mới
     */
    public void addOrderDetail(int orderId, int productId, int quantity, double unitPrice, 
                              double totalPrice, String size, String color) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice, TotalPrice, Size, Color) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("🔍 Debug OrderDetailDAO - Adding order detail: orderId=" + orderId + 
                          ", productId=" + productId + ", quantity=" + quantity + 
                          ", unitPrice=" + unitPrice + ", totalPrice=" + totalPrice + 
                          ", size=" + size + ", color=" + color);
        
        // Kiểm tra validation
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }
        
        if (unitPrice < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative");
        }
        
        if (totalPrice < 0) {
            throw new IllegalArgumentException("Total price cannot be negative");
        }
        
        // Kiểm tra order tồn tại
        OrderDAO orderDAO = new OrderDAO();
        if (!orderDAO.orderExists(orderId)) {
            throw new IllegalArgumentException("Order with ID " + orderId + " does not exist");
        }
        
        // Kiểm tra product tồn tại
        if (!productExists(productId)) {
            throw new IllegalArgumentException("Product with ID " + productId + " does not exist");
        }
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDouble(4, unitPrice);
            ps.setDouble(5, totalPrice);
            ps.setString(6, size);
            ps.setString(7, color);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Debug OrderDetailDAO - Order detail added successfully. Rows affected: " + rowsAffected);
            
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error adding order detail: " + e.getMessage());
            System.err.println("❌ Debug OrderDetailDAO - OrderId: " + orderId + ", ProductId: " + productId + 
                              ", Quantity: " + quantity + ", UnitPrice: " + unitPrice + 
                              ", TotalPrice: " + totalPrice + ", Size: " + size + ", Color: " + color);
            e.printStackTrace();
            throw new RuntimeException("Failed to add order detail", e);
        }
    }

    /**
     * Cập nhật OrderDetail
     */
    public boolean updateOrderDetail(int orderDetailId, int quantity, double unitPrice, 
                                   double totalPrice, String size, String color) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "UPDATE OrderDetails SET Quantity = ?, UnitPrice = ?, TotalPrice = ?, Size = ?, Color = ? "
                + "WHERE OrderDetailId = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setDouble(2, unitPrice);
            ps.setDouble(3, totalPrice);
            ps.setString(4, size);
            ps.setString(5, color);
            ps.setInt(6, orderDetailId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Debug OrderDetailDAO - Order detail updated successfully. Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error updating order detail: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa OrderDetail
     */
    public boolean deleteOrderDetail(int orderDetailId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "DELETE FROM OrderDetails WHERE OrderDetailId = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderDetailId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Debug OrderDetailDAO - Order detail deleted successfully. Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error deleting order detail: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy OrderDetail theo ID
     */
    public OrderDetail getOrderDetailById(int orderDetailId) {
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT OrderDetailId, OrderId, ProductId, Quantity, UnitPrice, TotalPrice, Size, Color "
                + "FROM OrderDetails WHERE OrderDetailId = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderDetailId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                detail.setOrderId(rs.getInt("OrderId"));
                detail.setProductId(rs.getInt("ProductId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setTotalPrice(rs.getDouble("TotalPrice"));
                detail.setSize(rs.getString("Size"));
                detail.setColor(rs.getString("Color"));
                return detail;
            }
        } catch (Exception e) {
            System.err.println("❌ Debug OrderDetailDAO - Error getting order detail by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
