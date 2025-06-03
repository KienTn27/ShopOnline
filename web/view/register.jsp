<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng ký tài khoản</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #56ccf2, #2f80ed);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .register-form {
                width: 450px;
                background: white;
                padding: 40px 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            }
            .register-form h3 {
                text-align: center;
                font-weight: 700;
                margin-bottom: 25px;
                color: #333;
            }
            .form-control {
                border-radius: 30px;
                padding: 12px 20px;
            }
            button {
                margin-top: 20px;
                border-radius: 30px;
                background: linear-gradient(to right, #56ccf2, #2f80ed);
                color: white;
                border: none;
                padding: 12px;
                font-size: 16px;
                font-weight: 600;
            }
            button:hover {
                background: linear-gradient(to right, #2f80ed, #56ccf2);
            }
            .alert {
                margin-top: 15px;
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
        </div>
            

    </body>
</html>
