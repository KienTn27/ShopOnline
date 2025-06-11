/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Notification;

/**
 *
 * @author X1 carbon Gen6
 */
public class NotificationDAO {

    private DBContext dbContext = DBContext.getInstance();

    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("NotificationID"));
                n.setUserId(rs.getInt("UserID"));
                n.setMessage(rs.getString("Message"));
                n.setIsRead(rs.getBoolean("IsRead"));
                n.setCreatedAt(rs.getString("CreatedAt"));
                list.add(n);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void markAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countUnreadNotifications(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND IsRead = 0";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public void addNotification(int userId, String message) {
        String sql = "INSERT INTO Notifications (UserID, Message, IsRead, CreatedAt) VALUES (?, ?, 0, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, message);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
