<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Quản lý Biến thể Sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f0f2f5; }
        .card { border: none; box-shadow: 0 0 25px rgba(0,0,0,0.07); border-radius: 0.75rem; }
        .variant-img-thumb { width: 50px; height: 50px; object-fit: cover; border-radius: 0.375rem; }
        .color-swatch { width: 20px; height: 20px; border-radius: 50%; display: inline-block; vertical-align: middle; border: 1px solid #ccc; }
        .custom-color-input { display: none; margin-top: 1rem; }
    </style>
</head>
<body>

<div class="container-fluid p-4">

    <!-- Header & Breadcrumb -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="Home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="managerProduct">Quản lý Sản phẩm</a></li>
            <li class="breadcrumb-item active" aria-current="page">Quản lý Biến thể</li>
        </ol>
    </nav>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="bi bi-box-seam me-2"></i>Quản lý Biến thể (Sản phẩm ID: ${productId})</h2>
        <a href="managerProduct" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-2"></i>Quay lại</a>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty param.status}">
        <div class="alert <c:choose><c:when test='${param.status.contains("success")}'>alert-success</c:when><c:otherwise>alert-danger</c:otherwise></c:choose> alert-dismissible fade show" role="alert">
            <i class="bi <c:choose><c:when test='${param.status.contains("success")}'>bi-check-circle-fill</c:when><c:otherwise>bi-exclamation-triangle-fill</c:otherwise></c:choose> me-2"></i>
            <c:choose>
                <c:when test="${param.status == 'add_success'}">Thêm biến thể mới thành công!</c:when>
                <c:when test="${param.status == 'update_success'}">Cập nhật biến thể thành công!</c:when>
                <c:when test="${param.status == 'delete_success'}">Xóa biến thể thành công!</c:when>
                <c:otherwise>Đã có lỗi xảy ra. Vui lòng thử lại.</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Add New Variant Form -->
    <div class="accordion mb-4" id="addVariantAccordion">
        <div class="accordion-item card">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                    <i class="bi bi-plus-circle-fill me-2"></i>Thêm Biến thể Mới
                </button>
            </h2>
            <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#addVariantAccordion">
                <div class="accordion-body">
                    <form action="managerVariants" method="post" class="row g-3" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${productId}">
                        
                        <div class="col-md-4"><label class="form-label">Size</label>
                            <select name="size" class="form-select" required>
                                <option value="XS">XS</option><option value="S" selected>S</option><option value="M">M</option><option value="L">L</option><option value="XL">XL</option><option value="XXL">XXL</option><option value="FreeSize">FreeSize</option>
                            </select>
                        </div>
                        
                        <div class="col-md-4"><label class="form-label">Màu sắc</label>
                            <select name="predefined_color" class="form-select" onchange="toggleCustomColor(this, 'customColorAdd')">
                                <option value="Black" selected>Đen</option><option value="White">Trắng</option><option value="Red">Đỏ</option><option value="Blue">Xanh dương</option><option value="Green">Xanh lá</option><option value="Yellow">Vàng</option><option value="Gray">Xám</option>
                                <option value="other">Màu khác...</option>
                            </select>
                        </div>
                        <div class="col-md-4 custom-color-input" id="customColorAdd">
                            <label class="form-label">Nhập màu khác</label>
                            <input type="text" class="form-control" name="custom_color" placeholder="VD: Brown hoặc #A52A2A">
                        </div>

                        <div class="col-md-6"><label class="form-label">Số lượng</label><input type="number" class="form-control" name="quantity" required min="0"></div>
                        <!--<div class="col-md-6"><label class="form-label">Giá</label><input type="number" class="form-control" name="price" required min="0" step="1000"></div>-->
                        <div class="col-12"><label class="form-label">Ảnh biến thể</label><input type="file" class="form-control" name="variantImage" accept="image/*"></div>
                        
                        <div class="col-12 text-end"><button type="submit" class="btn btn-primary"><i class="bi bi-plus-lg me-2"></i>Thêm Biến thể</button></div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Variants List -->
    <div class="card">
        <div class="card-header"><h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Danh sách Biến thể</h5></div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead><tr><th>Ảnh</th><th>ID</th><th>Size</th><th>Màu</th><th>Số lượng</th>
                            <!--<th>Giá</th>-->
                            <th>SKU</th><th>Trạng thái</th><th class="text-center">Hành động</th></tr></thead>
                    <tbody>
                        <c:forEach var="v" items="${variants}">
                            <tr>
                                <td>
                                    <c:set var="imageUrl" value="${v.variantImageURL}"/>
                                    <c:choose>
                                        <c:when test="${not empty imageUrl and not imageUrl.startsWith('http')}"><img src="${pageContext.request.contextPath}/${imageUrl}" alt="Ảnh" class="variant-img-thumb"></c:when>
                                        <c:when test="${not empty imageUrl}"><img src="${imageUrl}" alt="Ảnh" class="variant-img-thumb"></c:when>
                                        <c:otherwise><img src="https://via.placeholder.com/50" alt="No Image" class="variant-img-thumb"></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${v.variantID}</td><td>${v.size}</td>
                                <td><span class="color-swatch" style="background-color:${v.color};"></span> ${v.color}</td>
                                <td>${v.quantity}</td>
                                <!--<td><fmt:formatNumber value="${v.price}" type="currency" currencyCode="VND" /></td>-->
                                <td>${v.sku}</td><td><span class="badge ${v.active ? 'text-bg-success' : 'text-bg-warning'}">${v.active ? 'Hoạt động' : 'Đã ẩn'}</span></td>
                                <td class="text-center">
                                    <button class="btn btn-outline-primary btn-sm" onclick="openEditModal('${v.variantID}', '${v.size}', '${v.color}', '${v.quantity}', '${v.price}', '${v.sku}', '${v.variantImageURL}', ${v.active})"><i class="bi bi-pencil-square"></i></button>
                                    <form action="managerVariants" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn ẩn biến thể này?');">
                                        <input type="hidden" name="action" value="delete"><input type="hidden" name="variantId" value="${v.variantID}"><input type="hidden" name="productId" value="${productId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Edit Variant Modal -->
<div class="modal fade" id="editVariantModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Chỉnh sửa Biến thể</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="managerVariants" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update"><input type="hidden" name="variantId" id="editVariantId">
                    <input type="hidden" name="productId" value="${productId}"><input type="hidden" name="existingImageUrl" id="existingImageUrl">
                    
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Size</label>
                            <select name="editSize" id="editSize" class="form-select" required>
                                <option value="XS">XS</option><option value="S">S</option><option value="M">M</option><option value="L">L</option><option value="XL">XL</option><option value="XXL">XXL</option><option value="FreeSize">FreeSize</option>
                            </select>
                        </div>
                        <div class="col-md-6"><label class="form-label">Màu sắc</label>
                            <select name="edit_predefined_color" id="editPredefinedColor" class="form-select" onchange="toggleCustomColor(this, 'customColorEdit')">
                                <option value="Black">Đen</option><option value="White">Trắng</option><option value="Red">Đỏ</option><option value="Blue">Xanh dương</option><option value="Green">Xanh lá</option><option value="Yellow">Vàng</option><option value="Gray">Xám</option>
                                <option value="other">Màu khác...</option>
                            </select>
                        </div>
                        <div class="col-12 custom-color-input" id="customColorEdit">
                            <label class="form-label">Màu tùy chỉnh</label>
                            <input type="text" class="form-control" name="edit_custom_color" id="editCustomColor">
                        </div>
                        <div class="col-md-6"><label class="form-label">Số lượng</label><input type="number" class="form-control" id="editQuantity" name="editQuantity" required min="1"></div>
                        <!--<div class="col-md-6"><label class="form-label">Giá</label><input type="number" class="form-control" id="editPrice" name="editPrice" required min="0" step="1000"></div>-->
                        <div class="col-12"><label class="form-label">SKU (Không thể thay đổi)</label><input type="text" class="form-control" id="editSku" name="editSku" readonly></div>
                        <div class="col-12"><label class="form-label">Ảnh biến thể hiện tại</label><br>
                            <img id="currentImage" src="" alt="Ảnh hiện tại" style="max-width: 100px; max-height: 100px; border-radius: 5px; margin-bottom: 10px;">
                        </div>
                        <div class="col-12"><label class="form-label">Tải lên ảnh mới (để trống nếu không muốn thay đổi)</label>
                            <input type="file" class="form-control" name="editVariantImage" accept="image/*">
                        </div>
                        <div class="col-12"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="editIsActive" name="editIsActive"><label class="form-check-label" for="editIsActive">Đang hoạt động</label></div></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-2"></i>Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const editModal = new bootstrap.Modal(document.getElementById('editVariantModal'));

    // Hàm ẩn/hiện ô nhập màu tùy chỉnh
    function toggleCustomColor(selectElement, customColorDivId) {
        const customColorDiv = document.getElementById(customColorDivId);
        if (selectElement.value === 'other') {
            customColorDiv.style.display = 'block';
        } else {
            customColorDiv.style.display = 'none';
        }
    }

    function openEditModal(variantId, size, color, quantity, price, sku, imageUrl, isActive) {
        // Điền dữ liệu cơ bản
        document.getElementById('editVariantId').value = variantId;
        document.getElementById('editSize').value = size;
        document.getElementById('editQuantity').value = quantity;
//        document.getElementById('editPrice').value = parseFloat(price);
        document.getElementById('editSku').value = sku === 'null' ? '' : sku;
        document.getElementById('editIsActive').checked = isActive;

        // Xử lý logic cho dropdown màu
        const predefinedColorSelect = document.getElementById('editPredefinedColor');
        const customColorInput = document.getElementById('editCustomColor');
        const customColorDiv = document.getElementById('customColorEdit');
        
        let isPredefined = false;
        // Kiểm tra xem màu của biến thể có nằm trong danh sách màu định sẵn không
        for (let i = 0; i < predefinedColorSelect.options.length; i++) {
            if (predefinedColorSelect.options[i].value.toLowerCase() === color.toLowerCase()) {
                predefinedColorSelect.value = predefinedColorSelect.options[i].value;
                isPredefined = true;
                break;
            }
        }

        // Nếu màu không có trong danh sách, chọn "Màu khác" và điền vào ô input
        if (!isPredefined) {
            predefinedColorSelect.value = 'other';
            customColorInput.value = color;
            customColorDiv.style.display = 'block';
        } else {
            customColorInput.value = '';
            customColorDiv.style.display = 'none';
        }

        // Xử lý hiển thị ảnh
        const currentImageElement = document.getElementById('currentImage');
        const contextPath = '${pageContext.request.contextPath}';
        let finalImageUrl = 'https://via.placeholder.com/100'; 
        if (imageUrl && imageUrl !== 'null' && imageUrl.trim() !== '') {
            finalImageUrl = imageUrl.startsWith('http') ? imageUrl : contextPath + '/' + imageUrl;
        }
        currentImageElement.src = finalImageUrl;
        document.getElementById('existingImageUrl').value = imageUrl;

        editModal.show();
    }
</script>
</body>
</html>
