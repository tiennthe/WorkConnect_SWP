package controller.seeker;

import constant.CommonConst;
import dao.JobSeekerDAO;
import dao.WorkExperienceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.JobSeekers;
import model.WorkExperience;

@WebServlet(name = "ExperienceServlet", urlPatterns = {"/experience"})
public class ExperienceServlet extends HttpServlet {

    private final WorkExperienceDAO weDAO = new WorkExperienceDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url = "view/user/Experience.jsp"; // Default page to display experience
        String error = request.getParameter("error") != null ? request.getParameter("error") : "";
        request.setAttribute("error", error);

        switch (action) {
            case "update-experience":
                // Forward to the experience update page
                url = "view/user/Experience.jsp";
                break;

            default: {
                HttpSession session = request.getSession();
                Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

                if (account == null) {
                    response.sendRedirect("view/authen/login.jsp"); // Redirect to login if not logged in
                    return;
                }

                JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

                if (jobSeeker != null) {
                    try {
                        // Attempt to view education details
                        url = viewExperience(request, response);
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.getWriter().println("Database error.");
                    }
                } else {
                    // Set error message if job seeker information is missing
                    error = "You are not currently a member of Job Seeker. Please join to use this function.";
                    request.setAttribute("errorJobSeeker", error);
                    url = "view/user/Experience.jsp"; // Forward to education page to show the error message
                }
                break;
            }
        }

        // Forward to the designated page with any relevant error or data attributes set
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "add-experience":
                url = addExperience(request);
                break;
            case "update-experience":
                url = updateExperience(request);
                break;
            case "delete-experience": // New case for delete action
                url = deleteExperience(request);
                break;
            default:
                url = "experience"; // Redirect to the experience list page by default
        }

        response.sendRedirect(url);
    }

    // Add new work experience
    public String addExperience(HttpServletRequest request) throws IOException, ServletException {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker != null) {
            try {
                String companyName = request.getParameter("companyName");
                String jobTitle = request.getParameter("jobTitle");
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                String description = request.getParameter("description");

                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);

                // Check if endDate is earlier than startDate
                if (endDate.before(startDate)) {
                    // Set error message for invalid date range
                    try {
                        url = "experience?error=" + URLEncoder.encode("End date cannot be earlier than start date.", "UTF-8");
                        session.setAttribute("companyName", companyName);
                        session.setAttribute("jobTitle", jobTitle);
                        session.setAttribute("startDateStr", startDateStr);
                        session.setAttribute("endDateStr", endDateStr);
                        session.setAttribute("description", description);
                    } catch (UnsupportedEncodingException ex) {
                        Logger.getLogger(ExperienceServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {

                    WorkExperience weAdd = new WorkExperience();
                    weAdd.setJobSeekerID(jobSeeker.getJobSeekerID());
                    weAdd.setCompanyName(companyName);
                    weAdd.setJobTitle(jobTitle);
                    weAdd.setStartDate(startDate);
                    weAdd.setEndDate(endDate);
                    weAdd.setDescription(description);

                    session.removeAttribute("companyName");
                    session.removeAttribute("jobTitle");
                    session.removeAttribute("startDateStr");
                    session.removeAttribute("endDateStr");
                    session.removeAttribute("description");

                    weDAO.insert(weAdd); // Insert work experience

                    // Reload updated list after insertion
                    List<WorkExperience> wes = weDAO.findWorkExperiencesbyJobSeekerID(jobSeeker.getJobSeekerID());
                    request.setAttribute("successExperience", "Experience added successfully.");
                    request.setAttribute("wes", wes);
                    request.setAttribute("jobSeeker", jobSeeker);
                    url = "experience";
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorExperience", "An error occurred while adding the experience.");
            }
        } else {
            try {
                url = "experience?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(ExperienceServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return url;// Redirect to experience page
    }

    // Update work experience
    public String updateExperience(HttpServletRequest request) throws IOException, ServletException {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker != null) {
            try {
                String experienceIDStr = request.getParameter("experienceID");
                String companyName = request.getParameter("companyName");
                String jobTitle = request.getParameter("jobTitle");
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                String description = request.getParameter("description");

                int experienceID = Integer.parseInt(experienceIDStr);
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);
                // Check if endDate is earlier than startDate
                if (endDate.before(startDate)) {
                    // Set error message for invalid date range
                    try {
                        url = "experience?error=" + URLEncoder.encode("End date cannot be earlier than start date.", "UTF-8");
                    } catch (UnsupportedEncodingException ex) {
                        Logger.getLogger(ExperienceServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {

                    WorkExperience weUpdate = new WorkExperience();
                    weUpdate.setExperienceID(experienceID);
                    weUpdate.setCompanyName(companyName);
                    weUpdate.setJobTitle(jobTitle);
                    weUpdate.setStartDate(startDate);
                    weUpdate.setEndDate(endDate);
                    weUpdate.setDescription(description);

                    weDAO.updateExperience(weUpdate); // Update experience

                    // Reload updated list after update
                    List<WorkExperience> wes = weDAO.findWorkExperiencesbyJobSeekerID(jobSeeker.getJobSeekerID());
                    request.setAttribute("successExperience", "Experience updated successfully.");
                    request.setAttribute("wes", wes);
                    request.setAttribute("jobSeeker", jobSeeker);
                    url = "experience";
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorExperience", "An error occurred while updating the experience.");
            }
        } else {
            request.setAttribute("error", "No Job Seeker found for the current account.");
        }

        return url;
    }

    // View work experience
    private String viewExperience(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            url = "view/authen/login.jsp"; // Redirect if user is not logged in
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");

        if (jobSeeker == null) {
            try {
                url = "experience?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(ExperienceServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        List<WorkExperience> weList = weDAO.findWorkExperiencesbyJobSeekerID(jobSeeker.getJobSeekerID());

        if (weList == null || weList.isEmpty()) {
            request.setAttribute("errorExperience", "No experience found for this Job Seeker.");
            url = "view/user/Experience.jsp";
        }

        request.setAttribute("wes", weList);

        url = "view/user/Experience.jsp";
        return url;
    }

    // Delete work experience
    public String deleteExperience(HttpServletRequest request) throws IOException, ServletException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker != null) {
            try {
                String experienceIDStr = request.getParameter("experienceID");
                int experienceID = Integer.parseInt(experienceIDStr);

                weDAO.deleteExperience(experienceID); // Delete work experience
                request.setAttribute("successExperience", "Experience deleted successfully.");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorExperience", "An error occurred while deleting the experience.");
            }
        } else {
            request.setAttribute("error", "No Job Seeker found for the current account.");
        }

        return "experience"; // Redirect to experience page
    }
}
