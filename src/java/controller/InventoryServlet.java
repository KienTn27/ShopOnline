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
        InventoryDAO dao = new InventoryDAO();
        List<InventoryStat> inventoryList = dao.getInventoryStats();
        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("admin/inventory.jsp").forward(request, response);
    }
}
