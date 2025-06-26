

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="css/../css/managerUser.css" rel="stylesheet">
<style>
    /* Styles đã có từ trước */
    
    /* Pagination styles */
    .pagination .page-item.active .page-link {
        background-color: #667eea;
        border-color: #667eea;
    }
    
    .pagination .page-link {
        color: #667eea;
    }
    
    .pagination .page-link:hover {
        color: #764ba2;
    }
    
    /* Filter form styles */
    .search-section {
        background-color: #fff;
        border-radius: 0.5rem;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }
    
    /* Loading styles */
    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 9998;
    }
    
    .loading-spinner {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 9999;
    }
</style>

   
</head>
<body>
    <!-- Loading Overlay -->
    <div class="overlay" id="loadingOverlay"></div>
    <div class="loading-spinner" id="loadingSpinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>
    
    <!-- Header -->
    <div class="main-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="mb-0">
                        <i class="fas fa-box-open me-3"></i>
                        Quản lý sản phẩm
                    </h1>
                    <p class="mb-0 mt-2 opacity-75">Quản lý toàn bộ sản phẩm và danh mục</p>
                </div>
                <div class="col-md-6 text-end">
                    <div class="stats-card d-inline-block">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-chart-line fa-2x"></i>
                            </div>
                            <div>
                                <div class="h4 mb-0">${totalProducts}</div>
                                <small>Tổng sản phẩm</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12">
            <a class="btn btn-primary" href="admin/menu.jsp">
                <i class="fas fa-arrow-left me-2"></i>Trở về
            </a>
        </div>               
    </div>
    
    <div class="container-fluid">
        <!-- Action Buttons -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center">
                            <div class="action-buttons">
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                                </button>
                                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#categoryModal">
                                    <i class="fas fa-tags me-2"></i>Quản lý danh mục
                                </button>
                                <button class="btn btn-info" onclick="refreshData()">
                                    <i class="fas fa-sync-alt me-2"></i>Làm mới
                                </button>
                                <button class="btn btn-warning" onclick="exportToExcel()">
                                    <i class="fas fa-file-excel me-2"></i>Xuất Excel
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
      
        
        
<div class="search-section">
    <form id="filterForm" action="managerProduct" method="post">
        <input type="hidden" name="action" value="filter">
        <div class="row">
            <div class="col-md-4">
                <label class="form-label">Tìm kiếm sản phẩm</label>
                <input type="text" class="form-control" id="searchInput" name="searchInput" 
                       placeholder="Nhập tên sản phẩm..." value="${searchKeyword}">
            </div>
            <div class="col-md-3">
                <label class="form-label">Danh mục</label>
                <select class="form-select" id="categoryFilter" name="categoryFilter">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryID}" ${selectedCategoryId == category.categoryID ? 'selected' : ''}>
                            ${category.name} (${category.productCount})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">Giá từ</label>
                <input type="number" class="form-control" id="priceFrom" name="priceFrom" 
                       placeholder="0" value="${priceFrom}">
            </div>
            <div class="col-md-2">
                <label class="form-label">Giá đến</label>
                <input type="number" class="form-control" id="priceTo" name="priceTo" 
                       placeholder="1000000" value="${priceTo}">
            </div>
            <div class="col-md-1">
                <label class="form-label">&nbsp;</label>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>
    </form>
</div>

            
            <!-- Search Results Info -->
<c:if test="${not empty searchKeyword || not empty selectedCategoryId || not empty priceFrom || not empty priceTo}">
    <div class="alert alert-info mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <strong>Kết quả tìm kiếm:</strong> Tìm thấy ${totalProducts} sản phẩm
                <c:if test="${not empty searchKeyword}">
                    với từ khóa "<strong>${searchKeyword}</strong>"
                </c:if>
                <c:if test="${not empty selectedCategoryId}">
                    <c:forEach var="category" items="${categories}">
                        <c:if test="${category.categoryID == selectedCategoryId}">
                            trong danh mục "<strong>${category.name}</strong>"
                        </c:if>
                    </c:forEach>
                </c:if>
                <c:if test="${not empty priceFrom || not empty priceTo}">
                    với giá 
                    <c:if test="${not empty priceFrom}">
                        từ <strong><fmt:formatNumber value="${priceFrom}" type="currency" currencySymbol="₫"/></strong>
                    </c:if>
                    <c:if test="${not empty priceTo}">
                        đến <strong><fmt:formatNumber value="${priceTo}" type="currency" currencySymbol="₫"/></strong>
                    </c:if>
                </c:if>
            </div>
            <a href="managerProduct" class="btn btn-sm btn-outline-primary">
                <i class="fas fa-times me-1"></i>Xóa bộ lọc
            </a>
        </div>
    </div>
</c:if>

        
        <!-- Products Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>Danh sách sản phẩm
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0" id="productsTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${products}">
                                        <tr>
                                            <td>${product.productID}</td>
                                            <td>
                                                <img src="${product.imageURL}" alt="${product.name}" 
                                                     class="product-image" onerror="this.src='https://via.placeholder.com/60x60?text=No+Image'">
                                            </td>
                                          
                                                <td>
                                                <div class="fw-bold">${product.name}</div>
                                                <small class="text-muted">${product.description}...</small>
                                            </td>
                                            
                                            <td>${product.categoryName}</td>
                                            <td>
                                                <span class="fw-bold text-success">
                                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge ${product.quantity > 10 ? 'bg-success' : product.quantity > 0 ? 'bg-warning' : 'bg-danger'}">
                                                    ${product.quantity}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-badge ${product.isActive ? 'status-active' : 'status-inactive'}">
                                                    ${product.isActive ? 'Hoạt động' : 'Tạm dừng'}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn btn-sm btn-outline-primary" 
                                                            onclick="editProduct(${product.productID})" 
                                                            title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteProduct(${product.productID})" 
                                                            title="Xóa">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Pagination -->
<c:if test="${totalPages > 1}">
    <div class="card-footer">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center mb-0">
                <!-- Previous Page -->
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="managerProduct?page=${currentPage - 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty priceFrom ? '&priceFrom='.concat(priceFrom) : ''}${not empty priceTo ? '&priceTo='.concat(priceTo) : ''}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                
                <!-- Page Numbers -->
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="managerProduct?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty priceFrom ? '&priceFrom='.concat(priceFrom) : ''}${not empty priceTo ? '&priceTo='.concat(priceTo) : ''}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>
                
                <!-- Next Page -->
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="managerProduct?page=${currentPage + 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty priceFrom ? '&priceFrom='.concat(priceFrom) : ''}${not empty priceTo ? '&priceTo='.concat(priceTo) : ''}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</c:if>

        
    </div>
    
    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="addProductForm" action="ProductServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                                    <select class="form-select" name="categoryID" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryID}">${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Giá <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="price" min="0" step="0.01" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="quantity" min="0" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh sản phẩm</label>
                            <input type="file" class="form-control" name="image" accept="image/*">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="isActive" value="true" checked>
                                <label class="form-check-label">Kích hoạt sản phẩm</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Lưu sản phẩm
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Product Modal -->
    <div class="modal fade" id="editProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Sửa sản phẩm
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="editProductForm" action="ProductServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productID" id="editProductID">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" id="editName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                                    <select class="form-select" name="categoryID" id="editCategoryID" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryID}">${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Giá <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="price" id="editPrice" min="0" step="0.01" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="quantity" id="editQuantity" min="0" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh sản phẩm hiện tại</label>
                            <div id="currentImage" class="mb-2"></div>
                            <input type="file" class="form-control" name="image" accept="image/*">
                            <small class="text-muted">Để trống nếu không muốn thay đổi ảnh</small>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="isActive" id="editIsActive" value="true">
                                <label class="form-check-label">Kích hoạt sản phẩm</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Cập nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Category Management Modal -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-tags me-2"></i>Quản lý danh mục
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-12">
                            <button class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#addCategoryForm">
                                <i class="fas fa-plus me-2"></i>Thêm danh mục mới
                            </button>
                        </div>
                    </div>
                    
                    <div class="collapse" id="addCategoryForm">
                        <div class="card mb-3">
                            <div class="card-body">
                                <form action="CategoryServlet" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Tên danh mục</label>
                                                <input type="text" class="form-control" name="name" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Mô tả</label>
                                                <input type="text" class="form-control" name="description">
                                            </div>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save me-2"></i>Lưu danh mục
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên danh mục</th>
                                    <th>Mô tả</th>
                                    <th>Số sản phẩm</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.categoryID}</td>
                                        <td>${category.name}</td>
                                        <td>${category.description}</td>
                                        <td>
                                            <span class="badge bg-info">${category.productCount}</span>
                                        </td>
                                        <td>
                                           Đang hoạt động
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    
    <script src="js/managerUser.js"></script>
    
   <script>
// Xử lý khi nhấn Enter trong ô tìm kiếm
document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        document.getElementById('filterForm').submit();
    }
});

// Xử lý khi thay đổi danh mục
document.getElementById('categoryFilter').addEventListener('change', function() {
    document.getElementById('filterForm').submit();
});

function filterProducts() {
    document.getElementById('filterForm').submit();
}

function refreshData() {
    window.location.href = 'managerProduct';
}

function exportToExcel() {
    // Hiển thị loading
    document.getElementById('loadingOverlay').style.display = 'block';
    document.getElementById('loadingSpinner').style.display = 'block';
    
    // Chuyển hướng đến servlet xuất Excel
    window.location.href = 'ExportExcel';
}
function editProduct(productId) {
    // Hiển thị loading
    document.getElementById('loadingOverlay').style.display = 'block';
    document.getElementById('loadingSpinner').style.display = 'block';
    
    // Gọi AJAX để lấy thông tin sản phẩm
    fetch('ProductServlet?action=getProduct&productId=' + productId)
        .then(response => response.json())
        .then(data => {
            // Ẩn loading
            document.getElementById('loadingOverlay').style.display = 'none';
            document.getElementById('loadingSpinner').style.display = 'none';
            
            if (data.error) {
                alert('Lỗi: ' + data.error);
                return;
            }
            
            // Điền thông tin vào form
            document.getElementById('editProductID').value = data.productID;
            document.getElementById('editName').value = data.name;
            document.getElementById('editCategoryID').value = data.categoryID;
            document.getElementById('editDescription').value = data.description;
            document.getElementById('editPrice').value = data.price;
            document.getElementById('editQuantity').value = data.quantity;
            document.getElementById('editIsActive').checked = data.isActive;
            
            // Hiển thị ảnh hiện tại
            const currentImageDiv = document.getElementById('currentImage');
            if (data.imageURL) {
                currentImageDiv.innerHTML = `<img src="${data.imageURL}" alt="${data.name}" class="img-thumbnail" style="max-width: 100px;">`;
            } else {
                currentImageDiv.innerHTML = '<span class="text-muted">Không có ảnh</span>';
            }
            
            // Hiển thị modal
            const editModal = new bootstrap.Modal(document.getElementById('editProductModal'));
            editModal.show();
        })
        .catch(error => {
            // Ẩn loading
            document.getElementById('loadingOverlay').style.display = 'none';
            document.getElementById('loadingSpinner').style.display = 'none';
            
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin sản phẩm');
        });
}

function deleteProduct(productId) {
    if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
        // Hiển thị loading
        document.getElementById('loadingOverlay').style.display = 'block';
        document.getElementById('loadingSpinner').style.display = 'block';
        
        // Chuyển đến servlet xóa sản phẩm
        window.location.href = 'ProductServlet?action=delete&productId=' + productId;
    }
}

function editCategory(categoryId) {
    // Chức năng sửa danh mục sẽ được phát triển sau
    alert('Chức năng sửa danh mục đang được phát triển!');
}

function deleteCategory(categoryId) {
    if (confirm('Bạn có chắc chắn muốn xóa danh mục này?')) {
        // Hiển thị loading
        document.getElementById('loadingOverlay').style.display = 'block';
        document.getElementById('loadingSpinner').style.display = 'block';
        
        // Chuyển đến servlet xóa danh mục
        window.location.href = 'CategoryServlet?action=delete&categoryId=' + categoryId;
    }
}

// Khởi tạo DataTable khi trang đã load xong
document.addEventListener('DOMContentLoaded', function() {
    // Ẩn loading spinner
    document.getElementById('loadingOverlay').style.display = 'none';
    document.getElementById('loadingSpinner').style.display = 'none';
});


</script>

</body>
</html>
