/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import static constant.CommonConst.RECORD_PER_PAGE;
import java.util.LinkedHashMap;
import java.util.List;
import model.Company;

public class CompanyDAO extends GenericDAO<Company> {

    @Override
    public List<Company> findAll() {
        return queryGenericDAO(Company.class);
    }

    @Override
    public int insert(Company t) {
        String sql = "INSERT INTO [dbo].[Company]\n"
                + "           ([name]\n"
                + "           ,[description]\n"
                + "           ,[location]\n"
                + "           ,[accountId]\n"
                + "           ,[BusinessCode]\n"
                + "           ,[BusinessLicenseImage])\n"
                + "           ,[province])\n"
                + "           ,[provinceId])\n"
                + "           ,[ward])\n"
                + "           ,[wardId])\n"
                + "     VALUES(?,?,?,?,?,?,?,?,?,?)";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", t.getName());
        parameterMap.put("description", t.getDescription());
        parameterMap.put("location", t.getLocation());
        parameterMap.put("acountId", String.valueOf(t.getAccountId()));
        parameterMap.put("BusinessCode", t.getBusinessCode());
        parameterMap.put("BusinessLicenseImage", t.getBusinessLicenseImage());
        parameterMap.put("province", t.getProvince());
        parameterMap.put("provinceId", t.getProvinceId());
        parameterMap.put("ward", t.getWard());
        parameterMap.put("wardId", t.getWardId());
        return insertGenericDAO(sql, parameterMap);
    }

    public List<Company> filterCompanyByStatus(boolean status, int page) {
        String sql = "SELECT *\n"
                + "  FROM [JobSeeker].[dbo].[Company]\n"
                + "  where verificationStatus = ?\n"
                + "  order by id\n"
                + "  offset ? rows\n"
                + "  fetch next ? rows only";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", status);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        List<Company> list = queryGenericDAO(Company.class, sql, parameterMap);
        return list;
    }

    public Company findCompanyById(int id) {
        String sql = "SELECT * FROM [dbo].[Company] where id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("id", id);
        List<Company> list = queryGenericDAO(Company.class, sql, parameterMap);
        return list.isEmpty() ? null : list.get(0);
    }

    public void violateCompany(Company company) {
        String sql = "UPDATE [dbo].[Company]\n"
                + "   SET \n"
                + "      [verificationStatus] = ?\n"
                + "      \n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", 0);
        parameterMap.put("id", company.getId());
        updateGenericDAO(sql, parameterMap);
    }

    public void acceptCompany(Company company) {
        String sql = "UPDATE [dbo].[Company]\n"
                + "   SET \n"
                + "      [verificationStatus] = ?\n"
                + "      \n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", 1);
        parameterMap.put("id", company.getId());
        updateGenericDAO(sql, parameterMap);
    }

    public List<Company> searchCompaniesByName(String searchQuery, int page) {
        String sql = "SELECT *\n"
                + "FROM [dbo].[Company]\n"
                + "WHERE name LIKE ?\n"
                + "order by id\n"
                + "offset ? rows\n"
                + "fetch next ? rows only";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Company.class, sql, parameterMap);
    }

    public void updateCompany(Company companyEdit) {
        String sql = "UPDATE [dbo].[Company]\n"
                + "   SET [name] = ?\n"
                + "      ,[description] = ?\n"
                + "      ,[location] = ?\n"
                + "      ,[province] = ?\n"
                + "      ,[provinceId] = ?\n"
                + "      ,[ward] = ?\n"
                + "      ,[wardId] = ?\n"
                + " WHERE id = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", companyEdit.getName());
        parameterMap.put("description", companyEdit.getDescription());
        parameterMap.put("location", companyEdit.getLocation());
        parameterMap.put("province", companyEdit.getProvince());
        parameterMap.put("provinceId", companyEdit.getProvinceId());
        parameterMap.put("ward", companyEdit.getWard());
        parameterMap.put("wardId", companyEdit.getWardId());
        parameterMap.put("id", companyEdit.getId());
        updateGenericDAO(sql, parameterMap);
    }

    public int findAllTotalRecord() {
        String sql = "SELECT count(*) FROM [dbo].[Company]\n";
        parameterMap = new LinkedHashMap<>();
        return findTotalRecordGenericDAO(Company.class, sql, parameterMap);
    }

    public int findTotalRecordByStatus(boolean verificationStatus) {
        String sql = "SELECT count(*)\n"
                + "  FROM [dbo].[Company]\n"
                + "  where verificationStatus = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", verificationStatus);
        return findTotalRecordGenericDAO(Company.class, sql, parameterMap);
    }

    public List<Company> findAllCompany(int page) {
        String sql = "SELECT *\n"
                + "  FROM [JobSeeker].[dbo].[Company]\n"
                + "  order by id\n"
                + "  offset ? rows\n"
                + "  fetch next ? rows only";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Company.class, sql, parameterMap);
    }

    public int findTotalRecordByName(String searchQuery) {
        String sql = "SELECT count(*)\n"
                + "FROM [dbo].[Company]\n"
                + "WHERE name LIKE ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        return findTotalRecordGenericDAO(Company.class, sql, parameterMap);
    }
    // Tìm công ty theo từ khóa và trạng thái (chấp nhận hoặc vi phạm)

    public List<Company> searchCompaniesByNameAndStatus(String searchQuery, boolean status, int page) {
        String sql = "SELECT *\n"
                + "FROM [dbo].[Company]\n"
                + "WHERE name LIKE ? AND verificationStatus = ?\n"
                + "ORDER BY id\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("verificationStatus", status);
        parameterMap.put("offset", (page - 1) * RECORD_PER_PAGE);
        parameterMap.put("fetch", RECORD_PER_PAGE);
        return queryGenericDAO(Company.class, sql, parameterMap);
    }

// Đếm tổng số bản ghi theo từ khóa và trạng thái
    public int findTotalRecordByNameAndStatus(String searchQuery, boolean status) {
        String sql = "SELECT count(*)\n"
                + "FROM [dbo].[Company]\n"
                + "WHERE name LIKE ? AND verificationStatus = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", "%" + searchQuery + "%");
        parameterMap.put("verificationStatus", status);
        return findTotalRecordGenericDAO(Company.class, sql, parameterMap);
    }

    public List<Company> getCompanyNameByAccountId(int id) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Company]\n"
                + "  where accountId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("accountId", id);
        return queryGenericDAO(Company.class, sql, parameterMap);
    }

    public static void main(String[] args) {
        CompanyDAO dao = new CompanyDAO();
        List<Company> companies = dao.getCompanyNameByAccountId(2);
        System.out.println(companies.size());
    }

    public boolean checkExistNameCompany(String name) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Company]\n"
                + "  where name = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("name", name);
        return !queryGenericDAO(Company.class, sql, parameterMap).isEmpty();
    }

    public boolean checkExistOther(String name, int id) {
        List<Company> list = findAll();
        for (Company company : list) {
            //lay ra id cua thang company do
            if ((id != company.getId()) && name.equalsIgnoreCase(company.getName())) {
                return true;
            }
        }
        return false;
    }

    public List<Company> getTop3RecentCompanysByOpen() {
        String sql = "select top 3 * from Company where verificationStatus = ? order by id desc";

        parameterMap = new LinkedHashMap<>();
        parameterMap.put("verificationStatus", 1);

        return queryGenericDAO(Company.class, sql, parameterMap);
    }

    public boolean isCompanyExist(int companyId) {
        // Gọi phương thức findCompanyById để kiểm tra xem công ty có tồn tại không
        Company company = findCompanyById(companyId);

        // Nếu company khác null thì công ty tồn tại, ngược lại thì không
        return company != null;
    }

    public boolean checkCompanyByAccountId(Company company) {
        String sql = "SELECT * FROM [dbo].[Company] where accountId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("id", company.getAccountId());
        List<Company> list = queryGenericDAO(Company.class, sql, parameterMap);
        return list.size() == 0 ? true : false;
    }

    public boolean checkExistBusinessCode(int id, String businessCode) {
        List<Company> list = findAll();
        for (Company company : list) {
            //lay ra id cua thang company do
            if (id != company.getAccountId() && businessCode.equals(company.getBusinessCode())) {
                return true;
            }
        }
        return false;
    }

    public Company findCompanyByAccountId(int id) {
        String sql = "SELECT * FROM [dbo].[Company] where accountId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("id", id);
        List<Company> list = queryGenericDAO(Company.class, sql, parameterMap);
        Company com = list.size() == 0 ? null : list.get(0);
        return com;
    }

    public int getCompanyIdByBusinessCode(String businessCode) {
        String sql = "SELECT id FROM Company WHERE BusinessCode = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("BusinessCode", businessCode);
        return findTotalRecordGenericDAO(Company.class, sql, parameterMap);
    }

    public boolean doesBusinessCodeExist(String businessCode, int accountId) {
        String sql = "SELECT * FROM [dbo].[Company] WHERE BusinessCode = ? AND accountId = ?";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("BusinessCode", businessCode);
        parameterMap.put("accountId", accountId);

        // Return true if the result is not empty, indicating the business code exists for the account
        return !queryGenericDAO(Company.class, sql, parameterMap).isEmpty();
    }

    public boolean isCompanyActive(String businessCode) {
        String sql = "SELECT * FROM [dbo].[Company] WHERE BusinessCode = ? AND verificationStatus = 1";
        parameterMap = new LinkedHashMap<>();
        parameterMap.put("BusinessCode", businessCode);

        // Return true if the result is not empty, meaning the company is active
        return !queryGenericDAO(Company.class, sql, parameterMap).isEmpty();
    }

}