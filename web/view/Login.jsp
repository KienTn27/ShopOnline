<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <!-- Bootstrap CSS -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Background nhẹ nhàng với gradient pastel */
        body {
            background: linear-gradient(135deg, #fdfbfb, #ebedee);
            font-family: 'Arial', sans-serif;
            min-height: 100vh;
        }
        .login-container {
            margin-top: 10%;
            max-width: 400px;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background: #ffffff;
        }
        .card-header {
            background-color: #007bff;
            color: #fff;
            text-align: center;
            font-size: 1.5rem;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .form-control {
            border-radius: 20px;
        }
        .btn-primary {
            border-radius: 20px;
        }
        .card-footer {
            background-color: #f1f1f1;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="card">
            <div class="card-header">
                Đăng Nhập
            </div>
            <div class="card-body">
                <form action="Home" method="POST">
                    <div class="form-group">
                        <label for="userId">User ID</label>
                        <input type="text" class="form-control" id="userId" name="userId" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Đăng Nhập</button>
                </form>
                <%-- Hiển thị thông báo lỗi nếu có --%>
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <div class="alert alert-danger mt-3" role="alert">
                        <%= errorMessage %>
                    </div>
                <%
                    }
                %>
            </div>
            <div class="card-footer text-center">
                Chưa có tài khoản? <a href="signup.jsp" class="text-primary">Đăng ký ngay</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
