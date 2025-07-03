<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .access-denied-container {
            background: white;
            border-radius: 20px;
            padding: 60px 40px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 90%;
        }

        .access-denied-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 30px;
        }

        .access-denied-title {
            font-size: 2rem;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 20px;
        }

        .access-denied-message {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="access-denied-icon">
            <i class="fas fa-ban"></i>
        </div>
        <h1 class="access-denied-title">Truy cập bị từ chối</h1>
        <p class="access-denied-message">
            Bạn không có quyền truy cập vào trang này. 
            Vui lòng đăng nhập với tài khoản có quyền phù hợp hoặc liên hệ quản trị viên.
        </p>
        <a href="${pageContext.request.contextPath}/Home" class="btn-home">
            <i class="fas fa-home"></i>
            Về trang chủ
        </a>
    </div>
</body>
</html> 