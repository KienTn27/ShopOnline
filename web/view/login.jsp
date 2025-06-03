<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #667eea, #764ba2);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .login-form {
                width: 400px;
                background: white;
                padding: 40px 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                animation: fadeIn 1s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-form h3 {
                font-weight: 700;
                color: #333;
                text-align: center;
                margin-bottom: 25px;
            }

            .login-form label {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .login-form .form-control {
                border-radius: 30px;
                padding: 12px 20px;
                font-size: 15px;
                border: 1px solid #ccc;
                transition: all 0.3s;
            }

            .login-form .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 8px rgba(102, 126, 234, 0.5);
            }

            .login-form button {
                margin-top: 20px;
                background: linear-gradient(to right, #667eea, #764ba2);
                border: none;
                color: white;
                border-radius: 30px;
                padding: 12px;
                font-size: 16px;
                font-weight: 600;
                transition: background 0.3s;
            }

            .login-form button:hover {
                background: linear-gradient(to right, #5a67d8, #6b46c1);
            }

            .login-links {
                margin-top: 20px;
                text-align: center;
            }

            .login-links a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                margin: 0 8px;
                font-size: 14px;
                transition: color 0.3s;
            }

            .login-links a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            .alert {
                margin-top: 15px;
            }
        </style>
    </head>
    <body>

        <div class="login-form">
            <h3>Đăng nhập tài khoản</h3>
            <form action="login" method="post">
                <div class="mb-3">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" required />
                </div>
                <button type="submit" class="btn w-100">Đăng nhập</button>

                <% 
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) { 
                %>
                <div class="alert alert-danger text-center" role="alert">
                    <%= errorMessage %>
                </div>
                <% } %>
            </form>

            <div class="login-links">
                <a href="register">Đăng ký tài khoản</a> |
                <a href="forgot-password">Quên mật khẩu?</a>
            </div>
        </div>

    </body>
</html>
