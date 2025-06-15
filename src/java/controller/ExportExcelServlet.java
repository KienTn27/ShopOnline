package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.Category;
import model.Product1;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;

/**
 * Servlet xử lý xuất dữ liệu sản phẩm ra file Excel
 * @author truon
 */
@WebServlet(name = "ExportExcelServlet", urlPatterns = {"/ExportExcel"})
public class ExportExcelServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        exportProducts(request, response);
    }

    /**
     * Xuất danh sách sản phẩm ra file Excel
     */
    private void exportProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách sản phẩm từ database
            List<Product1> products = productDAO.getAllProduct();
            
            // Tạo workbook mới (sử dụng HSSF cho định dạng XLS thay vì XSSF cho XLSX)
            Workbook workbook = new HSSFWorkbook();
            
            // Tạo sheet "Sản phẩm"
            Sheet sheet = workbook.createSheet("Sản phẩm");
            
            // Tạo font cho header
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            
            // Tạo CellStyle cho header
            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);
            headerCellStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
            headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerCellStyle.setBorderTop(BorderStyle.THIN);
            headerCellStyle.setBorderBottom(BorderStyle.THIN);
            headerCellStyle.setBorderLeft(BorderStyle.THIN);
            headerCellStyle.setBorderRight(BorderStyle.THIN);
            headerCellStyle.setAlignment(HorizontalAlignment.CENTER);
            
            // Tạo CellStyle cho dữ liệu
            CellStyle dataCellStyle = workbook.createCellStyle();
            dataCellStyle.setBorderTop(BorderStyle.THIN);
            dataCellStyle.setBorderBottom(BorderStyle.THIN);
            dataCellStyle.setBorderLeft(BorderStyle.THIN);
            dataCellStyle.setBorderRight(BorderStyle.THIN);
            
            // Tạo CellStyle cho số tiền
            CellStyle currencyCellStyle = workbook.createCellStyle();
            currencyCellStyle.setBorderTop(BorderStyle.THIN);
            currencyCellStyle.setBorderBottom(BorderStyle.THIN);
            currencyCellStyle.setBorderLeft(BorderStyle.THIN);
            currencyCellStyle.setBorderRight(BorderStyle.THIN);
            currencyCellStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0 \"₫\""));
            
            // Tạo CellStyle cho ngày tháng
            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setBorderTop(BorderStyle.THIN);
            dateCellStyle.setBorderBottom(BorderStyle.THIN);
            dateCellStyle.setBorderLeft(BorderStyle.THIN);
            dateCellStyle.setBorderRight(BorderStyle.THIN);
            dateCellStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));
            
            // Tạo header row
            Row headerRow = sheet.createRow(0);
            String[] columns = {"ID", "Tên sản phẩm", "Danh mục", "Mô tả", "Giá", "Số lượng", "Trạng thái", "Ngày tạo", "Đường dẫn ảnh"};
            
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerCellStyle);
            }
            
            // Tạo data rows
            int rowNum = 1;
            for (Product1 product : products) {
                Row row = sheet.createRow(rowNum++);
                
                // ID
                Cell cell0 = row.createCell(0);
                cell0.setCellValue(product.getProductID());
                cell0.setCellStyle(dataCellStyle);
                
                // Tên sản phẩm
                Cell cell1 = row.createCell(1);
                cell1.setCellValue(product.getName());
                cell1.setCellStyle(dataCellStyle);
                
                // Danh mục
                Cell cell2 = row.createCell(2);
                if (product.getCategoryID() != 0) {
                    Category category = categoryDAO.getCategoryById(product.getCategoryID());
                    cell2.setCellValue(category != null ? category.getName() : "Không xác định");
                } else {
                    cell2.setCellValue("Không xác định");
                }
                cell2.setCellStyle(dataCellStyle);
                
                // Mô tả
                Cell cell3 = row.createCell(3);
                cell3.setCellValue(product.getDescription() != null ? product.getDescription() : "");
                cell3.setCellStyle(dataCellStyle);
                
                // Giá
                Cell cell4 = row.createCell(4);
                cell4.setCellValue(product.getPrice().doubleValue());
                cell4.setCellStyle(currencyCellStyle);
                
                // Số lượng
                Cell cell5 = row.createCell(5);
                cell5.setCellValue(product.getQuantity());
                cell5.setCellStyle(dataCellStyle);
                
                // Trạng thái
                Cell cell6 = row.createCell(6);
                cell6.setCellValue(product.getIsActive() ? "Đang bán" : "Ngừng bán");
                cell6.setCellStyle(dataCellStyle);
                
                // Ngày tạo
                Cell cell7 = row.createCell(7);
                if (product.getCreatedAt() != null) {
                    cell7.setCellValue(product.getCreatedAt());
                    cell7.setCellStyle(dateCellStyle);
                } else {
                    cell7.setCellValue("");
                    cell7.setCellStyle(dataCellStyle);
                }
                
                // Đường dẫn ảnh
                Cell cell8 = row.createCell(8);
                cell8.setCellValue(product.getImageURL() != null ? product.getImageURL() : "");
                cell8.setCellStyle(dataCellStyle);
            }
            
            // Tự động điều chỉnh độ rộng cột
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Thiết lập header cho response
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
            String currentDateTime = dateFormat.format(new Date());
            String fileName = "DanhSachSanPham_" + currentDateTime + ".xls"; // Đổi đuôi thành .xls
            
            response.setContentType("application/vnd.ms-excel"); // Đổi content type
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
            
            // Ghi workbook ra OutputStream
            workbook.write(response.getOutputStream());
            
            // Đóng workbook
            workbook.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("managerProduct?error=" + e.getMessage());
        }
    }
}