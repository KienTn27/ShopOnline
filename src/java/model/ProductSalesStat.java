package model;

public class ProductSalesStat {
    private String saleDate; // Ngày bán
    private int totalQuantity; // Tổng số sản phẩm bán ra

    public ProductSalesStat(String saleDate, int totalQuantity) {
        this.saleDate = saleDate;
        this.totalQuantity = totalQuantity;
    }

    public String getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(String saleDate) {
        this.saleDate = saleDate;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
}
