package model;

public class OrderDetailView {

    private int orderDetailId;
    private int orderId;
    private int productId;
    private String productName;
    private String imageURL;
    private int quantity;
    private double unitPrice;

    public double getTotalPrice() {
        return unitPrice * quantity;
    }

    public OrderDetailView() {
    }

    public OrderDetailView(int orderDetailId, int orderId, int productId, String productName, String imageURL, int quantity, double unitPrice) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.imageURL = imageURL;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    // Getters and setters
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
        return imageURL;
    }

    public void setImageUrl(String imageURL) {
        this.imageURL = imageURL;
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
}
