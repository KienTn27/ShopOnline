<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <style>
            /* Container chính cho menu */
            
            .menu-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
                background-color: #f9f9f9;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                max-width: 800px;
                margin: auto;
            }
            /* Style cho từng liên kết */
            
            .menu-container a {
                display: inline-block;
                padding: 10px 15px;
                background-color: #ffffff;
                text-decoration: none;
                color: #333;
                font-weight: bold;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                transition: all 0.2s ease, transform 0.3s ease-in-out;
                min-width: 120px;
                text-align: center;
                font-size: 14px;
            }
            /* Hiệu ứng hover */
            
            .menu-container a:hover {
                background-color: #007bff;
                color: #fff;
                animation: shake 0.3s ease-in-out;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }
            /* Keyframes cho hiệu ứng lắc */
            
            @keyframes shake {
                0%,
                100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-3px);
                }
                50% {
                    transform: translateX(3px);
                }
                75% {
                    transform: translateX(-3px);
                }
            }
            /* Responsive cho thiết bị nhỏ */
            
            @media (max-width: 768px) {
                .menu-container {
                    flex-direction: column;
                    align-items: center;
                }
                .menu-container a {
                    width: 100%;
                }
            }
        </style>
    </head>

    <body>
        <div class="menu-container">
            <a href="<%= request.getContextPath() %>/Home" style="background:#007bff;color:#fff;">🏠 Quay lại trang Home</a>
            <a href="<%= request.getContextPath() %>/RevenueServlet">📈 Doanh thu</a>
            <a href="<%= request.getContextPath() %>/TopProductsServlet">🔥 Bán chạy</a>
            <a href="<%= request.getContextPath() %>/TopUsersServlet">👑 Người dùng chi tiêu</a>
            <a href="<%= request.getContextPath() %>/ReviewServlet">💬 Đánh giá</a>
            <a href="<%= request.getContextPath() %>/average-revenue">📊 Doanh thu trung bình</a>
            <a href="<%= request.getContextPath() %>/product-sales">📦 Bán ra</a>
            <a href="<%= request.getContextPath() %>/highest-revenue">🌟 Doanh thu cao nhất</a>
            <a href="<%= request.getContextPath() %>/lowest-revenue-day">📉 Doanh thu thấp nhất</a>
            <a href="<%= request.getContextPath() %>/admin/user-management">👤 Quản lý người dùng</a>
        </div>
    </body>

    </html>