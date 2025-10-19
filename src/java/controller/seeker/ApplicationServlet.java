package controller.seeker;

import constant.CommonConst;
import dao.ApplicationDAO;
import dao.CVDAO;
import dao.JobPostingsDAO;
import dao.JobSeekerDAO;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Applications;
import model.JobPostings;
import model.JobSeekers;

@WebServlet(name = "ApplicationServlet", urlPatterns = {"/application"})
public class ApplicationServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    private final JobPostingsDAO jobPostingDAO = new JobPostingsDAO();
    private final CVDAO cvDAO = new CVDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = parsePage(request);
        String filter = request.getParameter("status");
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("view/authen/login.jsp");
            return;
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if ("cancel-application".equals(action)) {
            response.sendRedirect(cancelledApplication(request, response));
            return;
        }

        if (jobSeeker != null) {
            try {
                viewListApplication(request, response, filter);
            } catch (Exception e) {
                Logger.getLogger(ApplicationServlet.class.getName()).log(Level.SEVERE, "Error accessing the database.", e);
                request.setAttribute("error", "Database error occurred.");
            }
        } else {
            request.setAttribute("errorJobSeeker", "You are not currently a member of Job Seeker. Please join to use this function.");
        }

        request.getRequestDispatcher("view/user/Application.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("cancel-application".equals(action)) {
            response.sendRedirect(cancelledApplication(request, response));
        } else {
            response.sendRedirect("home");
        }
    }

    private void viewListApplication(HttpServletRequest request, HttpServletResponse response, String statusFilter)
            throws IOException, UnsupportedEncodingException {
        int page = parsePage(request);
        int pageSize = 10;

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker == null) {
            String errorMsg = "You are not currently a member of Job Seeker. Please join to use this function.";
            response.sendRedirect("application?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            return;
        }

        List<Applications> applicationList;
        int totalRecords;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            applicationList = applicationDAO.findApplicationByJobSeekerIDAndStatus(
                    jobSeeker.getJobSeekerID(), Integer.parseInt(statusFilter), page, pageSize);
            totalRecords = applicationDAO.countTotalApplicationsByJSIDAndStatus(
                    jobSeeker.getJobSeekerID(), Integer.parseInt(statusFilter));
        } else {
            applicationList = applicationDAO.findApplicationByJobSeekerID(jobSeeker.getJobSeekerID(), page, pageSize);
            totalRecords = applicationDAO.countTotalApplicationsByJSID(jobSeeker.getJobSeekerID());
        }

        Map<Integer, String> jobPostingMap = new HashMap<>();
        Map<Integer, String> applicationStatusMap = new HashMap<>();
        
        for (Applications app : applicationList) {
            JobPostings jobPosting = jobPostingDAO.findJobPostingById(app.getJobPostingID());
            jobPostingMap.put(app.getApplicationID(), jobPosting.getTitle());
            
            if ("Violate".equals(jobPosting.getStatus())) {
                // Set a custom status message for applications with violated job postings
                applicationStatusMap.put(app.getApplicationID(), "Violate");
            } else {
                applicationStatusMap.put(app.getApplicationID(), app.getStatus()+""); // Set the normal status if no violation
            }

        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        request.setAttribute("applications", applicationList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("jobPostingMap", jobPostingMap);
        request.setAttribute("applicationStatusMap", applicationStatusMap);
        request.setAttribute("selectedStatus", statusFilter);
    }

    private String cancelledApplication(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (jobSeeker == null) {
            try {
                return "application?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(ApplicationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            int status = Integer.parseInt(request.getParameter("status"));

            applicationDAO.cancelApplication(applicationId, status);
            request.setAttribute("successApplication", "Job application canceled successfully.");
        } catch (NumberFormatException e) {
            Logger.getLogger(ApplicationServlet.class.getName()).log(Level.WARNING, "Invalid application ID or status", e);
            request.setAttribute("error", "Invalid application ID or status.");
        }

        return "application";
    }

    private int parsePage(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            return 1; // default to page 1 if parsing fails
        }
    }
}