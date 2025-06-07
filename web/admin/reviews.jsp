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
    <title>Quản lý đánh giá</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reviews.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container">
        <%-- <jsp:include page="menu.jsp" /> --%>

        <h2 class="page-title"><i class="fas fa-comments"></i> Quản lý phản hồi đánh giá</h2>

        <div class="filter-search-section">
            <div class="filter-group">
                <label for="sort-by" class="filter-label">Sắp xếp theo:</label>
                <select id="sort-by" class="filter-select">
                    <option value="newest">Mới nhất</option>
                    <option value="oldest">Cũ nhất</option>
                    <option value="highest">Đánh giá cao nhất</option>
                    <option value="lowest">Đánh giá thấp nhất</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="filter-stars" class="filter-label">Lọc theo sao:</label>
                <select id="filter-stars" class="filter-select">
                    <option value="all">Tất cả sao</option>
                    <option value="5">5 sao</option>
                    <option value="4">4 sao</option>
                    <option value="3">3 sao</option>
                    <option value="2">2 sao</option>
                    <option value="1">1 sao</option>
                </select>
            </div>
            <div class="filter-group search-group">
                <label for="search-input" class="filter-label">Tìm kiếm:</label>
                <input type="text" id="search-input" class="filter-input" placeholder="Tên sản phẩm hoặc người dùng...">
                <button class="filter-button"><i class="fas fa-search"></i> Lọc</button>
            </div>
        </div>

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
                                <td>
                                    <div class="action-buttons">
                                        <a href="review-detail?id=<%= r.getReviewID() %>" class="action-button view-button" title="Xem chi tiết"><i class="fas fa-eye"></i> Chi tiết</a>
                                        <a href="review-delete?id=<%= r.getReviewID() %>" class="action-button delete-button" onclick="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?')" title="Xóa đánh giá"><i class="fas fa-trash-alt"></i> Xóa</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="pagination">
            <a href="#" class="pagination-item disabled">Trước</a>
            <a href="#" class="pagination-item active">1</a>
            <a href="#" class="pagination-item">2</a>
            <a href="#" class="pagination-item">3</a>
            <a href="#" class="pagination-item">Sau</a>
        </div>
    </div>
</body>
</html>