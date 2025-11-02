/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class Feedback {
    private int FeedbackID;
    private int AccountID;
    private String ContentFeedback;
    private Date CreatedAt;
    private int Status;
    private int JobPostingID;
    public Feedback() {
    }

    public Feedback(int FeedbackID, int AccountID, String ContentFeedback, Date CreatedAt, int Status, int JobPostingID) {
        this.FeedbackID = FeedbackID;
        this.AccountID = AccountID;
        this.ContentFeedback = ContentFeedback;
        this.CreatedAt = CreatedAt;
        this.Status = Status;
        this.JobPostingID = JobPostingID;
    }

    

    public int getFeedbackID() {
        return FeedbackID;
    }

    public void setFeedbackID(int FeedbackID) {
        this.FeedbackID = FeedbackID;
    }

    public int getAccountID() {
        return AccountID;
    }

    public void setAccountID(int AccountID) {
        this.AccountID = AccountID;
    }

    public String getContentFeedback() {
        return ContentFeedback;
    }

    public void setContentFeedback(String ContentFeedback) {
        this.ContentFeedback = ContentFeedback;
    }

    public Date getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Date CreatedAt) {
        this.CreatedAt = CreatedAt;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    public int getJobPostingID() {
        return JobPostingID;
    }

    public void setJobPostingID(int JobPostingID) {
        this.JobPostingID = JobPostingID;
    }
    
    
}