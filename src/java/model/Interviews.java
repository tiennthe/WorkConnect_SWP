package model;

import java.sql.Date;

public class Interviews {

    private int Id;
    private int ApplicationID;
    private int RecruiterID;
    private int SeekerID;
    private String Reason; 
    private int Status; // 0: Pending, 1: Rescheduled, 2: Confirmed, 3: Rejected
    private Date ScheduleAt;

    public Interviews() {
    }

    public Interviews(int Id, int ApplicationID, int RecruiterID, int SeekerID, String Reason, int Status, Date ScheduleAt) {
        this.Id = Id;
        this.ApplicationID = ApplicationID;
        this.RecruiterID = RecruiterID;
        this.SeekerID = SeekerID;
        this.Reason = Reason;
        this.Status = Status;
        this.ScheduleAt = ScheduleAt;
    }

    public int getId() {
        return Id;
    }

    public void setId(int Id) {
        this.Id = Id;
    }

    public int getApplicationID() {
        return ApplicationID;
    }

    public void setApplicationID(int ApplicationID) {
        this.ApplicationID = ApplicationID;
    }

    public int getRecruiterID() {
        return RecruiterID;
    }

    public void setRecruiterID(int RecruiterID) {
        this.RecruiterID = RecruiterID;
    }

    public int getSeekerID() {
        return SeekerID;
    }

    public void setSeekerID(int SeekerID) {
        this.SeekerID = SeekerID;
    }

    public String getReason() {
        return Reason;
    }

    public void setReason(String Reason) {
        this.Reason = Reason;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    public Date getScheduleAt() {
        return ScheduleAt;
    }

    public void setScheduleAt(Date ScheduleAt) {
        this.ScheduleAt = ScheduleAt;
    }
}

