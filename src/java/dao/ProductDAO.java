package dao;

import dao.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Product;
import model.TopProduct;

/**
 * ProductDAO - Data Access Object for Product management
 * @author truon
 */
public class ProductDAO extends DBContext {

    public ProductDAO() {
        super();
    }

    /**
     * Get all products with pagination support
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY CreatedAt DESC";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get product by ID
     */
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Products WHERE ProductID = ?";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Search products by name, description or category
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.* FROM Products p 
            LEFT JOIN Categories c ON p.CategoryID = c.CategoryID 
            WHERE p.Name LIKE ? 
               OR p.Description LIKE ? 
               OR c.Name LIKE ?
            ORDER BY p.CreatedAt DESC
        """;
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);
            st.setString(3, searchPattern);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products by category
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE CategoryID = ? AND IsActive = 1 ORDER BY CreatedAt DESC";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by category: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products with price filter
     */
    public List<Product> getProductsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE Price BETWEEN ? AND ? AND IsActive = 1 ORDER BY Price ASC";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBigDecimal(1, minPrice);
            st.setBigDecimal(2, maxPrice);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by price range: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Add new product
     */
    public boolean addProduct(Product product) {
        String sql = """
            INSERT INTO Products (Name, CategoryID, Description, Price, Quantity, ImageURL, IsActive, CreatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, product.getName());
            st.setObject(2, product.getCategoryID()); // Handle null
            st.setString(3, product.getDescription());
            st.setBigDecimal(4, product.getPrice());
            st.setInt(5, product.getQuantity());
            st.setString(6, product.getImageURL());
            st.setObject(7, product.getIsActive() != null ? product.getIsActive() : true);
            st.setTimestamp(8, new Timestamp(new Date().getTime()));
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing product
     */
    public boolean updateProduct(Product product) {
        String sql = """
            UPDATE Products 
            SET Name = ?, CategoryID = ?, Description = ?, Price = ?, 
                Quantity = ?, ImageURL = ?, IsActive = ?
            WHERE ProductID = ?
        """;
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, product.getName());
            st.setObject(2, product.getCategoryID());
            st.setString(3, product.getDescription());
            st.setBigDecimal(4, product.getPrice());
            st.setInt(5, product.getQuantity());
            st.setString(6, product.getImageURL());
            st.setObject(7, product.getIsActive());
            st.setInt(8, product.getProductID());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete product (soft delete - set IsActive = false)
     */
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE Products SET IsActive = 0 WHERE ProductID = ?";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Hard delete product (permanently remove from database)
     */
    public boolean hardDeleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE ProductID = ?";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error hard deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update product quantity (for inventory management)
     */
    public boolean updateProductQuantity(int productId, int newQuantity) {
        String sql = "UPDATE Products SET Quantity = ? WHERE ProductID = ?";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newQuantity);
            st.setInt(2, productId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get products with low stock (quantity <= threshold)
     */
    public List<Product> getLowStockProducts(int threshold) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE Quantity <= ? AND IsActive = 1 ORDER BY Quantity ASC";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, threshold);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting low stock products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get active products only
     */
    public List<Product> getActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE IsActive = 1 ORDER BY CreatedAt DESC";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting active products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get products with pagination
     */
    public List<Product> getProductsPaginated(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT * FROM Products 
            ORDER BY CreatedAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, (page - 1) * pageSize);
            st.setInt(2, pageSize);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting paginated products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get total product count
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) FROM Products WHERE IsActive = 1";
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total product count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Advanced search with multiple filters
     */
    public List<Product> advancedSearch(String keyword, Integer categoryId, 
                                       BigDecimal minPrice, BigDecimal maxPrice, 
                                       Boolean isActive) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Description LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (categoryId != null) {
            sql.append(" AND CategoryID = ?");
            params.add(categoryId);
        }
        
        if (minPrice != null) {
            sql.append(" AND Price >= ?");
            params.add(minPrice);
        }
        
        if (maxPrice != null) {
            sql.append(" AND Price <= ?");
            params.add(maxPrice);
        }
        
        if (isActive != null) {
            sql.append(" AND IsActive = ?");
            params.add(isActive);
        }
        
        sql.append(" ORDER BY CreatedAt DESC");
         Connection connection = DBContext.getInstance().getConnection();
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in advanced search: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Helper method to map ResultSet to Product object
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductID(rs.getInt("ProductID"));
        product.setName(rs.getString("Name"));
        
        // Handle nullable CategoryID
        int categoryId = rs.getInt("CategoryID");
        product.setCategoryID(rs.wasNull() ? null : categoryId);
        
        product.setDescription(rs.getString("Description"));
        product.setPrice(rs.getBigDecimal("Price"));
        product.setQuantity(rs.getInt("Quantity"));
        product.setImageURL(rs.getString("ImageURL"));
        
        // Handle nullable IsActive
        boolean isActive = rs.getBoolean("IsActive");
        product.setIsActive(rs.wasNull() ? null : isActive);
        
        product.setCreatedAt(rs.getTimestamp("CreatedAt"));
        
        return product;
    }

    /**
 * Lấy danh sách sản phẩm bán chạy nhất (chỉ lấy các sản phẩm đang hoạt động)
 * @return List<TopProduct>
 */
public List<TopProduct> getTopSellingProducts() {
    List<TopProduct> list = new ArrayList<>();
    String sql = """
        SELECT p.ProductID,
               p.Name AS ProductName,
               SUM(od.Quantity) AS SoldQuantity,
               SUM(od.Quantity * p.Price) AS Revenue
        FROM OrderDetails od
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE p.IsActive = 1
        GROUP BY p.ProductID, p.Name
        ORDER BY SoldQuantity DESC, Revenue DESC
        """;

    try (
        Connection conn = DBContext.getInstance().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()
    ) {
        while (rs.next()) {
            String name = rs.getString("ProductName");
            int soldQuantity = rs.getInt("SoldQuantity");
            double revenue = rs.getDouble("Revenue");
            list.add(new TopProduct( name, soldQuantity, revenue));
        }
    } catch (SQLException e) {
        System.err.println("Error getting top selling products: " + e.getMessage());
        e.printStackTrace();
    }
    return list;
}

  
    
    
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
      
      
        
        
    }
}
