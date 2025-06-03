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
        String sql = "SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS Day, " +
                     "COUNT(*) AS TotalOrders, " +
                     "SUM(TotalAmount) AS TotalRevenue, " +
                     "AVG(TotalAmount) AS AvgRevenue " +
                     "FROM Orders " +
                     "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') " +
                     "ORDER BY Day";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
}
