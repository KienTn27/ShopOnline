package controller;

import dao.InventoryDAO;
import model.InventoryStat;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            // Hiển thị form chỉnh sửa
            String productId = request.getParameter("productId");
            String productName = request.getParameter("productName");
            String stockQuantity = request.getParameter("stockQuantity");
            request.setAttribute("productId", productId);
            request.setAttribute("productName", productName);
            request.setAttribute("stockQuantity", stockQuantity);
            request.getRequestDispatcher("admin/edit-inventory.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            // Xử lý xóa sản phẩm
            String productId = request.getParameter("productId");
            if (productId != null) {
                try {
                    int id = Integer.parseInt(productId);
                    InventoryDAO dao = new InventoryDAO();
                    dao.deleteInventory(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("inventory");
            return;
        } else if ("add".equals(action)) {
            // Hiển thị form thêm sản phẩm
            request.getRequestDispatcher("admin/add-inventory.jsp").forward(request, response);
            return;
        } else {
            // Hiển thị danh sách tồn kho
            int page = 1;
            int pageSize = 10; // Số dòng mỗi trang, có thể chỉnh
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            InventoryDAO dao = new InventoryDAO();
            List<InventoryStat> inventoryList = dao.getInventoryStatsPage(page, pageSize);
            int totalRecords = dao.getTotalInventoryCount();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            request.setAttribute("inventoryList", inventoryList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("admin/inventory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String productName = request.getParameter("productName");
            String stockQuantityStr = request.getParameter("stockQuantity");
            if (productName != null && stockQuantityStr != null) {
                try {
                    int stockQuantity = Integer.parseInt(stockQuantityStr);
                    InventoryDAO dao = new InventoryDAO();
                    dao.addInventory(productName, stockQuantity);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("inventory");
            return;
        }
        String productIdStr = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String stockQuantityStr = request.getParameter("stockQuantity");
        if (productIdStr != null && productName != null && stockQuantityStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                int stockQuantity = Integer.parseInt(stockQuantityStr);
                InventoryDAO dao = new InventoryDAO();
                dao.updateInventory(productId, productName, stockQuantity);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("inventory");
    }
}
