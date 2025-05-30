<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản</title>
    <!-- Bootstrap CSS -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Background nhẹ với gradient pastel */
        body {
            background: linear-gradient(135deg, #fdfbfb, #ebedee);
            font-family: 'Arial', sans-serif;
            min-height: 100vh;
        }
        .signup-container {
            margin-top: 8%;
            max-width: 500px;
        }
        .card {
            border: none;
            border-radius: 10px;
            background: #ffffff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #28a745;
            color: #fff;
            text-align: center;
            font-size: 1.5rem;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .form-control {
            border-radius: 20px;
        }
        .btn-success {
            border-radius: 20px;
        }
        .card-footer {
            background-color: #f8f9fa;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container signup-container">
        <div class="card">
            <div class="card-header">
                Đăng Ký Tài Khoản
            </div>
            <div class="card-body">
                <form action="signup" >
                    <div class="form-group">
                        <label for="userId">Tên đăng nhập</label>
                        <input type="text" class="form-control" id="userId" name="userId" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="fullname">Họ và tên</label>
                        <input type="text" class="form-control" id="fullname" name="fullname" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" class="form-control" id="address" name="address" required>
                    </div>
                    <div class="form-group">
                        <label for="birthday">Ngày sinh</label>
                        <input type="date" class="form-control" id="birthday" name="birthday" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone" required>
                    </div>
                    <button type="submit" class="btn btn-success btn-block">Đăng Ký</button>
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
                Đã có tài khoản? <a href="login.jsp" class="text-success">Đăng nhập ngay</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
