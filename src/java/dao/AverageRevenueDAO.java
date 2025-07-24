/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.RevenueStat;

public class AverageRevenueDAO {

    // Phương thức tính doanh thu trung bình/ngày
    public List<RevenueStat> getAverageRevenueByDay() {
        List<RevenueStat> list = new ArrayList<>();
        String sql = "SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Day, "
                + "COUNT(*) AS TotalOrders, "
                + "SUM(TotalAmount) AS TotalRevenue, "
                + "AVG(TotalAmount) AS AvgRevenue "
                + "FROM Orders "
                + "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') "
                + "ORDER BY Day";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String day = rs.getString("Day");
                int totalOrders = rs.getInt("TotalOrders");
                double totalRevenue = rs.getDouble("TotalRevenue");
                double avgRevenue = rs.getDouble("AvgRevenue");

                list.add(new RevenueStat(java.sql.Date.valueOf(day), totalOrders, totalRevenue, avgRevenue));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy doanh thu trung bình/ngày có phân trang
    public List<RevenueStat> getAverageRevenueByDayPage(int page, int pageSize) {
        List<RevenueStat> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Day, COUNT(*) AS TotalOrders, SUM(TotalAmount) AS TotalRevenue, AVG(TotalAmount) AS AvgRevenue, ROW_NUMBER() OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM-dd')) AS rn FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd')) t WHERE rn BETWEEN ? AND ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String day = rs.getString("Day");
                int totalOrders = rs.getInt("TotalOrders");
                double totalRevenue = rs.getDouble("TotalRevenue");
                double avgRevenue = rs.getDouble("AvgRevenue");
                list.add(new RevenueStat(java.sql.Date.valueOf(day), totalOrders, totalRevenue, avgRevenue));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số ngày có doanh thu
    public int getTotalAverageRevenueCount() {
        String sql = "SELECT COUNT(*) FROM (SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Day FROM Orders GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd')) t";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
