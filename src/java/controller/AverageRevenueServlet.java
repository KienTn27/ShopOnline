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
        int page = 1;
        int pageSize = 10;
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
        AverageRevenueDAO dao = new AverageRevenueDAO();
        List<RevenueStat> stats = dao.getAverageRevenueByDayPage(page, pageSize);
        int totalRecords = dao.getTotalAverageRevenueCount();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        request.setAttribute("stats", stats);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/admin/average-revenue.jsp").forward(request, response);
    }
}
