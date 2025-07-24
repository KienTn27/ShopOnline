<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Vui lòng kiểm tra email</title>
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
            
            .notify-box {
                width: 420px;
                background: white;
                padding: 40px 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                text-align: center;
            }
            
            .notify-box h3 {
                color: #2f80ed;
                font-weight: 700;
                margin-bottom: 20px;
            }
            
            .notify-box p {
                font-size: 17px;
                color: #333;
            }
            
            .btn-login {
                margin-top: 25px;
                border-radius: 30px;
                background: linear-gradient(to right, #56ccf2, #2f80ed);
                color: white;
                border: none;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: 600;
            }
            
            .btn-login:hover {
                background: linear-gradient(to right, #2f80ed, #56ccf2);
            }
        </style>
    </head>

    <body>
        <div class="notify-box">
            <h3>Vui lòng kiểm tra email</h3>
            <p>Một email hướng dẫn đặt lại mật khẩu đã được gửi đến địa chỉ bạn cung cấp.<br>Vui lòng kiểm tra hộp thư và làm theo hướng dẫn để thay đổi mật khẩu.</p>
            <a href="/login" class="btn btn-login">Quay lại đăng nhập</a>
        </div>
    </body>

    </html>