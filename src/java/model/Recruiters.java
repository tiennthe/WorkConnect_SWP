package model;

public class Recruiter {
    private int RecruiterID;
    private boolean isVerify;
    private int AccountID;
    private int CompanyID;
    private String Position;
    private String FrontCitizenImage;
    private String BackCitizenImage;

    public Recruiter() {
    }

    public Recruiter(int RecruiterID, boolean isVerify, int AccountID, int CompanyID, String Position, String FrontCitizenImage, String BackCitizenImage) {
        this.RecruiterID = RecruiterID;
        this.isVerify = isVerify;
        this.AccountID = AccountID;
        this.CompanyID = CompanyID;
        this.Position = Position;
        this.FrontCitizenImage = FrontCitizenImage;
        this.BackCitizenImage = BackCitizenImage;
    }

    public int getRecruiterID() {
        return RecruiterID;
    }

    public void setRecruiterID(int RecruiterID) {
        this.RecruiterID = RecruiterID;
    }

    public boolean isIsVerify() {
        return isVerify;
    }

    public void setIsVerify(boolean isVerify) {
        this.isVerify = isVerify;
    }

    public int getAccountID() {
        return AccountID;
    }

    public void setAccountID(int AccountID) {
        this.AccountID = AccountID;
    }

    public int getCompanyID() {
        return CompanyID;
    }

    public void setCompanyID(int CompanyID) {
        this.CompanyID = CompanyID;
    }

    public String getPosition() {
        return Position;
    }

    public void setPosition(String Position) {
        this.Position = Position;
    }

    public String getFrontCitizenImage() {
        return FrontCitizenImage;
    }

    public void setFrontCitizenImage(String FrontCitizenImage) {
        this.FrontCitizenImage = FrontCitizenImage;
    }

    public String getBackCitizenImage() {
        return BackCitizenImage;
    }

    public void setBackCitizenImage(String BackCitizenImage) {
        this.BackCitizenImage = BackCitizenImage;
    }
    
}