/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class TopUser {
    private String fullName;
    private int totalOrders;
    private double totalSpent;

    public TopUser(String fullName, int totalOrders, double totalSpent) {
        this.fullName = fullName;
        this.totalOrders = totalOrders;
        this.totalSpent = totalSpent;
    }

    public String getFullName() {
        return fullName;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public double getTotalSpent() {
        return totalSpent;
    }
}

