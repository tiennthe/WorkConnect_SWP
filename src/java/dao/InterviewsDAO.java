package dao;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Interviews;
import java.sql.Date;

public class InterviewsDAO extends GenericDAO<Interviews> {

    @Override
    public List<Interviews> findAll() {
        return queryGenericDAO(Interviews.class);
    }

    @Override
    public int insert(Interviews t) {
        String sql = "INSERT INTO [dbo].[Interviews] "
                + "([ApplicationID],[RecruiterID],[SeekerID],[Reason],[Status],[ScheduleAt]) "
                + "VALUES (?,?,?,?,?,?)";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", t.getApplicationID());
        parameterMap.put("RecruiterID", t.getRecruiterID());
        parameterMap.put("SeekerID", t.getSeekerID());
        parameterMap.put("Reason", t.getReason());
        parameterMap.put("Status", t.getStatus());
        parameterMap.put("ScheduleAt", t.getScheduleAt());

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
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? ORDER BY [ScheduleAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findBySeekerIdAndStatus(int seekerId, int status) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? AND [Status] = ? ORDER BY [ScheduleAt] DESC, [Id] DESC";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Status", status);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    // Pagination variants
    public List<Interviews> findBySeekerId(int seekerId, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? ORDER BY [ScheduleAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("SeekerID", seekerId);
        parameterMap.put("Offset", (page - 1) * pageSize);
        parameterMap.put("PageSize", pageSize);
        return queryGenericDAO(Interviews.class, sql, parameterMap);
    }

    public List<Interviews> findBySeekerIdAndStatus(int seekerId, int status, int page, int pageSize) {
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [SeekerID] = ? AND [Status] = ? ORDER BY [ScheduleAt] DESC, [Id] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
        String sql = "SELECT * FROM [dbo].[Interviews] WHERE [ApplicationID] = ? ORDER BY [ScheduleAt] DESC, [Id] DESC";
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
                + "[ScheduleAt] = ? "
                + "WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ApplicationID", t.getApplicationID());
        parameterMap.put("RecruiterID", t.getRecruiterID());
        parameterMap.put("SeekerID", t.getSeekerID());
        parameterMap.put("Reason", t.getReason());
        parameterMap.put("Status", t.getStatus());
        parameterMap.put("ScheduleAt", t.getScheduleAt());
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

    public boolean updateScheduleAndStatus(int interviewId, Date newScheduleAt, int interviewStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [ScheduleAt] = ?, [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ScheduleAt", newScheduleAt);
        parameterMap.put("Status", interviewStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);

        Integer appId = getApplicationIdByInterviewId(interviewId);
        if (ok && appId != null) {
            new ApplicationDAO().ChangeStatusApplication(appId, 5);
        }
        return ok;
    }

    public boolean acceptJobApplication(int interviewId, int interviewAcceptStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewAcceptStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);

        Integer appId = getApplicationIdByInterviewId(interviewId);
        if (ok && appId != null) {
            new ApplicationDAO().ChangeStatusApplication(appId, 4);
        }
        return ok;
    }

    public boolean rejectJobApplication(int interviewId, int interviewRejectStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewRejectStatus);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);

        Integer appId = getApplicationIdByInterviewId(interviewId);
        if (ok && appId != null) {
            new ApplicationDAO().ChangeStatusApplication(appId, 6);
        }
        return ok;
    }

    public boolean rejectWithReason(int interviewId, String reason, int interviewRejectStatus) {
        String sql = "UPDATE [dbo].[Interviews] SET [Status] = ?, [Reason] = ? WHERE [Id] = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", interviewRejectStatus);
        parameterMap.put("Reason", reason);
        parameterMap.put("Id", interviewId);
        boolean ok = updateGenericDAO(sql, parameterMap);

        Integer appId = getApplicationIdByInterviewId(interviewId);
        if (ok && appId != null) {
            new ApplicationDAO().ChangeStatusApplication(appId, 5);
        }
        return ok;
    }
}
