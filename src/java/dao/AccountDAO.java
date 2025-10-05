package java.dao;

import java.model.Account;
import java.util.LinkedHashMap;
import java.util.List;

public class AccountDAO extends GenericDAO<Account> {

    public List<Account> findAll() {
        return queryGenericDAO(Account.class);
    }

    public int insert(Account t) {
        String sql = "INSERT INTO [dbo].[Account]\n"
                + "           ([username]\n"
                + "           ,[password]\n"
                + "           ,[email]\n"
                + "           ,[phone]\n"
                + "           ,[firstName]\n"
                + "           ,[lastName]\n"
                + "           ,[dob]\n"
                + "           ,[address]\n"
                + "           ,[avatar]\n"
                + "           ,[roleId]\n"
                + "           ,[isActive]\n"
                + "           ,[updatedAt]\n"
                + "           ,[gender])\n"
                + "     VALUES\n"
                + "           (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("username", t.getUsername());
        parameterMap.put("password", t.getPassword());
        parameterMap.put("email", t.getEmail());
        parameterMap.put("phone", t.getPhone());
        parameterMap.put("firstName", t.getFirstName());
        parameterMap.put("lastName", t.getLastName());
        parameterMap.put("dob", t.getDob());
        parameterMap.put("address", t.getAddress());
        parameterMap.put("avatar", t.getAvatar());
        parameterMap.put("roleId", t.getRoleId());
        parameterMap.put("isActive", true);
        parameterMap.put("updatedAt", t.getUpdatedAt());
        parameterMap.put("gender", t.isGender());

        return insertGenericDAO(sql, parameterMap);
    }
    
    //    danh sach tat ca cac account
    public List<Account> findAllAccounts() {
        return findAll();
    }
}