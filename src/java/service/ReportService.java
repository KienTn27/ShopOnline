package service;

import dao.RevenueDAO;
import dao.AverageRevenueDAO;
import dao.ProductSalesDAO;
import dao.InventoryDAO;
import dao.UserDAO;
import model.RevenueStat;
import model.ProductSalesStat;
import model.InventoryStat;
import model.TopUser;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Service layer for handling report and statistics business logic
 *
 * @author Admin
 */
public class ReportService {

    private static final Logger LOGGER = Logger.getLogger(ReportService.class.getName());

    private final RevenueDAO revenueDAO;
    private final AverageRevenueDAO averageRevenueDAO;
    private final ProductSalesDAO productSalesDAO;
    private final InventoryDAO inventoryDAO;
    private final UserDAO userDAO;

    public ReportService() {
        this.revenueDAO = new RevenueDAO();
        this.averageRevenueDAO = new AverageRevenueDAO();
        this.productSalesDAO = new ProductSalesDAO();
        this.inventoryDAO = new InventoryDAO();
        this.userDAO = new UserDAO();
    }

    /**
     * Get revenue statistics with validation and business logic
     */
    public Map<String, Object> getRevenueStats(String type, int page, int pageSize) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Validate parameters
            if (type == null || (!type.equals("day") && !type.equals("month"))) {
                type = "day";
            }

            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 || pageSize > 100) {
                pageSize = 10;
            }

            // Get data with pagination
            List<RevenueStat> stats = revenueDAO.getRevenueByPage(type, page, pageSize);
            int totalRecords = revenueDAO.getTotalRevenueCount(type);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Calculate additional metrics
            double totalRevenue = stats.stream().mapToDouble(RevenueStat::getTotalRevenue).sum();
            int totalOrders = stats.stream().mapToInt(RevenueStat::getTotalOrders).sum();
            double avgRevenue = stats.isEmpty() ? 0 : totalRevenue / stats.size();

            result.put("stats", stats);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("type", type);
            result.put("totalRevenue", totalRevenue);
            result.put("totalOrders", totalOrders);
            result.put("avgRevenue", avgRevenue);

            LOGGER.info("Revenue stats retrieved successfully: " + stats.size() + " records");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting revenue stats", e);
            result.put("error", "Có lỗi xảy ra khi tải dữ liệu doanh thu");
        }

        return result;
    }

    /**
     * Get average revenue statistics
     */
    public Map<String, Object> getAverageRevenueStats(int page, int pageSize) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 || pageSize > 100) {
                pageSize = 10;
            }

            List<RevenueStat> stats = averageRevenueDAO.getAverageRevenueByDayPage(page, pageSize);
            int totalRecords = averageRevenueDAO.getTotalAverageRevenueCount();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            double totalRevenue = stats.stream().mapToDouble(RevenueStat::getTotalRevenue).sum();
            double avgRevenue = stats.isEmpty() ? 0 : totalRevenue / stats.size();

            result.put("stats", stats);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("totalRevenue", totalRevenue);
            result.put("avgRevenue", avgRevenue);

            LOGGER.info("Average revenue stats retrieved successfully: " + stats.size() + " records");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting average revenue stats", e);
            result.put("error", "Có lỗi xảy ra khi tải dữ liệu doanh thu trung bình");
        }

        return result;
    }

    /**
     * Get product sales statistics
     */
    public Map<String, Object> getProductSalesStats(int page, int pageSize, boolean showTable) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 || pageSize > 100) {
                pageSize = 7;
            }

            List<ProductSalesStat> stats;
            int totalRecords;

            if (showTable) {
                stats = productSalesDAO.getProductSalesByDayPage(page, pageSize);
                totalRecords = productSalesDAO.getTotalProductSalesDayCount();
            } else {
                stats = productSalesDAO.getProductSalesByDay();
                totalRecords = stats.size();
            }

            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Calculate metrics
            int totalQuantity = stats.stream().mapToInt(ProductSalesStat::getTotalQuantity).sum();
            double avgDaily = stats.isEmpty() ? 0 : (double) totalQuantity / stats.size();

            result.put("stats", stats);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("showTable", showTable);
            result.put("totalQuantity", totalQuantity);
            result.put("avgDaily", avgDaily);

            LOGGER.info("Product sales stats retrieved successfully: " + stats.size() + " records");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product sales stats", e);
            result.put("error", "Có lỗi xảy ra khi tải dữ liệu bán hàng");
        }

        return result;
    }

    /**
     * Get inventory statistics
     */
    public Map<String, Object> getInventoryStats(int page, int pageSize) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 || pageSize > 100) {
                pageSize = 10;
            }

            List<InventoryStat> stats = inventoryDAO.getInventoryStatsPage(page, pageSize);
            int totalRecords = inventoryDAO.getTotalInventoryCount();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Calculate metrics
            int totalProducts = stats.stream().mapToInt(InventoryStat::getStockQuantity).sum();
            int lowStockCount = (int) stats.stream().filter(s -> s.getStockQuantity() < 10).count();

            result.put("stats", stats);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("totalProducts", totalProducts);
            result.put("lowStockCount", lowStockCount);

            LOGGER.info("Inventory stats retrieved successfully: " + stats.size() + " records");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory stats", e);
            result.put("error", "Có lỗi xảy ra khi tải dữ liệu tồn kho");
        }

        return result;
    }

    /**
     * Get top users statistics
     */
    public Map<String, Object> getTopUsersStats(int page, int pageSize, boolean showTable) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 || pageSize > 100) {
                pageSize = 7;
            }

            List<TopUser> stats;
            int totalRecords;

            if (showTable) {
                stats = userDAO.getTopUserPage(page, pageSize);
                totalRecords = userDAO.getTotalTopUserCount();
            } else {
                stats = userDAO.getTopUser();
                totalRecords = stats.size();
            }

            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Calculate metrics
            double totalSpending = stats.stream().mapToDouble(TopUser::getTotalSpent).sum();
            double avgSpending = stats.isEmpty() ? 0 : totalSpending / stats.size();

            result.put("stats", stats);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("showTable", showTable);
            result.put("totalSpending", totalSpending);
            result.put("avgSpending", avgSpending);

            LOGGER.info("Top users stats retrieved successfully: " + stats.size() + " records");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting top users stats", e);
            result.put("error", "Có lỗi xảy ra khi tải dữ liệu người dùng");
        }

        return result;
    }
}
