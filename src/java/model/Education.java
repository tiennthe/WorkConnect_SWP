/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class Education {
    private int EducationID;
    private int JobSeekerID;
    private String Institution;
    private String Degree;
    private String FieldOfStudy;
    private Date StartDate;
    private Date EndDate;
    private String DegreeImg;
    public Education() {
    }

    public Education(int EducationID, int JobSeekerID, String Institution, String Degree, String FieldOfStudy, Date StartDate, Date EndDate, String DegreeImg) {
        this.EducationID = EducationID;
        this.JobSeekerID = JobSeekerID;
        this.Institution = Institution;
        this.Degree = Degree;
        this.FieldOfStudy = FieldOfStudy;
        this.StartDate = StartDate;
        this.EndDate = EndDate;
        this.DegreeImg = DegreeImg;
    }

    public int getEducationID() {
        return EducationID;
    }

    public void setEducationID(int EducationID) {
        this.EducationID = EducationID;
    }

    public int getJobSeekerID() {
        return JobSeekerID;
    }

    public void setJobSeekerID(int JobSeekerID) {
        this.JobSeekerID = JobSeekerID;
    }

    public String getInstitution() {
        return Institution;
    }

    public void setInstitution(String Institution) {
        this.Institution = Institution;
    }

    public String getDegree() {
        return Degree;
    }

    public void setDegree(String Degree) {
        this.Degree = Degree;
    }

    public String getFieldOfStudy() {
        return FieldOfStudy;
    }

    public void setFieldOfStudy(String FieldOfStudy) {
        this.FieldOfStudy = FieldOfStudy;
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

    public String getDegreeImg() {
        return DegreeImg;
    }

    public void setDegreeImg(String DegreeImg) {
        this.DegreeImg = DegreeImg;
    }
    
    
}
