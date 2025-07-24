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
        <div class="container">
            <h2>Danh sách tồn kho</h2>

            <div class="button-group">
                <a href="admin/menu.jsp" class="btn btn-secondary" style="margin-right: 10px;">
                    <i class="fas fa-arrow-left"></i> Quay lại menu
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
                                
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>