/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import constant.CommonConst;
import dao.ApplicationDAO;
import dao.CompanyDAO;
import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import dao.RecruitersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Company;
import model.JobPostings;
import model.Job_Posting_Category;
import model.Recruiters;

@WebServlet(name = "Dashboard", urlPatterns = {"/Dashboard"})
public class Dashboard extends HttpServlet {

    JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    RecruitersDAO RecruitersDAO = new RecruitersDAO();
    Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();
    CompanyDAO cdao = new CompanyDAO();
    ApplicationDAO applicationDao = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            // If user is not logged in, redirect to login
            response.sendRedirect("view/authen/login.jsp");
            return;
        }

        List<Job_Posting_Category> category = categoryDAO.findAll();
        //List<Job_Posting_Category> category = categoryDAO.findAll();
        request.setAttribute("jobCategories", category);
        // Fetch the recruiter info using the account ID
        Recruiters recruiters = RecruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));

        if (recruiters == null) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
            dispatcher.forward(request, response);
        } else {
            Company company = cdao.findCompanyById(recruiters.getCompanyID());
            if (company == null || !company.isVerificationStatus() || !recruiters.isIsVerify()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
                dispatcher.forward(request, response);
            } else {
                List<JobPostings> listSize = jobPostingsDAO.findJobPostingbyRecruitersIDandOneMonth(recruiters.getRecruiterID());
                List<JobPostings> listTop5 = jobPostingsDAO.getTop5RecentJobPostingsByRecruiterID(recruiters.getRecruiterID());
                //tong so bai dang cho duyet pendding
                int totalPendingForRecruiter = applicationDao.countPendingApplicationsForRecruiter(recruiters.getRecruiterID());
                int totalAgreeForRecruiter = applicationDao.countAgreeApplicationsForRecruiter(recruiters.getRecruiterID());
                int totalViolateJPForRecruiter = jobPostingsDAO.countViolateJobPostingsForRecruiter(recruiters.getRecruiterID());
                int q1 = jobPostingsDAO.findTotalJobPostingCountByQuarter(recruiters.getRecruiterID(), 1);
                int q2 = jobPostingsDAO.findTotalJobPostingCountByQuarter(recruiters.getRecruiterID(), 2);
                int q3 = jobPostingsDAO.findTotalJobPostingCountByQuarter(recruiters.getRecruiterID(), 3);
                int q4 = jobPostingsDAO.findTotalJobPostingCountByQuarter(recruiters.getRecruiterID(), 4);
                request.setAttribute("q1", q1);
                request.setAttribute("q2", q2);
                request.setAttribute("q3", q3);
                request.setAttribute("q4", q4);
                
                request.setAttribute("totalViolateJPForRecruiter", totalViolateJPForRecruiter);
                request.setAttribute("totalAgreeForRecruiter", totalAgreeForRecruiter);
                request.setAttribute("totalPendingApplications", totalPendingForRecruiter);

                // Gửi dữ liệu đến JSP
                request.setAttribute("listSize", listSize);
                request.setAttribute("listTop5", listTop5);

                // Chuyển hướng đến trang dashboard.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/dashboard.jsp");
                dispatcher.forward(request, response);
            }
        }
    }
}