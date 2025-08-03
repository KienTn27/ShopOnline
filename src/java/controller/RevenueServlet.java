/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import service.ReportService;
import validation.ReportValidator;
import exception.ReportException;
import jakarta.servlet.annotation.WebServlet;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet for handling revenue reports with improved architecture
 *
 * @author Admin
 */
@WebServlet("/revenue")
public class RevenueServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RevenueServlet.class.getName());
    private final ReportService reportService;

    public RevenueServlet() {
        this.reportService = new ReportService();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RevenueServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RevenueServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate user session and permissions
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Validate and sanitize input parameters
            String type = ReportValidator.sanitizeInput(request.getParameter("type"));
            type = ReportValidator.validateType(type);

            int page = ReportValidator.validatePage(request.getParameter("page"));
            int pageSize = ReportValidator.validatePageSize(request.getParameter("pageSize"), 100);

            // Get data from service layer
            Map<String, Object> result = reportService.getRevenueStats(type, page, pageSize);

            // Check for errors
            if (result.containsKey("error")) {
                request.setAttribute("error", result.get("error"));
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }

            // Set attributes for JSP
            request.setAttribute("stats", result.get("stats"));
            request.setAttribute("currentPage", result.get("currentPage"));
            request.setAttribute("totalPages", result.get("totalPages"));
            request.setAttribute("totalRecords", result.get("totalRecords"));
            request.setAttribute("type", result.get("type"));
            request.setAttribute("totalRevenue", result.get("totalRevenue"));
            request.setAttribute("totalOrders", result.get("totalOrders"));
            request.setAttribute("avgRevenue", result.get("avgRevenue"));

            LOGGER.info("Revenue report generated successfully for type: " + type + ", page: " + page);

            // Forward to JSP
            request.getRequestDispatcher("/admin/revenue.jsp").forward(request, response);

        } catch (ReportException e) {
            LOGGER.log(Level.WARNING, "Validation error in revenue report", e);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in revenue report", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải báo cáo doanh thu");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Revenue Report Servlet with improved architecture";
    }
}
