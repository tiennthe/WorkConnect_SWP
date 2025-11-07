package model;

import java.sql.Timestamp;

public class Interviews {

    private int Id;
    private int ApplicationID;
    private int RecruiterID;
    private int SeekerID;
    private String Reason; 
    private int Status; // 0: Pending, 1: Rescheduled, 2: Confirmed, 3: Rejected
    private Timestamp ScheduleAt;
    private int CreatedBy; // recruiterId or seekerId

    public Interviews() {
    }

    public Interviews(int Id, int ApplicationID, int RecruiterID, int SeekerID, String Reason, int Status, Timestamp ScheduleAt, int CreatedBy) {
        this.Id = Id;
        this.ApplicationID = ApplicationID;
        this.RecruiterID = RecruiterID;
        this.SeekerID = SeekerID;
        this.Reason = Reason;
        this.Status = Status;
        this.ScheduleAt = ScheduleAt;
        this.CreatedBy = CreatedBy;
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

    public Timestamp getScheduleAt() {
        return ScheduleAt;
    }

    public void setScheduleAt(Timestamp ScheduleAt) {
        this.ScheduleAt = ScheduleAt;
    }

    public int getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(int CreatedBy) {
        this.CreatedBy = CreatedBy;
    }
}
