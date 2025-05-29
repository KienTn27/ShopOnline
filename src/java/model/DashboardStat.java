package model;

import java.util.HashMap;
import java.util.Map;

/**
 * Class representing dashboard statistics.
 * @author HUNG
 */
public class DashboardStat {
    private int totalOrders;
    private double totalRevenue;
    private int totalReviews;
    private Map<String, Integer> orderByStatus;

    /**
     * Default constructor initializing orderByStatus to an empty HashMap.
     */
    public DashboardStat() {
        this.totalOrders = 0;
        this.totalRevenue = 0.0;
        this.totalReviews = 0;
        this.orderByStatus = new HashMap<>();
    }

    /**
     * Gets the total number of orders.
     * @return the total number of orders
     */
    public int getTotalOrders() {
        return totalOrders;
    }

    /**
     * Sets the total number of orders.
     * @param totalOrders the total number of orders
     */
    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    /**
     * Gets the total revenue.
     * @return the total revenue
     */
    public double getTotalRevenue() {
        return totalRevenue;
    }

    /**
     * Sets the total revenue.
     * @param totalRevenue the total revenue
     */
    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    /**
     * Gets the total number of reviews.
     * @return the total number of reviews
     */
    public int getTotalReviews() {
        return totalReviews;
    }

    /**
     * Sets the total number of reviews.
     * @param totalReviews the total number of reviews
     */
    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    /**
     * Gets the map of order counts by status.
     * @return a map with order status as key and count as value
     */
    public Map<String, Integer> getOrderByStatus() {
        return orderByStatus;
    }

    /**
     * Sets the map of order counts by status.
     * @param orderByStatus a map with order status as key and count as value
     */
    public void setOrderByStatus(Map<String, Integer> orderByStatus) {
        this.orderByStatus = orderByStatus != null ? orderByStatus : new HashMap<>();
    }

    /**
     * Returns a string representation of the DashboardStat object.
     * @return a string containing all dashboard statistics
     */
    @Override
    public String toString() {
        return "DashboardStat{" +
               "totalOrders=" + totalOrders +
               ", totalRevenue=" + totalRevenue +
               ", totalReviews=" + totalReviews +
               ", orderByStatus=" + orderByStatus +
               '}';
    }
}