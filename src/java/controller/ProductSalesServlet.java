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
        // Lấy dữ liệu từ DAO
        ProductSalesDAO dao = new ProductSalesDAO();
        List<ProductSalesStat> stats = dao.getProductSalesByDay();

        // Gửi dữ liệu sang JSP
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/admin/product-sales.jsp").forward(request, response);
    }
}
