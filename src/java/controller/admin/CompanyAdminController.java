/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import dao.CompanyDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Company;
import model.PageControl;
import utils.Email;

@MultipartConfig
@WebServlet(name = "CompanyAdminController", urlPatterns = {"/companies"})
public class CompanyAdminController extends HttpServlet {

    CompanyDAO dao = new CompanyDAO();
    AccountDAO accDao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve error đã xử lí ở doPost
        String notice = request.getParameter("notice") != null ? request.getParameter("notice") : "";
        request.setAttribute("notice", notice);
        // get ve pageNumber
        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
//        get ve gia tri cua drop-down filter
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        //        get ve gia tri tu thanh search
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";
        List<Company> listCompanies;
        //get ve url
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "all":
                    // Tìm tất cả các công ty theo từ khóa
                    listCompanies = dao.searchCompaniesByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
                    break;
                case "accept":
                    // Tìm các công ty đã được chấp nhận theo từ khóa
                    listCompanies = dao.searchCompaniesByNameAndStatus(searchQuery, true, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, true);
                    pageControl.setUrlPattern(requestURL + "?filter=accept&searchQuery=" + searchQuery + "&");
                    break;
                case "violate":
                    // Tìm các công ty vi phạm theo từ khóa
                    listCompanies = dao.searchCompaniesByNameAndStatus(searchQuery, false, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, false);
                    pageControl.setUrlPattern(requestURL + "?filter=violate&searchQuery=" + searchQuery + "&");
                    break;
                default:
                    // Mặc định sẽ tìm tất cả các công ty theo từ khóa
                    listCompanies = dao.searchCompaniesByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else {
            //get ve request URL
            //total record

            switch (filter) {
                case "all":
                    listCompanies = dao.findAllCompany(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "accept":
                    listCompanies = dao.filterCompanyByStatus(true, page);
                    totalRecord = dao.findTotalRecordByStatus(true);
                    pageControl.setUrlPattern(requestURL + "?filter=accept" + "&");
                    break;
                case "violate":
                    listCompanies = dao.filterCompanyByStatus(false, page);
                    totalRecord = dao.findTotalRecordByStatus(false);
                    pageControl.setUrlPattern(requestURL + "?filter=violate" + "&");
                    break;
                default:
                    listCompanies = dao.findAllCompany(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }

        request.setAttribute("listCompanies", listCompanies);
        // Handle GET requests based on the action
        //total page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0 ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE) + 1;
        //set total record, total page, page to pageControl
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        //set attribute pageControl 
        request.setAttribute("pageControl", pageControl);
        // SWT: CRITICAL(CODE_SMELL)
        switch (action) {

            case "view":
                url = viewDetailCompany(request);
                break;
            default:
                url = "view/admin/companyManagement.jsp";
        }

        // Forward to the appropriate page
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        response.setContentType("application/json");
        switch (action) {
            case "violate":
                url = violateCompany(request);
                break;
            case "accept":
                url = accepetCompany(request);
                break;
            default:
                url = "companies";
        }
        response.sendRedirect(url);
    }

    private String violateCompany(HttpServletRequest request) throws UnsupportedEncodingException {
        try {
            int id = Integer.parseInt(request.getParameter("id-company"));
            Company company = dao.findCompanyById(id);
            Account account = accDao.findUserById(company.getAccountId());
            //send mail process
            String subjectMail = "Notification: Suspension of " + company.getName() + " on the Platform";
            String contentMail = "Dear " + account.getFullName() + ",\n"
                    + "\n"
                    + "We would like to inform you that the company " + company.getName() + ", which you represent for recruitment on our platform, has been suspended due to recieved a lot of report.\n"
                    + "\n"
                    + "Effective immediately, all job listings for this company will no longer be publicly visible, and candidates will not be able to apply for its positions. This suspension will remain in place until the issue is resolved.\n"
                    + "\n"
                    + "If you have any questions or need assistance, please feel free to contact our support team at [support email] or [support phone number].\n"
                    + "\n"
                    + "Best regards";
            Email.sendEmail(account.getEmail(), subjectMail, contentMail);
            dao.violateCompany(company);

            return "companies?notice=" + URLEncoder.encode("Deactive and send Email successfully!", "UTF-8");
        } catch (MessagingException ex) {
            return "companies?notice=" + URLEncoder.encode("Deactive and send Email process have error!!", "UTF-8");
        }
    }

    private String accepetCompany(HttpServletRequest request) throws UnsupportedEncodingException {
        try {
            int id = Integer.parseInt(request.getParameter("id-company"));
            Company company = dao.findCompanyById(id);
            Account account = accDao.findUserById(company.getAccountId());
            //send mail process
            String subjectMail = "Notification: Your Company Has Been Reactivated on Our Platform";
            String contentMail = "Dear " + account.getFullName() + ",\n"
                    + "\n"
                    + "We are pleased to inform you that your company, " + company.getName() + ", has been reactivated on our platform. You can now continue posting job opportunities and managing your recruitment activities.\n"
                    + "\n"
                    + "Thank you for your cooperation, and please reach out if you have any questions or need assistance.\n"
                    + "\n"
                    + "Best regards";
            Email.sendEmail(account.getEmail(), subjectMail, contentMail);
            dao.acceptCompany(company);
            return "companies?notice=" + URLEncoder.encode("Active and send Email successfully!", "UTF-8");
        } catch (MessagingException ex) {
            return "companies?notice=" + URLEncoder.encode("Active and send Email process have error!!", "UTF-8");
        }
    }

    private String viewDetailCompany(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Company companyDetail = dao.findCompanyById(id);
        request.setAttribute("CompanyDetail", companyDetail);
        return "view/admin/viewDetailCompany.jsp";
    }

    private String getBusinessLicenseImg(String businessLicense, HttpServletRequest request) {
        String imagePath = null;
        try {
            // get ve businessLicense
            Part part = request.getPart(businessLicense);
//SWT: MAJOR (CODE_SMELL)            
            if (part.getSubmittedFileName() == null || part.getSubmittedFileName().trim().isEmpty() || part == null) {
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
}