package model;

import java.util.Date;
import java.util.List;

public class JobPostings {

    private int JobPostingID;
    private int RecruiterID;
    private String Title;
    private String Description;
    private String Requirements;
    private double MinSalary;
    private double MaxSalary;
    private String Location;
    private Date PostedDate;
    private Date ClosingDate;
    private int Job_Posting_CategoryID;
    private String Status;
    private List<Applications> application;
    private String province;
    private String ward;
    private int provinceId;
    private int wardId;
    

    public JobPostings() {
    }

    public JobPostings(int JobPostingID, int RecruiterID, String Title, String Description, String Requirements, double MinSalary, double MaxSalary, String Location, Date PostedDate, Date ClosingDate, int Job_Posting_CategoryID, String Status, String province, String ward, int provinceId, int wardId) {
        this.JobPostingID = JobPostingID;
        this.RecruiterID = RecruiterID;
        this.Title = Title;
        this.Description = Description;
        this.Requirements = Requirements;
        this.MinSalary = MinSalary;
        this.MaxSalary = MaxSalary;
        this.Location = Location;
        this.PostedDate = PostedDate;
        this.ClosingDate = ClosingDate;
        this.Job_Posting_CategoryID = Job_Posting_CategoryID;
        this.Status = Status;
        this.province = province;
        this.ward = ward;
        this.provinceId = provinceId;
        this.wardId = wardId;
    }
    
    public String getWard(){
        return ward;
    }
    
    public String getProvince(){
        return province;
    }

    public int getProvinceId() {
        return provinceId;
    }

    public int getWardId() {
        return wardId;
    }

    public void setProvinceId(int provinceId) {
        this.provinceId = provinceId;
    }

    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public int getJobPostingID() {
        return JobPostingID;
    }

    public void setJobPostingID(int JobPostingID) {
        this.JobPostingID = JobPostingID;
    }

    public int getRecruiterID() {
        return RecruiterID;
    }

    public void setRecruiterID(int RecruiterID) {
        this.RecruiterID = RecruiterID;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public String getRequirements() {
        return Requirements;
    }

    public void setRequirements(String Requirements) {
        this.Requirements = Requirements;
    }

    public double getMinSalary() {
        return MinSalary;
    }

    public void setMinSalary(double MinSalary) {
        this.MinSalary = MinSalary;
    }

    public double getMaxSalary() {
        return MaxSalary;
    }

    public void setMaxSalary(double MaxSalary) {
        this.MaxSalary = MaxSalary;
    }

    public String getLocation() {
        return Location;
    }

    public void setLocation(String Location) {
        this.Location = Location;
    }

    public Date getPostedDate() {
        return PostedDate;
    }

    public void setPostedDate(Date PostedDate) {
        this.PostedDate = PostedDate;
    }

    public Date getClosingDate() {
        return ClosingDate;
    }

    public void setClosingDate(Date ClosingDate) {
        this.ClosingDate = ClosingDate;
    }

    public int getJob_Posting_CategoryID() {
        return Job_Posting_CategoryID;
    }

    public void setJob_Posting_CategoryID(int Job_Posting_CategoryID) {
        this.Job_Posting_CategoryID = Job_Posting_CategoryID;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public List<Applications> getApplication() {
        return application;
    }

    public void setApplication(List<Applications> application) {
        this.application = application;
    }
}