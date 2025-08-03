package validation;

import java.util.regex.Pattern;
import exception.ReportException;

/**
 * Validation class for report and statistics parameters
 * @author Admin
 */
public class ReportValidator {
    
    private static final Pattern PAGE_PATTERN = Pattern.compile("^[1-9]\\d*$");
    private static final Pattern PAGE_SIZE_PATTERN = Pattern.compile("^[1-9]\\d*$");
    private static final Pattern TYPE_PATTERN = Pattern.compile("^(day|month)$");
    
    /**
     * Validate page parameter
     */
    public static int validatePage(String pageParam) throws ReportException {
        if (pageParam == null || pageParam.trim().isEmpty()) {
            return 1; // Default to first page
        }
        
        if (!PAGE_PATTERN.matcher(pageParam).matches()) {
            throw new ReportException("Số trang không hợp lệ", "INVALID_PAGE");
        }
        
        int page = Integer.parseInt(pageParam);
        if (page < 1) {
            throw new ReportException("Số trang phải lớn hơn 0", "INVALID_PAGE");
        }
        
        return page;
    }
    
    /**
     * Validate page size parameter
     */
    public static int validatePageSize(String pageSizeParam, int maxPageSize) throws ReportException {
        if (pageSizeParam == null || pageSizeParam.trim().isEmpty()) {
            return 10; // Default page size
        }
        
        if (!PAGE_SIZE_PATTERN.matcher(pageSizeParam).matches()) {
            throw new ReportException("Kích thước trang không hợp lệ", "INVALID_PAGE_SIZE");
        }
        
        int pageSize = Integer.parseInt(pageSizeParam);
        if (pageSize < 1 || pageSize > maxPageSize) {
            throw new ReportException("Kích thước trang phải từ 1 đến " + maxPageSize, "INVALID_PAGE_SIZE");
        }
        
        return pageSize;
    }
    
    /**
     * Validate type parameter (day/month)
     */
    public static String validateType(String type) throws ReportException {
        if (type == null || type.trim().isEmpty()) {
            return "day"; // Default to day
        }
        
        if (!TYPE_PATTERN.matcher(type).matches()) {
            throw new ReportException("Loại thống kê không hợp lệ (chỉ hỗ trợ 'day' hoặc 'month')", "INVALID_TYPE");
        }
        
        return type;
    }
    
    /**
     * Validate date range parameters
     */
    public static void validateDateRange(String startDate, String endDate) throws ReportException {
        if (startDate != null && endDate != null) {
            // Basic date format validation
            if (!startDate.matches("\\d{4}-\\d{2}-\\d{2}") || !endDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
                throw new ReportException("Định dạng ngày không hợp lệ (YYYY-MM-DD)", "INVALID_DATE_FORMAT");
            }
            
            // Check if start date is before end date
            if (startDate.compareTo(endDate) > 0) {
                throw new ReportException("Ngày bắt đầu phải trước ngày kết thúc", "INVALID_DATE_RANGE");
            }
        }
    }
    
    /**
     * Validate user permissions for report access
     */
    public static void validateUserPermission(Object user, String requiredRole) throws ReportException {
        if (user == null) {
            throw new ReportException("Người dùng chưa đăng nhập", "UNAUTHORIZED");
        }
        
        // Add role validation logic here if needed
        // For now, just check if user exists
    }
    
    /**
     * Sanitize input string to prevent XSS
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        
        return input.replaceAll("<script[^>]*>.*?</script>", "")
                   .replaceAll("<[^>]*>", "")
                   .replaceAll("javascript:", "")
                   .replaceAll("on\\w+\\s*=", "")
                   .trim();
    }
} 