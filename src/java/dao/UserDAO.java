package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import model.TopUser;
import model.User;

public class UserDAO extends DBContext {

    private final DBContext dbContext = DBContext.getInstance();

 

    // Đăng ký tài khoản
    public void addUser(User user) throws SQLException {
        String sql = "INSERT INTO User (username, password, FullName, Email, Phone, Role, isActive) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
            st.setString(5, c.getUsername());
            st.setString(6, c.getPhone());

            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }
//dang nhap
    public User login(String username, String password) {
        String sql = "SELECT * FROM [Users] WHERE [Username] = ? AND [Password] = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    user.setRole(rs.getString("Role"));
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreateAt(rs.getTimestamp("CreatedAt"));

                    return user;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; // Không tìm thấy user
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT * FROM [Users] WHERE [Username] = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có user → return true
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO [Users] ([Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive]) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRole());
            ps.setTimestamp(7, new java.sql.Timestamp(user.getCreateAt().getTime()));
            ps.setBoolean(8, user.isIsActive());

            int rows = ps.executeUpdate();

            return rows > 0; // Nếu insert thành công → return true

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật thông tin cá nhân user
    public boolean updateUserProfile(User user) {
        String sql = "UPDATE Users SET FullName=?, Username=?, Email=?, Phone=? WHERE UserID=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getUserId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra mật khẩu hiện tại
    public boolean checkPassword(int userId, String password) {
        String sql = "SELECT UserID FROM Users WHERE UserID = ? AND Password = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, password); // Lưu ý: Cần so sánh với mật khẩu đã hash trong thực tế
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật mật khẩu
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword); // Lưu ý: Cần lưu mật khẩu đã hash trong thực tế
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

// Lấy userId theo email
//    public Integer getUserIdByEmail(String email) {
//        String sql = "SELECT UserID FROM Users WHERE Email = ?";
//        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, email);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt("UserID");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//// Lưu token
//    public void savePasswordResetToken(int userId, String token, Timestamp expiry) {
//        String sql = "INSERT INTO password_reset_tokens (user_id, token, expiry) VALUES (?, ?, ?)";
//        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setString(2, token);
//            ps.setTimestamp(3, expiry);
//            ps.executeUpdate();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//// Kiểm tra token hợp lệ
//    public boolean isValidResetToken(String token) {
//        String sql = "SELECT * FROM password_reset_tokens WHERE token = ? AND is_used = 0 AND expiry > GETDATE()";
//        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, token);
//            ResultSet rs = ps.executeQuery();
//            return rs.next();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//// Cập nhật mật khẩu theo token
//    public boolean updatePasswordByToken(String token, String newPassword) {
//        String sql = "UPDATE Users SET Password = ? WHERE UserID = "
//                + "(SELECT user_id FROM password_reset_tokens WHERE token = ? AND is_used = 0 AND expiry > GETDATE())";
//        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, newPassword);
//            ps.setString(2, token);
//            int rows = ps.executeUpdate();
//
//            if (rows > 0) {
//                // Đánh dấu token đã dùng
//                String updateTokenSql = "UPDATE password_reset_tokens SET is_used = 1 WHERE token = ?";
//                try (PreparedStatement ps2 = conn.prepareStatement(updateTokenSql)) {
//                    ps2.setString(1, token);
//                    ps2.executeUpdate();
//                }
//                return true;
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//}
