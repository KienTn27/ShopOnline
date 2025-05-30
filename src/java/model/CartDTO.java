/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author X1 carbon Gen6
 */
public class CartDTO {

    private int cartId;
    private int userId;
    private int productId;
    private int quantity;
    private Date createdAt;
    private String productName;
    private double price;

    public CartDTO() {
    }

    public CartDTO(int cartId, int userId, int productId, int quantity, Date createdAt, String productName, double price) {
        this.cartId = cartId;
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
        this.createdAt = createdAt;
        this.productName = productName;
        this.price = price;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

}
