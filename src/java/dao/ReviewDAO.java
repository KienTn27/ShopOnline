/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.DBContext;
import model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
     String sql = """
    SELECT r.ReviewID, u.FullName, p.Name AS ProductName, r.Comment, r.Rating, r.CreatedAt
    FROM Reviews r
    JOIN Users u ON r.UserID = u.UserID
    JOIN Products p ON r.ProductID = p.ProductID
    ORDER BY r.CreatedAt DESC
    """;


        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Review(
                        rs.getInt("ReviewID"),
                        rs.getString("FullName"),
                        rs.getString("ProductName"),
                        rs.getString("Comment"),
                        rs.getInt("Rating"),
                        rs.getTimestamp("CreatedAt")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

