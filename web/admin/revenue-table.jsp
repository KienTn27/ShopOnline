<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.RevenueStat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng chi tiết doanh thu trung bình/ngày</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/revenue.css">
</head>
<body>
    <a href="revenue" class="btn-back-menu btn-back-stat">
        <span style="font-size:1.2em;">&#8592;</span> Quay lại trang tổng quan
    </a>
    <div class="table-section">
        <div class="section-header">
            <h2 class="section-title">📋 Bảng chi tiết doanh thu trung bình/ngày</h2>
            <p class="section-subtitle">Dữ liệu chi tiết từng ngày</p>
        </div>
        <div class="table-card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Số đơn hàng</th>
                            <th>Tổng doanh thu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<RevenueStat> stats = (List<RevenueStat>) request.getAttribute("stats");
                           if (stats != null && !stats.isEmpty()) {
                               for (RevenueStat s : stats) { %>
                            <tr>
                                <td><%= s.getLabel() %></td>
                                <td><%= s.getTotalOrders() %></td>
                                <td class="currency"><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</td>
                            </tr>
                        <%   }
                           } else { %>
                            <tr><td colspan="3" class="no-data">Không có dữ liệu</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <!-- PHÂN TRANG -->
            <div class="pagination">
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages != null && totalPages > 1) {
        // Nút Trước
        if (currentPage > 1) {
            out.print("<a href='revenue-table?page=" + (currentPage - 1) + "' class='page-btn'>Trước</a>");
        } else {
            out.print("<span class='page-btn disabled'>Trước</span>");
        }
        // Các nút số trang
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) {
                out.print("<span class='page-btn active'>" + i + "</span>");
            } else {
                out.print("<a href='revenue-table?page=" + i + "' class='page-btn'>" + i + "</a>");
            }
        }
        // Nút Sau
        if (currentPage < totalPages) {
            out.print("<a href='revenue-table?page=" + (currentPage + 1) + "' class='page-btn'>Sau</a>");
        } else {
            out.print("<span class='page-btn disabled'>Sau</span>");
        }
    }
%>
            </div>
        </div>
    </div>
</body>
</html> 