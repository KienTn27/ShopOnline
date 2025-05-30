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

/**
 *
 * @author X1 carbon Gen6
 */
public class OrderDetailDAO {

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        Connection conn = DBContext.getInstance().getConnection();
        String query = "SELECT * FROM OrderDetails WHERE OrderId = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                detail.setOrderId(rs.getInt("OrderId"));
                detail.setProductId(rs.getInt("ProductId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setTotalPrice(rs.getDouble("TotalPrice"));
                orderDetails.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderDetails;
    }
}
