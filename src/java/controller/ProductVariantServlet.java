package controller;


import dao.ProductDAO;
import dao.ProductVariantDAO;
import model.ProductVariant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import model.Product;
import model.Product1;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "ProductVariantServlet", urlPatterns = {"/managerVariants"})
public class ProductVariantServlet extends HttpServlet {

    private ProductVariantDAO variantDAO;
    private ProductDAO productDAO; // MỚI: Khai báo ProductDAO
    private static final String UPLOAD_DIRECTORY = "uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        this.variantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO(); // MỚI: Khởi tạo ProductDAO
    }

    // doGet không thay đổi
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("managerProduct?error=productId_missing");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            List<ProductVariant> variants = variantDAO.getProductVariantsByProductIdByAdmin(productId);

            request.setAttribute("variants", variants);
            request.setAttribute("productId", productId);
            request.getRequestDispatcher("admin/managerVariants.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("managerProduct?error=invalid_productId");
        }
    }

    // THAY ĐỔI LỚN: doPost sẽ gọi hàm cập nhật số lượng
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String statusParam = "error";

        if (action == null || productIdStr == null) {
            response.sendRedirect("managerProduct?error=invalid_request");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr); // Lấy productId ở đây để tái sử dụng
            boolean success = false;
            
            switch (action) {
                case "add":
                    success = handleAddVariant(request);
                    statusParam = success ? "add_success" : "add_fail";
                    break;
                case "update":
                    success = handleUpdateVariant(request);
                    statusParam = success ? "update_success" : "update_fail";
                    break;
                case "delete":
                    success = handleDeleteVariant(request);
                    statusParam = success ? "delete_success" : "delete_fail";
                    break;
            }

            // MỚI: Nếu bất kỳ hành động nào thành công, cập nhật số lượng sản phẩm cha
            if (success) {
                updateParentProductQuantity(productId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            statusParam = "error";
        }
        
        response.sendRedirect("managerVariants?productId=" + productIdStr + "&status=" + statusParam);
    }

    // MỚI: Phương thức điều phối việc cập nhật số lượng sản phẩm cha
    private void updateParentProductQuantity(int productId) {
        // Bước 1: Lấy tổng số lượng mới từ tất cả các biến thể
        int totalQuantity = productDAO.getTotalVariantQuantityByProductId(productId);
        
        // Bước 2: Cập nhật số lượng đó vào bảng Products
        boolean isUpdated = productDAO.updateProductQuantity(productId, totalQuantity);
        
        if (isUpdated) {
            System.out.println("SUCCESS: Parent product " + productId + " quantity updated to " + totalQuantity);
        } else {
            System.err.println("ERROR: Failed to update parent product " + productId + " quantity.");
        }
    }

    // Các hàm handleAdd, handleUpdate, handleDelete, uploadFile, generateSKU giữ nguyên không đổi...
    // (Copy lại các hàm đó từ phiên bản trước của bạn và dán vào đây)

    private boolean handleAddVariant(HttpServletRequest request) throws IOException, ServletException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        String size = request.getParameter("size");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
//        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String imageUrl = uploadFile(request, "variantImage");
        String predefinedColor = request.getParameter("predefined_color");
        String color;
        if ("other".equals(predefinedColor)) {
            color = request.getParameter("custom_color");
        } else {
            color = predefinedColor;
        }
        String sku = generateSKU(String.valueOf(productId), size, color);
        
             Product1 p =   productDAO.getProductById(productId);

        
        ProductVariant newVariant = new ProductVariant();
        newVariant.setProductID(productId);
        newVariant.setSize(size);
        newVariant.setColor(color);
        newVariant.setQuantity(quantity);
        newVariant.setPrice(p.getPrice());
        newVariant.setSku(sku);
        newVariant.setVariantImageURL(imageUrl);
        newVariant.setActive(true);
        return variantDAO.addProductVariant(newVariant);
    }

    private boolean handleUpdateVariant(HttpServletRequest request) throws IOException, ServletException {
        String newImageUrl = uploadFile(request, "editVariantImage");
        String existingImageUrl = request.getParameter("existingImageUrl");
        String predefinedColor = request.getParameter("edit_predefined_color");
        String color;
        if ("other".equals(predefinedColor)) {
            color = request.getParameter("edit_custom_color");
        } else {
            color = predefinedColor;
        }
        
   int productId = Integer.parseInt(request.getParameter("productId"));
        

                             Product1 p =   productDAO.getProductById(productId);

        ProductVariant variantToUpdate = new ProductVariant();
        variantToUpdate.setVariantID(Integer.parseInt(request.getParameter("variantId")));
        variantToUpdate.setProductID(Integer.parseInt(request.getParameter("productId")));
        
        
        variantToUpdate.setSize(request.getParameter("editSize"));
        variantToUpdate.setColor(color);
        variantToUpdate.setQuantity(Integer.parseInt(request.getParameter("editQuantity")));
        variantToUpdate.setPrice(p.getPrice());
        variantToUpdate.setSku(request.getParameter("editSku"));
        variantToUpdate.setActive(request.getParameter("editIsActive") != null);
        if (newImageUrl != null && !newImageUrl.isEmpty()) {
            variantToUpdate.setVariantImageURL(newImageUrl);
        } else {
            variantToUpdate.setVariantImageURL(existingImageUrl);
        }
        return variantDAO.updateProductVariant(variantToUpdate);
    }

    private boolean handleDeleteVariant(HttpServletRequest request) {
        int variantId = Integer.parseInt(request.getParameter("variantId"));
        return variantDAO.deleteProductVariant(variantId);
    }

    private String uploadFile(HttpServletRequest request, String formFieldName) throws IOException, ServletException {
        Part filePart = request.getPart(formFieldName);
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        return UPLOAD_DIRECTORY + "/" + uniqueFileName;
    }
    
    private String generateSKU(String productId, String size, String color) {
        String randomPart = UUID.randomUUID().toString().substring(0, 3).toUpperCase();
        String colorCode = color.replaceAll("[^a-zA-Z0-9]", "").toUpperCase();
        if (colorCode.length() > 5) {
            colorCode = colorCode.substring(0, 5);
        }
        return productId + "-" + size + "-" + colorCode + "-" + randomPart;
    }
}
