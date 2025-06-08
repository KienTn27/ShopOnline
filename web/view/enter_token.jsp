<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Nhập mã xác thực</title>
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
            
            .token-form {
                width: 400px;
                background: white;
                padding: 35px 25px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }
            
            .token-form h3 {
                text-align: center;
                font-weight: 700;
                margin-bottom: 20px;
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
        <div class="token-form">
            <h3>Nhập mã xác thực</h3>
            <form action="verify-token" method="post">
                <div class="mb-3">
                    <label>Mã xác thực (token)</label>
                    <input type="text" name="token" class="form-control" required placeholder="Nhập mã xác thực từ email" />
                </div>
                <button type="submit" class="btn w-100">Xác nhận</button>
                <% 
            String message = (String) session.getAttribute("message");
            if (message != null) { 
                session.removeAttribute("message");
        %>
                    <div class="alert alert-danger text-center" role="alert">
                        <%= message %>
                    </div>
                    <% } %>
            </form>
        </div>
    </body>

    </html>