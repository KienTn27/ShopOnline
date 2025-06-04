<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                        <li class="nav-item mx-2"><a class="nav-link" href="#" title="Sản phẩm"><i class="fa fa-tshirt fa-lg"></i></a></li>
                        <li class="nav-item mx-2"><a class="nav-link" href="#" title="Giỏ hàng"><i class="fa fa-shopping-cart fa-lg"></i></a></li>
                        <li class="nav-item mx-2"><a class="nav-link" href="#" title="Liên hệ"><i class="fa fa-envelope fa-lg"></i></a></li>
                        <li class="nav-item mx-2">
                            <% if (session.getAttribute("user") != null) { %>
                                <a class="nav-link" href="<%= request.getContextPath() %>/profile" title="Tài khoản"><i class="fa fa-user-circle fa-lg"></i></a>
                                <a class="nav-link" href="<%= request.getContextPath() %>/logout">Đăng xuất</a>
                                <% } else { %>
                                    <a class="nav-link" href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                                    <% } %>
                        </li>
                        <li class="nav-item mx-2">
                            <form class="d-flex position-relative" autocomplete="off" onsubmit="return false;">
                                <input class="form-control me-2" type="search" id="searchInput" placeholder="Tìm kiếm sản phẩm..." aria-label="Search" style="min-width:220px;">
                                <div id="searchSuggestions" class="list-group position-absolute w-100" style="top:100%; z-index:1000; display:none;"></div>
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
                            <h2>Thời trang nam nữ</h2>
                            <p>Đa dạng mẫu mã, chất lượng đảm bảo, giá hợp lý.</p>
                        </div>
                    </div>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>

        <div class="container promo-section">
            <h3>Miễn phí vận chuyển cho đơn hàng từ 499.000đ</h3>
            <p>Đổi trả dễ dàng trong 7 ngày. Đăng ký thành viên để nhận ưu đãi độc quyền!</p>
        </div>

        <div class="container">
            <div class="collection-section">
                <h2 class="mb-4 text-center fw-bold" style="color:#2f80ed;">Bộ sưu tập nổi bật</h2>
                <div class="row g-4">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="collection-card">
                            <img src="https://images.unsplash.com/photo-1469398715555-76331a6c7c9b?auto=format&fit=crop&w=600&q=80" alt="BST Jeans" />
                            <div class="collection-title">BST Jeans Cá Tính</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="collection-card">
                            <img src="https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=600&q=80" alt="BST Áo Khoác" />
                            <div class="collection-title">Áo Khoác Sành Điệu</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="collection-card">
                            <img src="https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=600&q=80" alt="BST Váy Nữ" />
                            <div class="collection-title">Váy Nữ Dịu Dàng</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="collection-card">
                            <img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=600&q=80" alt="BST Áo Thun" />
                            <div class="collection-title">Áo Thun Năng Động</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="product-section">
                <h2 class="mb-4 text-center fw-bold" style="color:#2f80ed;">Sản phẩm nổi bật</h2>
                <div class="row g-4">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card product-card position-relative">
                            <span class="badge-sale">-20%</span>
                            <img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80" alt="Áo thun nam basic" />
                            <div class="card-body">
                                <div class="product-title">Áo thun nam basic</div>
                                <div class="product-price">199.000đ</div>
                                <button class="btn btn-buy w-100 mt-2">Mua ngay</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card product-card position-relative">
                            <span class="badge-sale">-30%</span>
                            <img src="https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=400&q=80" alt="Váy nữ mùa hè" />
                            <div class="card-body">
                                <div class="product-title">Váy nữ mùa hè</div>
                                <div class="product-price">299.000đ</div>
                                <button class="btn btn-buy w-100 mt-2">Mua ngay</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card product-card position-relative">
                            <span class="badge-sale">-15%</span>
                            <img src="https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=400&q=80" alt="Áo khoác bomber" />
                            <div class="card-body">
                                <div class="product-title">Áo khoác bomber</div>
                                <div class="product-price">399.000đ</div>
                                <button class="btn btn-buy w-100 mt-2">Mua ngay</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card product-card position-relative">
                            <span class="badge-sale">-10%</span>
                            <img src="https://images.unsplash.com/photo-1469398715555-76331a6c7c9b?auto=format&fit=crop&w=400&q=80" alt="Quần jeans nam" />
                            <div class="card-body">
                                <div class="product-title">Quần jeans nam</div>
                                <div class="product-price">259.000đ</div>
                                <button class="btn btn-buy w-100 mt-2">Mua ngay</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer text-center mt-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 text-md-start mb-2 mb-md-0">
                        <b>FashionShop</b> &copy; 2024. All rights reserved.
                    </div>
                    <div class="col-md-6 text-md-end">
                        <span><i class="fa fa-phone"></i> 0123 456 789</span> &nbsp;|&nbsp;
                        <span><i class="fa fa-envelope"></i> support@fashionshop.vn</span>
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
            searchInput.addEventListener('focus', function() {
                showSuggestions(trendingProducts);
            });

            // Gợi ý theo tên khi nhập
            searchInput.addEventListener('input', function() {
                const value = this.value.trim().toLowerCase();
                if (!value) {
                    showSuggestions(trendingProducts);
                } else {
                    const filtered = trendingProducts.filter(p => p.toLowerCase().includes(value));
                    showSuggestions(filtered);
                }
            });

            // Ẩn gợi ý khi blur (trễ để click chọn)
            searchInput.addEventListener('blur', function() {
                setTimeout(() => {
                    suggestionsBox.style.display = 'none';
                }, 150);
            });

            // Chọn gợi ý
            suggestionsBox.addEventListener('mousedown', function(e) {
                if (e.target && e.target.matches('button')) {
                    searchInput.value = e.target.textContent;
                    suggestionsBox.style.display = 'none';
                }
            });
        </script>

    </body>

    </html>