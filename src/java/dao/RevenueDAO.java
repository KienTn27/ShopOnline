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
}

