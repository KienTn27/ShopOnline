<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chỉnh sửa tồn kho</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/inventory.css">
    <style>
        .edit-form { max-width: 400px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); padding: 2rem; }
        .edit-form h2 { text-align: center; margin-bottom: 2rem; }
        .edit-form label { font-weight: 600; display: block; margin-bottom: 0.5rem; }
        .edit-form input[type="text"], .edit-form input[type="number"] { width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e5e7eb; margin-bottom: 1.5rem; font-size: 1rem; }
        .edit-form .form-actions { display: flex; gap: 1rem; justify-content: center; }
        .edit-form button, .edit-form a { padding: 0.75rem 1.5rem; border-radius: 8px; border: none; font-weight: 600; font-size: 1rem; cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 0.5rem; }
        .edit-form .btn-save { background: #10b981; color: white; }
        .edit-form .btn-save:hover { background: #059669; }
        .edit-form .btn-cancel { background: #e5e7eb; color: #374151; }
        .edit-form .btn-cancel:hover { background: #d1d5db; }
    </style>
</head>
<body>
<div class="edit-form">
    <h2><i class="fas fa-edit"></i> Chỉnh sửa tồn kho</h2>
    <form action="inventory" method="post">
        <input type="hidden" name="productId" value="${productId}">
        <label for="productName">Tên sản phẩm:</label>
        <input type="text" id="productName" name="productName" value="${productName}" required>
        <label for="stockQuantity">Số lượng tồn:</label>
        <input type="number" id="stockQuantity" name="stockQuantity" min="0" value="${stockQuantity}" required>
        <div class="form-actions">
            <button type="submit" class="btn-save"><i class="fas fa-save"></i> Lưu</button>
            <a href="inventory" class="btn-cancel"><i class="fas fa-times"></i> Hủy</a>
        </div>
    </form>
</div>
</body>
</html> 