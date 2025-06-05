<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Fashion Store Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .page-title {
            color: #2c3e50;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            text-align: center;
            border-left: 4px solid;
        }

        .stat-card.total { border-left-color: #3498db; }
        .stat-card.active { border-left-color: #2ecc71; }
        .stat-card.blocked { border-left-color: #e74c3c; }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 14px;
        }

        .alert {
            background: #fee;
            color: #c33;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #e74c3c;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .table-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tr:hover {
            background: #f8f9ff;
            transition: all 0.3s ease;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-blocked {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .role-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .role-admin {
            background: #fff3cd;
            color: #856404;
        }

        .role-user {
            background: #d1ecf1;
            color: #0c5460;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-block {
            background: #ffeaa7;
            color: #d63031;
        }

        .btn-block:hover {
            background: #fdcb6e;
            transform: translateY(-1px);
        }

        .btn-unblock {
            background: #55efc4;
            color: #00b894;
        }

        .btn-unblock:hover {
            background: #00cec9;
            color: white;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: #fab1a0;
            color: #e17055;
        }

        .btn-delete:hover {
            background: #e17055;
            color: white;
            transform: translateY(-1px);
        }

        .search-container {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .search-box {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-box:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-icon {
            position: absolute;
            right: 35px;
            top: 50%;
            transform: translateY(-50%);
            color: #adb5bd;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .page-title {
                font-size: 24px;
            }
            
            .table-container {
                overflow-x: auto;
            }
            
            table {
                min-width: 800px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .table-container {
            animation: fadeIn 0.6s ease-out;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <div>
                <a href="menu.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại menu
                </a>
            </div>
            <h1 class="page-title">
                <i class="fas fa-users-cog"></i>
                Quản Lý Người Dùng
            </h1>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-container">
            <div class="stat-card total">
                <div class="stat-number" id="totalUsers">0</div>
                <div class="stat-label">Tổng số người dùng</div>
            </div>
            <div class="stat-card active">
                <div class="stat-number" id="activeUsers">0</div>
                <div class="stat-label">Đang hoạt động</div>
            </div>
            <div class="stat-card blocked">
                <div class="stat-number" id="blockedUsers">0</div>
                <div class="stat-label">Đã khóa</div>
            </div>
        </div>

        <!-- Search Box -->
        <div class="search-container" style="position: relative;">
            <input type="text" class="search-box" placeholder="Tìm kiếm theo tên, email hoặc số điện thoại..." id="searchInput">
            <i class="fas fa-search search-icon"></i>
        </div>

        <c:if test="${requestScope.error != null}">
            <div class="alert">
                <i class="fas fa-exclamation-triangle"></i>
                ${requestScope.error}
            </div>
        </c:if>

        <div class="table-container">
            <div class="table-header">
                <i class="fas fa-table"></i>
                Danh sách người dùng
            </div>
            
            <c:choose>
                <c:when test="${empty requestScope.userList}">
                    <div class="empty-state">
                        <i class="fas fa-users"></i>
                        <h3>Chưa có người dùng nào</h3>
                        <p>Danh sách người dùng sẽ hiển thị ở đây khi có dữ liệu</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table id="userTable">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-user"></i> Người dùng</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-phone"></i> Điện thoại</th>
                                <th><i class="fas fa-user-tag"></i> Vai trò</th>
                                <th><i class="fas fa-toggle-on"></i> Trạng thái</th>
                                <th><i class="fas fa-cogs"></i> Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${requestScope.userList}">
                                <tr class="user-row" data-search="${user.username} ${user.fullName} ${user.email} ${user.phone}">
                                    <td><strong>#<c:out value="${user.userId}" /></strong></td>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <c:out value="${user.fullName.substring(0,1).toUpperCase()}" />
                                            </div>
                                            <div>
                                                <div style="font-weight: 600; color: #2c3e50;">
                                                    <c:out value="${user.fullName}" />
                                                </div>
                                                <div style="font-size: 12px; color: #7f8c8d;">
                                                    @<c:out value="${user.username}" />
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <i class="fas fa-envelope" style="color: #7f8c8d; margin-right: 5px;"></i>
                                        <c:out value="${user.email}" />
                                    </td>
                                    <td>
                                        <i class="fas fa-phone" style="color: #7f8c8d; margin-right: 5px;"></i>
                                        <c:out value="${user.phone}" />
                                    </td>
                                    <td>
                                        <span class="role-badge ${user.role == 'admin' ? 'role-admin' : 'role-user'}">
                                            <c:out value="${user.role}" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.isActive}">
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-blocked">
                                                    <i class="fas fa-ban"></i> Đã khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <form method="post" action="user-management" style="display:inline;">
                                                <input type="hidden" name="userId" value="${user.userId}" />
                                                <c:choose>
                                                    <c:when test="${user.isActive}">
                                                        <button type="submit" name="action" value="block" class="btn btn-block">
                                                            <i class="fas fa-ban"></i> Khóa
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" name="action" value="unblock" class="btn btn-unblock">
                                                            <i class="fas fa-unlock"></i> Mở khóa
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                            <form method="post" action="user-management" style="display:inline;" 
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này? Hành động này không thể hoàn tác!');">
                                                <input type="hidden" name="userId" value="${user.userId}" />
                                                <button type="submit" name="action" value="delete" class="btn btn-delete">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Calculate and display statistics
        function updateStats() {
            const rows = document.querySelectorAll('#userTable tbody tr');
            let totalUsers = rows.length;
            let activeUsers = 0;
            let blockedUsers = 0;

            rows.forEach(row => {
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge && statusBadge.classList.contains('status-active')) {
                    activeUsers++;
                } else {
                    blockedUsers++;
                }
            });

            document.getElementById('totalUsers').textContent = totalUsers;
            document.getElementById('activeUsers').textContent = activeUsers;
            document.getElementById('blockedUsers').textContent = blockedUsers;
        }

        // Search functionality
        function setupSearch() {
            const searchInput = document.getElementById('searchInput');
            const userRows = document.querySelectorAll('.user-row');

            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase().trim();
                
                userRows.forEach(row => {
                    const searchData = row.getAttribute('data-search').toLowerCase();
                    if (searchData.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateStats();
            setupSearch();
        });
    </script>
</body>
</html>