package dao;

import java.util.LinkedHashMap;
import java.util.List;
import model.Interviews;
import java.sql.Timestamp;

public class InterviewsDAO extends GenericDAO<Interviews> {

    @Override
    public List<Interviews> findAll() {
        return queryGenericDAO(Interviews.class);
    }

    @Override
    public int insert(Interviews t) {
        String sql = "INSERT INTO [dbo].[Interviews] "
                + "([ApplicationID],[RecruiterID],[SeekerID],[Reason],[Status],[ScheduleAt],[CreatedBy]) "
                + "VALUES (?,?,?,?,?,?,?)";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", t.getApplicationID());
        parameterMap.put("RecruiterID", t.getRecruiterID());
        parameterMap.put("SeekerID", t.getSeekerID());
        parameterMap.put("Reason", t.getReason());
        parameterMap.put("Status", t.getStatus());
        parameterMap.put("ScheduleAt", t.getScheduleAt());
        parameterMap.put("CreatedBy", t.getCreatedBy());

        return insertGenericDAO(sql, parameterMap);
    }

    public Interviews findById(int id) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Id", id);
        List<Interviews> list = queryGenericDAO(Interviews.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Interviews> findByApplicationId(int applicationId) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [ApplicationID] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", applicationId);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findBySeekerId(int seekerId) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? ORDER BY [CreatedAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findByRecruiterId(int recruiterId) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [RecruiterID] = ? ORDER BY [CreatedAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findBySeekerIdAndStatus(int seekerId, int status) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? AND [Status] = ? ORDER BY [CreatedAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    // Pagination variants
    public List<Interviews> findBySeekerId(int seekerId, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? ORDER BY [CreatedAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findBySeekerIdAndStatus(int seekerId, int status, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? AND [Status] = ? ORDER BY [CreatedAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public int countBySeekerId(int seekerId) {
        String sql = "SELECT COUNT(*) FROM [dbo].[Interviews] WHERE [SeekerID] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        return countGenericDAO(sql, parameterMap);
    }

    // Latest-only (group by ApplicationID, RecruiterID, SeekerID) for seeker
    public List<Interviews> findLatestBySeekerId(int seekerId, int page, int pageSize) {
        String sql = "WITH iv AS (\n" +
                "  SELECT *, ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE SeekerID = ?\n" +
                ")\n" +
                "SELECT * FROM iv WHERE rn = 1\n" +
                "ORDER BY CreatedAt DESC, Id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findLatestBySeekerIdAndStatus(int seekerId, int status, int page, int pageSize) {
        String sql = "WITH iv AS (\n" +
                "  SELECT *, ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE SeekerID = ? AND Status = ?\n" +
                ")\n" +
                "SELECT * FROM iv WHERE rn = 1\n" +
                "ORDER BY CreatedAt DESC, Id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public int countLatestBySeekerId(int seekerId) {
        String sql = "WITH iv AS (\n" +
                "  SELECT ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE SeekerID = ?\n" +
                ") SELECT COUNT(*) FROM iv WHERE rn = 1";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        return countGenericDAO(sql, parameterMap);
    }

    public int countLatestBySeekerIdAndStatus(int seekerId, int status) {
        String sql = "WITH iv AS (\n" +
                "  SELECT ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE SeekerID = ? AND Status = ?\n" +
                ") SELECT COUNT(*) FROM iv WHERE rn = 1";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        return countGenericDAO(sql, parameterMap);
    }

    public List<Interviews> findByRecruiterId(int recruiterId, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [RecruiterID] = ? ORDER BY [CreatedAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findByRecruiterIdAndStatus(int recruiterId, int status, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [RecruiterID] = ? AND [Status] = ? ORDER BY [CreatedAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Status", status);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    // Latest-only variants (group by ApplicationID, RecruiterID, SeekerID)
    public List<Interviews> findLatestByRecruiterId(int recruiterId, int page, int pageSize) {
        String sql = "WITH iv AS (\n" +
                "  SELECT *, ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE RecruiterID = ?\n" +
                ")\n" +
                "SELECT * FROM iv WHERE rn = 1\n" +
                "ORDER BY CreatedAt DESC, Id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findLatestByRecruiterIdAndStatus(int recruiterId, int status, int page, int pageSize) {
        String sql = "WITH iv AS (\n" +
                "  SELECT *, ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE RecruiterID = ? AND Status = ?\n" +
                ")\n" +
                "SELECT * FROM iv WHERE rn = 1\n" +
                "ORDER BY CreatedAt DESC, Id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Status", status);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public int countLatestByRecruiterId(int recruiterId) {
        String sql = "WITH iv AS (\n" +
                "  SELECT ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE RecruiterID = ?\n" +
                ") SELECT COUNT(*) FROM iv WHERE rn = 1";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        return countGenericDAO(sql, parameterMap);
    }

    public int countLatestByRecruiterIdAndStatus(int recruiterId, int status) {
        String sql = "WITH iv AS (\n" +
                "  SELECT ROW_NUMBER() OVER (PARTITION BY ApplicationID, RecruiterID, SeekerID ORDER BY CreatedAt DESC, Id DESC) rn\n" +
                "  FROM [dbo].[Interviews]\n" +
                "  WHERE RecruiterID = ? AND Status = ?\n" +
                ") SELECT COUNT(*) FROM iv WHERE rn = 1";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Status", status);
        return countGenericDAO(sql, parameterMap);
    }

    public int countByRecruiterId(int recruiterId) {
        String sql = "SELECT COUNT(*) FROM [dbo].[Interviews] WHERE [RecruiterID] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        return countGenericDAO(sql, parameterMap);
    }

    public int countByRecruiterIdAndStatus(int recruiterId, int status) {
        String sql = "SELECT COUNT(*) FROM [dbo].[Interviews] WHERE [RecruiterID] = ? AND [Status] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        parameterMap.put("Status", status);
        return countGenericDAO(sql, parameterMap);
    }

    public int countBySeekerIdAndStatus(int seekerId, int status) {
        String sql = "SELECT COUNT(*) FROM [dbo].[Interviews] WHERE [SeekerID] = ? AND [Status] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        return countGenericDAO(sql, parameterMap);
    }

    public List<Interviews> findHistoryByInterviewId(int interviewId) {
        Integer appId = getApplicationIdByInterviewId(interviewId);
        if (appId == null) return java.util.Collections.emptyList();
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [ApplicationID] = ? ORDER BY [CreatedAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", appId);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public boolean update(Interviews t) {
        String sql = "UPDATE [dbo].[Interviews] SET "
                + "[ApplicationID] = ?, "
                + "[RecruiterID] = ?, "
                + "[SeekerID] = ?, "
                + "[Reason] = ?, "
                + "[Status] = ?, "
                + "[ScheduleAt] = ?, "
                + "[CreatedBy] = ? "
                + "WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", t.getApplicationID());
        parameterMap.put("RecruiterID", t.getRecruiterID());
        parameterMap.put("SeekerID", t.getSeekerID());
        parameterMap.put("Reason", t.getReason());
        parameterMap.put("Status", t.getStatus());
        parameterMap.put("ScheduleAt", t.getScheduleAt());
        parameterMap.put("CreatedBy", t.getCreatedBy());
        parameterMap.put("Id", t.getId());
        return updateGenericDAO(sql, parameterMap);
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", status);
        parameterMap.put("Id", id);
        return updateGenericDAO(sql, parameterMap);
    }

    private Integer getApplicationIdByInterviewId(int interviewId) {
        String sql = "SELECT ApplicationID FROM [dbo].[Interviews] WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Id", interviewId);
        List<Integer> ids = queryGenericDAO1(Integer.class, sql, parameterMap);
        return ids.isEmpty() ? null : ids.get(0);
    }

    public boolean updateScheduleAndStatus(int interviewId, Timestamp newScheduleAt, int interviewStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [ScheduleAt] = ?, [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ScheduleAt", newScheduleAt);
        parameterMap.put("Status", interviewStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);
        return ok;
    }

    public boolean updateScheduleStatusAndReason(int interviewId, Timestamp newScheduleAt, int interviewStatus, String reason) {
        String sql = "UPDATE [dbo].[Interviews] SET [ScheduleAt] = ?, [Status] = ?, [Reason] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ScheduleAt", newScheduleAt);
        parameterMap.put("Status", interviewStatus);
        parameterMap.put("Reason", reason);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);
        return ok;
    }

    public boolean acceptJobApplication(int interviewId, int interviewAcceptStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewAcceptStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);
        return ok;
    }

    public boolean rejectJobApplication(int interviewId, int interviewRejectStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewRejectStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);
        return ok;
    }

    public boolean rejectWithReason(int interviewId, String reason, int interviewRejectStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ?, [Reason] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewRejectStatus);
        parameterMap.put("Reason", reason);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);
        return ok;
    }
}


