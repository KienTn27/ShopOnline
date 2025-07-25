<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html lang="fr">

    <head>
        <!-- Site meta -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Shop Quần Áo Thời Trang</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700;800&family=Roboto:wght@400;500;700&display=swap&subset=vietnamese" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(120deg, #f8fafc 0%, #e0e7ef 100%);
                font-family: 'Montserrat', 'Roboto', Arial, Helvetica, sans-serif;
            }

            .navbar {
                background: #2f80ed;
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.6rem;
                letter-spacing: 1px;
            }

            .hero {
                background: url('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80') center/cover no-repeat;
                min-height: 340px;
                border-radius: 18px;
                box-shadow: 0 8px 32px rgba(44, 62, 80, 0.10);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 32px;
                margin-bottom: 40px;
                position: relative;
            }

            .hero-overlay {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(47, 128, 237, 0.25);
                border-radius: 18px;
            }

            .hero-content {
                position: relative;
                z-index: 2;
                color: #fff;
                text-align: center;
            }

            .hero-content h1 {
                font-size: 2.8rem;
                font-weight: 800;
                margin-bottom: 12px;
                text-shadow: 0 2px 8px rgba(44, 62, 80, 0.15);
            }

            .hero-content p {
                font-size: 1.2rem;
                font-weight: 500;
            }

            .product-section {
                margin-top: 32px;
                margin-bottom: 32px;
            }

            .product-card {
                border: none;
                border-radius: 18px;
                box-shadow: 0 4px 18px rgba(44, 62, 80, 0.10);
                transition: transform 0.15s, box-shadow 0.15s;
                overflow: visible;
                background: #fff;
            }

            .product-card:hover {
                transform: translateY(-6px) scale(1.03);
                box-shadow: 0 8px 32px rgba(44, 62, 80, 0.18);
            }

            .product-card img {
                width: 100%;
                height: 260px;
                object-fit: cover;
                transition: transform 0.3s;
            }

            .product-card:hover img {
                transform: scale(1.07) rotate(-2deg);
            }

            .product-card .card-body {
                padding: 18px 16px 12px 16px;
            }

            .product-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: #2f80ed;
                margin-bottom: 6px;
            }

            .product-price {
                font-size: 1.1rem;
                font-weight: 600;
                color: #e74c3c;
            }

            .btn-buy {
                border-radius: 30px;
                background: linear-gradient(90deg, #56ccf2, #2f80ed);
                color: #fff;
                font-weight: 600;
                padding: 8px 22px;
                border: none;
                transition: background 0.2s, transform 0.15s;
            }

            .btn-buy:hover {
                background: linear-gradient(90deg, #2f80ed, #56ccf2);
                color: #fff;
                transform: scale(1.07);
                box-shadow: 0 4px 18px rgba(44, 62, 80, 0.18);
            }

            .footer {
                background: #2f80ed;
                color: #fff;
                padding: 24px 0 10px 0;
                margin-top: 40px;
                border-radius: 18px 18px 0 0;
            }

            .swiper {
                width: 100%;
                height: 320px;
                border-radius: 18px;
                margin-bottom: 40px;
                box-shadow: 0 8px 32px rgba(44, 62, 80, 0.10);
            }

            .swiper-slide {
                position: relative;
                background-position: center;
                background-size: cover;
            }

            .swiper-slide .slide-content {
                position: absolute;
                left: 40px;
                bottom: 40px;
                color: #fff;
                background: rgba(47, 128, 237, 0.55);
                padding: 18px 32px;
                border-radius: 16px;
                box-shadow: 0 4px 18px rgba(44, 62, 80, 0.10);
                max-width: 60%;
            }

            .product-card .badge-sale {
                position: absolute;
                top: 18px;
                left: 18px;
                background: linear-gradient(90deg, #e74c3c, #f9ca24);
                color: #fff;
                font-weight: 700;
                border-radius: 12px;
                padding: 4px 14px;
                font-size: 0.95rem;
                box-shadow: 0 2px 8px rgba(231, 76, 60, 0.12);
            }

            .collection-section {
                margin-top: 48px;
                margin-bottom: 32px;
            }

            .collection-card {
                border-radius: 18px;
                overflow: hidden;
                box-shadow: 0 4px 18px rgba(44, 62, 80, 0.10);
                position: relative;
                transition: transform 0.18s;
            }

            .collection-card:hover {
                transform: translateY(-6px) scale(1.03);
            }

            .collection-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }

            .collection-title {
                position: absolute;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(47, 128, 237, 0.65);
                color: #fff;
                font-size: 1.2rem;
                font-weight: 700;
                padding: 12px 0;
                text-align: center;
            }

            .promo-section {
                margin-top: 32px;
                margin-bottom: 32px;
                background: linear-gradient(90deg, #56ccf2, #2f80ed);
                color: #fff;
                border-radius: 18px;
                padding: 32px 0;
                text-align: center;
                box-shadow: 0 4px 18px rgba(44, 62, 80, 0.10);
            }

            .promo-section h3 {
                font-size: 2rem;
                font-weight: 800;
                margin-bottom: 10px;
            }

            .promo-section p {
                font-size: 1.1rem;
                font-weight: 500;
            }
            /* Thêm vào cuối phần <style> */

            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 40px;
                margin-bottom: 20px;
            }

            .pagination {
                display: flex;
                list-style: none;
                padding: 0;
                margin: 0;
                gap: 8px;
            }

            .pagination .page-item .page-link {
                border: none;
                padding: 10px 15px;
                border-radius: 12px;
                background: #fff;
                color: #2f80ed;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(44, 62, 80, 0.08);
                transition: all 0.2s;
                text-decoration: none;
            }

            .pagination .page-item.active .page-link {
                background: linear-gradient(90deg, #56ccf2, #2f80ed);
                color: #fff;
                transform: scale(1.1);
            }

            .pagination .page-item:hover .page-link {
                background: #2f80ed;
                color: #fff;
                transform: translateY(-2px);
            }

            .pagination .page-item.disabled .page-link {
                background: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
            }

            .product-info {
                margin-bottom: 20px;
                padding: 15px;
                background: rgba(47, 128, 237, 0.05);
                border-radius: 12px;
                text-align: center;
            }

            .product-info h5 {
                color: #2f80ed;
                font-weight: 700;
                margin-bottom: 5px;
            }

            .product-quantity {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 10px;
            }

            .product-quantity.out-of-stock {
                color: #e74c3c;
                font-weight: 600;
            }

            .btn-buy:disabled {
                background: #6c757d !important;
                cursor: not-allowed;
                transform: none !important;
            }

            .empty-products {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-products i {
                font-size: 4rem;
                margin-bottom: 20px;
                opacity: 0.5;
            }
        </style>
    </head>

    <body>

        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <a class="navbar-brand" href="#">FashionShop</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav align-items-center">
                        <li class="nav-item mx-2"><a class="nav-link" href="#" title="Trang chủ"><i class="fa fa-home fa-lg"></i></a></li>
                        <li class="nav-item mx-2"><a class="nav-link" href="CartServlet" title="Giỏ hàng"><i class="fa fa-shopping-cart fa-lg"></i></a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link position-relative" href="#" id="notifDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notifCount">
                                    <!-- Số lượng chưa đọc -->
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" id="notifMenu">
                                <!-- Dữ liệu sẽ được load từ JSP -->
                            </ul>
                        </li>
                        <li class="nav-item dropdown mx-2">
                            <% if (session.getAttribute("user") != null) { %>
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" title="Tài khoản">
                                <i class="fa fa-user-circle fa-lg"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/view/profile.jsp">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/CartServlet?action=viewOrders">Đơn hàng của tôi</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <% if (session.getAttribute("user") != null && (((User)session.getAttribute("user")).getRole().equals("Admin") || ((User)session.getAttribute("user")).getRole().equals("SuperAdmin"))) { %>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/admin/menu.jsp">Quản lý website</a></li>
                                    <% } %>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
                            </ul>
                            <% } else { %>
                            <a class="nav-link" href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                            <% } %>
                        </li>
                        <li class="nav-item mx-2">
                            <form id="filterForm" action="Home" method="get">
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <div style="display: flex; background: white; justify-content: space-between; border-radius: 10px; align-items: center">
                                            <label style="margin-left: 5px; margin-top: 8px" class="form-label">Danh mục sản phẩm</label>
                                            <select style="max-width: 40%" class="form-select" id="categoryFilter" name="categoryFilter" onchange="this.form.submit()">
                                                <option value="0">Tất cả</option>
                                                <c:forEach var="category" items="${categories}">
                                                    <option value="${category.categoryID}" ${categorySelected == category.categoryID ? 'selected' : ''}>
                                                        ${category.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>    
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="swiper mySwiper mt-4">
                <div class="swiper-wrapper">
                    <div class="swiper-slide" style="background-image:url('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80')">
                        <div class="slide-content">
                            <h2>Bộ sưu tập Xuân Hè 2024</h2>
                            <p>Khám phá phong cách mới, trẻ trung, cá tính cho mọi giới tính!</p>
                        </div>
                    </div>
                    <div class="swiper-slide" style="background-image:url('https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1200&q=80')">
                        <div class="slide-content">
                            <h2>Sale Off 50% - Chỉ hôm nay!</h2>
                            <p>Đừng bỏ lỡ cơ hội sở hữu những item hot trend với giá cực tốt.</p>
                        </div>
                    </div>
                    <div class="swiper-slide" style="background-image:url('https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80')">
                        <div class="slide-content">
                            <h2>Thời trang nam</h2>
                            <p>Đa dạng mẫu mã, chất lượng đảm bảo, giá hợp lý.</p>
                        </div>
                    </div>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>

        <div class="container promo-section">
            <h4>Giá sinh viên – Phong cách chuẩn men!</h4>
            <h4>Mặc đẹp mỗi ngày – Không lo ví mỏng!</h4>
            <h4>Thời trang nam chất – Giá hợp túi tiền sinh viên</h4>
            <h4>Sinh viên mặc đẹp – Tự tin đi học, đi chơi</h4>

        </div>
        <!-- Thêm sau phần sản phẩm nổi bật, trước footer -->
        <div class="container">
            <div class="product-section">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
                    <h2 class="fw-bold" style="color:#2f80ed;">Tất cả sản phẩm</h2>
                    <div class="product-info">
                        <h5>Tổng cộng: ${totalProducts} sản phẩm</h5>
                        <small>Trang ${currentPage} / ${totalPages}</small>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty productList}">
                        <div class="row g-4">
                            <c:forEach var="product" items="${productList}">
                                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                                    <div class="card product-card">
                                        <c:choose>
                                            <c:when test="${not empty product.imageUrl}">
                                                <img src="${product.imageUrl}" alt="${product.name}" />
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80" alt="${product.name}" />
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="card-body">
                                            <div class="product-title">${product.name}</div>
                                            <div class="product-price">
                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" />đ
                                            </div>
                                            <div class="product-quantity ${product.quantity <= 0 ? 'out-of-stock' : ''}">
                                                <c:choose>
                                                    <c:when test="${product.quantity <= 0}">
                                                        <i class="fas fa-times-circle"></i> Hết hàng
                                                    </c:when>
                                                    <c:when test="${product.quantity <= 5}">
                                                        <i class="fas fa-exclamation-triangle text-warning"></i> Chỉ còn ${product.quantity} sản phẩm
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-check-circle text-success"></i> Còn ${product.quantity} sản phẩm
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a class="btn btn-buy w-100 mt-2" href="product-detail?id=${product.productId}">Xem chi tiết</a>

                                            <!--                                            <button class="btn btn-buy w-100 mt-2" 
                                            ${product.quantity <= 0 ? 'disabled' : ''}
                                            onclick="addToCart('${product.productId}')">
                                            ${product.quantity <= 0 ? 'Hết hàng' : 'Thêm vào giỏ hàng'}
                                        </button>-->
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container">
                                <nav aria-label="Product pagination">
                                    <ul class="pagination">
                                        <!-- Previous Button -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="Home?page=${currentPage - 1}" aria-label="Previous">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>

                                        <!-- Page Numbers -->
                                        <c:choose>
                                            <c:when test="${totalPages <= 7}">
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="Home?page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- First page -->
                                                <li class="page-item ${currentPage == 1 ? 'active' : ''}">
                                                    <a class="page-link" href="Home?page=1">1</a>
                                                </li>

                                                <!-- Dots if needed -->
                                                <c:if test="${currentPage > 4}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link">...</span>
                                                    </li>
                                                </c:if>

                                                <!-- Pages around current -->
                                                <c:forEach begin="${currentPage > 4 ? currentPage - 1 : 2}" end="${currentPage < totalPages - 3 ? currentPage + 1 : totalPages - 1}" var="i">
                                                    <c:if test="${i > 1 && i < totalPages}">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link" href="Home?page=${i}">${i}</a>
                                                        </li>
                                                    </c:if>
                                                </c:forEach>

                                                <!-- Dots if needed -->
                                                <c:if test="${currentPage < totalPages - 3}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link">...</span>
                                                    </li>
                                                </c:if>

                                                <!-- Last page -->
                                                <li class="page-item ${currentPage == totalPages ? 'active' : ''}">
                                                    <a class="page-link" href="Home?page=${totalPages}">${totalPages}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Next Button -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="Home?page=${currentPage + 1}" aria-label="Next">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-products">
                            <i class="fas fa-box-open"></i>
                            <h4>Không có sản phẩm nào</h4>
                            <p>Hiện tại chưa có sản phẩm nào trong cửa hàng.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <footer class="footer text-center mt-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 text-md-start mb-2 mb-md-0">
                        <b>FashionShop</b> &copy; 2025. All rights reserved.
                    </div>
                    <div class="col-md-6 text-md-end">
                        <span><i class="fa fa-phone"></i> 0983 455 882</span> &nbsp;|&nbsp;
                        <span><i class="fa fa-envelope"></i> kien@gmail.com</span>
                    </div>
                </div>
            </div>
        </footer>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
        <script>
                                                var swiper = new Swiper(".mySwiper", {
                                                    loop: true,
                                                    pagination: {
                                                        el: ".swiper-pagination",
                                                        clickable: true,
                                                    },
                                                    autoplay: {
                                                        delay: 3500,
                                                        disableOnInteraction: false,
                                                    },
                                                });
                                                // Dữ liệu sản phẩm mẫu cho gợi ý
                                                const trendingProducts = [
                                                    "Áo thun nam basic",
                                                    "Váy nữ mùa hè",
                                                    "Áo khoác bomber",
                                                    "Quần jeans nam",
                                                    "Áo sơ mi trắng",
                                                    "Đầm dạ hội",
                                                    "Áo hoodie unisex",
                                                    "Chân váy chữ A"
                                                ];
                                                const searchInput = document.getElementById('searchInput');
                                                const suggestionsBox = document.getElementById('searchSuggestions');

                                                function showSuggestions(list) {
                                                    if (list.length === 0) {
                                                        suggestionsBox.style.display = 'none';
                                                        return;
                                                    }
                                                    suggestionsBox.innerHTML = list.map(item => `<button type="button" class="list-group-item list-group-item-action">${item}</button>`).join('');
                                                    suggestionsBox.style.display = 'block';
                                                }

                                                // Gợi ý xu hướng khi focus
                                                searchInput.addEventListener('focus', function () {
                                                    showSuggestions(trendingProducts);
                                                });
                                                // Gợi ý theo tên khi nhập
                                                searchInput.addEventListener('input', function () {
                                                    const value = this.value.trim().toLowerCase();
                                                    if (!value) {
                                                        showSuggestions(trendingProducts);
                                                    } else {
                                                        const filtered = trendingProducts.filter(p => p.toLowerCase().includes(value));
                                                        showSuggestions(filtered);
                                                    }
                                                });
                                                // Ẩn gợi ý khi blur (trễ để click chọn)
                                                searchInput.addEventListener('blur', function () {
                                                    setTimeout(() => {
                                                        suggestionsBox.style.display = 'none';
                                                    }, 150);
                                                });
                                                // Chọn gợi ý
                                                suggestionsBox.addEventListener('mousedown', function (e) {
                                                    if (e.target && e.target.matches('button')) {
                                                        searchInput.value = e.target.textContent;
                                                        suggestionsBox.style.display = 'none';
                                                    }
                                                });
                                                document.addEventListener("DOMContentLoaded", function () {
                                                    const notifBtn = document.getElementById("notifDropdown");
                                                    const notifMenu = document.getElementById("notifMenu");
                                                    notifBtn.addEventListener("click", function () {
                                                        fetch("NotificationServlet") // Gọi servlet NotificationServlet
                                                                .then(res => res.text())
                                                                .then(html => {
                                                                    notifMenu.innerHTML = html;
                                                                    updateNotifCount();
                                                                });
                                                    });
                                                    notifMenu.addEventListener("click", function (e) {
                                                        const target = e.target.closest(".notification-item");
                                                        if (target) {
                                                            const notiId = target.getAttribute("data-id");
                                                            if (target.classList.contains("bg-light")) {
                                                                fetch('MarkNotificationReadServlet?id=' + notiId, {
                                                                    method: 'POST'
                                                                }).then(res => {
                                                                    if (res.ok) {
                                                                        target.classList.remove("bg-light", "text-dark");
                                                                        target.classList.add("bg-white");
                                                                        updateNotifCount();
                                                                    }
                                                                });
                                                            }
                                                        }
                                                    });
                                                    function updateNotifCount() {
                                                        fetch("CountUnreadServlet")
                                                                .then(res => res.text())
                                                                .then(count => {
                                                                    document.getElementById("notifCount").textContent = count === "0" ? "" : count;
                                                                });
                                                    }
                                                });
        </script>
        <% if (session.getAttribute("user") == null) { %>
        <script>
            function addToCart(productId) {
                alert('Vui lòng đăng nhập để mua hàng!');
                window.location.href = '<%= request.getContextPath() %>/login';
            }
        </script>
        <% } else { %>
        <script>
            function addToCart(productId) {
                console.log('Gọi addToCart với productId:', productId);
                fetch('<%= request.getContextPath() %>/AddToCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId + '&quantity=1'
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log('Kết quả thêm vào giỏ:', data);
                            if (data.success) {
                                alert('Đã thêm sản phẩm vào giỏ hàng!');
                            } else {
                                alert('Có lỗi xảy ra: ' + data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!');
                        });
            }
        </script>
        <% } %>
    </body>

</html>