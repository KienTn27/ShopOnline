<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.RevenueStat"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bảng chi tiết doanh thu trung bình/ngày</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/revenue.css">
        <style>
            .pagination {
                display: flex;
                justify-content: center;
                gap: 0.3rem;
                margin: 1.2rem 0 0.5rem 0;
            }
            .page-btn {
                border: 2px solid #2563eb;
                background: #fff;
                color: #2563eb;
                border-radius: 999px;
                padding: 4px 14px;
                font-size: 0.98rem;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s, color 0.2s, border 0.2s;
                margin: 0 1px;
                outline: none;
                box-shadow: 0 1px 4px rgba(72,187,255,0.07);
                text-decoration: none;
                display: inline-block;
            }
            .page-btn:hover:not(.active):not(.disabled) {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
            }
            .page-btn.active {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
                cursor: default;
            }
            .page-btn.disabled {
                background: #f1f5f9;
                color: #b0b8c9;
                border-color: #e2e8f0;
                cursor: not-allowed;
                pointer-events: none;
            }
            .btn-back-menu {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: #e3f2fd;
                color: #2563eb;
                font-weight: 600;
                border: none;
                border-radius: 999px;
                padding: 0.5rem 1.1rem;
                margin: 1.2rem 0 1.2rem 0;
                text-decoration: none;
                box-shadow: 0 2px 8px rgba(72,187,255,0.08);
                font-size: 1rem;
                transition: background 0.2s, color 0.2s;
            }
            .btn-back-menu:hover {
                background: #2563eb;
                color: #fff;
            }
            .btn-back-menu i, .btn-back-menu span[style*='vertical-align:middle'] {
                color: inherit !important;
            }
        </style>
    </head>
    <body>
        <a href="revenue" class="btn-back-menu">
            <i class="fas fa-arrow-left"></i>
            <span style="vertical-align:middle;">Quay lại trang tổng quan</span>
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