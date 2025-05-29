package dao; // Giữ nguyên package 'dao' như file gốc của bạn

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Cần import annotation này
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DashboardStat; // Import DashboardStat from model package
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet to display dashboard statistics.
 * @author HUNG
 */
@WebServlet("/dashboard-data") // Đặt một URL ánh xạ cho Servlet này. Ví dụ: /dashboard-data
public class DashboardDAO extends HttpServlet {

    /**
     * Retrieves dashboard statistics from the database.
     * @return DashboardStat object containing total orders, revenue, reviews, and orders by status.
     */
    private DashboardStat getDashboardStat() {
        DashboardStat stat = new DashboardStat();

        try (Connection conn = DBContext.getInstance().getConnection()) {
            // Tổng đơn hàng
            // Thêm AS TotalOrders để cột có tên rõ ràng hơn trong kết quả
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) AS TotalOrders FROM Orders");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                stat.setTotalOrders(rs1.getInt("TotalOrders")); // Lấy theo tên cột thay vì chỉ số
            } else {
                stat.setTotalOrders(0); // Handle empty result
            }

            // Tổng doanh thu
            // Dựa trên hình ảnh bạn cung cấp, bảng OrderDetails có Quantity và UnitPrice.
            // Sử dụng chúng để tính doanh thu, KHÔNG CẦN JOIN Products.
            PreparedStatement ps2 = conn.prepareStatement("SELECT SUM(od.Quantity * od.UnitPrice) AS TotalRevenue FROM OrderDetails od");
            // Hoặc, nếu cột TotalPrice trong OrderDetails đã lưu tổng giá của từng item (Quantity * UnitPrice), bạn có thể dùng:
            // PreparedStatement ps2 = conn.prepareStatement("SELECT SUM(od.TotalPrice) AS TotalRevenue FROM OrderDetails od");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                stat.setTotalRevenue(rs2.getDouble("TotalRevenue")); // Lấy theo tên cột
            } else {
                stat.setTotalRevenue(0.0); // Handle empty result
            }

            // Tổng đánh giá
            // Thêm AS TotalReviews và sửa lỗi lấy dữ liệu từ rs3 thay vì rs1
            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) AS TotalReviews FROM Reviews");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                stat.setTotalReviews(rs3.getInt("TotalReviews")); // Đã sửa lỗi: lấy từ rs3 thay vì rs1
            } else {
                stat.setTotalReviews(0); // Handle empty result
            }

            // Số đơn theo trạng thái
            // Thêm AS OrderCount để cột COUNT(*) có tên rõ ràng hơn
            PreparedStatement ps4 = conn.prepareStatement("SELECT Status, COUNT(*) AS OrderCount FROM Orders GROUP BY Status");
            ResultSet rs4 = ps4.executeQuery();
            Map<String, Integer> orderByStatus = new HashMap<>();
            while (rs4.next()) {
                orderByStatus.put(rs4.getString("Status"), rs4.getInt("OrderCount")); // Lấy theo tên cột
            }
            stat.setOrderByStatus(orderByStatus);

        } catch (SQLException e) {
            e.printStackTrace(); // Rất quan trọng để in lỗi ra console để debug
            throw new RuntimeException("Failed to retrieve dashboard statistics", e);
        }

        return stat;
    }

    /**
     * Handles the HTTP <code>GET</code> method to display dashboard statistics.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            DashboardStat stat = getDashboardStat();
            try (PrintWriter out = response.getWriter()) {
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Dashboard Statistics</title>");
                out.println("<style>");
                out.println("body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; color: #333; }");
                out.println("h1 { color: #0056b3; text-align: center; margin-bottom: 30px; }");
                out.println(".dashboard-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; max-width: 1200px; margin: 0 auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }");
                out.println(".stat-box { background-color: #e0f7fa; border: 1px solid #b2ebf2; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); }");
                out.println(".stat-box h2 { color: #007bff; margin-top: 0; font-size: 1.5em; }");
                out.println(".stat-box p { font-size: 2em; font-weight: bold; color: #333; margin: 10px 0; }");
                out.println(".stat-box ul { list-style-type: none; padding: 0; margin: 0; text-align: left; }");
                out.println(".stat-box li { padding: 8px 0; border-bottom: 1px dashed #cfd8dc; display: flex; justify-content: space-between; align-items: center; }");
                out.println(".stat-box li:last-child { border-bottom: none; }");
                out.println(".stat-box li span { font-weight: bold; }");
                out.println("</style>");
                out.println("</head>");
                out.println("<body>");
                out.println("<h1>Dashboard Statistics</h1>");
                out.println("<div class='dashboard-container'>"); // Container cho các hộp thống kê
                
                // Total Orders
                out.println("<div class='stat-box'>");
                out.println("<h2>Total Orders</h2>");
                out.println("<p>" + stat.getTotalOrders() + "</p>");
                out.println("</div>");
                
                // Total Revenue
                out.println("<div class='stat-box'>");
                out.println("<h2>Total Revenue</h2>");
                out.println("<p>$" + String.format("%,.2f", stat.getTotalRevenue()) + "</p>"); // Định dạng số tiền có dấu phẩy
                out.println("</div>");
                
                // Total Reviews
                out.println("<div class='stat-box'>");
                out.println("<h2>Total Reviews</h2>");
                out.println("<p>" + stat.getTotalReviews() + "</p>");
                out.println("</div>");
                
                // Orders by Status
                out.println("<div class='stat-box'>");
                out.println("<h2>Orders by Status</h2>");
                out.println("<ul>");
                stat.getOrderByStatus().forEach((status, count) ->
                    out.println("<li>" + status + ": <span>" + count + "</span></li>")
                );
                out.println("</ul>");
                out.println("</div>");
                
                out.println("</div>"); // Kết thúc dashboard-container
                out.println("</body>");
                out.println("</html>");
            }
        } catch (Exception e) {
            e.printStackTrace(); // In ra stack trace để debug lỗi
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load dashboard data: " + e.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method by delegating to doGet.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for displaying dashboard statistics";
    }
}