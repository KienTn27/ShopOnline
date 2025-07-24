<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Tồn kho sản phẩm</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <link rel="stylesheet" href="css/inventory.css">
</head>
<body>
<style>
.btn-back-menu {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: #e3f2fd;
    color: #2563eb;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    padding: 0.6rem 1.2rem;
    margin-bottom: 1.2rem;
    text-decoration: none;
    box-shadow: 0 2px 8px rgba(72,187,255,0.08);
    transition: background 0.2s, color 0.2s;
}
.btn-back-menu:hover {
    background: #90cdf4;
    color: #fff;
}
.pagination {
    display: flex;
    justify-content: center;
    gap: 0.5rem;
    margin: 2rem 0 1rem 0;
}
.page-btn {
    border: 2px solid #2563eb;
    background: #fff;
    color: #2563eb;
    border-radius: 999px;
    padding: 6px 18px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s, color 0.2s, border 0.2s;
    margin: 0 2px;
    outline: none;
    box-shadow: none;
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
</style>
<a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>
<div class="container">
    <h2>Danh sách tồn kho</h2>

    <div class="button-group">
        <a href="inventory?action=add" class="btn btn-primary">
            <i class="fas fa-plus-circle"></i> Thêm sản phẩm
        </a>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên sản phẩm</th>
            <th>Số lượng tồn</th>
            <th>Hành động</th> </tr>
        </thead>
        <tbody>
        <c:forEach var="inv" items="${inventoryList}">
            <tr>
                <td data-label="ID">${inv.productId}</td>
                <td data-label="Tên sản phẩm">${inv.productName}</td>
                <td data-label="Số lượng tồn">${inv.stockQuantity}</td>
                <td data-label="Hành động">
                    <a href="inventory?action=edit&productId=${inv.productId}&productName=${inv.productName}&stockQuantity=${inv.stockQuantity}" class="btn-action btn-edit">
                        <i class="fas fa-edit"></i> Sửa
                    </a>
                    <a href="inventory?action=delete&productId=${inv.productId}" class="btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <!-- PHÂN TRANG -->
    <div class="pagination">
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages != null && totalPages > 1) {
        // Nút Trước
        if (currentPage > 1) {
            out.print("<a href='inventory?page=" + (currentPage - 1) + "' class='page-btn'>Trước</a>");
        } else {
            out.print("<span class='page-btn disabled'>Trước</span>");
        }
        // Các nút số trang
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) {
                out.print("<span class='page-btn active'>" + i + "</span>");
            } else {
                out.print("<a href='inventory?page=" + i + "' class='page-btn'>" + i + "</a>");
            }
        }
        // Nút Sau
        if (currentPage < totalPages) {
            out.print("<a href='inventory?page=" + (currentPage + 1) + "' class='page-btn'>Sau</a>");
        } else {
            out.print("<span class='page-btn disabled'>Sau</span>");
        }
    }
%>
    </div>
</div>
</body>
</html>