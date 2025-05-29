package dao;

import model.Product;
import model.TopUser;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private final DBContext dbContext = DBContext.getInstance();

    // Đăng nhập
    public User getUserByUsernamePassword(String email, String password) throws SQLException {
        User user = null;
        String sql = "SELECT * FROM User WHERE Email = ? AND Password = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User(rs.getString("UserId"), rs.getString("FullName"), rs.getString("Password"), rs.getString("Address"), rs.getDate("Birthday"), rs.getString("Phone"), rs.getFloat("Amount"));
                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("Phone"));
                user.setRole(rs.getString("Role"));
                user.setActive(rs.getBoolean("isActive"));
            }
        }
        return user;
    }

    // Đăng ký tài khoản
    public void addUser(User user) throws SQLException {
        String sql = "INSERT INTO User (username, password, FullName, Email, Phone, Role, isActive) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword()); // Nên mã hóa mật khẩu trong thực tế
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole());
            stmt.setBoolean(7, user.isActive());
            stmt.executeUpdate();
        }
    }

    // Tìm kiếm sản phẩm
    public List<Product> searchProducts(String keyword) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE name LIKE ? OR description LIKE ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
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

    // Lấy danh sách top người dùng chi tiêu nhiều nhất
    public List<TopUser> getTopUser() {
        List<TopUser> list = new ArrayList<>();
        String sql = """
           SELECT u.FullName, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalSpent
            FROM User u
            JOIN Orders o ON u.userId = o.userId
            GROUP BY u.FullName
            ORDER BY TotalSpent DESC
        """;

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String fullName = rs.getString("FullName");
                int orders = rs.getInt("TotalOrders");
                double spent = rs.getDouble("TotalSpent");

                list.add(new TopUser(fullName, orders, spent));
            }

        } catch (Exception e) {
        }

        return list;
    }
    public User dangnhap(String userId, String password) {
        String sql = "SELECT * FROM users WHERE userId = ? AND password = ?";
        User user = null;
        try {

            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) // kiểm tra xem có tồn tại dữ liệu từ ResultSet không
            {
                user = new User(rs.getString("UserId"), rs.getString("FullName"),
                        rs.getString("Password"), rs.getString("Address"), rs.getDate("Birthday"),
                        rs.getString("Phone"), rs.getFloat("Amount"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return user;

    }
    public int insert(User c) throws Exception {
        String sql = """
                     INSERT INTO [dbo].[User]
                                ([UserId]
                                ,[Fullname]
                                ,[Password]
                                ,[Email]
                                ,[Username]
                                ,[Phone])
                          VALUES
                                (?,?,?,?,?,?)""";
        try {
            PreparedStatement st = dbContext.getConnection().prepareStatement(sql);
            st.setInt(1, c.getUserId());
            st.setString(2, c.getFullName());
            st.setString(3, c.getPassword());
            st.setString(4, c.getEmail());
            st.setString (5, c.getUsername());
            st.setString(6, c.getPhone());

            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }
}
