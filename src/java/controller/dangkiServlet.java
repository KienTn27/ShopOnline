/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.sql.Date;
import model.User;

/**
 *
 * @author PHAN TUAN
 */
@WebServlet(name="dangkiServlet", urlPatterns={"/signup"})
public class dangkiServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet dangkiServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet dangkiServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
         DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
         PrintWriter out = response.getWriter();

        //lấy dữ liệu từ form
        String id=request.getParameter("userId");
        String password=request.getParameter("password");
        String fullname=request.getParameter("fullname");
        String address=request.getParameter("address");
        String birthday_raw=request.getParameter("birthday");
        String phone=request.getParameter("phone");
        String email=request.getParameter("email");
        Date birthday = null;
        UserDAO cdb= new UserDAO();
        try{
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate ld = LocalDate.parse(birthday_raw, formatter);
            birthday = Date.valueOf(ld);
            User c=cdb.getUserByUsernamePassword( email, password);
            if(c==null) {
                User u = new User(id, fullname, password, address, birthday, phone, 0);
                out.print(u);
                if(cdb.insert(u) > 0){
                    response.sendRedirect("Login");
                } else {
                    throw new Exception();
                }
               //response.sendRedirect("Home");
            } else {
                request.setAttribute("errorMessage","Tên đăng nhập "+ id+" đã tồn tại!!!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
        } catch(Exception e) {
           System.out.println(e);
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
