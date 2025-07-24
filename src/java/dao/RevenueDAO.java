/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.RevenueStat;
import dao.DBContext;

public class RevenueDAO {
    public List<RevenueStat> getRevenueBy(String type) {
        List<RevenueStat> list = new ArrayList<>();
        String sql = "";

     if (type != null && type.equals("day")) {
    // Thống kê doanh thu theo ngày
    sql = "SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Label, " +
          "COUNT(*) AS TotalOrders, " +
          "SUM(TotalAmount) AS TotalRevenue " +
          "FROM Orders " +
          "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') " +
          "ORDER BY Label";
} else {
    // Thống kê doanh thu theo tháng
    sql = "SELECT FORMAT(OrderDate, 'yyyy-MM') AS Label, " +
          "COUNT(*) AS TotalOrders, " +
          "SUM(TotalAmount) AS TotalRevenue " +
          "FROM Orders " +
          "GROUP BY FORMAT(OrderDate, 'yyyy-MM') " +
          "ORDER BY Label";
}

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String label = rs.getString("Label");
                int totalOrders = rs.getInt("TotalOrders");
                double revenue = rs.getDouble("TotalRevenue");
                list.add(new RevenueStat(label, totalOrders, revenue));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lấy doanh thu có phân trang
    public List<RevenueStat> getRevenueByPage(String type, int page, int pageSize) {
        List<RevenueStat> list = new ArrayList<>();
        String sql = "";
        if (type != null && type.equals("day")) {
            sql = "SELECT * FROM (SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Label, COUNT(*) AS TotalOrders, SUM(TotalAmount) AS TotalRevenue, ROW_NUMBER() OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM-dd')) AS rn FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd')) t WHERE rn BETWEEN ? AND ?";
        } else {
            sql = "SELECT * FROM (SELECT FORMAT(OrderDate, 'yyyy-MM') AS Label, COUNT(*) AS TotalOrders, SUM(TotalAmount) AS TotalRevenue, ROW_NUMBER() OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM')) AS rn FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM')) t WHERE rn BETWEEN ? AND ?";
        }
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String label = rs.getString("Label");
                int totalOrders = rs.getInt("TotalOrders");
                double revenue = rs.getDouble("TotalRevenue");
                list.add(new RevenueStat(label, totalOrders, revenue));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm đếm tổng số dòng doanh thu
    public int getTotalRevenueCount(String type) {
        String sql = "";
        if (type != null && type.equals("day")) {
            sql = "SELECT COUNT(*) FROM (SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Label FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd')) t";
        } else {
            sql = "SELECT COUNT(*) FROM (SELECT FORMAT(OrderDate, 'yyyy-MM') AS Label FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM')) t";
        }
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

