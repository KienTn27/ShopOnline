<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>

        <meta charset="UTF-8">
        <title>Menu Quản trị</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background: #f6f8fa;
                min-height: 100vh;
                padding: 2rem;
                overflow-x: hidden;
            }
            
            .admin-header {
                text-align: center;
                margin-bottom: 2.5rem;
            }
            
            .admin-header h1 {
                color: #2d3748;
                font-size: 2.3rem;
                font-weight: 800;
                margin-bottom: 0.5rem;
                letter-spacing: -0.01em;
            }
            
            .admin-header p {
                color: #4a5568;
                font-size: 1.1rem;
                font-weight: 400;
            }
            
            .menu-wrapper {
                max-width: 1400px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(370px, 1fr));
                gap: 2rem;
            }
            
            .menu-group {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 24px 0 rgba(60, 72, 88, 0.08);
                transition: box-shadow 0.3s, transform 0.3s;
                overflow: hidden;
                border: 1.5px solid #e2e8f0;
            }
            
            .menu-group:hover {
                box-shadow: 0 8px 32px 0 rgba(72, 187, 255, 0.15);
                border-color: #90cdf4;
                transform: translateY(-4px) scale(1.01);
            }
            
            .group-header {
                padding: 1.7rem 2rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: #f7fafc;
                cursor: pointer;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .group-title {
                display: flex;
                align-items: center;
                gap: 1.1rem;
            }
            
            .group-icon {
                width: 48px;
                height: 48px;
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.7rem;
                background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
                color: #2563eb;
                box-shadow: 0 2px 8px 0 rgba(72, 187, 255, 0.10);
            }
            
            .menu-group:nth-child(2) .group-icon {
                background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);
                color: #b83280;
            }
            
            .menu-group:nth-child(3) .group-icon {
                background: linear-gradient(135deg, #fceabb 0%, #f8b500 100%);
                color: #b7791f;
            }
            
            .menu-group:nth-child(4) .group-icon {
                background: linear-gradient(135deg, #c2e9fb 0%, #81ecec 100%);
                color: #0984e3;
            }
            
            .menu-group:nth-child(5) .group-icon {
                background: linear-gradient(135deg, #d4fc79 0%, #96e6a1 100%);
                color: #38a169;
            }
            
            .group-header h3 {
                color: #2d3748;
                font-size: 1.18rem;
                font-weight: 700;
                margin: 0;
            }
            
            .arrow {
                font-size: 1.3rem;
                color: #a0aec0;
                transition: transform 0.3s, color 0.3s;
            }
            
            .arrow[style*="rotate(90deg)"] {
                color: #4299e1;
            }
            
            .group-content {
                display: none;
                flex-direction: column;
                background: #f9fafb;
            }
            
            .group-content[style*="flex"] {
                display: flex;
                animation: slideDown 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            }
            
            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .group-content a {
                display: flex;
                align-items: center;
                gap: 1.1rem;
                padding: 1.2rem 2rem;
                text-decoration: none;
                color: #2d3748;
                background: transparent;
                border-bottom: 1px solid #e2e8f0;
                font-weight: 500;
                font-size: 1.05rem;
                position: relative;
                transition: background 0.2s, color 0.2s, padding-left 0.2s;
            }
            
            .group-content a:last-child {
                border-bottom: none;
            }
            
            .group-content a:hover {
                background: #e3f2fd;
                color: #2563eb;
                padding-left: 2.5rem;
            }
            
            .group-content a .menu-icon {
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.1rem;
                opacity: 0.85;
                transition: opacity 0.2s;
            }
            
            .group-content a:hover .menu-icon {
                opacity: 1;
            }
            
            .stats-badge {
                background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
                color: #2563eb;
                font-size: 0.75rem;
                padding: 0.18rem 0.7rem;
                border-radius: 12px;
                margin-left: auto;
                font-weight: 700;
                box-shadow: 0 2px 8px rgba(72, 187, 255, 0.10);
            }
            
            @media (max-width: 768px) {
                body {
                    padding: 1rem;
                }
                .admin-header h1 {
                    font-size: 1.5rem;
                }
                .menu-wrapper {
                    grid-template-columns: 1fr;
                    gap: 1.2rem;
                }
                .group-header {
                    padding: 1.2rem 1rem;
                }
                .group-content a {
                    padding: 1rem 1rem;
                    font-size: 0.98rem;
                }
            }
        </style>
        <script>
            function toggleGroup(groupId) {
                const groupContent = document.getElementById(groupId);
                const isVisible = groupContent.style.display === "flex";
                groupContent.style.display = isVisible ? "none" : "flex";
                const arrow = document.querySelector(`#${groupId}-toggle .arrow`);
                arrow.style.transform = isVisible ? "rotate(0deg)" : "rotate(90deg)";
            }

            // Add some interactivity
            document.addEventListener('DOMContentLoaded', function() {
                // Add stagger animation for menu groups
                const menuGroups = document.querySelectorAll('.menu-group');
                menuGroups.forEach((group, index) => {
                    group.style.animationDelay = `${index * 0.1}s`;
                    group.style.animation = 'fadeInUp 0.6s ease forwards';
                });

                // Add ripple effect to menu items
                const menuItems = document.querySelectorAll('.group-content a');
                menuItems.forEach(item => {
                    item.addEventListener('click', function(e) {
                        const ripple = document.createElement('span');
                        const rect = this.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        const x = e.clientX - rect.left - size / 2;
                        const y = e.clientY - rect.top - size / 2;

                        ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50%;
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                    `;

                        this.appendChild(ripple);
                        setTimeout(() => ripple.remove(), 600);
                    });
                });
            });

            // CSS for animations
            const style = document.createElement('style');
            style.textContent = `
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            @keyframes ripple {
                to {
                    transform: scale(2);
                    opacity: 0;
                }
            }
        `;
            document.head.appendChild(style);
        </script>
    </head>

    <body>
        <div class="admin-header">
            <h1>✨ Fashion Store Admin</h1>
            <p>Bảng điều khiển quản trị thời trang hiện đại</p>
        </div>

        <div class="menu-wrapper">
            <!-- Nhóm Doanh thu -->
            <div class="menu-group" id="group-revenue-toggle">
                <div class="group-header" onclick="toggleGroup('group-revenue')">
                    <div class="group-title">
                        <div class="group-icon">📊</div>
                        <h3>Doanh thu</h3>
                    </div>
                    <span class="arrow">➤</span>
                </div>
                <div class="group-content" id="group-revenue">
                    <a href="<%= request.getContextPath() %>/RevenueServlet">
                        <span class="menu-icon">📈</span> Doanh thu
                        <span class="stats-badge">Mới</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/average-revenue">
                        <span class="menu-icon">📊</span> Doanh thu trung bình
                    </a>
                    <a href="<%= request.getContextPath() %>/highest-revenue">
                        <span class="menu-icon">🌟</span> Doanh thu cao nhất
                    </a>
                    <a href="<%= request.getContextPath() %>/lowest-revenue-day">
                        <span class="menu-icon">📉</span> Doanh thu thấp nhất
                    </a>
                </div>
            </div>

            <!-- Nhóm Sản phẩm -->
            <div class="menu-group" id="group-products-toggle">
                <div class="group-header" onclick="toggleGroup('group-products')">
                    <div class="group-title">
                        <div class="group-icon">👗</div>
                        <h3>Sản phẩm</h3>
                    </div>
                    <span class="arrow">➤</span>
                </div>
                <div class="group-content" id="group-products">
                    <a href="<%= request.getContextPath() %>/TopProductsServlet">
                        <span class="menu-icon">🔥</span> Bán chạy
                        <span class="stats-badge">Hot</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/product-sales">
                        <span class="menu-icon">📦</span> Bán ra
                    </a>
                    <a href="<%= request.getContextPath() %>/UpdateStatusServlet">
                        <span class="menu-icon">🗂️</span> Cập nhật trạng thái đơn hàng
                    </a>

                    <a href="<%= request.getContextPath() %>/managerProduct">
                        <span class="menu-icon">🗂️</span> Quản lí sản phẩm
                    </a>
                </div>
            </div>


            <!-- Nhóm Người dùng & Đánh giá -->
            <div class="menu-group" id="group-users-reviews-toggle">
                <div class="group-header" onclick="toggleGroup('group-users-reviews')">
                    <div class="group-title">
                        <div class="group-icon">💎</div>
                        <h3>Người dùng & Đánh giá</h3>
                    </div>
                    <span class="arrow">➤</span>
                </div>
                <div class="group-content" id="group-users-reviews">
                    <a href="<%= request.getContextPath() %>/TopUsersServlet">
                        <span class="menu-icon">👑</span> Người dùng chi tiêu
                        <span class="stats-badge">VIP</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/ReviewServlet">
                        <span class="menu-icon">⭐</span> Đánh giá
                    </a>
                </div>
            </div>

            <!-- Nhóm Tồn kho -->
            <div class="menu-group" id="group-inventory-toggle">
                <div class="group-header" onclick="toggleGroup('group-inventory')">
                    <div class="group-title">
                        <div class="group-icon">📋</div>
                        <h3>Tồn kho</h3>
                    </div>
                    <span class="arrow">➤</span>
                </div>
                <div class="group-content" id="group-inventory">
                    <a href="<%= request.getContextPath() %>/inventory">
                        <span class="menu-icon">📦</span> Quản lý tồn kho
                    </a>
                </div>
            </div>

            <!-- Nhóm Quản trị hệ thống -->
            <div class="menu-group" id="group-admin-toggle">
                <div class="group-header" onclick="toggleGroup('group-admin')">
                    <div class="group-title">
                        <div class="group-icon">⚙️</div>
                        <h3>Quản trị hệ thống</h3>
                    </div>
                    <span class="arrow">➤</span>
                </div>
                <div class="group-content" id="group-admin">
                    <%-- DEBUG: Hiển thị role hiện tại --%>
                        <c:if test="${not empty sessionScope.user}">
                            <div style="color:red; font-weight:bold;">ROLE:
                                <c:out value="${sessionScope.user.role}" />
                            </div>
                        </c:if>
                        <%-- Chỉ hiển thị cho Admin hoặc SuperAdmin --%>
                            <c:if test="${not empty sessionScope.user && (sessionScope.user.role eq 'Admin' || sessionScope.user.role eq 'SuperAdmin')}">
                                <a href="<%= request.getContextPath() %>/admin/user-management">
                                    <span class="menu-icon">👤</span> Quản lý người dùng
                                </a>
                            </c:if>
                            <a href="<%= request.getContextPath() %>/#">
                                <span class="menu-icon">🔄</span> Cập nhật trạng thái
                            </a>
                </div>
            </div>
        </div>
    </body>

    </html> 