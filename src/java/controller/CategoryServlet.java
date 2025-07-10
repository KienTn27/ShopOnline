package controller;

import dao.CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import model.Category;

/**
 * Servlet quản lý danh mục
 *
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
      
      try {
          switch (action != null ? action : "") {
              case "getCategory":
                  getCategoryById(request, response);
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
          response.sendRedirect("managerProduct?error=" + e.getMessage());
      }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      
      request.setCharacterEncoding("UTF-8");
      response.setCharacterEncoding("UTF-8");
      
      String action = request.getParameter("action");
      
      try {
          switch (action != null ? action : "") {
              case "add":
                  addCategory(request, response);
                  break;
              case "update":
                  updateCategory(request, response);
                  break;
                  case "delete":  // Thêm case này
                deleteCategory(request, response);
                break;
              default:
                  response.sendRedirect("managerProduct");
                  break;
          }
      } catch (Exception e) {
          e.printStackTrace();
          response.sendRedirect("managerProduct?error=" + e.getMessage());
      }
  }

 
  
  
  
  
  
  private void addCategory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    
    // Thiết lập kiểu phản hồi
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();
    
    // Validate input
    if (name == null || name.trim().isEmpty()) {
        out.print("{\"success\": false, \"message\": \"Tên danh mục không được để trống\"}");
        return;
    }
    
    // Tạo đối tượng Category
    Category category = new Category();
    category.setName(name.trim());
    category.setDescription(description != null ? description.trim() : "");
    
    // Thêm vào database
    boolean success = categoryDAO.addCategory(category);
    
    if (success) {
        out.print("{\"success\": true, \"message\": \"Thêm danh mục thành công\"}");
    } else {
        out.print("{\"success\": false, \"message\": \"Cập nhật danh mục thất bại. Có thể tên danh mục đã tồn tại\"}");
    }
    
    out.flush();
    out.close();
}

  
  
  
  
  
  
  
  private void updateCategory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String categoryIdStr = request.getParameter("categoryID");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    
    // Validate input
    if (categoryIdStr == null || name == null || name.trim().isEmpty()) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"message\": \"Thông tin danh mục không hợp lệ\"}");
        return;
    }
    
    try {
        int categoryId = Integer.parseInt(categoryIdStr);
        
        // Tạo đối tượng Category
        Category category = new Category();
        category.setCategoryID(categoryId);
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        
        // Cập nhật trong database
        boolean success = categoryDAO.updateCategory(category);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        if (success) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"message\": \"Cập nhật danh mục thất bại. Có thể tên danh mục đã tồn tại\"}");
        }
        
    } catch (NumberFormatException e) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"message\": \"ID danh mục không hợp lệ\"}");
    }
}

  
  
  
  
private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String categoryIdStr = request.getParameter("categoryID");
    String forceDelete = request.getParameter("force");
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();
    
    if (categoryIdStr == null) {
        out.print("{\"success\": false, \"message\": \"ID danh mục không hợp lệ\"}");
        return;
    }
    
    try {
        int categoryId = Integer.parseInt(categoryIdStr);
        boolean success = false;
        
        if ("true".equals(forceDelete)) {
            // Xóa cưỡng chế (xóa cả sản phẩm trong danh mục)
            success = categoryDAO.forceDeleteCategory(categoryId);
            if (success) {
                out.print("{\"success\": true, \"message\": \"Xóa danh mục và tất cả sản phẩm thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Xóa danh mục thất bại\"}");
            }
        } else {
            // Xóa thông thường (kiểm tra có sản phẩm không)
            if (categoryDAO.hasProducts(categoryId)) {
                out.print("{\"success\": false, \"message\": \"Không thể xóa danh mục vì còn chứa sản phẩm\"}");
            } else {
                success = categoryDAO.deleteCategory(categoryId);
                if (success) {
                    out.print("{\"success\": true, \"message\": \"Xóa danh mục thành công\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Xóa danh mục thất bại\"}");
                }
            }
        }
        
    } catch (NumberFormatException e) {
        out.print("{\"success\": false, \"message\": \"ID danh mục không hợp lệ\"}");
    } finally {
        out.flush();
        out.close();
    }
}

  /**
   * Lấy thông tin danh mục theo ID (AJAX)
   */
  private void getCategoryById(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");
      
      String categoryIdStr = request.getParameter("categoryId");
      PrintWriter out = response.getWriter();
      
      if (categoryIdStr == null) {
          out.print("{\"error\": \"ID danh mục không hợp lệ\"}");
          return;
      }
      
      try {
          int categoryId = Integer.parseInt(categoryIdStr);
          Category category = categoryDAO.getCategoryById(categoryId);
          
          if (category != null) {
              StringBuilder json = new StringBuilder();
              json.append("{");
              json.append("\"categoryID\": ").append(category.getCategoryID()).append(",");
              json.append("\"name\": \"").append(escapeJson(category.getName())).append("\",");
              json.append("\"description\": \"").append(escapeJson(category.getDescription())).append("\"");
              json.append("}");
              
              out.print(json.toString());
          } else {
              out.print("{\"error\": \"Không tìm thấy danh mục\"}");
          }
          
      } catch (NumberFormatException e) {
          out.print("{\"error\": \"ID danh mục không hợp lệ\"}");
      }
  }

  /**
   * Escape JSON string
   */
  private String escapeJson(String str) {
      if (str == null) return "";
      return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
  }
}