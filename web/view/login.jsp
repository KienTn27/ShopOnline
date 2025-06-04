<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                min-height: 100vh;
                background: linear-gradient(120deg, #f8fafc 0%, #e0e7ef 100%);
                background-image: url('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80');
                background-size: cover;
                background-position: center;
                position: relative;
                font-family: 'Montserrat', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .overlay {
                position: fixed;
                top: 0; left: 0; right: 0; bottom: 0;
                background: rgba(255,255,255,0.7);
                z-index: 1;
            }
            .login-form {
                position: relative;
                z-index: 2;
                max-width: 400px;
                margin: 60px auto;
                background: rgba(255,255,255,0.95);
                border-radius: 18px;
                box-shadow: 0 8px 32px rgba(44,62,80,0.15);
                padding: 40px 32px 32px 32px;
                backdrop-filter: blur(2px);
            }
            .login-form h3 {
                font-family: 'Montserrat', sans-serif;
                font-weight: 700;
                color: #2f80ed;
                margin-bottom: 24px;
                text-align: center;
            }
            .login-form label {
                font-weight: 600;
                color: #333;
            }
            .login-form .form-control {
                border-radius: 30px;
                padding: 12px 20px;
                margin-bottom: 18px;
                border: 1px solid #e0e7ef;
                background: #f8fafc;
            }
            .login-form button {
                border-radius: 30px;
                background: linear-gradient(90deg, #56ccf2, #2f80ed);
                color: #fff;
                font-weight: 700;
                padding: 12px;
                font-size: 16px;
                border: none;
                transition: background 0.2s;
            }
            .login-form button:hover {
                background: linear-gradient(90deg, #2f80ed, #56ccf2);
            }
            .login-links {
                text-align: center;
                margin-top: 18px;
            }
            .login-links a {
                color: #2f80ed;
                font-weight: 600;
                text-decoration: none;
                margin: 0 8px;
                transition: color 0.2s;
            }
            .login-links a:hover {
                color: #56ccf2;
                text-decoration: underline;
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
