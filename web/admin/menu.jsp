<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menu Quản trị</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 35%, #16213e 100%);
            min-height: 100vh;
            padding: 2rem;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background particles */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="%23ffffff08" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            pointer-events: none;
            z-index: -1;
        }

        /* Header section */
        .admin-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .admin-header h1 {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            letter-spacing: -0.02em;
        }

        .admin-header p {
            color: #94a3b8;
            font-size: 1.1rem;
            font-weight: 400;
        }

        .menu-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 2rem;
        }

        .menu-group {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
            position: relative;
        }

        .menu-group::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
        }

        .menu-group:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
            border-color: rgba(102, 126, 234, 0.3);
        }

        .group-header {
            padding: 2rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, rgba(255, 255, 255, 0.02) 100%);
            transition: all 0.3s ease;
            position: relative;
        }

        .group-header:hover {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        }

        .group-title {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .group-icon {
            width: 50px;
            height: 50px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            position: relative;
            overflow: hidden;
        }

        /* Fashion-themed gradients for each category */
        .menu-group:nth-child(1) .group-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .menu-group:nth-child(2) .group-icon {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .menu-group:nth-child(3) .group-icon {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .menu-group:nth-child(4) .group-icon {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .menu-group:nth-child(5) .group-icon {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        .group-icon::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.2);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .group-header:hover .group-icon::before {
            opacity: 1;
        }

        .group-header h3 {
            color: #ffffff;
            font-size: 1.2rem;
            font-weight: 600;
            letter-spacing: -0.01em;
        }

        .arrow {
            font-size: 1.4rem;
            color: #94a3b8;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .group-content {
            display: none;
            flex-direction: column;
            padding: 0;
            background: rgba(0, 0, 0, 0.1);
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
            gap: 1.2rem;
            padding: 1.5rem 2rem;
            text-decoration: none;
            color: #cbd5e1;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            position: relative;
            font-weight: 500;
        }

        .group-content a:last-child {
            border-bottom: none;
        }

        .group-content a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s ease;
        }

        .group-content a:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.03);
            transform: translateX(8px);
        }

        .group-content a:hover::before {
            width: 4px;
        }

        /* Fashion-specific icons */
        .group-content a .menu-icon {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            opacity: 0.8;
            transition: opacity 0.3s ease;
        }

        .group-content a:hover .menu-icon {
            opacity: 1;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .admin-header h1 {
                font-size: 2rem;
            }

            .menu-wrapper {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .group-header {
                padding: 1.5rem;
            }

            .group-content a {
                padding: 1.2rem 1.5rem;
            }
        }

        /* Arrow rotation */
        .arrow[style*="rotate(90deg)"] {
            transform: rotate(90deg);
            color: #667eea;
        }

        /* Glowing effect on hover */
        .menu-group:hover {
            box-shadow: 
                0 30px 60px rgba(0, 0, 0, 0.4),
                0 0 40px rgba(102, 126, 234, 0.2);
        }

        /* Stats badge for some items */
        .stats-badge {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            font-size: 0.7rem;
            padding: 0.2rem 0.6rem;
            border-radius: 12px;
            margin-left: auto;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(240, 147, 251, 0.3);
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
                    <span class="menu-icon">📈</span>
                    Doanh thu
                    <span class="stats-badge">Mới</span>
                </a>
                <a href="<%= request.getContextPath() %>/average-revenue">
                    <span class="menu-icon">📊</span>
                    Doanh thu trung bình
                </a>
                <a href="<%= request.getContextPath() %>/highest-revenue">
                    <span class="menu-icon">🌟</span>
                    Doanh thu cao nhất
                </a>
                <a href="<%= request.getContextPath() %>/lowest-revenue-day">
                    <span class="menu-icon">📉</span>
                    Doanh thu thấp nhất
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
            <span class="menu-icon">🔥</span>
            Bán chạy
            <span class="stats-badge">Hot</span>
        </a>
        <a href="<%= request.getContextPath() %>/product-sales">
            <span class="menu-icon">📦</span>
            Bán ra
        </a>
        <a href="<%= request.getContextPath() %>/UpdateStatusServlet">
            <span class="menu-icon">🗂️</span>
            Cập nhật trạng thái đơn hàng
        </a>
            
             <a href="<%= request.getContextPath() %>/managerProduct">
            <span class="menu-icon">🗂️</span>
            Quản lí sản phẩm
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
                    <span class="menu-icon">👑</span>
                    Người dùng chi tiêu
                    <span class="stats-badge">VIP</span>
                </a>
                <a href="<%= request.getContextPath() %>/ReviewServlet">
                    <span class="menu-icon">⭐</span>
                    Đánh giá
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
                    <span class="menu-icon">📦</span>
                    Quản lý tồn kho
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

                <a href="<%= request.getContextPath() %>/admin/user-management">
                    <span class="menu-icon">👤</span>
                    Quản lý người dùng
                </a>
                <a href="<%= request.getContextPath() %>/#">
                    <span class="menu-icon">🔄</span>
                    Cập nhật trạng thái
                </a>
            </div>
        </div>
    </div>
</body>
</html>