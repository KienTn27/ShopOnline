package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import dao.RevenueDAO;
import model.RevenueStat;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/revenue-table")
public class RevenueTableServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null || (!type.equals("day") && !type.equals("month"))) {
            type = "day"; // mặc định
        }

        int page = 1;
        int pageSize = 8; // Số dòng mỗi trang
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        RevenueDAO dao = new RevenueDAO();
        List<RevenueStat> stats = dao.getRevenueByPage(type, page, pageSize);
        int totalRecords = dao.getTotalRevenueCount(type);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("type", type);
        request.setAttribute("stats", stats);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/admin/revenue-table.jsp").forward(request, response);
    }
}
