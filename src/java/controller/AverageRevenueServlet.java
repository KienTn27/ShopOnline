package controller;

import java.io.IOException;
import java.util.List;
import dao.AverageRevenueDAO;
import model.RevenueStat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/average-revenue")
public class AverageRevenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ DAO
        AverageRevenueDAO dao = new AverageRevenueDAO();
        List<RevenueStat> stats = dao.getAverageRevenueByDay();

        // Gửi dữ liệu sang JSP
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/admin/average-revenue.jsp").forward(request, response);
    }
}
