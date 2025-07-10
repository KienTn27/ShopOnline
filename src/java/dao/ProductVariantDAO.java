package dao;




import model.ProductVariant;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductVariantDAO - Data Access Object for ProductVariant management.
 * Handles CRUD operations and other data retrieval for product variants.
 */
public class ProductVariantDAO extends DBContext {

    public ProductVariantDAO() {
        super();
    }
   public boolean updatePriceByProductId(int productId, BigDecimal newPrice) {
    String sql = "UPDATE ProductVariants SET Price = ? WHERE ProductID = ?";
    
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setBigDecimal(1, newPrice);
        st.setInt(2, productId);
        
        int rowsAffected = st.executeUpdate();
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.err.println("Error updating price by ProductID: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

  
    private ProductVariant mapResultSetToProductVariant(ResultSet rs) throws SQLException {
        ProductVariant variant = new ProductVariant();
        variant.setVariantID(rs.getInt("VariantID"));
        variant.setProductID(rs.getInt("ProductID"));
        variant.setSize(rs.getString("Size"));
        variant.setColor(rs.getString("Color"));
        
        // SKU can be NULL in DB, so check for nullability
        String sku = rs.getString("SKU");
        variant.setSku(rs.wasNull() ? null : sku);
        
        variant.setQuantity(rs.getInt("Quantity"));
        variant.setPrice(rs.getBigDecimal("Price"));
        
        // VariantImageURL can be NULL in DB, so check for nullability
        String variantImageURL = rs.getString("VariantImageURL");
        variant.setVariantImageURL(rs.wasNull() ? null : variantImageURL);
        
        // IsActive is BIT NULL DEFAULT 1. rs.getBoolean returns false for NULL, so check rs.wasNull()
        boolean isActive = rs.getBoolean("IsActive");
        variant.setActive(rs.wasNull() ? true : isActive); // Default to true if DB value is NULL
        
        // CreatedAt is DATETIME NULL DEFAULT GETDATE(). Convert Timestamp to LocalDateTime
        Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
        if (createdAtTimestamp != null) {
            variant.setCreatedAt(createdAtTimestamp.toLocalDateTime());
        } else {
            // If CreatedAt is null in DB (unlikely with default GETDATE()), set to null or LocalDateTime.now()
            variant.setCreatedAt(null); 
        }
        
        return variant;
    }

   
    public boolean addProductVariant(ProductVariant variant) {
        String sql = """
            INSERT INTO ProductVariants 
            (ProductID, Size, Color, SKU, Quantity, Price, VariantImageURL, IsActive, CreatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variant.getProductID());
            st.setString(2, variant.getSize());
            st.setString(3, variant.getColor());
            
            // SKU can be null
            if (variant.getSku() != null && !variant.getSku().isEmpty()) {
                st.setString(4, variant.getSku());
            } else {
                st.setNull(4, java.sql.Types.NVARCHAR);
            }
            
            st.setInt(5, variant.getQuantity());
            st.setBigDecimal(6, variant.getPrice());
            
            // VariantImageURL can be null
            if (variant.getVariantImageURL() != null && !variant.getVariantImageURL().isEmpty()) {
                st.setString(7, variant.getVariantImageURL());
            } else {
                st.setNull(7, java.sql.Types.NVARCHAR);
            }
            
            st.setBoolean(8, variant.isActive());
            
            // CreatedAt: Convert LocalDateTime to Timestamp
            if (variant.getCreatedAt() != null) {
                st.setTimestamp(9, Timestamp.valueOf(variant.getCreatedAt()));
            } else {
                st.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now())); // Default if not set in model
            }
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding product variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

  
    public boolean updateProductVariant(ProductVariant variant) {
        String sql = """
            UPDATE ProductVariants 
            SET ProductID = ?, Size = ?, Color = ?, SKU = ?, Quantity = ?, Price = ?, 
                VariantImageURL = ?, IsActive = ?
            WHERE VariantID = ?
        """;
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variant.getProductID());
            st.setString(2, variant.getSize());
            st.setString(3, variant.getColor());
            
            // SKU can be null
            if (variant.getSku() != null && !variant.getSku().isEmpty()) {
                st.setString(4, variant.getSku());
            } else {
                st.setNull(4, java.sql.Types.NVARCHAR);
            }
            
            st.setInt(5, variant.getQuantity());
            st.setBigDecimal(6, variant.getPrice());
            
            // VariantImageURL can be null
            if (variant.getVariantImageURL() != null && !variant.getVariantImageURL().isEmpty()) {
                st.setString(7, variant.getVariantImageURL());
            } else {
                st.setNull(7, java.sql.Types.NVARCHAR);
            }
            
            st.setBoolean(8, variant.isActive());
            st.setInt(9, variant.getVariantID()); // WHERE clause
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

  
    public boolean deleteProductVariant(int variantId) {
        String sql = "UPDATE ProductVariants SET IsActive = 0 WHERE VariantID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variantId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error soft deleting product variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean hardDeleteProductVariant(int variantId) {
        String sql = "DELETE FROM ProductVariants WHERE VariantID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variantId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error hard deleting product variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

   
    public List<ProductVariant> getAllProductVariants() {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariants ORDER BY CreatedAt DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                variants.add(mapResultSetToProductVariant(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all product variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

    public ProductVariant getProductVariantById(int variantId) {
        String sql = "SELECT * FROM ProductVariants WHERE VariantID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variantId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProductVariant(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product variant by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<ProductVariant> getProductVariantsByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariants WHERE ProductID = ? AND IsActive = 1 ORDER BY Size, Color";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    variants.add(mapResultSetToProductVariant(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product variants by ProductID: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }
    
    
     public List<ProductVariant> getProductVariantsByProductIdByAdmin(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariants WHERE ProductID = ?  ORDER BY Size, Color";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    variants.add(mapResultSetToProductVariant(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product variants by ProductID: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

    public ProductVariant getProductVariantBySKU(String sku) {
        String sql = "SELECT * FROM ProductVariants WHERE SKU = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, sku);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProductVariant(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product variant by SKU: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

  
    public List<ProductVariant> getLowStockProductVariants(int threshold) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariants WHERE Quantity <= ? AND IsActive = 1 ORDER BY Quantity ASC";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, threshold);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    variants.add(mapResultSetToProductVariant(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting low stock product variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

   
    public List<ProductVariant> getActiveProductVariants() {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariants WHERE IsActive = 1 ORDER BY CreatedAt DESC";
        
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                variants.add(mapResultSetToProductVariant(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting active product variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

   
    public List<ProductVariant> getProductVariantsPaginated(int page, int pageSize) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = """
            SELECT * FROM ProductVariants 
            ORDER BY CreatedAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, (page - 1) * pageSize);
            st.setInt(2, pageSize);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    variants.add(mapResultSetToProductVariant(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting paginated product variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

   
    public int getTotalProductVariantCount() {
        String sql = "SELECT COUNT(*) FROM ProductVariants WHERE IsActive = 1";
        
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total product variant count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Updates the quantity of a specific product variant.
     * @param variantId The ID of the variant to update.
     * @param newQuantity The new quantity for the variant.
     * @return true if the quantity was updated successfully, false otherwise.
     */
    public boolean updateProductVariantQuantity(int variantId, int newQuantity) {
        String sql = "UPDATE ProductVariants SET Quantity = ? WHERE VariantID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newQuantity);
            st.setInt(2, variantId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product variant quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the price of a specific product variant.
     * @param variantId The ID of the variant to update.
     * @param newPrice The new price for the variant.
     * @return true if the price was updated successfully, false otherwise.
     */
    public boolean updateProductVariantPrice(int variantId, BigDecimal newPrice) {
        String sql = "UPDATE ProductVariants SET Price = ? WHERE VariantID = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBigDecimal(1, newPrice);
            st.setInt(2, variantId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating product variant price: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ProductVariantDAO dao = new ProductVariantDAO();

        // --- Test addProductVariant ---
        System.out.println("--- Testing addProductVariant ---");
        ProductVariant newVariant = new ProductVariant(
            1, // ProductID (ví dụ: Áo Thun Nam)
            "M", // Size
            "Đen", // Color
            "ATNM-M-DEN-001", // SKU (có thể null)
            50, // Quantity
            new BigDecimal("150000.00"), // Price
            "images/variants/atnm_m_den.jpg" // VariantImageURL (có thể null)
        );
        if (dao.addProductVariant(newVariant)) {
            System.out.println("Added new variant successfully: " + newVariant.getSku());
        } else {
            System.out.println("Failed to add new variant.");
        }

        // --- Test getProductVariantById ---
        System.out.println("\n--- Testing getProductVariantById (VariantID = 1) ---");
        ProductVariant fetchedVariant = dao.getProductVariantById(1); // Assuming VariantID 1 exists
        if (fetchedVariant != null) {
            System.out.println("Fetched Variant: " + fetchedVariant);
        } else {
            System.out.println("Variant with ID 1 not found.");
        }

        // --- Test updateProductVariant ---
        System.out.println("\n--- Testing updateProductVariant (VariantID = 1) ---");
        if (fetchedVariant != null) {
            fetchedVariant.setQuantity(45); // Giảm số lượng
            fetchedVariant.setPrice(new BigDecimal("145000.00")); // Giảm giá
            fetchedVariant.setActive(true); // Đảm bảo active
            if (dao.updateProductVariant(fetchedVariant)) {
                System.out.println("Updated variant successfully: " + fetchedVariant.getVariantID());
            } else {
                System.out.println("Failed to update variant.");
            }
        }

        // --- Test getProductVariantsByProductId ---
        System.out.println("\n--- Testing getProductVariantsByProductId (ProductID = 1) ---");
        List<ProductVariant> variantsForProduct = dao.getProductVariantsByProductId(1);
        if (!variantsForProduct.isEmpty()) {
            System.out.println("Variants for ProductID 1:");
            for (ProductVariant pv : variantsForProduct) {
                System.out.println("- " + pv.getVariantID() + ": " + pv.getSize() + " - " + pv.getColor() + " (Qty: " + pv.getQuantity() + ")");
            }
        } else {
            System.out.println("No variants found for ProductID 1.");
        }

        // --- Test getAllProductVariants ---
        System.out.println("\n--- Testing getAllProductVariants ---");
        List<ProductVariant> allVariants = dao.getAllProductVariants();
        System.out.println("Total variants in DB: " + allVariants.size());
        // for (ProductVariant pv : allVariants) {
        //     System.out.println(pv);
        // }

        // --- Test getLowStockProductVariants (threshold = 10) ---
        System.out.println("\n--- Testing getLowStockProductVariants (threshold = 10) ---");
        List<ProductVariant> lowStockVariants = dao.getLowStockProductVariants(10);
        if (!lowStockVariants.isEmpty()) {
            System.out.println("Low stock variants (<=10):");
            for (ProductVariant pv : lowStockVariants) {
                System.out.println("- " + pv.getVariantID() + ": " + pv.getSize() + " - " + pv.getColor() + " (Qty: " + pv.getQuantity() + ")");
            }
        } else {
            System.out.println("No low stock variants found.");
        }
        
        // --- Test getTotalProductVariantCount ---
        System.out.println("\n--- Testing getTotalProductVariantCount ---");
        System.out.println("Total active product variants: " + dao.getTotalProductVariantCount());

        // --- Test deleteProductVariant (soft delete) ---
        // System.out.println("\n--- Testing deleteProductVariant (soft delete VariantID = 1) ---");
        // if (dao.deleteProductVariant(1)) {
        //     System.out.println("Soft deleted variant with ID 1 successfully.");
        //     ProductVariant softDeleted = dao.getProductVariantById(1);
        //     System.out.println("IsActive after soft delete: " + (softDeleted != null ? softDeleted.isActive() : "N/A"));
        // } else {
        //     System.out.println("Failed to soft delete variant with ID 1.");
        // }
        
        // --- Test hardDeleteProductVariant (use with extreme caution) ---
        // System.out.println("\n--- Testing hardDeleteProductVariant (VariantID = 2, assuming it exists) ---");
        // if (dao.hardDeleteProductVariant(2)) {
        //     System.out.println("Hard deleted variant with ID 2 successfully.");
        // } else {
        //     System.out.println("Failed to hard delete variant with ID 2.");
        // }
    }
}
