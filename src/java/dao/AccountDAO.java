package dao;

import java.util.LinkedHashMap;
import java.util.List;

import model.Account;

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
    
    public List<Account> findAllAccounts() {
        return findAll();
    }

    public Account findUserByUsernameAndPassword(Account account) {
        String sql = "SELECT * FROM [dbo].[Account] where username = ? and password = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("username", account.getUsername());
        parameterMap.put("password", account.getPassword());
        List<Account> list = queryGenericDAO(Account.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public boolean checkUsernameExist(Account account) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Account]\n"
                + "  where username = ? ";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("username", account.getUsername());
        return !queryGenericDAO(Account.class, sql, parameterMap).isEmpty();
    }

    public boolean checkUserEmailExist(Account account) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Account]\n"
                + "  where email = ? ";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("email", account.getEmail());
        return !queryGenericDAO(Account.class, sql, parameterMap).isEmpty();
    }

    public void updateAccount(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [username] = ?\n"
                + "      ,[password] = ?\n"
                + "      ,[email] = ?\n"
                + "      ,[phone] = ?\n"
                + "      ,[firstName] = ?\n"
                + "      ,[lastName] = ?\n"
                + "      ,[dob] = ?\n"
                + "      ,[address] = ?\n"
                + "      ,[avatar] = ?\n"
                + "      ,[roleId] = ?\n"
                + "      ,[isActive] = ?\n"
                + "      ,[createAt] = ?\n"
                + "      ,[updatedAt] = getDate()\n"
                + "      ,[gender] = ?\n"
                + " WHERE id = ?";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("username", account.getUsername());
        parameterMap.put("password", account.getPassword());
        parameterMap.put("email", account.getEmail());
        parameterMap.put("phone", account.getPhone());
        parameterMap.put("firstName", account.getFirstName());
        parameterMap.put("lastName", account.getLastName());
        parameterMap.put("dob", account.getDob());
        parameterMap.put("address", account.getAddress());
        parameterMap.put("avatar", account.getAvatar());
        parameterMap.put("roleId", (Integer) account.getRoleId());
        parameterMap.put("isActive", account.isIsActive());
        parameterMap.put("createAt", account.getCreateAt());
        parameterMap.put("gender", account.isGender());
        parameterMap.put("id", account.getId());
        updateGenericDAO(sql, parameterMap);
    }

    public Account findUserById(int id) {
        String sql = "SELECT * FROM [dbo].[Account] where id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("id", id);
        List<Account> list = queryGenericDAO(Account.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public void updatePasswordbyEmail(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [password] = ?\n"
                + " WHERE email = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("password", account.getPassword());
        parameterMap.put("email", account.getEmail());
        updateGenericDAO(sql, parameterMap);
    }
}