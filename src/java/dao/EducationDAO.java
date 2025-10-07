/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.LinkedHashMap;
import java.util.List;

import model.Education;

/**
 *
 * @author vanct
 */
public class EducationDAO extends GenericDAO<Education> {

    public List<Education> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Nhap thong tin Dao tao
    public int insert(Education t) {
        String sql = "INSERT INTO Education(JobSeekerID, Institution, Degree, FieldOfStudy, StartDate, EndDate, DegreeImg) values \n"
                + "  (?, ?, ?, ?, ?, ?, ?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", t.getJobSeekerID());
        parameterMap.put("Institution", t.getInstitution());
        parameterMap.put("Degree", t.getDegree());
        parameterMap.put("FieldOfStudy", t.getFieldOfStudy());
        parameterMap.put("StartDate", t.getStartDate());
        parameterMap.put("EndDate", t.getEndDate());
        parameterMap.put("DegreeImg", t.getDegreeImg());
        
        return insertGenericDAO(sql, parameterMap);
    }
    
    //Tim CV cho Job Seeker
    public List<Education> findEducationbyJobSeekerID(int JobSeekerID) {
        String sql = "select * from Education where JobSeekerID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("JobSeekerID", JobSeekerID);
//        List<Education> list = queryGenericDAO(Education.class, sql, parameterMap);
        return queryGenericDAO(Education.class, sql, parameterMap);
        
    }
    
    //Update thong tin hoc van
    public void updateEducation(Education education) {
        String sql = "UPDATE [dbo].[Education]\n"
                + "   SET [Institution] = ?\n"
                + "      ,[Degree] = ?\n"
                + "      ,[FieldOfStudy] = ?\n"
                + "      ,[StartDate] = ?\n"
                + "      ,[EndDate] = ?\n"
                + "      ,[DegreeImg] = ?\n"
                + " WHERE EducationID = ?";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("Institution", education.getInstitution());
        parameterMap.put("Degree", education.getDegree());
        parameterMap.put("FieldOfStudy", education.getFieldOfStudy());
        parameterMap.put("StartDate", education.getStartDate());
        parameterMap.put("EndDate", education.getEndDate());
        parameterMap.put("DegreeImg", education.getDegreeImg());
        parameterMap.put("EducationID", education.getEducationID());        
        
        updateGenericDAO(sql, parameterMap);
    }
    
    public void deleteEducation(int educationID) {
        String sql = "DELETE FROM [dbo].[Education]\n"
                + "      WHERE EducationID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("EducationID", educationID);
        deleteGenericDAO(sql, parameterMap);
    }
    
}
