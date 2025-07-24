package dao;

import java.sql.*;
import java.util.*;
import dao.DBContext;
import model.InventoryStat;

public class InventoryDAO {

    public List<InventoryStat> getInventoryStats() {
        List<InventoryStat> list = new ArrayList<>();
        String sql = "SELECT ProductID, Name, Quantity AS StockQuantity FROM Products";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InventoryStat stat = new InventoryStat();
                stat.setProductId(rs.getInt("ProductID"));
                stat.setProductName(rs.getString("Name"));
                stat.setStockQuantity(rs.getInt("StockQuantity"));
                list.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tồn kho có phân trang
    public List<InventoryStat> getInventoryStatsPage(int page, int pageSize) {
        List<InventoryStat> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT ProductID, Name, Quantity AS StockQuantity, ROW_NUMBER() OVER (ORDER BY ProductID) AS rn FROM Products) t WHERE rn BETWEEN ? AND ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryStat stat = new InventoryStat();
                stat.setProductId(rs.getInt("ProductID"));
                stat.setProductName(rs.getString("Name"));
                stat.setStockQuantity(rs.getInt("StockQuantity"));
                list.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số sản phẩm tồn kho
    public int getTotalInventoryCount() {
        String sql = "SELECT COUNT(*) FROM Products";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Cập nhật tên và số lượng tồn kho cho sản phẩm
    public void updateInventory(int productId, String productName, int stockQuantity) {
        String sql = "UPDATE Products SET Name = ?, Quantity = ? WHERE ProductID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productName);
            ps.setInt(2, stockQuantity);
            ps.setInt(3, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa sản phẩm khỏi bảng Products theo ProductID
    public void deleteInventory(int productId) {
        String sql = "DELETE FROM Products WHERE ProductID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Thêm sản phẩm mới vào bảng Products
    public void addInventory(String productName, int stockQuantity) {
        String sql = "INSERT INTO Products (Name, Quantity) VALUES (?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productName);
            ps.setInt(2, stockQuantity);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
