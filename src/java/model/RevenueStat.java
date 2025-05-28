package model;

import java.util.Date;

public class RevenueStat {
    private String label; // Ngày hoặc Tháng
    private int totalOrders;
    private double totalRevenue;

    public RevenueStat(String label, int totalOrders, double totalRevenue) {
        this.label = label;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
    }

    public String getLabel() {
        return label;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }
}
