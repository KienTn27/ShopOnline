<%--  
    Document   : reviews  
    Created on : May 23, 2025, 11:36:39 PM  
    Author     : HUNG  
--%>  

<%@page contentType="text/html" pageEncoding="UTF-8"%>  
<%@page import="java.util.*, model.Review"%>  

<%  
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");  
    if (reviews == null) reviews = new ArrayList<>();  
%>  

<!DOCTYPE html>  
<html lang="vi">  
    <head>  
        <meta charset="UTF-8">  
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  
        <title>Customer Feedback</title>  
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reviews.css">  
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">  

        <style>
            .btn-back-menu {
                display: inline-block;
                margin-top: 30px;
                padding: 10px 20px;
                font-size: 16px;
                color: white;
                background-color: #007bff;
                border: none;
                border-radius: 8px;
                text-decoration: none;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .btn-back-menu:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            .btn-back-menu i {
                margin-right: 8px;
            }

            .container {
                text-align: center;
            }

            table {
                margin: 0 auto;
            }
        </style>
    </head>  
    <body>  
        <div class="container">  
            <%-- <jsp:include page="menu.jsp" /> --%>  

            <h2 class="page-title"><i class="fas fa-comments"></i> Customer Feedback</h2>  

            <div class="table-responsive">  
                <table>  
                    <thead>  
                        <tr>  
                            <th>ID</th>  
                            <th>Người dùng</th>  
                            <th>Sản phẩm</th>  
                            <th>Đánh giá</th>  
                            <th>Nội dung</th>  
                            <th>Thời gian</th>  
                            <th>Thao tác</th>  
                        </tr>  
                    </thead>  
                    <tbody>  
                        <% if (reviews.isEmpty()) { %>  
                        <tr>  
                            <td colspan="7" class="no-reviews">Không có đánh giá nào để hiển thị.</td>  
                        </tr>  
                        <% } else { %>  
                        <% for (Review r : reviews) { %>  
                        <tr>  
                            <td><%= r.getReviewID() %></td>  
                            <td><%= r.getUserName() %></td>  
                            <td><%= r.getProductName() %></td>  
                            <td>  
                                <div class="star-rating">  
                                    <% for (int i = 1; i <= 5; i++) { %>  
                                    <span class="star <%= i <= r.getRating() ? "filled" : "" %>"><i class="fas fa-star"></i></span>  
                                        <% } %>  
                                </div>  
                            </td>  
                            <td>  
                                <div class="review-comment"><%= r.getComment() %></div>  
                            </td>  
                            <td><%= r.getCreatedAt() %></td>  
                            <td><!-- Thêm thao tác nếu cần --></td>  
                        </tr>  
                        <% } %>  
                        <% } %>  
                    </tbody>  
                </table>  
            </div>  

            <a href="admin/menu.jsp" class="btn-back-menu"><i class="fas fa-arrow-left"></i> Quay lại menu</a>  
        </div>  
    </body>  
</html>
