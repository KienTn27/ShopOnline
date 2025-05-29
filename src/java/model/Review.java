package model;

import java.util.Date;

public class Review {
    private int reviewID;
    private String userName;
    private String productName;
    private String comment;
    private int rating;
    private Date createdAt;

    public Review(int reviewID, String userName, String productName, String comment, int rating, Date createdAt) {
        this.reviewID = reviewID;
        this.userName = userName;
        this.productName = productName;
        this.comment = comment;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getReviewID() {
        return reviewID;
    }

    public String getUserName() {
        return userName;
    }

    public String getProductName() {
        return productName;
    }

    public String getComment() {
        return comment;
    }

    public int getRating() {
        return rating;
    }

    public Date getCreatedAt() {
        return createdAt;
    }
}
