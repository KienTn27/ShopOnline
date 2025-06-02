package controller;

import java.io.IOException;
import dao.TopRevenueDayDAO;
import model.TopRevenueDay;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/highest-revenue")

public class TopRevenueDayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ DAO
        TopRevenueDayDAO dao = new TopRevenueDayDAO();
        TopRevenueDay stat = dao.getHighestRevenueDay();

        // Gửi dữ liệu sang JSP
        request.setAttribute("highestRevenueStat", stat);
        request.getRequestDispatcher("/admin/highest-revenue.jsp").forward(request, response);
    }
}
