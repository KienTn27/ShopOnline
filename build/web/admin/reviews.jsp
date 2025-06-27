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
                                        <button class="action-button view-button" onclick="showReviewDetail(<%= r.getReviewID() %>, '<%= r.getUserName() %>', '<%= r.getProductName() %>', <%= r.getRating() %>, '<%= r.getComment() != null ? r.getComment().replace("'", "\\'") : "" %>', '<%= r.getCreatedAt() %>')" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </button>
                                        <button class="action-button delete-button" onclick="showDeleteConfirm(<%= r.getReviewID() %>, '<%= r.getUserName() %>', '<%= r.getProductName() %>')" title="Xóa đánh giá">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
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

    <!-- Review Detail Modal -->
    <div id="reviewDetailModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-comment-dots"></i> Chi tiết đánh giá</h3>
                <span class="close" onclick="closeReviewModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="review-detail-info">
                    <div class="detail-row">
                        <label><i class="fas fa-hashtag"></i> ID đánh giá:</label>
                        <span id="detail-review-id"></span>
                    </div>
                    <div class="detail-row">
                        <label><i class="fas fa-user"></i> Người đánh giá:</label>
                        <span id="detail-user-name"></span>
                    </div>
                    <div class="detail-row">
                        <label><i class="fas fa-box"></i> Sản phẩm:</label>
                        <span id="detail-product-name"></span>
                    </div>
                    <div class="detail-row">
                        <label><i class="fas fa-star"></i> Đánh giá:</label>
                        <div id="detail-star-rating" class="star-rating"></div>
                    </div>
                    <div class="detail-row">
                        <label><i class="fas fa-calendar"></i> Thời gian:</label>
                        <span id="detail-created-at"></span>
                    </div>
                    <div class="detail-row full-width">
                        <label><i class="fas fa-comment"></i> Nội dung đánh giá:</label>
                        <div id="detail-comment" class="review-content"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeReviewModal()">
                    <i class="fas fa-times"></i> Đóng
                </button>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteConfirmModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);">
                <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa</h3>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div style="text-align: center; padding: 1rem;">
                    <i class="fas fa-trash-alt" style="font-size: 3rem; color: #ef4444; margin-bottom: 1rem;"></i>
                    <h4>Bạn có chắc chắn muốn xóa đánh giá này?</h4>
                    <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 1rem; margin: 1rem 0;">
                        <p><strong>ID:</strong> <span id="delete-review-id"></span></p>
                        <p><strong>Người đánh giá:</strong> <span id="delete-user-name"></span></p>
                        <p><strong>Sản phẩm:</strong> <span id="delete-product-name"></span></p>
                    </div>
                    <p style="color: #ef4444; font-weight: 600;">Hành động này không thể hoàn tác!</p>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button class="btn btn-danger" onclick="confirmDelete()">
                    <i class="fas fa-trash-alt"></i> Xóa
                </button>
            </div>
        </div>
    </div>

    <script>
        let currentDeleteId = null;

        function showReviewDetail(reviewId, userName, productName, rating, comment, createdAt) {
            // Populate modal with review details
            document.getElementById('detail-review-id').textContent = reviewId;
            document.getElementById('detail-user-name').textContent = userName;
            document.getElementById('detail-product-name').textContent = productName;
            document.getElementById('detail-created-at').textContent = createdAt;
            document.getElementById('detail-comment').textContent = comment;
            
            // Create star rating display
            const starContainer = document.getElementById('detail-star-rating');
            starContainer.innerHTML = '';
            for (let i = 1; i <= 5; i++) {
                const star = document.createElement('span');
                star.className = `star ${i <= rating ? 'filled' : ''}`;
                star.innerHTML = '<i class="fas fa-star"></i>';
                starContainer.appendChild(star);
            }
            
            // Show modal
            document.getElementById('reviewDetailModal').style.display = 'block';
        }
        
        function closeReviewModal() {
            document.getElementById('reviewDetailModal').style.display = 'none';
        }

        function showDeleteConfirm(reviewId, userName, productName) {
            currentDeleteId = reviewId;
            document.getElementById('delete-review-id').textContent = reviewId;
            document.getElementById('delete-user-name').textContent = userName;
            document.getElementById('delete-product-name').textContent = productName;
            document.getElementById('deleteConfirmModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteConfirmModal').style.display = 'none';
            currentDeleteId = null;
        }

        function confirmDelete() {
            if (currentDeleteId) {
                // Redirect to delete servlet
                window.location.href = 'review-delete?id=' + currentDeleteId;
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const detailModal = document.getElementById('reviewDetailModal');
            const deleteModal = document.getElementById('deleteConfirmModal');
            if (event.target === detailModal) {
                closeReviewModal();
            }
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        }

        // --- Pagination, Filter, Sort, Search for reviews table ---
        const PAGE_SIZE = 5;
        let currentPage = 1;

        function getVisibleRows() {
            const tbody = document.querySelector('table tbody');
            return Array.from(tbody.querySelectorAll('tr')).filter(row => {
                // Không phải dòng "không có đánh giá" và đang hiển thị
                return !row.querySelector('.no-reviews') && row.style.display !== 'none';
            });
        }

        function renderPagination() {
            const rows = getVisibleRows();
            const total = rows.length;
            const pageCount = Math.ceil(total / PAGE_SIZE) || 1;
            if (currentPage > pageCount) currentPage = pageCount;
            const pagDiv = document.querySelector('.pagination');
            pagDiv.innerHTML = '';
            // Nút Trước
            const prev = document.createElement('button');
            prev.className = 'pagination-item';
            prev.textContent = 'Trước';
            prev.disabled = currentPage === 1;
            prev.onclick = () => { if (currentPage > 1) { currentPage--; showPage(); } };
            pagDiv.appendChild(prev);
            // Số trang
            for (let i = 1; i <= pageCount; i++) {
                const btn = document.createElement('button');
                btn.className = 'pagination-item' + (i === currentPage ? ' active' : '');
                btn.textContent = i;
                btn.onclick = () => { currentPage = i; showPage(); };
                pagDiv.appendChild(btn);
            }
            // Nút Sau
            const next = document.createElement('button');
            next.className = 'pagination-item';
            next.textContent = 'Sau';
            next.disabled = currentPage === pageCount;
            next.onclick = () => { if (currentPage < pageCount) { currentPage++; showPage(); } };
            pagDiv.appendChild(next);
        }

        function showPage() {
            const rows = getVisibleRows();
            const tbody = document.querySelector('table tbody');
            const total = rows.length;
            const pageCount = Math.ceil(total / PAGE_SIZE) || 1;
            // Ẩn tất cả
            rows.forEach(row => row.style.display = 'none');
            // Hiện các dòng thuộc trang hiện tại
            const start = (currentPage - 1) * PAGE_SIZE;
            const end = start + PAGE_SIZE;
            rows.slice(start, end).forEach(row => row.style.display = '');
            // Nếu không còn dòng nào hiển thị, hiện dòng "không có đánh giá"
            const noReviewRow = tbody.querySelector('.no-reviews')?.parentElement;
            if (noReviewRow) noReviewRow.style.display = (rows.length === 0) ? '' : 'none';
            renderPagination();
        }

        function filterAndSortReviews() {
            const sortBy = document.getElementById('sort-by').value;
            const filterStars = document.getElementById('filter-stars').value;
            const search = document.getElementById('search-input').value.trim().toLowerCase();
            const table = document.querySelector('table');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            // Ẩn/hiện theo filter
            rows.forEach(row => {
                if (row.querySelector('.no-reviews')) return;
                const tds = row.querySelectorAll('td');
                const user = tds[1].textContent.toLowerCase();
                const product = tds[2].textContent.toLowerCase();
                const rating = tds[3].querySelectorAll('.star.filled').length;
                let show = true;
                if (filterStars !== 'all' && rating.toString() !== filterStars) show = false;
                if (search && !user.includes(search) && !product.includes(search)) show = false;
                row.style.display = show ? '' : 'none';
            });
            // Sắp xếp
            let filteredRows = rows.filter(row => row.style.display !== 'none' && !row.querySelector('.no-reviews'));
            if (sortBy === 'newest' || sortBy === 'oldest') {
                filteredRows.sort((a, b) => {
                    const dateA = new Date(a.querySelectorAll('td')[5].textContent);
                    const dateB = new Date(b.querySelectorAll('td')[5].textContent);
                    return sortBy === 'newest' ? dateB - dateA : dateA - dateB;
                });
            } else if (sortBy === 'highest' || sortBy === 'lowest') {
                filteredRows.sort((a, b) => {
                    const ratingA = a.querySelectorAll('td')[3].querySelectorAll('.star.filled').length;
                    const ratingB = b.querySelectorAll('td')[3].querySelectorAll('.star.filled').length;
                    return sortBy === 'highest' ? ratingB - ratingA : ratingA - ratingB;
                });
            }
            filteredRows.forEach(row => tbody.appendChild(row));
            // Reset về trang 1 mỗi khi filter/sort/search
            currentPage = 1;
            showPage();
        }

        window.addEventListener('DOMContentLoaded', function() {
            document.getElementById('sort-by').addEventListener('change', filterAndSortReviews);
            document.getElementById('filter-stars').addEventListener('change', filterAndSortReviews);
            document.getElementById('search-input').addEventListener('input', filterAndSortReviews);
            document.querySelector('.filter-button').addEventListener('click', filterAndSortReviews);
            // Khởi tạo lần đầu
            filterAndSortReviews();
        });
    </script>
</body>
</html>