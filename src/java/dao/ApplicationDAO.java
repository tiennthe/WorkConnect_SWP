/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.LinkedHashMap;
import java.util.List;
import model.Applications;

/**
 *
 * @author tuananh
 */
public class ApplicationDAO extends GenericDAO<Applications> {

    @Override
    public List<Applications> findAll() {
        return queryGenericDAO(Applications.class);
    }

    @Override
    public int insert(Applications t) {
        String sql = "INSERT INTO [dbo].[Applications] ([JobPostingID],"
                + "[JobSeekerID],[CVID],[Status])"
                + "VALUES (?,?,?,?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobPostingID", t.getJobPostingID());
        parameterMap.put("JobSeekerID", t.getJobSeekerID());
        parameterMap.put("CVID", t.getCVID());
        parameterMap.put("Status", t.getStatus());

        return insertGenericDAO(sql, parameterMap);
    }

    public void ChangeStatusApplication(int applicationId, int status) {
        String sql = "update [Applications] set[Status] = ? "
                + "WHERE [ApplicationID] = ?";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", status);
        parameterMap.put("ApplicationID", applicationId);

        updateGenericDAO(sql, parameterMap);
    }

    //Danh sach don xin viec tu seeker
    public List<Applications> findApplicationByJobSeekerID(int id, int page, int pageSize) {
        String sql = "select * from Applications where JobSeekerID = ? ORDER BY ApplicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("JobSeekerID", id);
        parameterMap.put("offset", (page - 1) * pageSize);
        parameterMap.put("fetch", pageSize);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    public List<Applications> findApplicationByJobSeekerID(int id) {
        String sql = "select * from Applications where JobSeekerID = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("JobSeekerID", id);

        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    //Danh sach don xin viec tu JobPosting
    public List<Applications> findApplicationByJobPostingID(int id) {
        String sql = "select * from Applications where JobPostingID = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("JobPostingID", id);
        List<Applications> applications = queryGenericDAO(Applications.class, sql, parameterMap);
        JobSeekerDAO jobSeekerDao = new JobSeekerDAO();
        for (Applications application : applications) {
            application.setJobSeeker(jobSeekerDao.findJobSeekerIDByJobSeekerID(application.getJobSeekerID() + ""));
        }
        return applications;
    }

    // Danh sach don xin viec tu Status = Appending
    public List<Applications> findApplicationByPending() {
        String sql = "select * from Applications where Status = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("Status", 3);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    // Danh sach don xin viec tu Status = Agree
    public List<Applications> findApplicationByApproved() {
        String sql = "select * from Applications where Status = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("Status", 2);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    // Danh sach don xin viec tu Status = Reject
    public List<Applications> findApplicationByReject() {
        String sql = "select * from Applications where Status = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("Status", 1);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    // Danh sach don xin viec tu Status = Cancel
    public List<Applications> findApplicationByCancel() {
        String sql = "select * from Applications where Status = ?";
        parameterMap = new LinkedHashMap<>();

        parameterMap.put("Status", 0);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    public List<Applications> findApplicationByJobSeekerIDAndStatus(int jobSeekerID, int status, int page, int pageSize) {
        String sql = "SELECT * FROM Applications WHERE JobSeekerID = ? AND Status = ? ORDER BY ApplicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", jobSeekerID);
        parameterMap.put("Status", status);
        parameterMap.put("offset", (page - 1) * pageSize);
        parameterMap.put("fetch", pageSize);
        return queryGenericDAO(Applications.class, sql, parameterMap);
    }

    public Applications getDetailApplication(int applicationID) {
        String sql = "select * from Applications where ApplicationID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", applicationID);
        List<Applications> applications = queryGenericDAO(Applications.class, sql, parameterMap);
        JobSeekerDAO jobSeekerDao = new JobSeekerDAO();
        for (Applications application : applications) {
            application.setJobSeeker(jobSeekerDao.findJobSeekerIDByJobSeekerID(application.getJobSeekerID() + ""));
        }
        return applications.isEmpty() ? null : applications.get(0);
    }

    //Update Status of Application
    public void cancelApplication(int applicationId, int status) {
        String sql = "UPDATE [Applications] SET [Status] = ? WHERE [ApplicationID] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", status);
        parameterMap.put("ApplicationID", applicationId);
        updateGenericDAO(sql, parameterMap);
    }

    public Applications findPendingApplication(int jobSeekerID, int jobPostingID) {
        String sql = "SELECT * FROM Applications WHERE JobSeekerID = ? AND JobPostingID = ? AND Status = 3";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", jobSeekerID);
        parameterMap.put("JobPostingID", jobPostingID);
        List<Applications> list = queryGenericDAO(Applications.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public int countTotalApplicationsByJSIDAndStatus(int jobSeekerID, int status) {
        String sql = "SELECT count(*) FROM [dbo].[Applications] WHERE JobSeekerID = ? AND Status = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", jobSeekerID);
        parameterMap.put("Status", status);
        return findTotalRecordGenericDAO(Applications.class, sql, parameterMap);
    }

    public int countTotalApplicationsByJSID(int jobSeekerID) {
        String sql = "SELECT count(*) FROM [dbo].[Applications] WHERE JobSeekerID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", jobSeekerID);
        return findTotalRecordGenericDAO(Applications.class, sql, parameterMap);
    }

    public List<Applications> findApplicationsByFilters(int jobPostingId, String searchName, String statusFilter, String dateFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT A.* FROM Applications as A"
                + " Join JobSeekers as J on A.JobSeekerId = J.JobSeekerId"
                + " Join Account as Ac on Ac.id = J.AccountId WHERE JobPostingID = ?");
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobPostingID", jobPostingId);

        if (searchName != null && !searchName.isEmpty()) {
            sql.append(" AND (firstName LIKE ? OR lastName LIKE ?)");
            parameterMap.put("firstName", "%" + searchName + "%");
            parameterMap.put("lastName", "%" + searchName + "%");
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND Status = ?");
            parameterMap.put("Status", Integer.parseInt(statusFilter));
        }
        if (dateFilter != null && !dateFilter.isEmpty()) {
            sql.append(" AND CONVERT(date, AppliedDate) = ?");
            parameterMap.put("AppliedDate", java.sql.Date.valueOf(dateFilter));
        }

        sql.append(" ORDER BY AppliedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        List<Applications> applications = queryGenericDAO(Applications.class, sql.toString(), parameterMap);
        JobSeekerDAO jobSeekerDao = new JobSeekerDAO();
        for (Applications application : applications) {
            application.setJobSeeker(jobSeekerDao.findJobSeekerIDByJobSeekerID(application.getJobSeekerID() + ""));
        }
        return applications;
    }

    public int countApplicationsByFilters(int jobPostingId, String searchName, String statusFilter, String dateFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Applications as A"
                + " JOIN JobSeekers as J ON A.JobSeekerId = J.JobSeekerId"
                + " JOIN Account as Ac ON Ac.id = J.AccountId WHERE JobPostingID = ?");

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobPostingID", jobPostingId);

        if (searchName != null && !searchName.isEmpty()) {
            sql.append(" AND (firstName LIKE ? OR lastName LIKE ?)");
            parameterMap.put("firstName", "%" + searchName + "%");
            parameterMap.put("lastName", "%" + searchName + "%");
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND Status = ?");
            parameterMap.put("Status", Integer.parseInt(statusFilter));
        }
        if (dateFilter != null && !dateFilter.isEmpty()) {
            sql.append(" AND CONVERT(date, AppliedDate) = ?");
            parameterMap.put("AppliedDate", java.sql.Date.valueOf(dateFilter));
        }

        return countGenericDAO(sql.toString(), parameterMap);
    }

    //dem tong so ung vien pendding all bai dang
    public int countPendingApplicationsForRecruiter(int recruiterId) {
        String sql = "SELECT COUNT(*) "
                + "FROM Applications a "
                + "JOIN JobPostings jp ON a.JobPostingID = jp.JobPostingID "
                + "WHERE jp.RecruiterID = ? AND a.Status = 3";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);

        return findTotalRecordGenericDAO(Applications.class, sql, parameterMap);
    }

    public int countAgreeApplicationsForRecruiter(int recruiterId) {
        String sql = "SELECT COUNT(*) "
                + "FROM Applications a "
                + "JOIN JobPostings jp ON a.JobPostingID = jp.JobPostingID "
                + "WHERE jp.RecruiterID = ? AND a.Status = 2";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);

        return findTotalRecordGenericDAO(Applications.class, sql, parameterMap);
    }

    public int getTotalApplicationsByJobPostingID(int jobPostId) {
        String sql = "SELECT COUNT(*) FROM Applications WHERE JobPostingID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobPostingID", jobPostId);

        List<Integer> result = queryGenericDAO1(Integer.class, sql, parameterMap);

        // Trả về giá trị đầu tiên của danh sách kết quả, nếu có
        return result.isEmpty() ? 0 : result.get(0);
    }

}