///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package model;
//
//import java.math.BigDecimal;
//import java.sql.Timestamp;
//
///**
// *
// * @author X1 carbon Gen6
// */
//public class Product {
//
//    private int productId;
//    private int productID;
//    private String name;
//    private String categoryId;
//    private String description;
//    private double price;
//    private int quantity;
//    private String imageUrl;
//    private String imageURL;
//    private int categoryID;
//    private Boolean isActive;
//    private String categoryName;
//    private Timestamp createdAt;
//    
//    public Product() {
//    }
//
//    public Product(int productId, String name, String categoryId, String description, double price, int quantity, String imageUrl, boolean isActive) {
//        this.productId = productId;
//        this.name = name;
//        this.categoryId = categoryId;
//        this.description = description;
//        this.price = price;
//        this.quantity = quantity;
//        this.imageUrl = imageUrl;
//        this.isActive = isActive;
//    }
//    
//    public Product(int productID, String name, int categoryID, String description, 
//                  double price, int quantity, String imageURL, boolean isActive, 
//                  java.util.Date createdAt) {
//        this.productID = productID;
//        this.name = name;
//        this.categoryID = categoryID;
//        this.description = description;
//        this.price = price;
//        this.quantity = quantity;
//        this.imageURL = imageURL;
//        this.isActive = isActive;
//        this.createdAt = createdAt != null ? new Timestamp(createdAt.getTime()) : null;
//    }
//
//    public int getProductId() {
//        return productId;
//    }
//
//    public void setProductId(int productId) {
//        this.productId = productId;
//    }
//
//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public String getCategoryId() {
//        return categoryId;
//    }
//
//    public void setCategoryId(String categoryId) {
//        this.categoryId = categoryId;
//    }
//
//    public String getDescription() {
//        return description;
//    }
//
//    public void setDescription(String description) {
//        this.description = description;
//    }
//
//    public double getPrice() {
//        return price;
//    }
//
//    public int getProductID() {
//        return productID;
//    }
//
//    public void setProductID(int productID) {
//        this.productID = productID;
//    }
//
//    public String getImageURL() {
//        return imageURL;
//    }
//
//    public void setImageURL(String imageURL) {
//        this.imageURL = imageURL;
//    }
//
//    public int getCategoryID() {
//        return categoryID;
//    }
//
//    public void setCategoryID(int categoryID) {
//        this.categoryID = categoryID;
//    }
//
//    public String getCategoryName() {
//        return categoryName;
//    }
//
//    public void setCategoryName(String categoryName) {
//        this.categoryName = categoryName;
//    }
//
//    public Timestamp getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(Timestamp createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    public void setPrice(double price) {
//        this.price = price;
//    }
//
//    public int getQuantity() {
//        return quantity;
//    }
//
//    public void setQuantity(int quantity) {
//        this.quantity = quantity;
//    }
//
//    public String getImageUrl() {
//        return imageUrl;
//    }
//
//    public void setImageUrl(String imageUrl) {
//        this.imageUrl = imageUrl;
//    }
//
//    public boolean isIsActive() {
//        return isActive;
//    }
//
//    public void setIsActive(boolean isActive) {
//        this.isActive = isActive;
//    }
//
//    public Boolean getIsActive() {
//        return isActive;
//    }
//
//    public void setIsActive(Boolean isActive) {
//        this.isActive = isActive;
//    }
//
//    @Override
//    public String toString() {
//        return "Product{" + "productId=" + productId + ", productID=" + productID + ", name=" + name + ", categoryId=" + categoryId + ", description=" + description + ", price=" + price + ", quantity=" + quantity + ", imageUrl=" + imageUrl + ", imageURL=" + imageURL + ", categoryID=" + categoryID + ", isActive=" + isActive + ", categoryName=" + categoryName + ", createdAt=" + createdAt + '}';
//    }
//
//}



package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
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
    public Product() {}

    public Product(int productID, String name, int categoryID, String description, 
                  BigDecimal price, int quantity, String imageURL, boolean isActive 
                 ) {
        this.productID = productID;
        this.name = name;
        this.categoryID = categoryID;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.imageURL = imageURL;
        this.isActive = isActive;
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
