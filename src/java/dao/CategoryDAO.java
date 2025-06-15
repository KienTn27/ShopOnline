package dao;


import dao.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author truon
 */

public class CategoryDAO{

    public CategoryDAO() {
        super();
    }

    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories ORDER BY Name ASC";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Get category by ID
     */
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Categories WHERE CategoryID = ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get category by name
     */
    public Category getCategoryByName(String name) {
        String sql = "SELECT * FROM Categories WHERE Name = ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, name);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting category by name: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Search categories by name or description
     */
    public List<Category> searchCategories(String keyword) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories WHERE Name LIKE ? OR Description LIKE ? ORDER BY Name ASC";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Add new category
     */
    public boolean addCategory(Category category) {
        // Check if category name already exists
        if (getCategoryByName(category.getName()) != null) {
            System.err.println("Category with name '" + category.getName() + "' already exists");
            return false;
        }
        
        String sql = "INSERT INTO Categories (Name, Description) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, category.getName());
            st.setString(2, category.getDescription());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Add category and return generated ID
     */
    public int addCategoryAndGetId(Category category) {
        // Check if category name already exists
        if (getCategoryByName(category.getName()) != null) {
            System.err.println("Category with name '" + category.getName() + "' already exists");
            return -1;
        }
        
        String sql = "INSERT INTO Categories (Name, Description) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            st.setString(1, category.getName());
            st.setString(2, category.getDescription());
            
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding category and getting ID: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Update existing category
     */
    public boolean updateCategory(Category category) {
        // Check if another category with same name exists (excluding current category)
        Category existingCategory = getCategoryByName(category.getName());
        if (existingCategory != null && existingCategory.getCategoryID() != category.getCategoryID()) {
            System.err.println("Another category with name '" + category.getName() + "' already exists");
            return false;
        }
        
        String sql = "UPDATE Categories SET Name = ?, Description = ? WHERE CategoryID = ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, category.getName());
            st.setString(2, category.getDescription());
            st.setInt(3, category.getCategoryID());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete category (check if it has products first)
     */
    public boolean deleteCategory(int categoryId) {
        // Check if category has products
        if (hasProducts(categoryId)) {
            System.err.println("Cannot delete category: it contains products");
            return false;
        }
        
        String sql = "DELETE FROM Categories WHERE CategoryID = ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Force delete category (delete all products in category first)
     */
    public boolean forceDeleteCategory(int categoryId) {
        String deleteProductsSql = "DELETE FROM Products WHERE CategoryID = ?";
        String deleteCategorySql = "DELETE FROM Categories WHERE CategoryID = ?";
        Connection conn = DBContext.getInstance().getConnection(); 
        try {
            PreparedStatement st1 = conn.prepareStatement(deleteProductsSql);
            conn.setAutoCommit(false);
            
                st1.setInt(1, categoryId);
                st1.executeUpdate();
            
            // Delete the category
            try (PreparedStatement st2 = conn.prepareStatement(deleteProductsSql)) {
                st2.setInt(1, categoryId);
                int rowsAffected = st2.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
            
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
            }
            System.err.println("Error force deleting category: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error resetting auto-commit: " + e.getMessage());
            }
        }
        return false;
    }

    /**
     * Check if category has products
     */
    public boolean hasProducts(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE CategoryID = ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking if category has products: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get product count for each category
     */
    public int getProductCountByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE CategoryID = ? AND IsActive = 1";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product count by category: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get categories with product counts (for dropdown/select options)
     */
    public List<Category> getCategoriesWithProductCount() {
        List<Category> categories = new ArrayList<>();
        String sql = """
            SELECT c.CategoryID, c.Name, c.Description, 
                   COUNT(p.ProductID) as ProductCount
            FROM Categories c
            LEFT JOIN Products p ON c.CategoryID = p.CategoryID AND p.IsActive = 1
            GROUP BY c.CategoryID, c.Name, c.Description
            ORDER BY c.Name ASC
        """;
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                Category category = mapResultSetToCategory(rs);
                // You can add product count as a property if needed
                categories.add(category);
            }
        } catch (SQLException e) {
            System.err.println("Error getting categories with product count: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Get categories that have products (for filtering)
     */
    public List<Category> getCategoriesWithProducts() {
        List<Category> categories = new ArrayList<>();
        String sql = """
            SELECT DISTINCT c.CategoryID, c.Name, c.Description
            FROM Categories c
            INNER JOIN Products p ON c.CategoryID = p.CategoryID
            WHERE p.IsActive = 1
            ORDER BY c.Name ASC
        """;
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting categories with products: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Check if category name is unique (for validation)
     */
    public boolean isCategoryNameUnique(String name, int excludeCategoryId) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE Name = ? AND CategoryID != ?";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, excludeCategoryId);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking category name uniqueness: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total category count
     */
    public int getTotalCategoryCount() {
        String sql = "SELECT COUNT(*) FROM Categories";
        
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total category count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Helper method to map ResultSet to Category object
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryID(rs.getInt("CategoryID"));
        category.setName(rs.getString("Name"));
        category.setDescription(rs.getString("Description"));
        return category;
    }

    /**
     * Test method
     */
    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();
        
        // Test get all categories
        List<Category> categories = dao.getAllCategories();
        System.out.println("Total categories: " + categories.size());
    }
}