package model;

public class InventoryStat {
    private int productId;
    private String productName;
    private int stockQuantity;

    public InventoryStat() {}

    public InventoryStat(int productId, String productName, int stockQuantity) {
        this.productId = productId;
        this.productName = productName;
        this.stockQuantity = stockQuantity;
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

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}
