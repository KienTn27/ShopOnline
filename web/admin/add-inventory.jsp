<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm sản phẩm mới</title>
    <link rel="stylesheet" href="css/inventory.css">
</head>
<body>
<div class="edit-form">
    <h2>Thêm sản phẩm mới</h2>
    <form action="inventory" method="post">
        <input type="hidden" name="action" value="add">
        <label for="productName">Tên sản phẩm:</label>
        <input type="text" id="productName" name="productName" required>
        <label for="stockQuantity">Số lượng tồn:</label>
        <input type="number" id="stockQuantity" name="stockQuantity" min="0" required>
        <button type="submit" class="btn-save">Thêm</button>
        <a href="inventory" class="btn-cancel">Hủy</a>
    </form>
</div>
</body>
</html> 