<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Đơn Hàng | E-Commerce Admin</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #4f46e5;
                --primary-hover: #4338ca;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --info-color: #06b6d4;
                --dark-color: #1f2937;
                --light-bg: #f8fafc;
                --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                --border-radius: 12px;
            }

            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .admin-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                padding: 1.5rem 0;
                margin-bottom: 2rem;
                box-shadow: var(--card-shadow);
            }

            .admin-title {
                color: var(--dark-color);
                font-weight: 700;
                font-size: 2rem;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .admin-title i {
                color: var(--primary-color);
                font-size: 1.8rem;
            }

            .stats-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .stat-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: var(--border-radius);
                padding: 1.5rem;
                text-align: center;
                box-shadow: var(--card-shadow);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.15);
            }

            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .stat-label {
                color: #6b7280;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .orders-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: var(--border-radius);
                box-shadow: var(--card-shadow);
                border: 1px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
            }

            .table-header {
                background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
                color: white;
                padding: 1.5rem;
                margin: 0;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .table-responsive {
                border-radius: 0;
            }

            .modern-table {
                margin: 0;
                background: white;
            }

            .modern-table thead th {
                background: var(--light-bg);
                color: var(--dark-color);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.5px;
                padding: 1rem;
                border: none;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .modern-table tbody tr {
                transition: background-color 0.2s ease;
                border-bottom: 1px solid #e5e7eb;
            }

            .modern-table tbody tr:hover {
                background-color: #f8fafc;
            }

            .modern-table td {
                padding: 1rem;
                vertical-align: middle;
                border: none;
            }

            .status-badge {
                padding: 0.375rem 0.75rem;
                border-radius: 50px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: inline-flex;
                align-items: center;
                gap: 0.375rem;
            }

            .status-pending {
                background: #fef3c7;
                color: #92400e;
            }

            .status-processing {
                background: #dbeafe;
                color: #1e40af;
            }

            .status-shipped {
                background: #d1fae5;
                color: #065f46;
            }

            .status-delivered {
                background: #dcfce7;
                color: #166534;
            }

            .status-cancelled {
                background: #fee2e2;
                color: #991b1b;
            }

            .update-form {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }

            .status-select {
                border-radius: 8px;
                border: 2px solid #e5e7eb;
                padding: 0.375rem 0.75rem;
                font-size: 0.875rem;
                transition: border-color 0.2s ease;
                background: white;
            }

            .status-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .btn-update {
                background: var(--primary-color);
                border: none;
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.875rem;
                font-weight: 500;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 0.375rem;
            }

            .btn-update:hover {
                background: var(--primary-hover);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
                color: white;
            }

            .order-id {
                font-weight: 600;
                color: var(--primary-color);
            }

            .product-name {
                font-weight: 500;
                color: var(--dark-color);
            }

            .total-amount {
                font-weight: 600;
                color: var(--success-color);
                font-size: 1.1rem;
            }

            .user-name {
                color: #4b5563;
                font-weight: 500;
            }

            .order-date {
                color: #6b7280;
                font-size: 0.9rem;
            }

            .no-orders {
                text-align: center;
                padding: 3rem;
                color: #6b7280;
            }

            .no-orders i {
                font-size: 3rem;
                margin-bottom: 1rem;
                color: #d1d5db;
            }

            @media (max-width: 768px) {
                .admin-title {
                    font-size: 1.5rem;
                    text-align: center;
                }

                .stats-cards {
                    grid-template-columns: repeat(2, 1fr);
                }

                .update-form {
                    flex-direction: column;
                    gap: 0.25rem;
                }

                .status-select, .btn-update {
                    width: 100%;
                    font-size: 0.8rem;
                }
            }

            .loading-spinner {
                display: none;
                margin-left: 0.5rem;
            }

            .form-updating .loading-spinner {
                display: inline-block;
            }

            .form-updating .btn-update {
                opacity: 0.7;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="admin-header">
            <div class="container">
                <h1 class="admin-title">
                    <i class="fas fa-shopping-cart"></i>
                    Quản Lý Đơn Hàng
                </h1>
            </div>
        </div>

        <div class="container">
            <!-- Statistics Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--info-color);">
                        <c:choose>
                            <c:when test="${not empty orders}">
                                ${orders.size()}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Tổng Đơn Hàng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--warning-color);">
                        <c:set var="pendingCount" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.status == 'Pending'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${pendingCount}
                    </div>
                    <div class="stat-label">Chờ Xử Lý</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--success-color);">
                        <c:set var="deliveredCount" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.status == 'Delivered'}">
                                <c:set var="deliveredCount" value="${deliveredCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${deliveredCount}
                    </div>
                    <div class="stat-label">Đã Giao</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--danger-color);">
                        <c:set var="cancelledCount" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.status == 'Cancelled'}">
                                <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${cancelledCount}
                    </div>
                    <div class="stat-label">Đã Hủy</div>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="orders-container">
                <h3 class="table-header">
                    <i class="fas fa-list"></i>
                    Danh Sách Đơn Hàng
                </h3>

                <c:choose>
                    <c:when test="${not empty orders}">
                        <div class="table-responsive">
                            <table class="table modern-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag me-1"></i>Mã Đơn</th>
                                        <th><i class="fas fa-user me-1"></i>Khách Hàng</th>
                                        <th><i class="fas fa-box me-1"></i>Sản Phẩm</th>
                                        <th><i class="fas fa-calendar me-1"></i>Ngày Đặt</th>
                                        <th><i class="fas fa-money-bill me-1"></i>Tổng Tiền</th>
                                        <th><i class="fas fa-info-circle me-1"></i>Trạng Thái</th>
                                        <th><i class="fas fa-edit me-1"></i>Cập Nhật</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td class="order-id">#${order.orderId}</td>
                                            <td class="user-name">${order.userName}</td>
                                            <td class="product-name">${order.productName}</td>
                                            <td class="order-date">${order.orderDate}</td>
                                            <td class="total-amount">${order.totalAmount}đ</td>
                                            <td>
                                                <span class="status-badge status-${order.status.toLowerCase()}">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Pending'}">
                                                            <i class="fas fa-clock"></i>Chờ xử lý
                                                        </c:when>
                                                        <c:when test="${order.status == 'Processing'}">
                                                            <i class="fas fa-spinner"></i>Đang xử lý
                                                        </c:when>
                                                        <c:when test="${order.status == 'Shipped'}">
                                                            <i class="fas fa-truck"></i>Đã gửi
                                                        </c:when>
                                                        <c:when test="${order.status == 'Delivered'}">
                                                            <i class="fas fa-check-circle"></i>Đã giao
                                                        </c:when>
                                                        <c:when test="${order.status == 'Cancelled'}">
                                                            <i class="fas fa-times-circle"></i>Đã hủy
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <form action="UpdateStatusServlet" method="post" class="update-form" onsubmit="showLoading(this)">
                                                    <input type="hidden" name="orderId" value="${order.orderId}" />
                                                    <select name="status" class="status-select">
                                                        <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                                        <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                                                        <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Đã gửi</option>
                                                        <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Đã giao</option>
                                                        <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                                    </select>
                                                    <button type="submit" class="btn-update">
                                                        <i class="fas fa-sync-alt"></i>
                                                        Cập nhật
                                                        <div class="loading-spinner">
                                                            <i class="fas fa-spinner fa-spin"></i>
                                                        </div>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-orders">
                            <i class="fas fa-inbox"></i>
                            <h4>Chưa có đơn hàng nào</h4>
                            <p>Không có đơn hàng nào để hiển thị.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    function showLoading(form) {
                                                        form.classList.add('form-updating');
                                                        form.querySelector('.btn-update').disabled = true;
                                                    }

                                                    // Add smooth animations on page load
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        const cards = document.querySelectorAll('.stat-card');
                                                        cards.forEach((card, index) => {
                                                            card.style.opacity = '0';
                                                            card.style.transform = 'translateY(20px)';
                                                            setTimeout(() => {
                                                                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                                                                card.style.opacity = '1';
                                                                card.style.transform = 'translateY(0)';
                                                            }, index * 100);
                                                        });

                                                        const tableContainer = document.querySelector('.orders-container');
                                                        if (tableContainer) {
                                                            tableContainer.style.opacity = '0';
                                                            tableContainer.style.transform = 'translateY(30px)';
                                                            setTimeout(() => {
                                                                tableContainer.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                                                                tableContainer.style.opacity = '1';
                                                                tableContainer.style.transform = 'translateY(0)';
                                                            }, 400);
                                                        }
                                                    });

                                                    // Auto-refresh functionality (optional)
                                                    let autoRefresh = false;
                                                    function toggleAutoRefresh() {
                                                        autoRefresh = !autoRefresh;
                                                        if (autoRefresh) {
                                                            setInterval(() => {
                                                                if (autoRefresh) {
                                                                    location.reload();
                                                                }
                                                            }, 30000); // Refresh every 30 seconds
                                                        }
                                                    }
        </script>
    </body>
</html>