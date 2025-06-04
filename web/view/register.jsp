<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - Fashion Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #000000;
            --secondary-color: #6c757d;
            --accent-color: #e91e63;
            --accent-light: #f8bbd9;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
            --text-primary: #212529;
            --text-secondary: #6c757d;
            --shadow-light: 0 2px 10px rgba(0,0,0,0.08);
            --shadow-medium: 0 4px 20px rgba(0,0,0,0.12);
            --shadow-heavy: 0 8px 40px rgba(0,0,0,0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            opacity: 0.1;
            z-index: -1;
        }

        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            position: relative;
        }

        .register-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 1000px;
            width: 100%;
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow-heavy);
            position: relative;
        }

        .register-info {
            background: linear-gradient(135deg, var(--accent-color), #ff6b9d);
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            color: white;
            position: relative;
        }

        .register-info::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="30" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .register-info-content {
            position: relative;
            z-index: 2;
        }

        .register-info h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .register-info p {
            font-size: 1.1rem;
            line-height: 1.6;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .register-info .features {
            list-style: none;
        }

        .register-info .features li {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 1rem;
        }

        .register-info .features li i {
            margin-right: 0.75rem;
            font-size: 1.2rem;
            opacity: 0.8;
        }

        .register-form {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .form-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--text-secondary);
            font-size: 1rem;
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
            display: block;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(233, 30, 99, 0.1);
            outline: none;
        }

        .form-control.is-valid {
            border-color: #28a745;
        }

        .form-control.is-invalid {
            border-color: #dc3545;
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

        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.85rem;
        }

        .strength-weak { color: #dc3545; }
        .strength-medium { color: #ffc107; }
        .strength-strong { color: #28a745; }

        .validation-message {
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }

        .validation-message.valid {
            color: #28a745;
        }

        .validation-message.invalid {
            color: #dc3545;
        }

        .btn-register {
            background: linear-gradient(135deg, var(--accent-color), #ff6b9d);
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            margin-top: 1rem;
            position: relative;
            overflow: hidden;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(233, 30, 99, 0.3);
            background: linear-gradient(135deg, #d81b60, #e91e63);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .btn-register:disabled {
            opacity: 0.6;
            transform: none;
            box-shadow: none;
        }

        .back-link {
            text-align: center;
            margin-top: 2rem;
        }

        .back-link a {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-link a:hover {
            color: var(--accent-color);
            text-decoration: none;
        }

        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 1rem;
            margin-top: 1rem;
            font-size: 0.9rem;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .loading-spinner {
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .btn-register.loading .loading-spinner {
            display: block;
        }

        .btn-register.loading .btn-text {
            opacity: 0;
        }

        @media (max-width: 768px) {
            .register-wrapper {
                grid-template-columns: 1fr;
                margin: 1rem;
            }
            
            .register-info {
                padding: 2rem;
                order: 2;
            }
            
            .register-info h1 {
                font-size: 2rem;
            }
            
            .register-form {
                padding: 2rem;
                order: 1;
            }
            
            .form-header h2 {
                font-size: 1.75rem;
            }
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        @media (max-width: 576px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-wrapper">
            <!-- Left Side - Information -->
            <div class="register-info">
                <div class="register-info-content">
                    <h1>Tham gia cộng đồng thời trang</h1>
                    <p>Khám phá những xu hướng mới nhất và tạo nên phong cách riêng của bạn cùng với chúng tôi.</p>
                    
                    <ul class="features">
                        <li>
                            <i class="fas fa-shipping-fast"></i>
                            Miễn phí vận chuyển cho đơn hàng trên 500k
                        </li>
                        <li>
                            <i class="fas fa-undo-alt"></i>
                            Đổi trả dễ dàng trong 30 ngày
                        </li>
                        <li>
                            <i class="fas fa-crown"></i>
                            Ưu đãi độc quyền cho thành viên VIP
                        </li>
                        <li>
                            <i class="fas fa-heart"></i>
                            Lưu sản phẩm yêu thích
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Right Side - Registration Form -->
            <div class="register-form">
                <div class="form-header">
                    <h2>Tạo tài khoản</h2>
                    <p>Điền thông tin để bắt đầu hành trình thời trang</p>
                </div>

                <form name="registerForm" action="register" method="post" onsubmit="return validateForm();" id="registerForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" required id="fullName">
                            <div class="validation-message" id="fullNameMsg"></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Tên đăng nhập</label>
                            <input type="text" name="username" class="form-control" required id="username">
                            <div class="validation-message" id="usernameMsg"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required id="email">
                            <div class="validation-message" id="emailMsg"></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" class="form-control" required id="phone">
                            <div class="validation-message" id="phoneMsg"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mật khẩu</label>
                            <div class="input-group-custom">
                                <input type="password" name="password" class="form-control" required id="password">
                                <button type="button" class="toggle-password" onclick="togglePassword('password')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="password-strength" id="passwordStrength"></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nhập lại mật khẩu</label>
                            <div class="input-group-custom">
                                <input type="password" name="confirmPassword" class="form-control" required id="confirmPassword">
                                <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="validation-message" id="confirmPasswordMsg"></div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-register w-100" id="submitBtn">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                        <span class="btn-text">
                            <i class="fas fa-user-plus me-2"></i>Tạo tài khoản
                        </span>
                    </button>

                    <% 
                        String message = (String) request.getAttribute("message");
                        if (message != null) { 
                    %>
                    <div class="alert alert-custom alert-info" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <%= message %>
                    </div>
                    <% } %>
                </form>

                <div class="back-link">
                    <a href="<%= request.getContextPath() %>/login">
                        <i class="fas fa-arrow-left"></i>
                        Đã có tài khoản? Đăng nhập
                    </a>
                </div>
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

        function validateEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }

        function validatePhone(phone) {
            const re = /^[0-9]{10,11}$/;
            return re.test(phone.replace(/\s/g, ''));
        }

        function showValidation(fieldId, isValid, message) {
            const field = document.getElementById(fieldId);
            const msgDiv = document.getElementById(fieldId + 'Msg');
            
            field.classList.remove('is-valid', 'is-invalid');
            field.classList.add(isValid ? 'is-valid' : 'is-invalid');
            
            msgDiv.textContent = message;
            msgDiv.classList.remove('valid', 'invalid');
            msgDiv.classList.add(isValid ? 'valid' : 'invalid');
        }

        // Real-time validation
        document.getElementById('fullName').addEventListener('input', function() {
            const value = this.value.trim();
            if (value.length >= 2) {
                showValidation('fullName', true, '✓ Tên hợp lệ');
            } else if (value.length > 0) {
                showValidation('fullName', false, '✗ Tên phải có ít nhất 2 ký tự');
            } else {
                showValidation('fullName', false, '');
            }
        });

        document.getElementById('username').addEventListener('input', function() {
            const value = this.value.trim();
            if (value.length >= 3 && /^[a-zA-Z0-9_]+$/.test(value)) {
                showValidation('username', true, '✓ Tên đăng nhập hợp lệ');
            } else if (value.length > 0) {
                showValidation('username', false, '✗ Tên đăng nhập phải có ít nhất 3 ký tự, chỉ chứa chữ, số và _');
            } else {
                showValidation('username', false, '');
            }
        });

        document.getElementById('email').addEventListener('input', function() {
            const value = this.value.trim();
            if (validateEmail(value)) {
                showValidation('email', true, '✓ Email hợp lệ');
            } else if (value.length > 0) {
                showValidation('email', false, '✗ Email không hợp lệ');
            } else {
                showValidation('email', false, '');
            }
        });

        document.getElementById('phone').addEventListener('input', function() {
            const value = this.value.trim();
            if (validatePhone(value)) {
                showValidation('phone', true, '✓ Số điện thoại hợp lệ');
            } else if (value.length > 0) {
                showValidation('phone', false, '✗ Số điện thoại phải có 10-11 chữ số');
            } else {
                showValidation('phone', false, '');
            }
        });

        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthDiv = document.getElementById('passwordStrength');
            const strength = checkPasswordStrength(password);
            
            let message = '';
            let className = '';
            
            if (password.length === 0) {
                strengthDiv.textContent = '';
                return;
            }
            
            switch(strength) {
                case 0:
                case 1:
                    message = '🔴 Mật khẩu yếu';
                    className = 'strength-weak';
                    break;
                case 2:
                case 3:
                    message = '🟡 Mật khẩu trung bình';
                    className = 'strength-medium';
                    break;
                case 4:
                case 5:
                    message = '🟢 Mật khẩu mạnh';
                    className = 'strength-strong';
                    break;
            }
            
            strengthDiv.textContent = message;
            strengthDiv.className = 'password-strength ' + className;
        });

        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword === '') {
                showValidation('confirmPassword', false, '');
                return;
            }
            
            if (password === confirmPassword) {
                showValidation('confirmPassword', true, '✓ Mật khẩu khớp');
            } else {
                showValidation('confirmPassword', false, '✗ Mật khẩu không khớp');
            }
        });

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            const username = document.getElementById('username').value;
            const fullName = document.getElementById('fullName').value;

            // Validate all fields
            let isValid = true;
            
            if (fullName.trim().length < 2) {
                showValidation('fullName', false, '✗ Tên phải có ít nhất 2 ký tự');
                isValid = false;
            }
            
            if (username.trim().length < 3 || !/^[a-zA-Z0-9_]+$/.test(username)) {
                showValidation('username', false, '✗ Tên đăng nhập không hợp lệ');
                isValid = false;
            }
            
            if (!validateEmail(email)) {
                showValidation('email', false, '✗ Email không hợp lệ');
                isValid = false;
            }
            
            if (!validatePhone(phone)) {
                showValidation('phone', false, '✗ Số điện thoại không hợp lệ');
                isValid = false;
            }

            if (password !== confirmPassword) {
                showValidation('confirmPassword', false, '✗ Mật khẩu không khớp');
                isValid = false;
            }
            
            if (password.length < 6) {
                alert("Mật khẩu phải có ít nhất 6 ký tự!");
                isValid = false;
            }

            if (isValid) {
                // Show loading state
                const submitBtn = document.getElementById('submitBtn');
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;
            }

            return isValid;
        }
    </script>
</body>
</html>