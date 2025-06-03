/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetail;
import model.OrderDetailView;

/**
 *
 * @author X1 carbon Gen6
 */
public class OrderDetailDAO {

    public List<OrderDetailView> getOrderDetailViewsByOrderId(int orderId) {
        List<OrderDetailView> orderDetails = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT od.OrderDetailId, od.OrderId, od.ProductId, "
                + "p.Name AS ProductName, p.ImageURL AS ImageUrl, "
                + "od.Quantity, od.UnitPrice "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.ProductId = p.ProductId "
                + "WHERE od.OrderId = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetailView detail = new OrderDetailView();
                detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                detail.setOrderId(rs.getInt("OrderId"));
                detail.setProductId(rs.getInt("ProductId"));
                detail.setProductName(rs.getString("ProductName"));
                detail.setImageUrl(rs.getString("ImageUrl"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                orderDetails.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderDetails;
    }
}
