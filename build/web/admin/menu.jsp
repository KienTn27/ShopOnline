<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menu Quản trị</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/menu.css">
    <script>
        function toggleGroup(groupId) {
            const groupContent = document.getElementById(groupId);
            const isVisible = groupContent.style.display === "flex";
            groupContent.style.display = isVisible ? "none" : "flex";
            const arrow = document.querySelector(`#${groupId}-toggle .arrow`);
            arrow.style.transform = isVisible ? "rotate(0deg)" : "rotate(90deg)";
        }
    </script>
</head>
<body>
    <div class="menu-wrapper">
        <!-- Nhóm Doanh thu -->
        <div class="menu-group" id="group-revenue-toggle">
            <div class="group-header" onclick="toggleGroup('group-revenue')">
                <h3>📊 Doanh thu</h3>
                <span class="arrow">➤</span>
            </div>
            <div class="group-content" id="group-revenue">
                <a href="<%= request.getContextPath() %>/RevenueServlet">📈 Doanh thu</a>
                <a href="<%= request.getContextPath() %>/average-revenue">📊 Doanh thu trung bình</a>
                <a href="<%= request.getContextPath() %>/highest-revenue">🌟 Doanh thu cao nhất</a>
                <a href="<%= request.getContextPath() %>/lowest-revenue-day">📉 Doanh thu thấp nhất</a>
            </div>
        </div>

        <!-- Nhóm Sản phẩm -->
        <div class="menu-group" id="group-products-toggle">
            <div class="group-header" onclick="toggleGroup('group-products')">
                <h3>📦 Sản phẩm</h3>
                <span class="arrow">➤</span>
            </div>
            <div class="group-content" id="group-products">
                <a href="<%= request.getContextPath() %>/TopProductsServlet">🔥 Bán chạy</a>
                <a href="<%= request.getContextPath() %>/product-sales">📦 Bán ra</a>
                <a href="<%= request.getContextPath() %>/TopProductsWithCategoryServlet">🗂️ Bán chạy theo danh mục</a>
                <a href="#">🗂️ Cập nhật trạng thái đơn hàng</a>
            </div>
        </div>

        <!-- Nhóm Người dùng & Đánh giá -->
        <div class="menu-group" id="group-users-reviews-toggle">
            <div class="group-header" onclick="toggleGroup('group-users-reviews')">
                <h3>👥 Người dùng & Đánh giá</h3>
                <span class="arrow">➤</span>
            </div>
            <div class="group-content" id="group-users-reviews">
                <a href="<%= request.getContextPath() %>/TopUsersServlet">👑 Người dùng chi tiêu</a>
                <a href="<%= request.getContextPath() %>/ReviewServlet">💬 Đánh giá</a>
            </div>
        </div>

        <!-- Nhóm Tồn kho -->
        <div class="menu-group" id="group-inventory-toggle">
            <div class="group-header" onclick="toggleGroup('group-inventory')">
                <h3>📋 Tồn kho</h3>
                <span class="arrow">➤</span>
            </div>
            <div class="group-content" id="group-inventory">
                <a href="<%= request.getContextPath() %>/inventory">📦 Quản lý tồn kho</a>
            </div>
        </div>

        <!-- Nhóm Quản trị hệ thống -->
        <div class="menu-group" id="group-admin-toggle">
            <div class="group-header" onclick="toggleGroup('group-admin')">
                <h3>🔧 Quản trị hệ thống</h3>
                <span class="arrow">➤</span>
            </div>
            <div class="group-content" id="group-admin">
                <a href="<%= request.getContextPath() %>/admin/user-management">👤 Quản lý người dùng</a>
            </div>
        </div>
    </div>
</body>
</html>
