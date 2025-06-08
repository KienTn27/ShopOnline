<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quên mật khẩu</title>
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
            .forgot-form {
                width: 450px;
                background: white;
                padding: 40px 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            }
            .forgot-form h3 {
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
    </head>
    <body>

        <div class="forgot-form">
            <h3>Quên mật khẩu</h3>
            <form action="forgot-password" method="post">
                <div class="mb-3">
                    <label>Email đã đăng ký</label>
                    <input type="email" name="email" class="form-control" required placeholder="Nhập email của bạn" />
                </div>

                <button type="submit" class="btn w-100">Gửi email đặt lại mật khẩu</button>

                <% 
                    String message = (String) session.getAttribute("message");
                    if (message != null) { 
                        session.removeAttribute("message");
                %>
                <div class="alert alert-info text-center" role="alert">
                    <%= message %>
                </div>
                <% } %>
            </form>
        </div>

    </body>
</html>
