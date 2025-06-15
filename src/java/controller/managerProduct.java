package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Product1;

/**
 * Servlet quản lý sản phẩm
 *
 * @author truon
 */
@WebServlet(name = "managerProduct", urlPatterns = {"/managerProduct"})
public class managerProduct extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private static final int PAGE_SIZE = 4; // Số sản phẩm mỗi trang

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - Hiển thị trang quản lý
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy tham số lọc
            String searchKeyword = request.getParameter("search");
            String categoryIdStr = request.getParameter("categoryId");
            String priceFromStr = request.getParameter("priceFrom");
            String priceToStr = request.getParameter("priceTo");
            String pageStr = request.getParameter("page");
            
            // Xử lý tham số trang
            int page = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // Giữ page = 1 nếu có lỗi
                }
            }
            
            // Xử lý các tham số lọc
            Integer categoryId = null;
            BigDecimal priceFrom = null;
            BigDecimal priceTo = null;
            
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu có lỗi
                }
            }
            
            if (priceFromStr != null && !priceFromStr.isEmpty()) {
                try {
                    priceFrom = new BigDecimal(priceFromStr);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu có lỗi
                }
            }
            
            if (priceToStr != null && !priceToStr.isEmpty()) {
                try {
                    priceTo = new BigDecimal(priceToStr);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu có lỗi
                }
            }
            
            // Lấy danh sách danh mục và thêm số lượng sản phẩm
            List<Category> categories = categoryDAO.getAllCategories();
            for (Category category : categories) {
                int productCount = categoryDAO.getProductCountByCategory(category.getCategoryID());
                category.setProductCount(productCount);
            }
            
            // Lấy danh sách sản phẩm theo bộ lọc
            List<Product1> filteredProducts = getFilteredProducts(searchKeyword, categoryId, priceFrom, priceTo);
            
            // Tính tổng số trang
            int totalProducts = filteredProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
            
            // Phân trang danh sách sản phẩm
            List<Product1> paginatedProducts = paginateProducts(filteredProducts, page, PAGE_SIZE);
            
            // Thêm tên danh mục cho mỗi sản phẩm
            addCategoryNameToProducts(paginatedProducts);
            
            // Thiết lập các thuộc tính cho JSP
            request.setAttribute("products", paginatedProducts);
            request.setAttribute("categories", categories);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            
            // Giữ lại các tham số lọc
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("priceFrom", priceFromStr);
            request.setAttribute("priceTo", priceToStr);
            
            // Forward đến trang JSP
            request.getRequestDispatcher("admin/managerProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Xử lý tìm kiếm và lọc từ form
        String action = request.getParameter("action");
        
        if ("filter".equals(action)) {
            // Lấy tham số từ form
            String searchInput = request.getParameter("searchInput");
            String categoryFilter = request.getParameter("categoryFilter");
            String priceFrom = request.getParameter("priceFrom");
            String priceTo = request.getParameter("priceTo");
            
            // Tạo URL redirect với các tham số
            StringBuilder redirectUrl = new StringBuilder("managerProduct?");
            
            if (searchInput != null && !searchInput.isEmpty()) {
                redirectUrl.append("search=").append(searchInput).append("&");
            }
            
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                redirectUrl.append("categoryId=").append(categoryFilter).append("&");
            }
            
            if (priceFrom != null && !priceFrom.isEmpty()) {
                redirectUrl.append("priceFrom=").append(priceFrom).append("&");
            }
            
            if (priceTo != null && !priceTo.isEmpty()) {
                redirectUrl.append("priceTo=").append(priceTo).append("&");
            }
            
            // Redirect với các tham số lọc
            response.sendRedirect(redirectUrl.toString());
        } else {
            // Mặc định chuyển về trang quản lý sản phẩm
            doGet(request, response);
        }
    }
    
    /**
     * Lấy danh sách sản phẩm đã lọc theo các điều kiện
     */
    private List<Product1> getFilteredProducts(String searchKeyword, Integer categoryId, 
                                             BigDecimal priceFrom, BigDecimal priceTo) {
        
        // Nếu không có điều kiện lọc, lấy tất cả sản phẩm
        if ((searchKeyword == null || searchKeyword.isEmpty()) && 
            categoryId == null && priceFrom == null && priceTo == null) {
            return productDAO.getAllProduct();
        }
        
        // Sử dụng phương thức advancedSearch để lọc sản phẩm
        return productDAO.advancedSearch(searchKeyword, categoryId, priceFrom, priceTo, null);
    }
    
    /**
     * Phân trang danh sách sản phẩm
     */
    private List<Product1> paginateProducts(List<Product1> products, int page, int pageSize) {
        List<Product1> paginatedList = new ArrayList<>();
        
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, products.size());
        
        if (startIndex < products.size()) {
            for (int i = startIndex; i < endIndex; i++) {
                paginatedList.add(products.get(i));
            }
        }
        
        return paginatedList;
    }
    
    /**
     * Thêm tên danh mục cho mỗi sản phẩm
     */
    private void addCategoryNameToProducts(List<Product1> products) {
        for (Product1 product : products) {
            int categoryId = product.getCategoryID();
            Category category = categoryDAO.getCategoryById(categoryId);
            if (category != null) {
                product.setCategoryName(category.getName());
            } else {
                product.setCategoryName("Chưa phân loại");
            }
        }
    }
}