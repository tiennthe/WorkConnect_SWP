/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.LinkedHashMap;
import java.util.List;
import model.Recruiters;

public class RecruitersDAO extends GenericDAO<Recruiters> {

//    @Override
    public List<Recruiters> findAll() {
        return queryGenericDAO(Recruiters.class);
    }

//    @Override
    public int insert(Recruiters t) {
        String sql = "INSERT INTO [dbo].[Recruiters]\n"
                + "           ([isVerify]\n"
                + "           ,[AccountID]\n"
                + "           ,[CompanyID]\n"
                + "           ,[Position]\n"
                + "           ,[FrontCitizenImage]\n"
                + "           ,[BackCitizenImage])\n"
                + "     VALUES (?,?,?,?,?,?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isVerify", false);
        parameterMap.put("AccountID", t.getAccountID());
        parameterMap.put("CompanyID", t.getCompanyID());
        parameterMap.put("Position", t.getPosition());
        parameterMap.put("FrontCitizenImage", t.getFrontCitizenImage());
        parameterMap.put("BackCitizenImage", t.getBackCitizenImage());

        return insertGenericDAO(sql, parameterMap);
    }

    public Recruiters findRecruitersbyAccountID(String AccountID) {
        String sql = "SELECT * FROM Recruiters WHERE AccountID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("AccountID", AccountID);
        List<Recruiters> list = queryGenericDAO(Recruiters.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Recruiters> listRecruiterByRecruiterID(int recruiterID) {
        String sql = "select * from [dbo].[Recruiters] where RecruiterID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterID);
        List<Recruiters> list = queryGenericDAO(Recruiters.class, sql, parameterMap);
        return queryGenericDAO(Recruiters.class, sql, parameterMap);
    }

    public List<Recruiters> listRecruiterByAccountID(int accountID) {
        String sql = "select * from [dbo].[Recruiters] where AccountID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("AccountID", accountID);
        List<Recruiters> list = queryGenericDAO(Recruiters.class, sql, parameterMap);
        return queryGenericDAO(Recruiters.class, sql, parameterMap);
    }

    public void updateVerification(String recruiterId, boolean verify) {
        String sql = "UPDATE [dbo].[Recruiters]\n"
                + "   SET [isVerify] = ?\n"
                + " WHERE RecruiterID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isVerify", verify);
        parameterMap.put("RecruiterID", recruiterId);
        updateGenericDAO(sql, parameterMap);
    }

    public void deleteRecruiter(String recruiterId) {
        String sql = "DELETE FROM [dbo].[Recruiters]\n"
                + "      WHERE RecruiterID = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        deleteGenericDAO(sql, parameterMap);
    }

    public Recruiters findById(String recruiterId) {
        String sql = "Select * from [dbo].[Recruiters] where RecruiterID = ? ";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("RecruiterID", recruiterId);
        return queryGenericDAO(Recruiters.class, sql, parameterMap).get(0);
    }

    public List<Recruiters> searchByName(String searchQuery) {
        String sql = "select re.*\n"
                + "	from Recruiters as re\n"
                + "	, Account as acc\n"
                + "	where re.AccountID = acc.id\n"
                + "	and acc.lastName + ' ' + acc.firstName LIKE ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("fullname", "%" + searchQuery + "%");
        return queryGenericDAO(Recruiters.class, sql, parameterMap);
    }
}