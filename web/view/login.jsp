<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Fashion Store</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #e8b4b8;
                --accent-color: #f8f9fa;
                --text-dark: #2c3e50;
                --text-light: #6c757d;
                --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --shadow-soft: 0 10px 40px rgba(0,0,0,0.1);
                --shadow-hover: 0 20px 60px rgba(0,0,0,0.15);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                position: relative;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: absolute;
                width: 200%;
                height: 200%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.15"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.15"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>') repeat;
                animation: float 20s ease-in-out infinite;
                pointer-events: none;
            }

            @keyframes float {
                0%, 100% { transform: translateY(0px) rotate(0deg); }
                50% { transform: translateY(-20px) rotate(2deg); }
            }

            .login-container {
                position: relative;
                z-index: 10;
                width: 100%;
                max-width: 420px;
                animation: slideUp 0.8s ease-out;
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

            .login-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                padding: 48px 40px;
                box-shadow: var(--shadow-soft);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .login-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-primary);
                border-radius: 24px 24px 0 0;
            }

            .login-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-hover);
            }

            .brand-section {
                text-align: center;
                margin-bottom: 40px;
            }

            .brand-logo {
                width: 64px;
                height: 64px;
                margin: 0 auto 20px;
                background: var(--gradient-primary);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 28px;
                color: white;
                box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }

            .brand-title {
                font-family: 'Playfair Display', serif;
                font-size: 28px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 8px;
                letter-spacing: -0.5px;
            }

            .brand-subtitle {
                color: var(--text-light);
                font-size: 15px;
                font-weight: 400;
            }

            .form-group {
                margin-bottom: 24px;
                position: relative;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                color: var(--text-dark);
                font-weight: 500;
                font-size: 14px;
                letter-spacing: 0.3px;
            }

            .form-control {
                width: 100%;
                padding: 16px 20px 16px 48px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 16px;
                background: #f8f9fa;
                transition: all 0.3s ease;
                font-family: 'Inter', sans-serif;
            }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
                transform: translateY(-1px);
            }

            .input-icon {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-light);
                font-size: 18px;
                transition: color 0.3s ease;
            }

            .form-control:focus + .input-icon {
                color: #667eea;
            }

            .btn-login {
                width: 100%;
                padding: 16px 24px;
                background: var(--gradient-primary);
                border: none;
                border-radius: 12px;
                color: white;
                font-size: 16px;
                font-weight: 600;
                letter-spacing: 0.5px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                text-transform: uppercase;
                margin-bottom: 24px;
            }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-login:hover::before {
                left: 100%;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(102, 126, 234, 0.4);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .divider {
                display: flex;
                align-items: center;
                margin: 32px 0;
                color: var(--text-light);
                font-size: 14px;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #e9ecef;
            }

            .divider span {
                padding: 0 16px;
                background: white;
            }

            .login-links {
                text-align: center;
                margin-top: 24px;
            }

            .login-links a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                transition: all 0.3s ease;
                margin: 0 8px;
                position: relative;
            }

            .login-links a::after {
                content: '';
                position: absolute;
                width: 0;
                height: 2px;
                bottom: -2px;
                left: 50%;
                background: #667eea;
                transition: all 0.3s ease;
                transform: translateX(-50%);
            }

            .login-links a:hover::after {
                width: 100%;
            }

            .login-links a:hover {
                color: #4c63d2;
                transform: translateY(-1px);
            }

            .alert {
                border-radius: 12px;
                border: none;
                padding: 16px 20px;
                margin-top: 20px;
                font-size: 14px;
                font-weight: 500;
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-5px); }
                75% { transform: translateX(5px); }
            }

            .alert-danger {
                background: linear-gradient(135deg, #ff6b6b, #ee5a52);
                color: white;
                box-shadow: 0 8px 24px rgba(238, 90, 82, 0.3);
            }

            /* Social Login Buttons */
            .social-login {
                display: flex;
                gap: 12px;
                margin-bottom: 24px;
            }

            .btn-social {
                flex: 1;
                padding: 12px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                background: white;
                color: var(--text-light);
                font-size: 18px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .btn-social:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            }

            .btn-google:hover {
                border-color: #ea4335;
                color: #ea4335;
            }

            .btn-facebook:hover {
                border-color: #1877f2;
                color: #1877f2;
            }

            /* Responsive Design */
            @media (max-width: 480px) {
                .login-card {
                    padding: 32px 24px;
                    margin: 16px;
                }

                .brand-title {
                    font-size: 24px;
                }

                .form-control {
                    padding: 14px 18px 14px 44px;
                }

                .btn-login {
                    padding: 14px 20px;
                }
            }

            /* Loading Animation */
            .loading {
                position: relative;
                pointer-events: none;
            }

            .loading::after {
                content: '';
                position: absolute;
                width: 20px;
                height: 20px;
                margin: auto;
                border: 2px solid transparent;
                border-top-color: white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            @keyframes spin {
                0% { transform: translate(-50%, -50%) rotate(0deg); }
                100% { transform: translate(-50%, -50%) rotate(360deg); }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-card">
                <div class="brand-section">
                    <div class="brand-logo">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <h1 class="brand-title">Fashion Store</h1>
                    <p class="brand-subtitle">Khám phá phong cách của bạn</p>
                </div>

                <form action="login" method="post" id="loginForm">
                    <div class="form-group">
                        <label for="username" class="form-label">Tên đăng nhập hoặc Email</label>
                        <div class="position-relative">
                            <input type="text" id="username" name="username" class="form-control" 
                                   placeholder="Nhập tên đăng nhập hoặc email" required autocomplete="username">
                            <i class="fas fa-user input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <div class="position-relative">
                            <input type="password" id="password" name="password" class="form-control" 
                                   placeholder="Nhập mật khẩu" required autocomplete="current-password">
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>

                    <button type="submit" class="btn-login" id="loginBtn">
                        <span>Đăng nhập</span>
                    </button>

                    <% 
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null) { 
                    %>
                    <div class="alert alert-danger text-center" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= errorMessage %>
                    </div>
                    <% } %>
                </form>

                <div class="divider">
                    <span>Hoặc đăng nhập với</span>
                </div>

                <div class="social-login">
                    <button type="button" class="btn-social btn-google" onclick="loginWithGoogle()">
                        <i class="fab fa-google"></i>
                    </button>
                    <button type="button" class="btn-social btn-facebook" onclick="loginWithFacebook()">
                        <i class="fab fa-facebook-f"></i>
                    </button>
                </div>

                <div class="login-links">
                    <a href="register">
                        <i class="fas fa-user-plus me-1"></i>
                        Tạo tài khoản mới
                    </a>
                    <span class="text-muted">|</span>
                    <a href="forgot-password">
                        <i class="fas fa-key me-1"></i>
                        Quên mật khẩu?
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Form submission with loading animation
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                const loginBtn = document.getElementById('loginBtn');
                loginBtn.classList.add('loading');
                loginBtn.innerHTML = '';
                
                // Simulate loading (remove this in production)
                setTimeout(() => {
                    loginBtn.classList.remove('loading');
                    loginBtn.innerHTML = '<span>Đăng nhập</span>';
                }, 2000);
            });

            // Social login functions (implement as needed)
            function loginWithGoogle() {
                // Implement Google OAuth login
                console.log('Google login clicked');
            }

            function loginWithFacebook() {
                // Implement Facebook OAuth login
                console.log('Facebook login clicked');
            }

            // Enhanced form validation
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.style.borderColor = '#dc3545';
                    } else {
                        this.style.borderColor = '#28a745';
                    }
                });

                input.addEventListener('input', function() {
                    this.style.borderColor = '#e9ecef';
                });
            });

            // Keyboard navigation
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && e.target.tagName !== 'BUTTON') {
                    const form = document.getElementById('loginForm');
                    if (form.checkValidity()) {
                        form.submit();
                    }
                }
            });
        </script>
    </body>
</html>