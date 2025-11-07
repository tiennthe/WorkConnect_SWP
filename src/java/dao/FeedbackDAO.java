/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import static constant.CommonConst.RECORD_PER_PAGE;
import java.util.LinkedHashMap;
import java.util.List;
import model.Feedback;

public class FeedbackDAO extends GenericDAO<Feedback> {

    @Override
    public List<Feedback> findAll() {
        return queryGenericDAO(Feedback.class);
    }

    @Override
    public int insert(Feedback t) {
        String sql = """
                     INSERT INTO [dbo].[Feedback]
                                ([AccountID]
                                ,[ContentFeedback]
                                ,[JobPostingID])
                          VALUES
                                (?,?,?)""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("AccountID", t.getAccountID());
        parameterMap.put("ContentFeedback", t.getContentFeedback());
        parameterMap.put("JobPostingID", t.getJobPostingID());
        return insertGenericDAO(sql, parameterMap);
    }

    public Feedback findFeedbackById(int id) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Feedback]\n"
                + "  where FeedbackID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("FeedbackID", id);
        return queryGenericDAO(Feedback.class, sql, parameterMap).get(0);
    }

    public void changeStatus(int id, int status) {
        String sql = "UPDATE [dbo].[Feedback]\n"
                + "   SET [Status] = ?\n"
                + " WHERE FeedbackID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", status);
        parameterMap.put("FeedbackID", id);
        updateGenericDAO(sql, parameterMap);
    }

    public void deleteFeedback(Feedback feedbackFound) {
        String sql = "DELETE FROM [dbo].[Feedback]\n"
                + "      WHERE FeedbackID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("FeedbackID", feedbackFound.getFeedbackID());
        deleteGenericDAO(sql, parameterMap);
    }

    public List<Feedback> findAllGroupByName(int page) {
        String sql = """
                     SELECT *
                       FROM [dbo].[Feedback]
                       order by AccountID
                       offset ? rows
                       fetch next ? rows only""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Feedback.class, sql, parameterMap);
    }

    public List<Feedback> searchFeedbackByName(String searchQuery, int page) {
        String sql = """
                     SELECT fe.*
                     FROM [dbo].[Feedback] as fe, Account as acc
                     WHERE fe.AccountID = acc.id and  
                     (acc.lastName + ' ' + acc.firstName) LIKE ?
                     order by acc.id
                     offset ? rows
                     fetch next ? rows only""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Feedback.class, sql, parameterMap);
    }

    public int findTotalRecordByName(String searchQuery) {
        String sql = """
                     SELECT count(*)
                     FROM [dbo].[Feedback] as fe, Account as acc
                     WHERE fe.AccountID = acc.id and  
                     (acc.lastName + ' ' + acc.firstName) LIKE ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        return findTotalRecordGenericDAO(Feedback.class, sql, parameterMap);
    }

    public List<Feedback> searchFeedbackByNameAndStatus(String searchQuery, int status, int page) {
        String sql = """
                     SELECT fe.*
                     FROM [dbo].[Feedback] as fe, Account as acc
                     WHERE fe.AccountID = acc.id and  
                     (acc.lastName + ' ' + acc.firstName) LIKE ?
                     and fe.[Status] = ?
                     order by acc.id
                     offset ? rows
                     fetch next ? rows only""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("status", status);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Feedback.class, sql, parameterMap);
    }

    public int findTotalRecordByNameAndStatus(String searchQuery, int status) {
        String sql = """
                     SELECT count(*)
                     FROM [dbo].[Feedback] as fe, Account as acc
                     WHERE fe.AccountID = acc.id and  
                     (acc.lastName + ' ' + acc.firstName) LIKE ? 
                     and fe.[Status] = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("status", status);
        return findTotalRecordGenericDAO(Feedback.class, sql, parameterMap);
    }

    public int findAllTotalRecord() {
        String sql = "SELECT count(*) FROM [dbo].[Feedback]\n";
        parameterMap = new LinkedHashMap<>();
        return findTotalRecordGenericDAO(Feedback.class, sql, parameterMap);
    }

    public List<Feedback> filterFeedbackByStatus(int status, int page) {
        String sql = """
                     SELECT *
                       FROM [dbo].[Feedback]
                       where Status = ?
                       order by FeedbackID
                       offset ? rows
                       fetch next ? rows only""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Status", status);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        List<Feedback> list = queryGenericDAO(Feedback.class, sql, parameterMap);
        return list;
    }

    public int findTotalRecordByStatus(int status) {
        String sql = """
                     SELECT count(*)
                       FROM [dbo].[Feedback]
                       where Status = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", status);
        return findTotalRecordGenericDAO(Feedback.class, sql, parameterMap);
    }

    public List<Feedback> findFeedbackByAccountID(int id) {
        String sql = """
                     SELECT *
                       FROM [dbo].[Feedback]
                       where AccountID = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("AccountID", id);
        return queryGenericDAO(Feedback.class, sql, parameterMap);
    }

    public void updateFeedback(int feedbackId, String content) {
        String sql = """
                     UPDATE [dbo].[Feedback]
                        SET 
                           [ContentFeedback] = ?
                       
                      WHERE FeedbackID = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ContentFeedback", content);
        parameterMap.put("FeedbackID", feedbackId);
        updateGenericDAO(sql, parameterMap);
    }

}