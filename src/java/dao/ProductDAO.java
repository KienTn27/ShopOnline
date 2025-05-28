/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

/**
 *
 * @author X1 carbon Gen6
 */
public class ProductDAO {

    private DBContext dbContext = DBContext.getInstance();

    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("ProductID"));
                p.setName(rs.getString("name"));
                p.setCategoryId(rs.getString("CategoryID"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("Price"));
                p.setQuantity(rs.getInt("Quantity"));
                p.setImageUrl(rs.getString("ImageURL"));
                p.setIsActive(rs.getBoolean("isActive"));
                products.add(p);
            }
        }
        return products;
    }

}
