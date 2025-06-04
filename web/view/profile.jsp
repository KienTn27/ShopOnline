<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thông tin cá nhân</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    .profile-card {
                        max-width: 480px;
                        margin: 40px auto;
                        background: #fff;
                        border-radius: 18px;
                        box-shadow: 0 4px 18px rgba(44, 62, 80, 0.10);
                        padding: 32px 28px;
                    }
                    
                    .profile-avatar {
                        width: 90px;
                        height: 90px;
                        border-radius: 50%;
                        background: #e0e7ef;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 3rem;
                        color: #2f80ed;
                        margin: 0 auto 18px auto;
                    }
                    
                    .profile-info label {
                        font-weight: 600;
                        color: #2f80ed;
                    }
                    
                    .profile-info .form-control[readonly] {
                        background: #f8fafc;
                        border: none;
                        color: #333;
                    }
                </style>
            </head>

            <body style="background: linear-gradient(120deg, #f8fafc 0%, #e0e7ef 100%); min-height:100vh;">
                <div class="container">
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <i class="fa fa-user-circle"></i>
                        </div>
                        <h3 class="text-center mb-4">Thông tin cá nhân</h3>
                        <form class="profile-info">
                            <div class="mb-3">
                                <label>Họ tên</label>
                                <input type="text" class="form-control" value="<%= user.getFullName() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Tên đăng nhập</label>
                                <input type="text" class="form-control" value="<%= user.getUsername() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Email</label>
                                <input type="email" class="form-control" value="<%= user.getEmail() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input type="text" class="form-control" value="<%= user.getPhone() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Vai trò</label>
                                <input type="text" class="form-control" value="<%= user.getRole() %>" readonly>
                            </div>
                            <div class="mb-3">
                                <label>Ngày tạo tài khoản</label>
                                <input type="text" class="form-control" value="<%= user.getCreateAt() != null ? user.getCreateAt() : " " %>" readonly>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            </html>