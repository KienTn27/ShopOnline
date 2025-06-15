package controller;

import dao.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet xử lý các thao tác với danh mục
 * @author truon
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/CategoryServlet"})
public class CategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("managerProduct");
            return;
        }
        
        try {
            switch (action) {
                case "getCategory":
                    getCategoryDetails(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendRedirect("managerProduct");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("managerProduct");
            return;
        }
        
        try {
            switch (action) {
                case "add":
                    addCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                default:
                    response.sendRedirect("managerProduct");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Xử lý thêm danh mục mới
     */
    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tên danh mục không được để trống!");
                response.sendRedirect("managerProduct");
                return;
            }
            
            Category category = new Category();
            category.setName(name);
            category.setDescription(description);
            
            boolean success = categoryDAO.addCategory(category);
            
            if (success) {
                session.setAttribute("successMessage", "Thêm danh mục thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể thêm danh mục. Có thể tên danh mục đã tồn tại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm danh mục: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Xử lý cập nhật danh mục
     */
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int categoryID = Integer.parseInt(request.getParameter("categoryID"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tên danh mục không được để trống!");
                response.sendRedirect("managerProduct");
                return;
            }
            
            Category category = new Category();
            category.setCategoryID(categoryID);
            category.setName(name);
            category.setDescription(description);
            
            boolean success = categoryDAO.updateCategory(category);
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật danh mục thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật danh mục. Có thể tên danh mục đã tồn tại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ!");
            response.sendRedirect("managerProduct");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật danh mục: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Xử lý xóa danh mục
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int categoryID = Integer.parseInt(request.getParameter("categoryId"));
            
            // Kiểm tra xem danh mục có sản phẩm không
            if (categoryDAO.hasProducts(categoryID)) {
                session.setAttribute("errorMessage", "Không thể xóa danh mục này vì đang chứa sản phẩm!");
                response.sendRedirect("managerProduct");
                return;
            }
            
            boolean success = categoryDAO.deleteCategory(categoryID);
            
            if (success) {
                session.setAttribute("successMessage", "Xóa danh mục thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa danh mục. Vui lòng thử lại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID danh mục không hợp lệ!");
            response.sendRedirect("managerProduct");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa danh mục: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Lấy thông tin chi tiết danh mục (AJAX)
     */
    private void getCategoryDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int categoryID = Integer.parseInt(request.getParameter("categoryId"));
            Category category = categoryDAO.getCategoryById(categoryID);
            
            if (category != null) {
                JSONObject json = new JSONObject();
                json.put("categoryID", category.getCategoryID());
                json.put("name", category.getName());
                json.put("description", category.getDescription() != null ? category.getDescription() : "");
                
                out.print(json.toString());
            } else {
                JSONObject error = new JSONObject();
                error.put("error", "Không tìm thấy danh mục!");
                out.print(error.toString());
            }
            
        } catch (NumberFormatException e) {
            JSONObject error = new JSONObject();
            error.put("error", "ID danh mục không hợp lệ!");
            out.print(error.toString());
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Có lỗi xảy ra: " + e.getMessage());
            out.print(error.toString());
        }
    }
}
