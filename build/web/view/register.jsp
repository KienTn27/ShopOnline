<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng ký tài khoản</title>
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
    .register-form {
        position: relative;
        z-index: 2;
        max-width: 450px;
        margin: 60px auto;
        background: rgba(255,255,255,0.95);
        border-radius: 18px;
        box-shadow: 0 8px 32px rgba(44,62,80,0.15);
        padding: 40px 32px 32px 32px;
        backdrop-filter: blur(2px);
    }
    .register-form h3 {
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
        color: #2f80ed;
        margin-bottom: 24px;
        text-align: center;
    }
    .register-form label {
        font-weight: 600;
        color: #333;
    }
    .register-form .form-control {
        border-radius: 30px;
        padding: 12px 20px;
        margin-bottom: 18px;
        border: 1px solid #e0e7ef;
        background: #f8fafc;
    }
    .register-form button {
        border-radius: 30px;
        background: linear-gradient(90deg, #56ccf2, #2f80ed);
        color: #fff;
        font-weight: 700;
        padding: 12px;
        font-size: 16px;
        border: none;
        transition: background 0.2s;
    }
    .register-form button:hover {
        background: linear-gradient(90deg, #2f80ed, #56ccf2);
    }
    .back-to-login {
        display: inline-flex;
        align-items: center;
        color: #2f80ed;
        font-weight: 600;
        text-decoration: none;
        transition: color 0.2s, box-shadow 0.2s;
        border-radius: 30px;
        padding: 8px 18px;
        margin-top: 10px;
    }
    .back-to-login i {
        margin-right: 8px;
        font-size: 18px;
    }
    .back-to-login:hover {
        color: #fff;
        background: linear-gradient(90deg, #56ccf2, #2f80ed);
        box-shadow: 0 2px 12px rgba(47,128,237,0.15);
        text-decoration: none;
    }
</style>
        <script>
            // Hàm kiểm tra mật khẩu và nhập lại mật khẩu
            function validateForm() {
                var password = document.forms["registerForm"]["password"].value;
                var confirmPassword = document.forms["registerForm"]["confirmPassword"].value;

                if (password !== confirmPassword) {
                    alert("Mật khẩu và Nhập lại mật khẩu không khớp!");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>

        <div class="register-form">
            <h3>Đăng ký tài khoản</h3>
            <form name="registerForm" action="register" method="post" onsubmit="return validateForm();">
                <div class="row">
                    <div class="col-6 mb-3">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" class="form-control" required />
                    </div>
                    <div class="col-6 mb-3">
                        <label>Tên đăng nhập</label>
                        <input type="text" name="username" class="form-control" required />
                    </div>

                    <div class="col-6 mb-3">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" required />
                    </div>
                    <div class="col-6 mb-3">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" required />
                    </div>

                    <div class="col-6 mb-3">
                        <label>Mật khẩu</label>
                        <input type="password" name="password" class="form-control" required />
                    </div>
                    <div class="col-6 mb-3">
                        <label>Nhập lại mật khẩu</label>
                        <input type="password" name="confirmPassword" class="form-control" required />
                    </div>
                </div>

                <button type="submit" class="btn w-100">Đăng ký</button>

                <% 
                    String message = (String) request.getAttribute("message");
                    if (message != null) { 
                %>
                <div class="alert alert-info text-center" role="alert">
                    <%= message %>
                </div>
                <% } %>
            </form>
            <div class="text-center mt-3">
                <a href="<%= request.getContextPath() %>/login" class="back-to-login">
                    <i class="fa fa-arrow-left"></i> Quay lại trang đăng nhập
                </a>
            </div>
        </div>


    </body>
</html>
