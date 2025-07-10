package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.Product;
import model.Product1;
import model.ProductVariant;
import model.TopProduct;

public class ProductDAO {

    // Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setCategoryId(rs.getString("CategoryID"));
                p.setDescription(rs.getString("Description"));
                p.setPrice(rs.getDouble("Price"));
                p.setQuantity(rs.getInt("Quantity"));
                p.setImageUrl(rs.getString("ImageURL"));
                p.setIsActive(rs.getBoolean("IsActive"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean decreaseProductQuantity(int productId, int quantityToDecrease) {
        String sql = "UPDATE Products SET Quantity = Quantity - ? WHERE ProductID = ? AND Quantity >= ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, quantityToDecrease);
            st.setInt(2, productId);
            st.setInt(3, quantityToDecrease);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error decreasing product quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE CategoryID = ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("ProductID"));
                    p.setName(rs.getString("Name"));
                    p.setCategoryId(rs.getString("CategoryID"));
                    p.setDescription(rs.getString("Description"));
                    p.setPrice(rs.getDouble("Price"));
                    p.setQuantity(rs.getInt("Quantity"));
                    p.setImageUrl(rs.getString("ImageURL"));
                    p.setIsActive(rs.getBoolean("IsActive"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product1> getProductsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        List<Product1> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE Price BETWEEN ? AND ? AND IsActive = 1 ORDER BY Price ASC";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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
    public boolean addProduct(Product1 product) {
        String sql = """
            INSERT INTO Products (Name, CategoryID, Description, Price, Quantity, ImageURL, IsActive, CreatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, product.getName());
            st.setObject(2, product.getCategoryID()); // Handle null
            st.setString(3, product.getDescription());
            st.setBigDecimal(4, product.getPrice());
            st.setInt(5, product.getQuantity());
            st.setString(6, product.getImageURL());
            st.setObject(7, product.getIsActive() != null ? product.getIsActive() : true);
            st.setTimestamp(8, new Timestamp(new java.util.Date().getTime()));

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
    public boolean updateProduct(Product1 product) {
        String sql = """
            UPDATE Products 
            SET Name = ?, CategoryID = ?, Description = ?, Price = ?, 
                Quantity = ?, ImageURL = ?, IsActive = ?
            WHERE ProductID = ?
        """;

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, productId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error hard deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    
    public int getTotalVariantQuantityByProductId(int productId) {
    // Câu lệnh SQL để tính tổng số lượng (Quantity) của các biến thể đang hoạt động
    String sql = "SELECT SUM(Quantity) FROM ProductVariants WHERE ProductID = ? AND IsActive = 1";
    
    // Sử dụng try-with-resources để tự động quản lý Connection, PreparedStatement và ResultSet
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, productId);
        
        // ResultSet cũng được quản lý trong khối try-with-resources
        try (ResultSet rs = ps.executeQuery()) {
            // Kiểm tra xem có kết quả trả về không
            if (rs.next()) {
                // Lấy giá trị từ cột đầu tiên (là kết quả của hàm SUM).
                // Nếu không có bản ghi nào khớp, SUM có thể trả về NULL, getInt sẽ coi là 0.
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        System.err.println("Lỗi khi tính tổng số lượng biến thể (ProductID: " + productId + "): " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println("Lỗi hệ thống không xác định khi tính tổng số lượng biến thể: " + e.getMessage());
        e.printStackTrace();
    }
    
    // Trả về 0 nếu có lỗi hoặc không có kết quả
    return 0;
}
    
    /**
     * Update product quantity (for inventory management)
     */
//    public boolean updateProductQuantity(int productId, int newQuantity) {
//        String sql = "UPDATE Products SET Quantity = ? WHERE ProductID = ?";
//
//        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
//            st.setInt(1, newQuantity);
//            st.setInt(2, productId);
//
//            int rowsAffected = st.executeUpdate();
//            return rowsAffected > 0;
//
//        } catch (SQLException e) {
//            System.err.println("Error updating product quantity: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return false;
//    }

    /**
     * Get products with low stock (quantity <= threshold)
     */
    public List<Product1> getLowStockProducts(int threshold) {
        List<Product1> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE Quantity <= ? AND IsActive = 1 ORDER BY Quantity ASC";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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
    public List<Product1> getActiveProducts() {
        List<Product1> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE IsActive = 1 ORDER BY CreatedAt DESC";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting active products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

//    /**
//     * Get product by ID
//     */
//    public Product1 getProductById(int productId) {
//        String sql = "SELECT * FROM Products WHERE ProductID = ?";
//
//        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
//            st.setInt(1, productId);
//
//            try (ResultSet rs = st.executeQuery()) {
//                if (rs.next()) {
//                    return mapResultSetToProduct(rs);
//                }
//            }
//        } catch (SQLException e) {
//            System.err.println("Error getting product by ID: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return null;
//    }

    
    public boolean updateProductQuantity(int productId, int newQuantity) {
    String sql = "UPDATE Products SET Quantity = ? WHERE ProductID = ?";
    
    // Sử dụng try-with-resources để tự động quản lý Connection và PreparedStatement
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        // Gán các tham số cho câu lệnh SQL
        ps.setInt(1, newQuantity);
        ps.setInt(2, productId);
        
        // Thực thi câu lệnh UPDATE và lấy số hàng bị ảnh hưởng
        int rowsAffected = ps.executeUpdate();
        
        // Trả về true nếu có hàng được cập nhật, ngược lại là false
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.err.println("Lỗi khi cập nhật số lượng sản phẩm (ProductID: " + productId + "): " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println("Lỗi hệ thống không xác định khi cập nhật số lượng sản phẩm: " + e.getMessage());
        e.printStackTrace();
    }
    
    // Trả về false nếu có bất kỳ lỗi nào xảy ra
    return false;
}
    
    
    public List<Product1> getAllProduct() {
        List<Product1> products = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY CreatedAt DESC";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

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
     * Get products with pagination
     */
    public List<Product1> getProductsPaginated(int page, int pageSize) {
        List<Product1> products = new ArrayList<>();
        String sql = """
            SELECT * FROM Products 
            ORDER BY CreatedAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

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
    public List<Product1> advancedSearch(String keyword, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice,
            Boolean isActive) {
        List<Product1> products = new ArrayList<>();
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql.toString())) {
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
    private Product1 mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product1 product = new Product1();
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

    public List<Product> getProductsWithPagination(int offset, int limit) {
        List<Product> products = new ArrayList<>();

        // SQL Server sử dụng OFFSET và FETCH thay vì LIMIT
        String sql = "SELECT * FROM Products WHERE IsActive = 1 "
                + "ORDER BY ProductID "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("ProductID"));
                    p.setName(rs.getString("Name"));
                    p.setCategoryId(rs.getString("CategoryID"));
                    p.setDescription(rs.getString("Description"));
                    p.setPrice(rs.getDouble("Price"));
                    p.setQuantity(rs.getInt("Quantity"));
                    p.setImageUrl(rs.getString("ImageURL"));
                    p.setIsActive(rs.getBoolean("IsActive"));
                    products.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    
    
    public Product1 getProductById(int productId) {
    // Câu lệnh SQL không đổi, đã tối ưu để lấy CategoryName
    String sql = "SELECT p.*, c.Name as CategoryName FROM Products p " +
                 "LEFT JOIN Categories c ON p.CategoryID = c.CategoryID " +
                 "WHERE p.ProductID = ?";
    
    // Sử dụng try-with-resources để quản lý Connection và PreparedStatement
    // conn và ps sẽ được tự động đóng sau khi khối try kết thúc
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, productId);
        
        // ResultSet cũng được quản lý trong một khối try-with-resources lồng nhau
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                // 1. Map thông tin cơ bản của sản phẩm từ ResultSet
                Product1 product = mapResultSetToProduct(rs);
                
                // 2. Lấy thêm CategoryName từ kết quả JOIN
                product.setCategoryName(rs.getString("CategoryName"));

                // 3. Tạo DAO để lấy danh sách biến thể
                ProductVariantDAO variantDAO = new ProductVariantDAO();
                List<ProductVariant> variants = variantDAO.getProductVariantsByProductIdByAdmin(productId);
                
                // 4. Gán danh sách biến thể vào đối tượng sản phẩm
                product.setVariants(variants);

                return product;
            }
        }
    } catch (SQLException e) {
        // Ghi log lỗi chi tiết hơn
        System.err.println("Lỗi khi lấy sản phẩm theo ID (ProductID: " + productId + "): " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        // Bắt các lỗi khác, ví dụ như lỗi khi kết nối DBContext
        System.err.println("Lỗi hệ thống không xác định khi lấy sản phẩm: " + e.getMessage());
        e.printStackTrace();
    }
    
    return null; // Trả về null nếu không tìm thấy sản phẩm hoặc có lỗi
}
    
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> products = new ArrayList<>();

        // SQL Server sử dụng TOP thay vì LIMIT
        String sql = "SELECT TOP (?) * FROM Products WHERE IsActive = 1 ORDER BY ProductID";

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("ProductID"));
                    p.setName(rs.getString("Name"));
                    p.setCategoryId(rs.getString("CategoryID"));
                    p.setDescription(rs.getString("Description"));
                    p.setPrice(rs.getDouble("Price"));
                    p.setQuantity(rs.getInt("Quantity"));
                    p.setImageUrl(rs.getString("ImageURL"));
                    p.setIsActive(rs.getBoolean("IsActive"));
                    products.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public static void main(String[] args) {
        List<Product1> l = new ArrayList<>();
        ProductDAO pd = new ProductDAO();
        System.out.println(pd.getProductsWithPagination(1, 5).get(0).getName());

//        System.out.println(l.size());
    }
}
