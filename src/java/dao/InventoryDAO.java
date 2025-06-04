package dao;

import java.sql.*;
import java.util.*;
import dao.DBContext;
import model.InventoryStat;

public class InventoryDAO {

    public List<InventoryStat> getInventoryStats() {
        List<InventoryStat> list = new ArrayList<>();
        String sql = "SELECT p.ProductID, p.Name, ISNULL(SUM(CASE " +
                     "WHEN il.ChangeType = 'Add' THEN il.Quantity " +
                     "WHEN il.ChangeType = 'Remove' THEN -il.Quantity " +
                     "ELSE 0 END), 0) AS StockQuantity " +
                     "FROM Products p " +
                     "LEFT JOIN Inventory_Logs il ON p.ProductID = il.ProductID " +
                     "GROUP BY p.ProductID, p.Name " +
                     "HAVING ISNULL(SUM(CASE " +
                     "WHEN il.ChangeType = 'Add' THEN il.Quantity " +
                     "WHEN il.ChangeType = 'Remove' THEN -il.Quantity " +
                     "ELSE 0 END), 0) > 0";
try (Connection conn = new DBContext().getConnection()) {
    PreparedStatement ps = conn.prepareStatement(sql);
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
}
