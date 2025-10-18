/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class WorkExperience {
    private int ExperienceID;
    private int JobSeekerID;
    private String CompanyName;
    private String JobTitle;
    private Date StartDate;
    private Date EndDate;
    private String Description;

    public WorkExperience() {
    }

    public WorkExperience(int ExperienceID, int JobSeekerID, String CompanyName, String JobTitle, Date StartDate, Date EndDate, String Description) {
        this.ExperienceID = ExperienceID;
        this.JobSeekerID = JobSeekerID;
        this.CompanyName = CompanyName;
        this.JobTitle = JobTitle;
        this.StartDate = StartDate;
        this.EndDate = EndDate;
        this.Description = Description;
    }

    public int getExperienceID() {
        return ExperienceID;
    }

    public void setExperienceID(int ExperienceID) {
        this.ExperienceID = ExperienceID;
    }

    public int getJobSeekerID() {
        return JobSeekerID;
    }

    public void setJobSeekerID(int JobSeekerID) {
        this.JobSeekerID = JobSeekerID;
    }

    public String getCompanyName() {
        return CompanyName;
    }

    public void setCompanyName(String CompanyName) {
        this.CompanyName = CompanyName;
    }

    public String getJobTitle() {
        return JobTitle;
    }

    public void setJobTitle(String JobTitle) {
        this.JobTitle = JobTitle;
    }

    public Date getStartDate() {
        return StartDate;
    }

    public void setStartDate(Date StartDate) {
        this.StartDate = StartDate;
    }

    public Date getEndDate() {
        return EndDate;
    }

    public void setEndDate(Date EndDate) {
        this.EndDate = EndDate;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }
    
    
}
