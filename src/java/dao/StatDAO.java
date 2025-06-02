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

import dao.DBContext;
import model.TopProduct;

public class StatDAO {

    /**
     * Lấy danh sách sản phẩm bán chạy (tổng số lượng đã bán và doanh thu).
     * @return List<TopProduct>
     */
    public List<TopProduct> getTopSellingProducts() {
        List<TopProduct> list = new ArrayList<>();
        String sql = "SELECT " +
                     "    p.Name AS ProductName, " +
                     "    SUM(od.Quantity) AS SoldQuantity, " +
                     "    SUM(od.TotalPrice) AS Revenue " +
                     "FROM [Shop].[dbo].[OrderDetails] od " +
                     "JOIN [Shop].[dbo].[Products] p ON od.ProductID = p.ProductID " +
                     "GROUP BY p.Name " +
                     "ORDER BY SoldQuantity DESC";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String name = rs.getString("ProductName");
                int quantity = rs.getInt("SoldQuantity");
                double revenue = rs.getDouble("Revenue");

                list.add(new TopProduct(name, quantity, revenue));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
