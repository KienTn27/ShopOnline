package dao;

import java.sql.*;
import java.util.*;
import dao.DBContext;
import model.InventoryStat;

public class InventoryDAO {

    public List<InventoryStat> getInventoryStats() {
        List<InventoryStat> list = new ArrayList<>();
        String sql = "SELECT ProductID, Name, Quantity AS StockQuantity FROM Products";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Cập nhật tên và số lượng tồn kho cho sản phẩm
    public void updateInventory(int productId, String productName, int stockQuantity) {
        String sql = "UPDATE Products SET Name = ?, Quantity = ? WHERE ProductID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Thêm sản phẩm mới vào bảng Products
    public void addInventory(String productName, int stockQuantity) {
        String sql = "INSERT INTO Products (Name, Quantity) VALUES (?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productName);
            ps.setInt(2, stockQuantity);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tồn kho có phân trang và lọc
    public List<InventoryStat> getInventoryStatsWithFilter(int page, int pageSize, Integer minQuantity, Integer maxQuantity, String searchName) {
        List<InventoryStat> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM (");
        sql.append("SELECT ProductID, Name, Quantity AS StockQuantity, ");
        sql.append("ROW_NUMBER() OVER (ORDER BY ProductID) AS rn ");
        sql.append("FROM Products WHERE 1=1");

        List<Object> parameters = new ArrayList<>();
        int paramIndex = 1;

        // Thêm điều kiện lọc theo số lượng
        if (minQuantity != null) {
            sql.append(" AND Quantity >= ?");
            parameters.add(minQuantity);
        }
        if (maxQuantity != null) {
            sql.append(" AND Quantity <= ?");
            parameters.add(maxQuantity);
        }

        // Thêm điều kiện lọc theo tên sản phẩm
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND Name LIKE ?");
            parameters.add("%" + searchName.trim() + "%");
        }

        sql.append(") t WHERE rn BETWEEN ? AND ?");

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set các tham số lọc
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            // Set tham số phân trang
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;
            ps.setInt(parameters.size() + 1, start);
            ps.setInt(parameters.size() + 2, end);

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

    // Đếm tổng số sản phẩm tồn kho với lọc
    public int getTotalInventoryCountWithFilter(Integer minQuantity, Integer maxQuantity, String searchName) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Products WHERE 1=1");

        List<Object> parameters = new ArrayList<>();

        // Thêm điều kiện lọc theo số lượng
        if (minQuantity != null) {
            sql.append(" AND Quantity >= ?");
            parameters.add(minQuantity);
        }
        if (maxQuantity != null) {
            sql.append(" AND Quantity <= ?");
            parameters.add(maxQuantity);
        }

        // Thêm điều kiện lọc theo tên sản phẩm
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND Name LIKE ?");
            parameters.add("%" + searchName.trim() + "%");
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set các tham số
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
