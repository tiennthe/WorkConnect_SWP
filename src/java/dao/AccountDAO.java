package dao;

import static constant.CommonConst.RECORD_PER_PAGE;

import java.util.LinkedHashMap;
import java.util.List;

import model.Account;

public class AccountDAO extends GenericDAO<Account> {

    @Override
    public List<Account> findAll() {
        return queryGenericDAO(Account.class);
    }

    @Override
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
                + "           ,[province])\n"
                + "           ,[provinceId])\n"
                + "           ,[ward])\n"
                + "           ,[wardId])\n"
                + "     VALUES\n"
                + "           (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
        parameterMap.put("province", t.getProvince());
        parameterMap.put("provinceId", t.getProvinceId());
        parameterMap.put("ward", t.getWard());
        parameterMap.put("wardId", t.getWardId());

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
                + "      ,[province] = ?\n"
                + "      ,[provinceId] = ?\n"
                + "      ,[ward] = ?\n"
                + "      ,[wardId] = ?\n"
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
        parameterMap.put("province", account.getProvince());
        parameterMap.put("provinceId", account.getProvinceId());
        parameterMap.put("ward", account.getWard());
        parameterMap.put("wardId", account.getWardId());
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
    
    public void deactiveAccount(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [isActive] = ?\n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isActive", 0);
        parameterMap.put("id", account.getId());
        updateGenericDAO(sql, parameterMap);
    }
    
    public void updatePassword(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [password] = ?\n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("password", account.getPassword());
        parameterMap.put("id", account.getId());
        updateGenericDAO(sql, parameterMap);
    }
    
    public void updatePasswordByUsername(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [password] = ?\n, [updatedAt] = (getDate())"
                + " WHERE username = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("password", account.getPassword());
        parameterMap.put("username", account.getUsername());
        updateGenericDAO(sql, parameterMap);
    }
    
    public int findAllTotalRecord(int roleId) {
        String sql = "SELECT count(*) FROM [dbo].[Account]\n"
                + "where roleId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        return findTotalRecordGenericDAO(Account.class, sql, parameterMap);
    }

    public List<Account> searchUserByName(String searchQuery, int roleId, int page) {
        String sql = "SELECT * FROM [dbo].[Account] WHERE roleId = ? AND lastName + ' ' +firstName LIKE ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        parameterMap.put("username", "%" + searchQuery + "%");
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Account.class, sql, parameterMap);
    }
    
    public int findTotalRecordByName(String searchQuery, int roleId) {
        String sql = "SELECT count(*) FROM [dbo].[Account] WHERE roleId = ? AND lastName + ' ' +firstName LIKE ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        parameterMap.put("username", "%" + searchQuery + "%");
        return findTotalRecordGenericDAO(Account.class, sql, parameterMap);
    }
    
    public List<Account> searchUserByNameAndStatus(String searchQuery, boolean status, int roleId, int page) {
        String sql = "SELECT * FROM [dbo].[Account] WHERE roleId = ? AND lastName + ' ' +firstName LIKE ? AND isActive = ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        parameterMap.put("username", "%" + searchQuery + "%");
        parameterMap.put("isActive", status);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Account.class, sql, parameterMap);
    }

    public int findTotalRecordByNameAndStatus(String searchQuery, boolean status, int roleId) {
        String sql = "SELECT count(*) FROM [dbo].[Account] WHERE roleId = ? AND lastName + ' ' +firstName LIKE ? AND isActive = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        parameterMap.put("username", "%" + searchQuery + "%");
        parameterMap.put("isActive", status);
        return findTotalRecordGenericDAO(Account.class, sql, parameterMap);
    }
    
    public List<Account> filterUserByStatus(boolean status, int roleId, int page) {
        String sql = "SELECT * FROM [dbo].[Account]\n"
                + "where isActive = ? and roleId = ?\n"
                + "order by id\n"
                + "OFFSET ? rows\n"
                + "FETCH NEXT ? rows only";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isActive", status);
        parameterMap.put("roleId", roleId);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        List<Account> list = queryGenericDAO(Account.class, sql, parameterMap);
        return list;
    }
    
     public List<Account> findAllUserByRoleId(int roleId, int page) {
        String sql = """
                     SELECT * FROM [dbo].[Account]
                     where roleId = ?
                     order by id
                     OFFSET ? rows
                     FETCH NEXT ? rows only""";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("roleId", roleId);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        List<Account> list = queryGenericDAO(Account.class, sql, parameterMap);
        return list;
    }
     
     public int findTotalRecordByStatus(boolean status, int roleId) {
        String sql = "SELECT count(*) FROM [dbo].[Account]\n"
                + "where isActive = ? and roleId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isActive", status);
        parameterMap.put("roleId", roleId);
        return findTotalRecordGenericDAO(Account.class, sql, parameterMap);
    }
     
     public void activeAccount(Account account) {
        String sql = "UPDATE [dbo].[Account]\n"
                + "   SET [isActive] = ?\n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("isActive", 1);
        parameterMap.put("id", account.getId());
        updateGenericDAO(sql, parameterMap);
    }
}