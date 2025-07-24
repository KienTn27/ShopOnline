<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo tài khoản Admin</title>
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
            
            .create-admin-container {
                background: white;
                border-radius: 20px;
                padding: 40px 32px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.12);
                max-width: 480px;
                width: 100%;
            }
            
            .form-title {
                font-size: 2rem;
                font-weight: 700;
                color: #2f80ed;
                margin-bottom: 24px;
                text-align: center;
            }
            
            .form-label {
                font-weight: 600;
                color: #343a40;
            }
            
            .btn-create {
                background: linear-gradient(90deg, #56ccf2, #2f80ed);
                color: white;
                font-weight: 600;
                border: none;
                border-radius: 8px;
                padding: 12px 0;
                width: 100%;
                margin-top: 10px;
                transition: background 0.2s;
            }
            
            .btn-create:hover {
                background: linear-gradient(90deg, #2f80ed, #56ccf2);
            }
            
            .alert {
                border-radius: 10px;
                margin-bottom: 18px;
            }
        </style>
    </head>

    <body>
        <div class="create-admin-container">
            <div class="form-title">
                <i class="fas fa-user-shield"></i> Tạo tài khoản Admin
            </div>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>
                            <form action="<%=request.getContextPath()%>/admin/create-admin" method="post" autocomplete="off">
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" name="fullName" required maxlength="100">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <input type="text" class="form-control" name="username" required maxlength="50">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" required maxlength="100">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" required maxlength="20">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" name="password" required minlength="6" maxlength="50">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nhập lại mật khẩu</label>
                                    <input type="password" class="form-control" name="confirmPassword" required minlength="6" maxlength="50">
                                </div>
                                <button type="submit" class="btn btn-create">
            <i class="fas fa-plus-circle"></i> Tạo tài khoản Admin
        </button>
                                <a href="<%=request.getContextPath()%>/admin/user-management" class="btn btn-link mt-2">&larr; Quay lại danh sách user</a>
                            </form>
        </div>
    </body>

    </html>