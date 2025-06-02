/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.ProductSalesStat;

public class ProductSalesDAO {

    // Phương thức tính số sản phẩm bán ra/ngày
    public List<ProductSalesStat> getProductSalesByDay() {
        List<ProductSalesStat> list = new ArrayList<>();
        String sql = "SELECT FORMAT(OrderDate, 'yyyy-MM-dd') AS SaleDate, " +
                     "SUM(Quantity) AS TotalQuantity " +
                     "FROM Orders o " +
                     "JOIN OrderDetails od ON o.OrderID = od.OrderID " +
                     "GROUP BY FORMAT(OrderDate, 'yyyy-MM-dd') " +
                     "ORDER BY SaleDate";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String saleDate = rs.getString("SaleDate");
                int totalQuantity = rs.getInt("TotalQuantity");

                list.add(new ProductSalesStat(saleDate, totalQuantity));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
