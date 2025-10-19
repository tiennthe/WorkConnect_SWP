/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class FavourJobPosting {
    private int FavourJPID;
    private int JobSeekerID;
    private int JobPostingID;

    public FavourJobPosting() {
    }

    public FavourJobPosting(int FavourJPID, int JobSeekerID, int JobPostingID) {
        this.FavourJPID = FavourJPID;
        this.JobSeekerID = JobSeekerID;
        this.JobPostingID = JobPostingID;
    }

    public int getFavourJPID() {
        return FavourJPID;
    }

    public void setFavourJPID(int FavourJPID) {
        this.FavourJPID = FavourJPID;
    }

    public int getJobSeekerID() {
        return JobSeekerID;
    }

    public void setJobSeekerID(int JobSeekerID) {
        this.JobSeekerID = JobSeekerID;
    }

    public int getJobPostingID() {
        return JobPostingID;
    }

    public void setJobPostingID(int JobPostingID) {
        this.JobPostingID = JobPostingID;
    }
    
    
}