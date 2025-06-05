<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
    </head>
    <body>
        <div class="container my-4">
            <h2 class="mb-4"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng của bạn</h2>

            <c:choose>
                <c:when test="${not empty sessionScope.carts}">
                    <div class="row g-3">
                        <c:forEach var="cart" items="${sessionScope.carts}">
                            <div class="col-md-12">
                                <div class="card p-3 shadow-sm d-flex flex-row align-items-center">
                                    <img src="${cart.imageURL}" class="img-thumbnail me-3" style="width: 100px; height: auto;" alt="${cart.productName}">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${cart.productName}</h5>
                                        <p class="mb-1 text-danger fw-bold"><fmt:formatNumber value="${cart.price}" type="number" />₫</p>

                                        <div class="d-flex align-items-center mb-2">
                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="me-2">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="quantity" value="${cart.quantity - 1}"/>
                                                <button class="btn btn-outline-secondary btn-sm">−</button>
                                            </form>

                                            <input type="text" class="form-control form-control-sm text-center mx-1" value="${cart.quantity}" style="width: 50px;" readonly />

                                            <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="ms-2">
                                                <input type="hidden" name="action" value="updatequantity"/>
                                                <input type="hidden" name="cartId" value="${cart.cartId}"/>
                                                <input type="hidden" name="quantity" value="${cart.quantity + 1}"/>
                                                <button class="btn btn-outline-secondary btn-sm">+</button>
                                            </form>
                                        </div>

                                        <div>Thành tiền: <strong><fmt:formatNumber value="${cart.price * cart.quantity}" type="number"/>₫</strong></div>
                                    </div>

                                    <div class="text-end ms-3">
                                        <a href="${pageContext.request.contextPath}/CartServlet?action=deleteCartItem&cartId=${cart.cartId}" class="btn btn-outline-danger btn-sm mb-1">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </a>
                                        <br/>
                                        <a href="${pageContext.request.contextPath}/SimilarProductServlet?categoryId=${cart.categoryId}" class="btn btn-outline-primary btn-sm">
                                            <i class="fa-solid fa-magnifying-glass"></i> Tìm tương tự
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Tổng tiền -->
                    <div class="mt-4 text-end">
                        <h4>Tổng cộng: <span class="text-danger"><fmt:formatNumber value="${cartTotal}" type="number" />₫</span></h4>
                    </div>
                    <!-- Form địa chỉ giao hàng -->
                    <div class="shipping-form">
                        <h3>📦 Nhập địa chỉ giao hàng</h3>
                        <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="shippingForm">
                            <input type="hidden" name="action" value="placeOrder">
                            <input type="hidden" name="totalAmount" value="${cartTotal}">
                            <input type="hidden" name="shippingAddress" id="shippingAddress">

                            <div class="location-select">
                                <label for="province">Tỉnh/Thành phố:</label>
                                <select id="province" required>
                                    <option value="">-- Chọn Tỉnh/Thành --</option>
                                </select>

                                <label for="district">Quận/Huyện:</label>
                                <select id="district" required>
                                    <option value="">-- Chọn Quận/Huyện --</option>
                                </select>

                                <label for="ward">Phường/Xã:</label>
                                <select id="ward" required>
                                    <option value="">-- Chọn Phường/Xã --</option>
                                </select>
                            </div>

                            <div class="address-box">
                                <label for="detailAddress">Địa chỉ cụ thể:</label>
                                <textarea id="detailAddress" rows="2" placeholder="Số nhà, tên đường..." required></textarea>
                            </div>

                            <button type="submit" class="checkout-btn">🛍 Thanh toán ngay</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty-message">Giỏ hàng của bạn đang trống 😢</p>
                </c:otherwise>
            </c:choose>

            <div class="links">
                <a href="${pageContext.request.contextPath}/Home">⬅️ Quay lại trang chủ</a>
                <a href="${pageContext.request.contextPath}/CartServlet?action=viewOrders">📦 Đơn hàng</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/vietnamjs@1.0.0/dist/vietnamjs.min.js"></script>
        <script>
            const provinceSelect = document.getElementById('province');
            const districtSelect = document.getElementById('district');
            const wardSelect = document.getElementById('ward');
            const detailAddress = document.getElementById('detailAddress');
            const shippingAddress = document.getElementById('shippingAddress');
            const shippingForm = document.getElementById('shippingForm');

            fetch('https://provinces.open-api.vn/api/?depth=3')
                    .then(res => res.json())
                    .then(data => {
                        data.forEach(province => {
                            const opt = document.createElement('option');
                            opt.value = province.name;
                            opt.text = province.name;
                            opt.dataset.districts = JSON.stringify(province.districts);
                            provinceSelect.appendChild(opt);
                        });

                        provinceSelect.addEventListener('change', () => {
                            districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            const selected = provinceSelect.selectedOptions[0];
                            const districts = JSON.parse(selected.dataset.districts || '[]');
                            districts.forEach(district => {
                                const opt = document.createElement('option');
                                opt.value = district.name;
                                opt.text = district.name;
                                opt.dataset.wards = JSON.stringify(district.wards);
                                districtSelect.appendChild(opt);
                            });
                        });

                        districtSelect.addEventListener('change', () => {
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            const selected = districtSelect.selectedOptions[0];
                            const wards = JSON.parse(selected.dataset.wards || '[]');
                            wards.forEach(ward => {
                                const opt = document.createElement('option');
                                opt.value = ward.name;
                                opt.text = ward.name;
                                wardSelect.appendChild(opt);
                            });
                        });
                    });

            shippingForm.addEventListener('submit', function (e) {
                const province = provinceSelect.value;
                const district = districtSelect.value;
                const ward = wardSelect.value;
                const detail = detailAddress.value.trim();

                if (!province || !district || !ward || !detail) {
                    alert("Vui lòng nhập đầy đủ địa chỉ giao hàng.");
                    e.preventDefault();
                    return;
                }

                shippingAddress.value = `${detail}, ${ward}, ${district}, ${province}`;
                    });
        </script>
    </body>
</html>
