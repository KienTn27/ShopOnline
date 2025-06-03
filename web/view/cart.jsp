<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
    </head>
    <body>
        <div class="cart-container">
            <h2>🛒 Giỏ hàng của bạn</h2>

            <c:choose>
                <c:when test="${not empty sessionScope.carts}">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cart" items="${sessionScope.carts}">
                                <tr>
                                    <td>
                                        <div class="product-info">
                                            <img src="${cart.imageURL}" alt="${cart.productName}" class="product-image"/>
                                            <div class="product-details">
                                                <div class="product-name">${cart.productName}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${cart.price}" type="number"/>₫</td>
                                    <td>
                                        <div class="quantity-box">
                                            <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                                                <input type="hidden" name="action" value="updatequantity">
                                                <input type="hidden" name="cartId" value="${cart.cartId}">
                                                <input type="hidden" name="quantity" value="${cart.quantity - 1}">
                                                <button type="submit">−</button>
                                            </form>

                                            <input type="text" value="${cart.quantity}" readonly>

                                            <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                                                <input type="hidden" name="action" value="updatequantity">
                                                <input type="hidden" name="cartId" value="${cart.cartId}">
                                                <input type="hidden" name="quantity" value="${cart.quantity + 1}">
                                                <button type="submit">+</button>
                                            </form>
                                        </div>

                                    </td>
                                    <td><fmt:formatNumber value="${cart.price * cart.quantity}" type="number"/>₫</td>
                                    <td>
                                        <a class="delete-btn" href="${pageContext.request.contextPath}/CartServlet?action=deleteCartItem&cartId=${cart.cartId}">🗑 Xóa</a><br>
                                        <a class="similar-btn" href="#">🔍 Tìm tương tự</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="total-label">Tổng cộng:</td>
                                <td colspan="2" class="total-value"><fmt:formatNumber value="${cartTotal}" type="number" />₫</td>
                            </tr>
                        </tfoot>
                    </table>

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
                <a href="${pageContext.request.contextPath}/HomeServlet">⬅️ Quay lại trang chủ</a>
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
