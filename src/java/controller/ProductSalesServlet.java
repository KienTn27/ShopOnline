package controller;

import java.io.IOException;
import java.util.List;
import dao.ProductSalesDAO;
import model.ProductSalesStat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/product-sales")
public class ProductSalesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductSalesDAO dao = new ProductSalesDAO();

        // Lấy tham số showTable
        String showTableParam = request.getParameter("showTable");
        boolean showTable = "1".equals(showTableParam);

        // Phân trang
        int page = 1;
        int pageSize = 7; // hoặc số bạn muốn
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<ProductSalesStat> stats;
        int totalRecords = 0;
        int totalPages = 1;

        if (showTable) {
            stats = dao.getProductSalesByDayPage(page, pageSize);
            totalRecords = dao.getTotalProductSalesDayCount();
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        } else {
            stats = dao.getProductSalesByDay(); // hoặc dữ liệu tổng quan
        }

        request.setAttribute("stats", stats);
        request.setAttribute("showTable", showTable);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/product-sales.jsp").forward(request, response);
    }
}
