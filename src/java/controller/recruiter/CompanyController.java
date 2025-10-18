/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import constant.CommonConst;
import dao.CompanyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import model.Account;
import model.Company;
import validate.Validation;

@MultipartConfig
@WebServlet(name = "CompanyController", urlPatterns = {"/company"})
public class CompanyController extends HttpServlet {

    Validation validate = new Validation();
    CompanyDAO companyDao = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve cac notice va error

        //get ve action tu side bar
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "create":
                url = "view/recruiter/createCompany.jsp";
                break;
            case "edit":
                url = editCompany(request);
                break;
            default:
                url = "view/recruiter/createCompany.jsp";
        }

        //chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "create":
                url = createCompany(request, response);
                break;
            case "edit":
                url = editCompanyDoPost(request, response);
                break;
            default:
                throw new AssertionError();
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private String createCompany(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        String url = "";

//        get ve cac thuoc tinh cua company
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String businessCode = request.getParameter("businessCode");
        String businessLicense = getBusinessLicenseImg("businessLicense", request);
//        tao doi tuong company va set cac thuoc tinh
        Company company = new Company();
        company.setName(name);
        company.setDescription(description);
        company.setLocation(location);
        company.setBusinessCode(businessCode);
        company.setBusinessLicenseImage(businessLicense);
        company.setAccountId(account.getId());
        //set data để hiển thị sang bên jsp
        request.setAttribute("company", company);
        //kiem tra xem company nay da nguoi tao chua
        boolean check = companyDao.checkCompanyByAccountId(company);
        if (check) {
            //chua tao
            //check valid business code
            if (!validate.checkCode(businessCode)) {
                String error = "Business code is not valid!!";
                request.setAttribute("errorCode", error);
                url = "view/recruiter/createCompany.jsp";
                return url;
            } else if (companyDao.checkExistBusinessCode(company.getAccountId(), businessCode)) {
                request.setAttribute("duplicateCode", "Business code is existed !!");
                url = "view/recruiter/createCompany.jsp";
                return url;
            }
            String notice = "Create successfully!!";
            request.setAttribute("notice", notice);
            companyDao.insert(company);
            url = "view/recruiter/createCompany.jsp";

        } else {
            //da tao roi
            String error = "You have registered your company information, please edit here";
            url = "view/recruiter/createCompany.jsp";
            request.setAttribute("error", error);
        }

        return url;
    }

    private String getBusinessLicenseImg(String businessLicense, HttpServletRequest request) {
        String imagePath = null;
        try {
            // get ve businessLicense
            Part part = request.getPart(businessLicense);
//SWT: MAJOR (CODE_SMELL)            
            if (part == null || part.getSubmittedFileName() == null || part.getSubmittedFileName().trim().isEmpty()) {
                imagePath = null;
            } else {
//        duong dan lưu ảnh
                String path = request.getServletContext().getRealPath("images");
                File dir = new File(path);
//        xem duong dan nay ton tai chua
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                File image = new File(dir, part.getSubmittedFileName());
//        ghi file vao trong duong dan
                part.write(image.getAbsolutePath());
//        lay ra contextPath cua project
                imagePath = request.getContextPath() + "/" + "/images/" + image.getName();
            }
        } catch (Exception e) {
            e.printStackTrace();
            imagePath = null;
        }
        return imagePath;
    }

    private String editCompany(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        Company company = companyDao.findCompanyByAccountId(account.getId());
        if (company == null) {
            request.setAttribute("error", "You must fill the company information firts!!");
        } else {
            request.setAttribute("company", company);
        }
        return "view/recruiter/editCompany.jsp";
    }

    private String editCompanyDoPost(HttpServletRequest request, HttpServletResponse response) {
        //get ve cac thong tin nhap
        int id = Integer.parseInt(request.getParameter("companyId"));
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        //tao doi tuong va set 
        Company company = companyDao.findCompanyById(id);
        company.setName(name);
        company.setLocation(location);
        company.setDescription(description);
        //cap nhap thong tin
        companyDao.updateCompany(company);
        //set vao request de gui sang trang jsp
        request.setAttribute("company", company);
        request.setAttribute("success", "Edit successfully!!");
        //tra ve duong dan
        return "view/recruiter/editCompany.jsp";
    }

}
