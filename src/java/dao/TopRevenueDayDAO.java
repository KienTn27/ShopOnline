package dao;

import java.sql.*;
import model.TopRevenueDay;

public class TopRevenueDayDAO {

    // Phương thức lấy ngày có doanh thu cao nhất
    public TopRevenueDay getHighestRevenueDay() {
        TopRevenueDay result = null;
        String sql = "SELECT TOP 1 FORMAT(OrderDate, 'yyyy-MM-dd') AS Day, " +
                     "SUM(TotalAmount) AS TotalRevenue " +
                     "FROM Orders " +
                     "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') " +
                     "ORDER BY TotalRevenue DESC";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String day = rs.getString("Day");
                double totalRevenue = rs.getDouble("TotalRevenue");
                result = new TopRevenueDay(day, totalRevenue);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // Phương thức lấy ngày có doanh thu thấp nhất
    public TopRevenueDay getLowestRevenueDay() {
        TopRevenueDay result = null;
        String sql = "SELECT TOP 1 FORMAT(OrderDate, 'yyyy-MM-dd') AS Day, " +
                     "SUM(TotalAmount) AS TotalRevenue " +
                     "FROM Orders " +
                     "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') " +
                     "ORDER BY TotalRevenue ASC";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String day = rs.getString("Day");
                double totalRevenue = rs.getDouble("TotalRevenue");
                result = new TopRevenueDay(day, totalRevenue);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
