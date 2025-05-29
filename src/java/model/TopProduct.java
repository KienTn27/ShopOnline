/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author X1 carbon Gen6
 */


public class TopProduct {
    private String productName;
    private int soldQuantity;
    private double revenue;

    public TopProduct(String productName, int soldQuantity, double revenue) {
        this.productName = productName;
        this.soldQuantity = soldQuantity;
        this.revenue = revenue;
    }

    public String getProductName() {
        return productName;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public double getRevenue() {
        return revenue;
    }
}

