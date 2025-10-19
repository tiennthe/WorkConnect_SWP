package controller.seeker;

import constant.CommonConst;
import dao.*;
import model.*;
import validate.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ViewDetailJobPostingServlet", urlPatterns = {"/jobPostingDetail"})
public class ViewDetailJobPostingServlet extends HttpServlet {

    // Initialize DAO objects
    private final Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();
    private final JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final FavourJobPostingDAO favourJPDAO = new FavourJobPostingDAO();
    private final CVDAO cvDAO = new CVDAO();
    private final Validation valid = new Validation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action") != null ? request.getParameter("action") : "";
            String url = "view/user/ViewJobPosting.jsp";

            switch (action) {
                case "details":
                    url = viewJobPostingDetails(request);
                    break;

                case "add-application":
                    url = handleAddApplication(request);
                    break;

                case "add-favourJP":
                    url = handleAddFavouriteJobPosting(request);
                    break;

                default:
                    url = handleDefaultAction(request);
                    break;
            }

            request.getRequestDispatcher(url).forward(request, response);

        } catch (Exception e) {
            Logger.getLogger(ViewDetailJobPostingServlet.class.getName()).log(Level.SEVERE, null, e);
            String error = URLEncoder.encode("An unexpected error occurred. Please try again later.", "UTF-8");
            response.sendRedirect("home?error=" + error);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action") != null ? request.getParameter("action") : "";
            String url;

            switch (action) {
                case "add-application":
                    url = processAddApplication(request);
                    break;

                case "add-favourJP":
                    url = processAddFavouriteJobPosting(request);
                    break;

                default:
                    url = "home";
            }

            response.sendRedirect(url);

        } catch (Exception e) {
            Logger.getLogger(ViewDetailJobPostingServlet.class.getName()).log(Level.SEVERE, null, e);
            String error = URLEncoder.encode("An unexpected error occurred. Please try again later.", "UTF-8");
            response.sendRedirect("home?error=" + error);
        }
    }

    private String viewJobPostingDetails(HttpServletRequest request) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        try {
            int jobPostingId = Integer.parseInt(request.getParameter("idJP"));

            // Get job posting details
            JobPostings jobPost = jobPostingsDAO.findJobPostingById(jobPostingId);
            if (jobPost == null) {
                return "home?error=" + URLEncoder.encode("Job posting not found.", "UTF-8");
            }
            boolean isOpenJP = jobPost.getStatus().equals("Open");
            if(isOpenJP) {
                request.setAttribute("isOpenJP", isOpenJP);
            }
            request.setAttribute("jobPost", jobPost);

            // Get category details
            Job_Posting_Category category = categoryDAO.findJob_Posting_CategoryNameByJobPostingID(jobPostingId);
            request.setAttribute("category", category.isStatus() ? category : "This category was deleted!");

            // Check if job seeker is a member
            JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
            if (jobSeeker == null) {
                // Set a message but still display job details
                request.setAttribute("errorJobSeeker",
                        "You are not currently a member of Job Seeker. Please join to use this function.");
            } else {
                // Continue retrieving related information if the job seeker exists
                Applications existingApplication = applicationDAO.findPendingApplication(
                        jobSeeker.getJobSeekerID(), jobPost.getJobPostingID());
                if (existingApplication != null) {
                    request.setAttribute("existingApplication", existingApplication);
                }

                FavourJobPosting existFavourJP = favourJPDAO.findExistFavourJP(
                        jobSeeker.getJobSeekerID(), jobPost.getJobPostingID());
                if (existFavourJP != null) {
                    request.setAttribute("existFavourJP", existFavourJP);
                }
            }

            // Set notice if exists
            String notice = request.getParameter("notice");
            if (notice != null) {
                request.setAttribute("notice", notice);
            }

            return "view/user/ViewJobPosting.jsp";

        } catch (NumberFormatException e) {
            Logger.getLogger(ViewDetailJobPostingServlet.class.getName()).log(Level.SEVERE, null, e);
            return "home?error=" + URLEncoder.encode("Invalid job posting ID.", "UTF-8");
        }
    }

    private String handleAddApplication(HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        try {
            int jobPostingId = Integer.parseInt(request.getParameter("jobPostingID"));

            JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");
            if (jobSeeker == null) {
                return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&error="
                        + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            }

            CV cv = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
            if (cv == null) {
                return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&error="
                        + URLEncoder.encode("CV is missing. You must upload a CV first.", "UTF-8");

            }

            request.setAttribute("cv", cv.getCVID());

            // Check for existing pending application
            Applications existingApp = applicationDAO.findPendingApplication(
                    jobSeeker.getJobSeekerID(), jobPostingId);
            if (existingApp != null) {
                return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&error="
                        + URLEncoder.encode("You already have a pending application for this position.", "UTF-8");
            }

            // Create new application
            Applications application = new Applications();
            application.setJobPostingID(jobPostingId);
            application.setJobSeekerID(jobSeeker.getJobSeekerID());
            application.setCVID(cv.getCVID());
            application.setStatus(3); // Pending status
            applicationDAO.insert(application);

            return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&success="
                    + URLEncoder.encode("Application submitted successfully.", "UTF-8");

        } catch (NumberFormatException e) {
            Logger.getLogger(ViewDetailJobPostingServlet.class.getName()).log(Level.SEVERE, null, e);
            return "jobPostingDetail?error=" + URLEncoder.encode("Invalid job posting information.", "UTF-8");
        }
    }

    private String handleAddFavouriteJobPosting(HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        try {
            int jobPostingId = Integer.parseInt(request.getParameter("jobPostingIDF"));
            JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");

            if (jobSeeker == null) {
                return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&error="
                        + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            }

            if (!favourJPDAO.getJobPostingsByJobSeeker(jobSeeker.getJobSeekerID(), jobPostingId)) {
                FavourJobPosting favourJP = new FavourJobPosting();
                favourJP.setJobSeekerID(jobSeeker.getJobSeekerID());
                favourJP.setJobPostingID(jobPostingId);
                favourJPDAO.insert(favourJP);
            }

            return "jobPostingDetail?action=details&idJP=" + jobPostingId + "&success="
                    + URLEncoder.encode("Job posting added to favorites.", "UTF-8");

        } catch (NumberFormatException e) {
            Logger.getLogger(ViewDetailJobPostingServlet.class.getName()).log(Level.SEVERE, null, e);
            return "jobPostingDetail?error=" + URLEncoder.encode("Invalid job posting information.", "UTF-8");
        }
    }

    private String handleDefaultAction(HttpServletRequest request) throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (jobSeeker != null) {
            CV cv = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
            if (cv != null) {
                request.setAttribute("cvFilePath", cv.getFilePath());
            }
        } else {
            request.setAttribute("errorJobSeeker",
                    "You are not currently a member of Job Seeker. Please join to use this function.");
        }

        return "view/user/ViewJobPosting.jsp";
    }

    // POST handling methods - similar to their GET counterparts but with appropriate response handling
    private String processAddApplication(HttpServletRequest request) throws IOException {
        return handleAddApplication(request);
    }

    private String processAddFavouriteJobPosting(HttpServletRequest request) throws IOException {
        return handleAddFavouriteJobPosting(request);
    }
}