/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.LinkedHashMap;
import java.util.List;
import model.WorkExperience;

public class WorkExperienceDAO extends GenericDAO<WorkExperience> {

    @Override
    public List<WorkExperience> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(WorkExperience t) {
        String sql = "insert into Work_Experience (JobSeekerID, CompanyName, JobTitle, StartDate, EndDate, Description)"
                + "values (?,?,?,?,?,?)";
        parameterMap = new LinkedHashMap<>();
        
        parameterMap.put("JobSeekerID", t.getJobSeekerID());
        parameterMap.put("CompanyName", t.getCompanyName());
        parameterMap.put("JobTitle", t.getJobTitle());
        parameterMap.put("StartDate", t.getStartDate());
        parameterMap.put("EndDate", t.getEndDate());
        parameterMap.put("Description", t.getDescription());
        
        return insertGenericDAO(sql, parameterMap);
    }
    
    public List<WorkExperience> findWorkExperiencesbyJobSeekerID(int JobSeekerID) {
        String sql = "select * from Work_Experience where JobSeekerID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", JobSeekerID);
        return queryGenericDAO(WorkExperience.class, sql, parameterMap);
        
    }
    
    public void updateExperience(WorkExperience we) {
        String sql = "UPDATE [dbo].[Work_Experience]\n"
                + "   SET [CompanyName] = ?\n"
                + "      ,[JobTitle] = ?\n"
                + "      ,[StartDate] = ?\n"
                + "      ,[EndDate] = ?\n"
                + "      ,[Description] = ?\n"
                + " WHERE ExperienceID = ?";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("CompanyName", we.getCompanyName());
        parameterMap.put("JobTitle", we.getJobTitle());
        parameterMap.put("StartDate", we.getStartDate());
        parameterMap.put("EndDate", we.getEndDate());
        parameterMap.put("Description", we.getDescription());
        parameterMap.put("ExperienceID", we.getExperienceID());
        
        updateGenericDAO(sql, parameterMap);
    }
    
    public void deleteExperience(int experienceID) {
        String sql = "DELETE FROM [dbo].[Work_Experience]\n"
                + "      WHERE ExperienceID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("ExperienceID", experienceID);
        deleteGenericDAO(sql, parameterMap);
    }
}
