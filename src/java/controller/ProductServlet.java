package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;
import java.util.UUID;
import model.Product1;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet xử lý các thao tác với sản phẩm
 * @author truon
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ProductServlet extends HttpServlet {
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private final String UPLOAD_DIRECTORY = "uploads/products";

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
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
                case "getProduct":
                    getProductDetails(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
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
                    addProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
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
     * Xử lý thêm sản phẩm mới
     */
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Lấy thông tin sản phẩm từ form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int categoryID = Integer.parseInt(request.getParameter("categoryID"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            boolean isActive = request.getParameter("isActive") != null;
            
            // Xử lý upload ảnh
            String imageURL = null;
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getUniqueFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                
                // Tạo thư mục nếu chưa tồn tại
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Lưu file
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                
                // Đường dẫn tương đối để lưu vào database
                imageURL = UPLOAD_DIRECTORY + "/" + fileName;
            }
            
            // Tạo đối tượng Product
            Product1 product = new Product1();
            product.setName(name);
            product.setDescription(description);
            product.setCategoryID(categoryID);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setImageURL(imageURL);
            product.setIsActive(isActive);
            
            // Thêm sản phẩm vào database
            boolean success = productDAO.addProduct(product);
            
            if (success) {
                session.setAttribute("successMessage", "Thêm sản phẩm thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể thêm sản phẩm. Vui lòng thử lại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
            response.sendRedirect("managerProduct");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm sản phẩm: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Xử lý cập nhật sản phẩm
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Lấy thông tin sản phẩm từ form
            int productID = Integer.parseInt(request.getParameter("productID"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int categoryID = Integer.parseInt(request.getParameter("categoryID"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            boolean isActive = request.getParameter("isActive") != null;
            
            // Lấy sản phẩm hiện tại từ database
            Product1 existingProduct = productDAO.getProductById(productID);
            
            if (existingProduct == null) {
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm cần cập nhật!");
                response.sendRedirect("managerProduct");
                return;
            }
            
            // Xử lý upload ảnh mới nếu có
            String imageURL = existingProduct.getImageURL(); // Giữ nguyên ảnh cũ nếu không upload ảnh mới
            Part filePart = request.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getUniqueFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                
                // Tạo thư mục nếu chưa tồn tại
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Xóa ảnh cũ nếu có
                if (existingProduct.getImageURL() != null && !existingProduct.getImageURL().isEmpty()) {
                    String oldFilePath = getServletContext().getRealPath("") + File.separator + existingProduct.getImageURL();
                    try {
                        Files.deleteIfExists(Paths.get(oldFilePath));
                    } catch (IOException e) {
                        System.err.println("Không thể xóa ảnh cũ: " + e.getMessage());
                    }
                }
                
                // Lưu file mới
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                
                // Đường dẫn tương đối để lưu vào database
                imageURL = UPLOAD_DIRECTORY + "/" + fileName;
            }
            
            // Cập nhật thông tin sản phẩm
            Product1 product = new Product1();
            product.setProductID(productID);
            product.setName(name);
            product.setDescription(description);
            product.setCategoryID(categoryID);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setImageURL(imageURL);
            product.setIsActive(isActive);
            
            // Cập nhật sản phẩm trong database
            boolean success = productDAO.updateProduct(product);
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật sản phẩm. Vui lòng thử lại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
            response.sendRedirect("managerProduct");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật sản phẩm: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Xử lý xóa sản phẩm
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int productID = Integer.parseInt(request.getParameter("productId"));
            
            // Lấy thông tin sản phẩm trước khi xóa
            Product1 product = productDAO.getProductById(productID);
            
            if (product == null) {
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm cần xóa!");
                response.sendRedirect("managerProduct");
                return;
            }
            
            // Xóa sản phẩm (soft delete)
            boolean success = productDAO.deleteProduct(productID);
            
            if (success) {
                session.setAttribute("successMessage", "Xóa sản phẩm thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa sản phẩm. Vui lòng thử lại!");
            }
            
            response.sendRedirect("managerProduct");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID sản phẩm không hợp lệ!");
            response.sendRedirect("managerProduct");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa sản phẩm: " + e.getMessage());
            response.sendRedirect("managerProduct");
        }
    }
    
    /**
     * Lấy thông tin chi tiết sản phẩm (AJAX)
     */
    private void getProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int productID = Integer.parseInt(request.getParameter("productId"));
            Product1 product = productDAO.getProductById(productID);
            
            if (product != null) {
                JSONObject json = new JSONObject();
                json.put("productID", product.getProductID());
                json.put("name", product.getName());
                json.put("categoryID", product.getCategoryID());
                json.put("description", product.getDescription() != null ? product.getDescription() : "");
                json.put("price", product.getPrice());
                json.put("quantity", product.getQuantity());
                json.put("imageURL", product.getImageURL());
                json.put("isActive", product.getIsActive());
                
                out.print(json.toString());
            } else {
                JSONObject error = new JSONObject();
                error.put("error", "Không tìm thấy sản phẩm!");
                out.print(error.toString());
            }
            
        } catch (NumberFormatException e) {
            JSONObject error = new JSONObject();
            error.put("error", "ID sản phẩm không hợp lệ!");
            out.print(error.toString());
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Có lỗi xảy ra: " + e.getMessage());
            out.print(error.toString());
        }
    }
    
    /**
     * Tạo tên file duy nhất cho ảnh upload
     */
    private String getUniqueFileName(Part part) {
        String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        
        int i = originalFileName.lastIndexOf('.');
        if (i > 0) {
            extension = originalFileName.substring(i);
        }
        
        return UUID.randomUUID().toString() + extension;
    }
}
