package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import model.TopUser;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO extends DBContext {

    private final DBContext dbContext = DBContext.getInstance();

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
        SELECT u.FullName, COUNT(o.OrderID) AS TotalOrders, 
               SUM(ISNULL(o.TotalAmount, 0)) AS TotalSpent
        FROM dbo.Users u
        JOIN dbo.Orders o ON u.UserId = o.UserId
        GROUP BY u.FullName
        ORDER BY TotalSpent DESC
    """;

        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String fullName = rs.getString("FullName");
                int orders = rs.getInt("TotalOrders");
                double spent = rs.getDouble("TotalSpent");

                System.out.println("📊 " + fullName + " - " + orders + " đơn - " + spent + "đ");

                list.add(new TopUser(fullName, orders, spent));
            }

        } catch (Exception e) {
            e.printStackTrace(); // Phải in lỗi để debug
        }

        return list;
    }

//dang nhap
    public User login(String username, String password) {
        String sql = "SELECT * FROM [Users] WHERE [Username] = ? AND is_deleted = 0";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("Password");
                    if (BCrypt.checkpw(password, hashedPassword)) {
                        User user = new User();
                        user.setUserId(rs.getInt("UserID"));
                        user.setUsername(rs.getString("Username"));
                        user.setPassword(hashedPassword); // Store the hashed password
                        user.setFullName(rs.getString("FullName"));
                        user.setEmail(rs.getString("Email"));
                        user.setPhone(rs.getString("Phone"));
                        user.setRole(rs.getString("Role"));
                        user.setIsActive(rs.getBoolean("IsActive"));
                        user.setCreateAt(rs.getTimestamp("CreatedAt"));

                        return user;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
// Không tìm thấy user
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

            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

            ps.setString(1, user.getUsername());
            ps.setString(2, hashedPassword);
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
        String sql = "SELECT Password FROM Users WHERE UserID = ?"; // Chỉ lấy mật khẩu
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("Password");
                    return BCrypt.checkpw(password, hashedPassword);
                }
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
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //// Lấy tất cả người dùng, admin lên đầu
    public List<User> getAllUsers() throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE is_deleted = 0 ORDER BY CASE WHEN Role = 'Admin' THEN 0 ELSE 1 END, UserID";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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
                userList.add(user);
            }
        }
        return userList;
    }

    // Block User
    public boolean updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE Users SET isActive = ? WHERE UserID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //XOA USER
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
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
        return null;
    }

////Quen Pass
    //Lấy userId theo email
    public Integer getUserIdByEmail(String email) {
        String sql = "SELECT UserID FROM Users WHERE Email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

// Lưu token
    public void savePasswordResetToken(int userId, String token, Timestamp expiry) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expiry) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiry);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// Kiểm tra token hợp lệ
    public boolean isValidResetToken(String token) {
        String sql = "SELECT * FROM password_reset_tokens WHERE token = ? AND is_used = 0 AND expiry > GETDATE()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Cập nhật mật khẩu theo token
    public boolean updatePasswordByToken(String token, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = "
                + "(SELECT user_id FROM password_reset_tokens WHERE token = ? AND is_used = 0 AND expiry > GETDATE())";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setString(2, token);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                String updateTokenSql = "UPDATE password_reset_tokens SET is_used = 1 WHERE token = ?";
                try (PreparedStatement updateTokenPs = conn.prepareStatement(updateTokenSql)) {
                    updateTokenPs.setString(1, token);
                    updateTokenPs.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm tài khoản Super Admin
    public boolean createSuperAdmin(String username, String password, String fullName, String email, String phone) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, CreatedAt, IsActive, is_deleted) VALUES (?, ?, ?, ?, ?, 'SuperAdmin', GETDATE(), 1, 0)";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, fullName);
            ps.setString(4, email);
            ps.setString(5, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Block user (set IsActive = 0)
    public boolean blockUser(int userId) {
        String sql = "UPDATE Users SET IsActive = 0 WHERE UserID = ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Unblock user (set IsActive = 1)
    public boolean unblockUser(int userId) {
        String sql = "UPDATE Users SET IsActive = 1 WHERE UserID = ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa mềm user (is_deleted = 1)
    public boolean softDeleteUser(int userId) {
        String sql = "UPDATE Users SET is_deleted = 1 WHERE UserID = ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Integer getIsDeletedByUsername(String username) {
        String sql = "SELECT is_deleted FROM [Users] WHERE [Username] = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("is_deleted");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Phân trang Top User theo chi tiêu
    public List<TopUser> getTopUserPage(int page, int pageSize) {
        List<TopUser> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                + "SELECT u.FullName, COUNT(o.OrderID) AS TotalOrders, "
                + "SUM(ISNULL(o.TotalAmount, 0)) AS TotalSpent, "
                + "ROW_NUMBER() OVER (ORDER BY SUM(ISNULL(o.TotalAmount, 0)) DESC) AS rn "
                + "FROM dbo.Users u "
                + "JOIN dbo.Orders o ON u.UserId = o.UserId "
                + "GROUP BY u.FullName) t "
                + "WHERE rn BETWEEN ? AND ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String fullName = rs.getString("FullName");
                int orders = rs.getInt("TotalOrders");
                double spent = rs.getDouble("TotalSpent");
                list.add(new TopUser(fullName, orders, spent));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tổng số top user
    public int getTotalTopUserCount() {
        String sql = "SELECT COUNT(*) FROM ("
                + "SELECT u.FullName "
                + "FROM dbo.Users u "
                + "JOIN dbo.Orders o ON u.UserId = o.UserId "
                + "GROUP BY u.FullName) t";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
