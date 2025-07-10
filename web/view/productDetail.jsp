<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết: ${product.name}</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Font: Be Vietnam Pro -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2c3e50;
            --accent-color: #e74c3c;
            --gold-color: #f39c12;
            --light-gray: #f8f9fa;
            --medium-gray: #6c757d;
            --border-color: #e9ecef;
            --shadow-light: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-medium: 0 4px 20px rgba(0,0,0,0.1);
            --shadow-heavy: 0 8px 30px rgba(0,0,0,0.15);
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .main-container {
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-heavy);
            overflow: hidden;
            margin: 2rem 0;
        }

        .product-image-section {
            position: relative;
            background: linear-gradient(45deg, #f8f9fa, #ffffff);
            padding: 2rem;
        }

        .product-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: var(--shadow-medium);
            transition: transform 0.3s ease;
        }

        .product-image:hover {
            transform: scale(1.02);
        }

        .product-info-section {
            padding: 3rem;
        }

        .product-title {
            font-weight: 700;
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .product-price {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--accent-color);
            text-shadow: 0 2px 4px rgba(231, 76, 60, 0.2);
        }

        .product-description {
            color: var(--medium-gray);
            line-height: 1.8;
            font-size: 1.1rem;
            margin: 1.5rem 0;
        }

        .section-title {
            font-weight: 600;
            font-size: 1.3rem;
            color: var(--primary-color);
            border-bottom: 3px solid var(--accent-color);
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--gold-color);
        }

        .variant-select {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .variant-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.25);
        }

        .btn-add-cart {
            background: linear-gradient(135deg, var(--accent-color), #c0392b);
            border: none;
            border-radius: 12px;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: var(--shadow-medium);
            transition: all 0.3s ease;
        }

        .btn-add-cart:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: var(--shadow-heavy);
            background: linear-gradient(135deg, #c0392b, var(--accent-color));
        }

        .btn-add-cart:disabled {
            background: var(--medium-gray);
            cursor: not-allowed;
        }

        .stock-info {
            font-weight: 600;
            font-size: 1rem;
        }

        .text-danger-stock {
            color: var(--accent-color) !important;
        }

        .text-success-stock {
            color: #27ae60 !important;
        }

        /* Reviews Section Styles */
        .reviews-section {
            background: var(--light-gray);
            padding: 3rem;
            margin-top: 3rem;
        }

        .reviews-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .rating-summary {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: var(--shadow-light);
            margin-bottom: 2rem;
        }

        .rating-overview {
            display: flex;
            align-items: center;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }

        .rating-score {
            font-size: 3rem;
            font-weight: 700;
            color: var(--gold-color);
        }

        .rating-stars {
            font-size: 1.5rem;
            color: var(--gold-color);
            margin-bottom: 0.5rem;
        }

        .rating-count {
            color: var(--medium-gray);
            font-size: 1rem;
        }

        .rating-breakdown {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex: 1;
        }

        .rating-bar {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .rating-bar-label {
            min-width: 60px;
            font-size: 0.9rem;
            color: var(--medium-gray);
        }

        .rating-bar-fill {
            flex: 1;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }

        .rating-bar-progress {
            height: 100%;
            background: linear-gradient(90deg, var(--gold-color), #f1c40f);
            transition: width 0.8s ease;
        }

        .rating-bar-count {
            min-width: 40px;
            text-align: right;
            font-size: 0.9rem;
            color: var(--medium-gray);
        }

        .review-item {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-light);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .review-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .reviewer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-color), var(--gold-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
        }

        .reviewer-details h6 {
            margin: 0;
            font-weight: 600;
            color: var(--primary-color);
        }

        .review-date {
            font-size: 0.85rem;
            color: var(--medium-gray);
        }

        .review-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .review-stars {
            color: var(--gold-color);
            font-size: 1.1rem;
        }

        .review-comment {
            color: #2c3e50;
            line-height: 1.6;
            font-size: 1rem;
            margin-top: 1rem;
        }

        .no-reviews {
            text-align: center;
            padding: 3rem;
            color: var(--medium-gray);
        }

        .no-reviews i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .filter-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 25px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            color: var(--medium-gray);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: var(--accent-color);
            border-color: var(--accent-color);
            color: white;
        }

        .load-more-btn {
            background: var(--primary-color);
            border: none;
            border-radius: 10px;
            padding: 1rem 2rem;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .load-more-btn:hover {
            background: #34495e;
            transform: translateY(-1px);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                margin: 1rem;
                border-radius: 15px;
            }

            .product-info-section,
            .reviews-section {
                padding: 2rem 1.5rem;
            }

            .product-title {
                font-size: 2rem;
            }

            .product-price {
                font-size: 1.8rem;
            }

            .rating-overview {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }

            .reviews-header {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-buttons {
                justify-content: center;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .slide-up {
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="main-container fade-in">
        <div class="row g-0">
            <!-- Product Image Section -->
            <div class="col-lg-6 product-image-section">
                <img id="productImageDisplay" src="${product.imageURL}" alt="Ảnh sản phẩm ${product.name}" class="product-image">
            </div>

            <!-- Product Info Section -->
            <div class="col-lg-6 product-info-section">
                <h1 class="product-title">${product.name}</h1>
                
                <p class="product-description">${product.description}</p>

                <div class="mb-4">
                    <span id="display-price" class="product-price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                    </span>
                    <span id="display-quantity" class="ms-3 stock-info">
                        <!-- Content will be filled by JavaScript -->
                    </span>
                </div>
                
                <hr class="my-4">

                <!-- Variant Selection -->
                <div class="mb-4">
                    <h5 class="section-title">
                        <i class="fas fa-palette me-2"></i>
                        Chọn phiên bản
                    </h5>
                    
                    <c:if test="${empty list}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Sản phẩm này hiện chưa có phiên bản nào.
                        </div>
                    </c:if>

                    <c:if test="${not empty list}">
                        <div class="mb-3">
                            <label for="variantSelect" class="form-label fw-semibold">Phiên bản:</label>
                            <select class="form-select variant-select" id="variantSelect">
                                <option value="">Chọn một phiên bản</option>
                                <c:forEach var="variant" items="${list}">
                                    <option value="${variant.variantID}"
                                            data-price="${variant.price}"
                                            data-quantity="${variant.quantity}"
                                            data-color="${variant.color}"
                                            data-size="${variant.size}"
                                            data-imageurl="${variant.variantImageURL != null && not empty variant.variantImageURL ? variant.variantImageURL : product.imageURL}"
                                            <c:if test="${variant.quantity == 0}">disabled</c:if>
                                    >
                                        Màu: ${variant.color}, Size: ${variant.size}
                                        <c:if test="${variant.quantity == 0}"> (Hết hàng)</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <p id="selectedVariantInfo" class="text-muted fst-italic"></p>
                    </c:if>
                </div>

               <c:if test="${sessionScope.role == 'Customer'}">
    <div class="d-grid">
        <button id="addToCartBtn" class="btn btn-add-cart" disabled>
            <i class="fas fa-shopping-cart me-2"></i>
            Thêm vào giỏ hàng
        </button>
    </div>
</c:if>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="reviews-section">
            <div class="reviews-header">
                <h3 class="section-title mb-0">
                    <i class="fas fa-star me-2"></i>
                    Đánh giá sản phẩm
                </h3>
                <div class="filter-buttons">
                    <button class="filter-btn active" data-rating="all">Tất cả</button>
                    <button class="filter-btn" data-rating="5">5 <i class="fas fa-star"></i></button>
                    <button class="filter-btn" data-rating="4">4 <i class="fas fa-star"></i></button>
                    <button class="filter-btn" data-rating="3">3 <i class="fas fa-star"></i></button>
                    <button class="filter-btn" data-rating="2">2 <i class="fas fa-star"></i></button>
                    <button class="filter-btn" data-rating="1">1 <i class="fas fa-star"></i></button>
                </div>
            </div>

            <c:if test="${not empty reviews}">
                <!-- Rating Summary -->
                <div class="rating-summary slide-up">
                    <div class="rating-overview">
                        <div class="text-center">
                            <div class="rating-score" id="averageRating">0.0</div>
                            <div class="rating-stars" id="averageStars"></div>
                            <div class="rating-count" id="totalReviews">${reviews.size()} đánh giá</div>
                        </div>
                        <div class="rating-breakdown" id="ratingBreakdown">
                            <!-- Will be populated by JavaScript -->
                        </div>
                    </div>
                </div>

                <!-- Reviews List -->
                <div id="reviewsList">
                    <c:forEach var="review" items="${reviews}" varStatus="status">
                        <div class="review-item slide-up" data-rating="${review.rating}" style="animation-delay: ${status.index * 0.1}s">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        ${review.userName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div class="reviewer-details">
                                        <h6>${review.userName}</h6>
                                        <div class="review-date">
                                            <i class="fas fa-clock me-1"></i>
                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <div class="review-stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <i class="fas fa-star ${star <= review.rating ? '' : 'text-muted'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <div class="review-comment">
                                ${review.comment}
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="text-center mt-4">
                    <button class="btn load-more-btn" id="loadMoreBtn" style="display: none;">
                        <i class="fas fa-chevron-down me-2"></i>
                        Xem thêm đánh giá
                    </button>
                </div>
            </c:if>

            <c:if test="${empty reviews}">
                <div class="no-reviews">
                    <i class="fas fa-comment-slash"></i>
                    <h5>Chưa có đánh giá nào</h5>
                    <p>Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM đã được tải hoàn toàn.');
        
        // Product variant selection logic
        const variantSelect = document.getElementById('variantSelect');
        const displayPrice = document.getElementById('display-price');
        const displayQuantity = document.getElementById('display-quantity');
        const selectedVariantInfo = document.getElementById('selectedVariantInfo');
        const addToCartBtn = document.getElementById('addToCartBtn');
        const productImageDisplay = document.getElementById('productImageDisplay'); 
        
        const originalProductImageURL = productImageDisplay.src; 
        const originalProductPrice = displayPrice.innerText;

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(Number(amount)); 
        }

        if (variantSelect) {
            variantSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const variantId = selectedOption.value;

                if (variantId) { 
                    const price = selectedOption.dataset.price;
                    const quantity = selectedOption.dataset.quantity;
                    const color = selectedOption.dataset.color;
                    const size = selectedOption.dataset.size;
                    const imageUrl = selectedOption.dataset.imageurl; 

                    displayPrice.innerText = formatCurrency(price);
                    selectedVariantInfo.innerHTML = `<i class="fas fa-check-circle text-success me-1"></i>Bạn đã chọn: Màu ${color}, Size ${size}`;
                    
                    const qty = parseInt(quantity);

                    if (qty === 0) {
                        displayQuantity.innerHTML = '<i class="fas fa-times-circle me-1"></i>(Hết hàng)';
                        displayQuantity.classList.add('text-danger-stock');
                        displayQuantity.classList.remove('text-success-stock');
                        addToCartBtn.disabled = true;
                    } else {
                        displayQuantity.innerHTML = `<i class="fas fa-check-circle me-1"></i>(Còn:`+ qty +` sản phẩm)`;
                        displayQuantity.classList.remove('text-danger-stock');
                        displayQuantity.classList.add('text-success-stock');
                        addToCartBtn.disabled = false;
                    }
                    
                    if (imageUrl) {
                        productImageDisplay.src = imageUrl;
                    } else {
                        productImageDisplay.src = originalProductImageURL;
                    }

                } else {
                    displayPrice.innerText = originalProductPrice;
                    displayQuantity.innerText = '';
                    selectedVariantInfo.innerText = '';
                    displayQuantity.classList.remove('text-danger-stock', 'text-success-stock');
                    addToCartBtn.disabled = true;
                    productImageDisplay.src = originalProductImageURL;
                }
            });

            // Auto-select first available variant
            let firstAvailableVariantFound = false;
            for (let i = 0; i < variantSelect.options.length; i++) {
                if (variantSelect.options[i].value !== "" && parseInt(variantSelect.options[i].dataset.quantity) > 0) {
                    variantSelect.value = variantSelect.options[i].value;
                    variantSelect.dispatchEvent(new Event('change')); 
                    firstAvailableVariantFound = true;
                    break;
                }
            }
            
            if (!firstAvailableVariantFound) {
                if (variantSelect.options.length > 1) { 
                    displayQuantity.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i>(Không có phiên bản nào còn hàng)';
                    displayQuantity.classList.add('text-danger-stock');
                } else {
                    displayQuantity.innerHTML = '<i class="fas fa-info-circle me-1"></i>(Sản phẩm này không có biến thể)';
                    displayQuantity.classList.add('text-muted');
                }
                addToCartBtn.disabled = true;
            }
        } else {
            if (addToCartBtn) {
               addToCartBtn.disabled = true;
            }
            if (displayQuantity) {
                displayQuantity.innerHTML = '<i class="fas fa-info-circle me-1"></i>(Sản phẩm này không có biến thể)';
                displayQuantity.classList.add('text-muted');
            }
        }

        // Reviews functionality
        const reviews = [
            <c:forEach var="review" items="${reviews}" varStatus="status">
            {
                rating: ${review.rating},
                userName: '${review.userName}',
                comment: '${review.comment}',
                createdAt: '<fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Calculate and display rating statistics
        function calculateRatingStats() {
            if (reviews.length === 0) return;

            const ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
            let totalRating = 0;

            reviews.forEach(review => {
                ratingCounts[review.rating]++;
                totalRating += review.rating;
            });

            const averageRating = (totalRating / reviews.length).toFixed(1);
            
            // Update average rating display
            document.getElementById('averageRating').textContent = averageRating;
            
            // Update stars display
            const starsHtml = generateStarsHtml(Math.round(averageRating));
            document.getElementById('averageStars').innerHTML = starsHtml;

            // Update rating breakdown
            const breakdownHtml = Object.keys(ratingCounts).reverse().map(rating => {
                const count = ratingCounts[rating];
                const percentage = reviews.length > 0 ? (count / reviews.length * 100) : 0;
                
                return `
                    <div class="rating-bar">
                        <div class="rating-bar-label">${rating} <i class="fas fa-star"></i></div>
                        <div class="rating-bar-fill">
                            <div class="rating-bar-progress" style="width: ${percentage}%"></div>
                        </div>
                        <div class="rating-bar-count">${count}</div>
                    </div>
                `;
            }).join('');
            
            document.getElementById('ratingBreakdown').innerHTML = breakdownHtml;
        }

        function generateStarsHtml(rating) {
            let starsHtml = '';
            for (let i = 1; i <= 5; i++) {
                starsHtml += `<i class="fas fa-star ${i <= rating ? '' : 'text-muted'}"></i>`;
            }
            return starsHtml;
        }

        // Filter reviews by rating
        const filterButtons = document.querySelectorAll('.filter-btn');
        const reviewItems = document.querySelectorAll('.review-item');

        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons
                filterButtons.forEach(btn => btn.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');

                const filterRating = this.dataset.rating;

                reviewItems.forEach(item => {
                    if (filterRating === 'all' || item.dataset.rating === filterRating) {
                        item.style.display = 'block';
                        item.classList.add('slide-up');
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        });

        // Initialize rating statistics
        if (reviews.length > 0) {
            calculateRatingStats();
        }

        // Add smooth scrolling to reviews section
        const reviewsSection = document.querySelector('.reviews-section');
        if (reviewsSection) {
            // You can add a button to scroll to reviews if needed
        }
    });
</script>

</body>
</html>