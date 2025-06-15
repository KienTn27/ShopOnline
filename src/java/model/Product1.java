package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product1 {
    private int productID;
    private String name;
    private String description;
    private BigDecimal price;
    private int quantity;
    private String imageURL;
    private Boolean isActive;
    private Timestamp createdAt;
    private int categoryID;
    private String categoryName; // Thêm field này

    // Constructors
    public Product1() {}

    public Product1(int productID, String name, int categoryID, String description, 
                  BigDecimal price, int quantity, String imageURL, boolean isActive, 
                  java.util.Date createdAt) {
        this.productID = productID;
        this.name = name;
        this.categoryID = categoryID;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.imageURL = imageURL;
        this.isActive = isActive;
        this.createdAt = createdAt != null ? new Timestamp(createdAt.getTime()) : null;
    }

    // Getters and Setters
    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    // Getter và setter cho categoryName
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}