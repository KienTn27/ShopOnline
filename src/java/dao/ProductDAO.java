package dao;

 Doanhthu
import java.sql.*;
import java.util.*;
import model.Product;
import model.TopProduct;

public class ProductDAO {

    // Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setCategoryId(rs.getString("CategoryID"));
                p.setDescription(rs.getString("Description"));
                p.setPrice(rs.getDouble("Price"));
                p.setQuantity(rs.getInt("Quantity"));
                p.setImageUrl(rs.getString("ImageURL"));
                p.setActive(rs.getBoolean("IsActive"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách sản phẩm bán chạy
    public List<TopProduct> getTopSellingProducts() {
        List<TopProduct> list = new ArrayList<>();
        String sql = """
            SELECT p.Name AS ProductName, 
                   SUM(od.Quantity) AS SoldQuantity, 
                   SUM(od.Quantity * p.Price) AS Revenue
            FROM OrderDetails od
            JOIN Products p ON od.ProductID = p.ProductID
            GROUP BY p.Name
            ORDER BY SoldQuantity DESC
            """;

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

 main
}
