/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class TopRevenueDay {
    private String day;         // Ngày có doanh thu cao nhất
    private double totalRevenue; // Tổng doanh thu trong ngày đó

    // Constructor
    public TopRevenueDay(String day, double totalRevenue) {
        this.day = day;
        this.totalRevenue = totalRevenue;
    }

    // Getters and Setters
    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}

