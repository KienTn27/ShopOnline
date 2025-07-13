package model;

/**
 * View model cho OrderDetail với thông tin sản phẩm
 */
public class OrderDetailView {
    private int orderDetailId;
    private int orderId;
    private int productId;
    private String productName;
    private String imageUrl;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private String size;
    private String color;
    
    // Constructor mặc định
    public OrderDetailView() {
    }
    
    // Constructor đầy đủ
    public OrderDetailView(int orderDetailId, int orderId, int productId, String productName,
                          String imageUrl, int quantity, double unitPrice, double totalPrice,
                          String size, String color) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.size = size;
        this.color = color;
    }
    
    // Getters và Setters
    public int getOrderDetailId() {
        return orderDetailId;
    }
    
    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public double getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
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
    
    @Override
    public String toString() {
        return "OrderDetailView{" +
                "orderDetailId=" + orderDetailId +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                ", size='" + size + '\'' +
                ", color='" + color + '\'' +
                '}';
    }
}
