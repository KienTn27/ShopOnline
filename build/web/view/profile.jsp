<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - Fashion Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #000000;
            --secondary-color: #6c757d;
            --accent-color: #e91e63;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
            --text-primary: #212529;
            --text-secondary: #6c757d;
            --shadow-light: 0 2px 10px rgba(0,0,0,0.08);
            --shadow-medium: 0 4px 20px rgba(0,0,0,0.12);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: var(--text-primary);
        }

        .container-custom {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .profile-header::after {
            content: '';
            position: absolute;
            bottom: -1rem;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-color), #ff6b9d);
            border-radius: 2px;
        }

        .profile-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .profile-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
            font-weight: 400;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: var(--shadow-medium);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .profile-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-color), #ff6b9d, #4facfe);
        }

        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-title i {
            font-size: 1.25rem;
            color: var(--accent-color);
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-color), #ff6b9d);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            margin: 0 auto 2rem auto;
            position: relative;
            box-shadow: var(--shadow-medium);
        }

        .profile-avatar::after {
            content: '';
            position: absolute;
            inset: -3px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-color), #ff6b9d, #4facfe);
            z-index: -1;
            opacity: 0.3;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(233, 30, 99, 0.1);
            outline: none;
        }

        .form-control[readonly] {
            background: var(--light-bg);
            border-color: var(--border-color);
            color: var(--text-secondary);
        }

        .btn-custom {
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--accent-color), #ff6b9d);
            color: white;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(233, 30, 99, 0.3);
        }

        .btn-secondary-custom {
            background: var(--primary-color);
            color: white;
        }

        .btn-secondary-custom:hover {
            background: #333;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .btn-warning-custom {
            background: linear-gradient(135deg, #ff9800, #f57c00);
            color: white;
        }

        .btn-warning-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 152, 0, 0.3);
        }

        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            border-left: 4px solid #2196f3;
        }

        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.85rem;
        }

        .strength-weak { color: #f44336; }
        .strength-medium { color: #ff9800; }
        .strength-strong { color: #4caf50; }

        @media (max-width: 768px) {
            .profile-layout {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .profile-card {
                padding: 1.5rem;
            }
            
            .profile-header h1 {
                font-size: 2rem;
            }
            
            .container-custom {
                padding: 1rem;
            }
        }

        .input-group-custom {
            position: relative;
        }

        .input-group-custom .form-control {
            padding-right: 3rem;
        }

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            z-index: 10;
        }

        .toggle-password:hover {
            color: var(--accent-color);
        }
    </style>
</head>

<body>
    <div class="container-custom">
        <div class="profile-header">
            <h1>Thông tin cá nhân</h1>
            <p>Quản lý thông tin tài khoản của bạn</p>
        </div>

        <% if (message != null) { %>
            <div class="alert alert-custom">
                <i class="fas fa-info-circle me-2"></i>
                <%= message %>
            </div>
        <% } %>

        <div class="profile-layout">
            <!-- Profile Information Card -->
            <div class="profile-card">
                <div class="card-title">
                    <i class="fas fa-user"></i>
                    Thông tin cá nhân
                </div>
                
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>

                <form method="post" action="<%= request.getContextPath() %>/updateProfile">
                    <div class="form-group">
                        <label class="form-label">Họ tên</label>
                        <input type="text" name="fullName" class="form-control" value="<%= user.getFullName() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tên đăng nhập</label>
                        <input type="text" name="username" class="form-control" value="<%= user.getUsername() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" value="<%= user.getPhone() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Vai trò</label>
                        <input type="text" class="form-control" value="<%= user.getRole() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Ngày tạo tài khoản</label>
                        <input type="text" class="form-control" value="<%= user.getCreateAt() != null ? user.getCreateAt() : "" %>" readonly>
                    </div>
                    
                    <button type="submit" class="btn btn-custom btn-primary-custom w-100 mb-3">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                    
                    <a href="<%= request.getContextPath() %>/Home" class="btn btn-custom btn-secondary-custom w-100">
                        <i class="fas fa-home me-2"></i>Quay lại Trang chủ
                    </a>
                </form>
            </div>

            <!-- Change Password Card -->
            <div class="profile-card">
                <div class="card-title">
                    <i class="fas fa-lock"></i>
                    Đổi mật khẩu
                </div>

                <form method="post" action="<%= request.getContextPath() %>/changePassword" id="passwordForm">
                    <div class="form-group">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <div class="input-group-custom">
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('currentPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Mật khẩu mới</label>
                        <div class="input-group-custom">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                            <button type="button" class="toggle-password" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength"></div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <div class="input-group-custom">
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required minlength="6">
                            <button type="button" class="toggle-password" onclick="togglePassword('confirmNewPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" class="mt-2"></div>
                    </div>
                    
                    <button type="submit" class="btn btn-custom btn-warning-custom w-100">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const button = field.nextElementSibling;
            const icon = button.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        function checkPasswordStrength(password) {
            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            return strength;
        }

        document.getElementById('newPassword').addEventListener('input', function() {
            const password = this.value;
            const strengthDiv = document.getElementById('passwordStrength');
            const strength = checkPasswordStrength(password);
            
            let message = '';
            let className = '';
            
            switch(strength) {
                case 0:
                case 1:
                    message = 'Mật khẩu yếu';
                    className = 'strength-weak';
                    break;
                case 2:
                case 3:
                    message = 'Mật khẩu trung bình';
                    className = 'strength-medium';
                    break;
                case 4:
                case 5:
                    message = 'Mật khẩu mạnh';
                    className = 'strength-strong';
                    break;
            }
            
            strengthDiv.textContent = message;
            strengthDiv.className = 'password-strength ' + className;
        });

        document.getElementById('confirmNewPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword === '') {
                matchDiv.textContent = '';
                return;
            }
            
            if (newPassword === confirmPassword) {
                matchDiv.innerHTML = '<i class="fas fa-check-circle text-success me-1"></i><span class="text-success">Mật khẩu khớp</span>';
            } else {
                matchDiv.innerHTML = '<i class="fas fa-times-circle text-danger me-1"></i><span class="text-danger">Mật khẩu không khớp</span>';
            }
        });

        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmNewPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
        });
    </script>
</body>

</html>