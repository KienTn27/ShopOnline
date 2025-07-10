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

    
    
   public List<Review> getReviewsByProductId(int productId) {
    List<Review> reviews = new ArrayList<>();
    String sql = """
        SELECT r.ReviewID, u.Username, p.Name as ProductName, 
               r.Comment, r.Rating, r.CreatedAt
        FROM Reviews r
        LEFT JOIN Users u ON r.UserID = u.UserID
        LEFT JOIN Products p ON r.ProductID = p.ProductID
        WHERE r.ProductID = ?
        ORDER BY r.CreatedAt DESC
    """;

    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {
        
        st.setInt(1, productId);

        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Review review = new Review(
                    rs.getInt("ReviewID"),
                    rs.getString("Username"),        // giữ nguyên Username
                    rs.getString("ProductName"),
                    rs.getString("Comment"),
                    rs.getInt("Rating"),
                    rs.getTimestamp("CreatedAt")
                );
                reviews.add(review);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error getting reviews by product ID: " + e.getMessage());
        e.printStackTrace();
    }

    return reviews;
}

    
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
    
    
    
     public static void main(String[] args) {
        ReviewDAO dao = new ReviewDAO();
        
        // Test getting reviews for product ID 1
        List<Review> reviews = dao.getReviewsByProductId(2);
        System.out.println("Found " + reviews.size() + " reviews for product 1:");
        
        for (Review review : reviews) {
            System.out.println("- " + review.getUserName() + " (" + review.getRating() + "★): " + 
                             review.getComment());
        }
        
//        // Test getting statistics
//        ReviewStatistics stats = dao.getReviewStatistics(1);
//        System.out.println("\nReview Statistics:");
//        System.out.println("Total: " + stats.getTotalReviews());
//        System.out.println("Average: " + stats.getFormattedAverageRating());
//        System.out.println("5 Stars: " + stats.getFiveStars());
//        System.out.println("4 Stars: " + stats.getFourStars());
//        System.out.println("3 Stars: " + stats.getThreeStars());
//        System.out.println("2 Stars: " + stats.getTwoStars());
//        System.out.println("1 Star: " + stats.getOneStar());
//        
//        // Test adding a new review
//        boolean added = dao.addReview(1, 1, 5, "Sản phẩm tuyệt vời!");
//        System.out.println("\nAdd review result: " + added);
//        
//        // Test checking if user has reviewed
//        boolean hasReviewed = dao.hasUserReviewedProduct(1, 1);
//        System.out.println("User has reviewed: " + hasReviewed);
    }
    
}

