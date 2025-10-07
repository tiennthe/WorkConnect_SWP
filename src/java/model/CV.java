
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class CV {
    private int CVID;
    private int JobSeekerID;
    private String FilePath;
    private Date UploadDate;
    private Date LastUpdated;

    public CV() {
    }

    public CV(int CVID, int JobSeekerID, String FilePath, Date UploadDate, Date LastUpdated) {
        this.CVID = CVID;
        this.JobSeekerID = JobSeekerID;
        this.FilePath = FilePath;
        this.UploadDate = UploadDate;
        this.LastUpdated = LastUpdated;
    }

    public int getCVID() {
        return CVID;
    }

    public void setCVID(int CVID) {
        this.CVID = CVID;
    }

    public int getJobSeekerID() {
        return JobSeekerID;
    }

    public void setJobSeekerID(int JobSeekerID) {
        this.JobSeekerID = JobSeekerID;
    }

    public String getFilePath() {
        return FilePath;
    }

    public void setFilePath(String FilePath) {
        this.FilePath = FilePath;
    }

    public Date getUploadDate() {
        return UploadDate;
    }

    public void setUploadDate(Date UploadDate) {
        this.UploadDate = UploadDate;
    }

    public Date getLastUpdated() {
        return LastUpdated;
    }

    public void setLastUpdated(Date LastUpdated) {
        this.LastUpdated = LastUpdated;
    }
    
    
}
