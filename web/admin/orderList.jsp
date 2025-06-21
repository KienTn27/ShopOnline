<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Đơn Hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #2563eb;
                --secondary-color: #64748b;
                --success-color: #16a34a;
                --warning-color: #ea580c;
                --danger-color: #dc2626;
                --info-color: #0891b2;
                --dark-color: #1e293b;
                --light-bg: #f8fafc;
                --border-color: #e2e8f0;
            }

            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .main-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                margin: 2rem auto;
                padding: 0;
                overflow: hidden;
            }

            .header-section {
                background: linear-gradient(135deg, var(--primary-color), #3b82f6);
                color: white;
                padding: 2rem;
                position: relative;
                overflow: hidden;
            }

            .header-section::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="rgba(255,255,255,0.1)"/></svg>') repeat;
                animation: float 20s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                50% {
                    transform: translateY(-10px) rotate(180deg);
                }
            }

            .header-content {
                position: relative;
                z-index: 2;
            }

            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .page-subtitle {
                opacity: 0.9;
                margin-top: 0.5rem;
                font-size: 1.1rem;
            }

            .stats-row {
                margin-top: 1.5rem;
                display: flex;
                gap: 2rem;
                flex-wrap: wrap;
            }

            .stat-item {
                background: rgba(255, 255, 255, 0.2);
                padding: 1rem;
                border-radius: 10px;
                backdrop-filter: blur(10px);
                flex: 1;
                min-width: 150px;
                text-align: center;
            }

            .stat-number {
                font-size: 1.8rem;
                font-weight: bold;
                display: block;
            }

            .stat-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .content-section {
                padding: 2rem;
            }

            .error-message {
                background: linear-gradient(135deg, #fef2f2, #fee2e2);
                color: var(--danger-color);
                border: 1px solid #fecaca;
                border-left: 4px solid var(--danger-color);
                padding: 1rem 1.5rem;
                border-radius: 10px;
                margin-bottom: 2rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                box-shadow: 0 4px 6px rgba(220, 38, 38, 0.1);
            }

            .table-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                border: 1px solid var(--border-color);
            }

            .table {
                margin: 0;
                font-size: 0.95rem;
            }

            .table thead th {
                background: linear-gradient(135deg, #f8fafc, #f1f5f9);
                border: none;
                padding: 1.25rem 1rem;
                font-weight: 600;
                color: var(--dark-color);
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
                position: relative;
            }

            .table thead th::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 2px;
                background: linear-gradient(90deg, var(--primary-color), transparent);
            }

            .table tbody td {
                padding: 1rem;
                vertical-align: middle;
                border-top: 1px solid #f1f5f9;
            }

            .table tbody tr {
                transition: all 0.3s ease;
            }

            .table tbody tr:hover {
                background: linear-gradient(135deg, #f8fafc, #f1f5f9);
                transform: translateX(5px);
            }

            .order-id {
                font-weight: 600;
                color: var(--primary-color);
                font-family: 'Courier New', monospace;
            }

            .user-badge {
                background: linear-gradient(135deg, #e0f2fe, #b3e5fc);
                color: #0277bd;
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.4rem;
            }

            .date-display {
                color: var(--secondary-color);
                font-size: 0.9rem;
            }

            .total-amount {
                font-weight: 700;
                font-size: 1.1rem;
                color: var(--success-color);
            }

            .status-badge {
                padding: 0.5rem 1rem;
                border-radius: 25px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .status-pending {
                background: linear-gradient(135deg, #fef3c7, #fde68a);
                color: #92400e;
            }

            .status-processing {
                background: linear-gradient(135deg, #dbeafe, #bfdbfe);
                color: #1e40af;
            }

            .status-confirmed {
                background: linear-gradient(135deg, #d1fae5, #a7f3d0);
                color: #065f46;
            }

            .status-shipped {
                background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
                color: #3730a3;
            }

            .status-delivered {
                background: linear-gradient(135deg, #dcfce7, #bbf7d0);
                color: #14532d;
            }

            .status-cancelled {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #991b1b;
                animation: pulse-red 2s infinite;
            }

            @keyframes pulse-red {
                0%, 100% {
                    box-shadow: 0 0 0 0 rgba(220, 38, 38, 0.4);
                }
                50% {
                    box-shadow: 0 0 0 10px rgba(220, 38, 38, 0);
                }
            }

            .update-form {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }

            .form-select {
                border: 2px solid var(--border-color);
                border-radius: 8px;
                padding: 0.5rem;
                font-size: 0.9rem;
                background: white;
                transition: all 0.3s ease;
                min-width: 130px;
            }

            .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
            }

            .btn-update {
                background: linear-gradient(135deg, var(--primary-color), #3b82f6);
                border: none;
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
            }

            .btn-update:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(37, 99, 235, 0.3);
                background: linear-gradient(135deg, #1e40af, var(--primary-color));
            }

            .disabled-message {
                background: linear-gradient(135deg, #f8fafc, #f1f5f9);
                color: var(--secondary-color);
                padding: 0.75rem 1rem;
                border-radius: 8px;
                font-size: 0.85rem;
                border-left: 3px solid #cbd5e1;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .no-orders {
                text-align: center;
                padding: 3rem;
                color: var(--secondary-color);
            }

            .no-orders i {
                font-size: 4rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }

            @media (max-width: 768px) {
                .main-container {
                    margin: 1rem;
                    border-radius: 15px;
                }

                .header-section {
                    padding: 1.5rem;
                }

                .page-title {
                    font-size: 2rem;
                }

                .stats-row {
                    gap: 1rem;
                }

                .stat-item {
                    min-width: 120px;
                }

                .content-section {
                    padding: 1.5rem;
                }

                .table-container {
                    overflow-x: auto;
                }

                .update-form {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .form-select {
                    min-width: 100px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="main-container">
                <!-- Header Section -->
                <div class="header-section">
                    <div class="header-content">
                        <h1 class="page-title">
                            <i class="fas fa-clipboard-list"></i>
                            Quản Lý Đơn Hàng
                        </h1>
                        <p class="page-subtitle">
                            Theo dõi và cập nhật trạng thái đơn hàng một cách hiệu quả
                        </p>
                        <div class="stats-row">
                            <div class="stat-item">
                                <span class="stat-number">${not empty orders ? orders.size() : 0}</span>
                                <span class="stat-label">Tổng đơn hàng</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">
                                    <c:set var="activeCount" value="0"/>
                                    <c:forEach var="order" items="${orders}">
                                        <c:if test="${order.status != 'Cancelled' && order.status != 'Delivered'}">
                                            <c:set var="activeCount" value="${activeCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${activeCount}
                                </span>
                                <span class="stat-label">Đang xử lý</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">
                                    <c:set var="deliveredCount" value="0"/>
                                    <c:forEach var="order" items="${orders}">
                                        <c:if test="${order.status == 'Delivered'}">
                                            <c:set var="deliveredCount" value="${deliveredCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${deliveredCount}
                                </span>
                                <span class="stat-label">Đã giao</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content Section -->
                <div class="content-section">
                    <!-- Error Message -->
                    <c:if test="${not empty requestScope.error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>${requestScope.error}</span>
                        </div>
                    </c:if>

                    <!-- Orders Table -->
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${not empty orders}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-hashtag me-1"></i>Mã Đơn Hàng</th>
                                            <th><i class="fas fa-user me-1"></i>Khách Hàng</th>
                                            <th><i class="fas fa-calendar me-1"></i>Ngày Đặt</th>
                                            <th><i class="fas fa-dollar-sign me-1"></i>Tổng Tiền</th>
                                            <th><i class="fas fa-info-circle me-1"></i>Trạng Thái</th>
                                            <th><i class="fas fa-edit me-1"></i>Cập Nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${orders}">
                                            <tr>
                                                <td>
                                                    <span class="order-id">#${order.orderId}</span>
                                                </td>
                                                <td>
                                                    <span class="user-badge">
                                                        <i class="fas fa-user-circle"></i>
                                                        ${order.userId}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="date-display">
                                                        <i class="far fa-clock me-1"></i>
                                                        ${order.orderDate}
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="total-amount">$${order.totalAmount}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Pending'}">
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-clock"></i>
                                                                Chờ xử lý
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Processing'}">
                                                            <span class="status-badge status-processing">
                                                                <i class="fas fa-cog fa-spin"></i>
                                                                Đang xử lý
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Confirmed'}">
                                                            <span class="status-badge status-confirmed">
                                                                <i class="fas fa-check"></i>
                                                                Đã xác nhận
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Shipped'}">
                                                            <span class="status-badge status-shipped">
                                                                <i class="fas fa-shipping-fast"></i>
                                                                Đang giao
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Delivered'}">
                                                            <span class="status-badge status-delivered">
                                                                <i class="fas fa-check-double"></i>
                                                                Đã giao
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Cancelled'}">
                                                            <span class="status-badge status-cancelled">
                                                                <i class="fas fa-times"></i>
                                                                Đã hủy
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-question"></i>
                                                                ${order.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Cancelled'}">
                                                            <div class="disabled-message">
                                                                <i class="fas fa-lock"></i>
                                                                <span>Không thể thay đổi trạng thái đơn hàng đã hủy</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="UpdateStatusServlet" method="post" class="update-form">
                                                                <input type="hidden" name="orderId" value="${order.orderId}" />
                                                                <select name="status" class="form-select">
                                                                    <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                                                    <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                                                                    <option value="Confirmed" ${order.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                                                    <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Đang giao</option>
                                                                    <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Đã giao</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-update">
                                                                    <i class="fas fa-save me-1"></i>
                                                                    Cập nhật
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="no-orders">
                                    <i class="fas fa-inbox"></i>
                                    <h4>Chưa có đơn hàng nào</h4>
                                    <p>Danh sách đơn hàng sẽ hiển thị tại đây khi có dữ liệu.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Add smooth scrolling and form validation
            document.addEventListener('DOMContentLoaded', function () {
                // Form submission with loading state
                const updateForms = document.querySelectorAll('.update-form');
                updateForms.forEach(form => {
                    form.addEventListener('submit', function (e) {
                        const button = form.querySelector('.btn-update');
                        const originalText = button.innerHTML;
                        button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang cập nhật...';
                        button.disabled = true;

                        // Re-enable button after 3 seconds in case of error
                        setTimeout(() => {
                            button.innerHTML = originalText;
                            button.disabled = false;
                        }, 3000);
                    });
                });

                // Auto-hide error messages after 10 seconds
                const errorMessages = document.querySelectorAll('.error-message');
                errorMessages.forEach(msg => {
                    setTimeout(() => {
                        msg.style.transition = 'opacity 0.5s ease';
                        msg.style.opacity = '0';
                        setTimeout(() => {
                            msg.remove();
                        }, 500);
                    }, 10000);
                });
            });
        </script>
    </body>
</html>