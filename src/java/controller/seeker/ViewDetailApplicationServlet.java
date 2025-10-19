package controller.seeker;

import constant.CommonConst;
import dao.ApplicationDAO;
import dao.CVDAO;
import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Applications;
import model.CV;
import model.JobPostings;
import model.Job_Posting_Category;

@WebServlet(name = "ViewDetailApplicationServlet", urlPatterns = {"/ViewDetailApplication"})
public class ViewDetailApplicationServlet extends HttpServlet {

    private Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();
    private JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    private ApplicationDAO applicationDAO = new ApplicationDAO();
    private CVDAO cvDAO = new CVDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "details":
                url = viewDetailApplication(request, response);
                break;
            default:
                url = "view/user/ApplicationDetail.jsp";
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private String viewDetailApplication(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp"; // Redirect to login page if user is not logged in
        }

        try {
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            Applications application = applicationDAO.getDetailApplication(applicationId);
            if (application == null) {
                request.setAttribute("errorApplication", "Application not found.");
                return "view/user/errorPage.jsp";
            }

            JobPostings jobPost = jobPostingsDAO.findJobPostingById(application.getJobPostingID());
            if (jobPost == null) {
                request.setAttribute("errorApplication", "Job posting not found.");
                return "view/user/errorPage.jsp";
            }

            Job_Posting_Category category = categoryDAO.findJob_Posting_CategoryNameByJobPostingID(application.getJobPostingID());
            
            if(category != null && category.isStatus()) {
                request.setAttribute("category", category);
            } else {
                request.setAttribute("category", "This category was deleted!");
            }
            
            CV cv = cvDAO.findCVbyCVID(application.getCVID());
            if (cv == null) {
                request.setAttribute("errorApplication", "CV not found.");
                return "view/user/errorPage.jsp";
            }
            
            request.setAttribute("account", account);
            request.setAttribute("application", application);
            request.setAttribute("jobPost", jobPost);
            
            request.setAttribute("cv", cv);

            return "view/user/ApplicationDetail.jsp";

        } catch (NumberFormatException e) {
            request.setAttribute("errorApplication", "Invalid ID format.");
            return "view/user/errorPage.jsp";
        } catch (Exception e) {
            request.setAttribute("errorApplication", "An unexpected error occurred.");
            return "view/user/errorPage.jsp";
        }
    }
}