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

            <!-- Form lọc sản phẩm -->
            <div class="filter-section">
                <!-- Error Message -->
                <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= errorMessage %>
                </div>
                <% } %>

                <form action="inventory" method="GET" class="filter-form" onsubmit="return validateFilter()">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="minQuantity">Số lượng từ:</label>
                            <input type="number" id="minQuantity" name="minQuantity" 
                                   value="${param.minQuantity}" min="0" placeholder="0">
                        </div>
                        <div class="filter-group">
                            <label for="maxQuantity">Đến:</label>
                            <input type="number" id="maxQuantity" name="maxQuantity" 
                                   value="${param.maxQuantity}" min="0" placeholder="999">
                        </div>

                        <div class="filter-buttons">
                            <button type="submit" class="btn-filter">
                                <i class="fas fa-search"></i> Lọc
                            </button>
                            <a href="inventory" class="btn-clear">
                                <i class="fas fa-times"></i> Xóa lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng tồn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${inventoryList}">
                        <tr>
                            <td data-label="ID">${inv.productId}</td>
                            <td data-label="Tên sản phẩm">${inv.productName}</td>
                            <td data-label="Số lượng tồn">${inv.stockQuantity}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- PHÂN TRANG -->
            <div class="pagination">
                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
    
                    // Lấy các tham số lọc hiện tại
                    String minQuantity = request.getParameter("minQuantity");
                    String maxQuantity = request.getParameter("maxQuantity");
    
                    // Tạo query string cho các tham số lọc
                    StringBuilder filterParams = new StringBuilder();
                    if (minQuantity != null && !minQuantity.trim().isEmpty()) {
                        filterParams.append("&minQuantity=").append(minQuantity);
                    }
                    if (maxQuantity != null && !maxQuantity.trim().isEmpty()) {
                        filterParams.append("&maxQuantity=").append(maxQuantity);
                    }
                    String filterQueryString = filterParams.toString();
    
                    if (totalPages != null && totalPages > 1) {
                        // Nút Trước
                        if (currentPage > 1) {
                            out.print("<a href='inventory?page=" + (currentPage - 1) + filterQueryString + "' class='page-btn'>Trước</a>");
                        } else {
                            out.print("<span class='page-btn disabled'>Trước</span>");
                        }
                        // Các nút số trang
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == currentPage) {
                                out.print("<span class='page-btn active'>" + i + "</span>");
                            } else {
                                out.print("<a href='inventory?page=" + i + filterQueryString + "' class='page-btn'>" + i + "</a>");
                            }
                        }
                        // Nút Sau
                        if (currentPage < totalPages) {
                            out.print("<a href='inventory?page=" + (currentPage + 1) + filterQueryString + "' class='page-btn'>Sau</a>");
                        } else {
                            out.print("<span class='page-btn disabled'>Sau</span>");
                        }
                    }
                %>
            </div>
        </div>

        <!-- JavaScript Validation -->
        <script>
            function validateFilter() {
                const minQuantity = document.getElementById('minQuantity').value;
                const maxQuantity = document.getElementById('maxQuantity').value;

                // Kiểm tra nếu cả hai trường đều có giá trị
                if (minQuantity && maxQuantity) {
                    const min = parseInt(minQuantity);
                    const max = parseInt(maxQuantity);

                    if (min >= max) {
                        alert('Số lượng "từ" phải nhỏ hơn số lượng "đến"');
                        return false;
                    }
                }

                // Kiểm tra giá trị âm
                if (minQuantity && parseInt(minQuantity) < 0) {
                    alert('Số lượng không được âm');
                    return false;
                }

                if (maxQuantity && parseInt(maxQuantity) < 0) {
                    alert('Số lượng không được âm');
                    return false;
                }

                return true;
            }

            // Real-time validation
            document.getElementById('minQuantity').addEventListener('input', function () {
                validateInputs();
            });

            document.getElementById('maxQuantity').addEventListener('input', function () {
                validateInputs();
            });

            function validateInputs() {
                const minQuantity = document.getElementById('minQuantity').value;
                const maxQuantity = document.getElementById('maxQuantity').value;
                const submitBtn = document.querySelector('.btn-filter');

                if (minQuantity && maxQuantity) {
                    const min = parseInt(minQuantity);
                    const max = parseInt(maxQuantity);

                    if (min >= max) {
                        submitBtn.style.opacity = '0.5';
                        submitBtn.style.cursor = 'not-allowed';
                        submitBtn.disabled = true;
                    } else {
                        submitBtn.style.opacity = '1';
                        submitBtn.style.cursor = 'pointer';
                        submitBtn.disabled = false;
                    }
                } else {
                    submitBtn.style.opacity = '1';
                    submitBtn.style.cursor = 'pointer';
                    submitBtn.disabled = false;
                }
            }
        </script>
    </body>
</html>