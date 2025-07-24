package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.DatabaseMetaData;

public class DBContext {
    private static volatile DBContext instance;
    private Connection connection;
    
    // Thông tin kết nối
    private static final String URL = "jdbc:sqlserver://PC-cua-KIEN:1433;databaseName=Shop;TrustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASSWORD = "sa";
    
    // Constructor riêng tư
    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connect();
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver SQL Server: " + e.getMessage());
        }
    }
    
    // Singleton pattern với thread-safety
    public static DBContext getInstance() {
        if (instance == null) {
            synchronized (DBContext.class) {
                if (instance == null) {
                    instance = new DBContext();
                }
            }
        }
        return instance;
    }
    
    // Lấy kết nối
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connect();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra trạng thái kết nối: " + e.getMessage());
        }
        return connection;
    }
    
    // Kết nối cơ sở dữ liệu
    private void connect() {
        try {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Kết nối cơ sở dữ liệu thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Không thể kết nối cơ sở dữ liệu: " + e.getMessage());
            connection = null;
        }
    }
    
    // Đóng kết nối
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✅ Đã đóng kết nối cơ sở dữ liệu.");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }
    
    // Phương thức kiểm tra kết nối và lấy thông tin từ cơ sở dữ liệu
    public void checkConnectionAndFetchData(String tableName) {
        try {
            Connection conn = getConnection();
            if (conn == null || conn.isClosed()) {
                System.out.println("❌ Kết nối không khả dụng.");
                return;
            }

            // Lấy metadata của cơ sở dữ liệu
            DatabaseMetaData metaData = conn.getMetaData();
            System.out.println("=== Thông tin cơ sở dữ liệu ===");
            System.out.println("Tên cơ sở dữ liệu: " + conn.getCatalog());
            System.out.println("URL: " + metaData.getURL());
            System.out.println("Phiên bản SQL Server: " + metaData.getDatabaseProductVersion());
            System.out.println("Driver: " + metaData.getDriverName());
            System.out.println("==============================");

            // Lấy dữ liệu từ bảng (nếu tableName không rỗng)
            if (tableName != null && !tableName.isEmpty()) {
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {
                    System.out.println("Dữ liệu từ bảng " + tableName + ":");
                    System.out.println("-----------------------------");
                    
                    // Lấy metadata của ResultSet để in tên cột
                    java.sql.ResultSetMetaData rsMetaData = rs.getMetaData();
                    int columnCount = rsMetaData.getColumnCount();
                    for (int i = 1; i <= columnCount; i++) {
                        System.out.print(rsMetaData.getColumnName(i) + "\t");
                    }
                    System.out.println("\n" + "-".repeat(50));
                    
                    // In dữ liệu
                    while (rs.next()) {
                        for (int i = 1; i <= columnCount; i++) {
                            System.out.print(rs.getString(i) + "\t");
                        }
                        System.out.println();
                    }
                } catch (SQLException e) {
                    System.err.println("Lỗi khi truy vấn bảng " + tableName + ": " + e.getMessage());
                }
            } else {
                System.out.println("Không có bảng được chỉ định để lấy dữ liệu.");
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy thông tin cơ sở dữ liệu: " + e.getMessage());
        }
    }
    
    // Test kết nối và lấy thông tin
    public static void main(String[] args) {
        try {
            DBContext dbContext = DBContext.getInstance();
            // Gọi phương thức để kiểm tra kết nối và lấy thông tin
            dbContext.checkConnectionAndFetchData("Users"); // Thay "Products" bằng tên bảng của bạn
            // Đóng kết nối
            dbContext.closeConnection();
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}