/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.LinkedHashMap;
import java.util.List;
import model.Job_Posting_Category;

public class Job_Posting_CategoryDAO extends GenericDAO<Job_Posting_Category> {

    @Override
    public List<Job_Posting_Category> findAll() {
        return queryGenericDAO(Job_Posting_Category.class);
    }

    @Override
    public int insert(Job_Posting_Category t) {
        String sql = "INSERT INTO [dbo].[Job_Posting_Category]\n"
                + "           ([name])\n"
                + "     VALUES (?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", t.getName());
        return insertGenericDAO(sql, parameterMap);
    }

    public Job_Posting_Category findJob_Posting_CategoryByID(int id) {
        String sql = "SELECT * FROM [dbo].[Job_Posting_Category] where id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("id", id);
        List<Job_Posting_Category> list = queryGenericDAO(Job_Posting_Category.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public Job_Posting_Category findJob_Posting_CategoryNameByJobPostingID(int jobPostingID) {
        String sql = "SELECT jpc.* "
                + "FROM [dbo].[JobPostings] jp "
                + "JOIN [dbo].[Job_Posting_Category] jpc ON jp.Job_Posting_CategoryID = jpc.id "
                + "WHERE jp.JobPostingID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("jobPostingID", jobPostingID);
        List<Job_Posting_Category> list = queryGenericDAO(Job_Posting_Category.class, sql, parameterMap); // Query returns a list of names (Strings)
        return list.isEmpty() ? null : list.get(0);
    }

    public void editCategory(int categoryId, String nameCate) {
        String sql = """
                     UPDATE [dbo].[Job_Posting_Category]
                        SET [name] = ?
                      WHERE id = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", nameCate);
        parameterMap.put("id", categoryId);
        updateGenericDAO(sql, parameterMap);
    }

    public void delete(String categoryId) {
        String sql = """
                     UPDATE [dbo].[Job_Posting_Category]
                        SET [status] = ?
                      WHERE id = ?""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("status", "0");
        parameterMap.put("id", categoryId);
        updateGenericDAO(sql, parameterMap);
    }

    public boolean checkDuplicateName(String nameCate) {
        List<Job_Posting_Category> listCate = findAll();
        for (Job_Posting_Category jobCate : listCate) {
            if (jobCate.getName().equalsIgnoreCase(nameCate)) {
                return true;
            }
        }
        return false;
    }

    public boolean checkDuplicateOther(int categoryId, String nameCate) {
        List<Job_Posting_Category> listCate = findAll();
        for (Job_Posting_Category jobCate : listCate) {
            if (jobCate.getId() != categoryId && jobCate.getName().equalsIgnoreCase(nameCate)) {
                return true;
            }
        }
        return false;
    }
}