/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;



import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Objects; // Để hỗ trợ equals() và hashCode()


public class ProductVariant {

    private int variantID; // PRIMARY KEY, IDENTITY(1,1)
    private int productID; // FOREIGN KEY to Products table
    private String size;
    private String color;
    private String sku; // Mã SKU riêng cho từng biến thể, có thể NULL
    private int quantity; // Số lượng tồn kho của biến thể này
    private BigDecimal price; // Giá của biến thể này
    private String variantImageURL; // URL ảnh riêng cho biến thể này, có thể NULL
    private boolean isActive; // Trạng thái hoạt động, mặc định là true (1)
    private LocalDateTime createdAt; // Thời gian tạo, mặc định là GETDATE()

    // Constructor mặc định (cần thiết cho một số framework như Spring, Hibernate)
    public ProductVariant() {
    }

    // Constructor đầy đủ (có thể bỏ qua variantID và createdAt nếu chúng luôn được DB tự động tạo)
    public ProductVariant(int variantID, int productID, String size, String color, String sku, int quantity,
                          BigDecimal price, String variantImageURL, boolean isActive, LocalDateTime createdAt) {
        this.variantID = variantID;
        this.productID = productID;
        this.size = size;
        this.color = color;
        this.sku = sku;
        this.quantity = quantity;
        this.price = price;
        this.variantImageURL = variantImageURL;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }


    
    // Constructor tiện lợi khi tạo mới một biến thể (variantID và createdAt sẽ được DB xử lý)
    public ProductVariant(int productID, String size, String color, String sku, int quantity,
                          BigDecimal price, String variantImageURL) {
        this.productID = productID;
        this.size = size;
        this.color = color;
        this.sku = sku;
        this.quantity = quantity;
        this.price = price;
        this.variantImageURL = variantImageURL;
        this.isActive = true; // Mặc định là active khi tạo mới
        this.createdAt = LocalDateTime.now(); // Hoặc để null để DB tự động set
    }

    public ProductVariant(int i, int newProductId, String variantSize, String variantColor, int variantQuantity, BigDecimal variantPrice, String variantSku, String variantImageURL) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


    // --- Getters và Setters cho tất cả các thuộc tính ---

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getVariantImageURL() {
        return variantImageURL;
    }

    public void setVariantImageURL(String variantImageURL) {
        this.variantImageURL = variantImageURL;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // --- Override equals(), hashCode(), và toString() để quản lý đối tượng tốt hơn ---

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductVariant that = (ProductVariant) o;
        return variantID == that.variantID &&
               productID == that.productID &&
               quantity == that.quantity &&
               isActive == that.isActive &&
               Objects.equals(size, that.size) &&
               Objects.equals(color, that.color) &&
               Objects.equals(sku, that.sku) &&
               Objects.equals(price, that.price) &&
               Objects.equals(variantImageURL, that.variantImageURL) &&
               Objects.equals(createdAt, that.createdAt);
    }

    @Override
    public int hashCode() {
        return Objects.hash(variantID, productID, size, color, sku, quantity, price, variantImageURL, isActive, createdAt);
    }

    @Override
    public String toString() {
        return "ProductVariant{" +
               "variantID=" + variantID +
               ", productID=" + productID +
               ", size='" + size + '\'' +
               ", color='" + color + '\'' +
               ", sku='" + sku + '\'' +
               ", quantity=" + quantity +
               ", price=" + price +
               ", variantImageURL='" + variantImageURL + '\'' +
               ", isActive=" + isActive +
               ", createdAt=" + createdAt +
               '}';
    }
}
