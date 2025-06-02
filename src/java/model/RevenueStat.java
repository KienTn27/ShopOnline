package model;

import java.util.Date;

public class RevenueStat {
    private String label; // Ngày hoặc Tháng
    private int totalOrders;
    private double totalRevenue;
    private double avgRevenue; // Doanh thu trung bình/ngày

    // Constructor hiện có
    public RevenueStat(String label, int totalOrders, double totalRevenue) {
        this.label = label;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
    }

    // Constructor mới với avgRevenue
    public RevenueStat(Date date, int totalOrders, double totalRevenue, double avgRevenue) {
        this.label = date.toString(); // Chuyển Date thành String
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.avgRevenue = avgRevenue;
    }

    // Getters
    public String getLabel() {
        return label;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public double getAvgRevenue() {
        return avgRevenue;
    }

    // Setter cho avgRevenue (nếu cần)
    public void setAvgRevenue(double avgRevenue) {
        this.avgRevenue = avgRevenue;
    }
}
