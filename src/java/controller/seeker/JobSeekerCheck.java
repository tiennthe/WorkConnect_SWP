package controller.seeker;

import constant.CommonConst;
import dao.JobSeekerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.JobSeekers;
import java.util.logging.Logger;
import java.util.logging.Level;
import model.Account;

@WebServlet(name = "JobSeekerCheck", urlPatterns = {"/JobSeekerCheck"})
public class JobSeekerCheck extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(JobSeekerCheck.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the session and retrieve the accountID from it
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        
        if (account == null) {
            // Log the issue and redirect to login page or error page
            LOGGER.log(Level.WARNING, "No accountID found in session");
            response.sendRedirect("view/authen/login.jsp");  // Or redirect to an appropriate page
            return;
        }
        
        try {
            // Fetch the job seeker using the JobSeekerDAO
            JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
            JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");
            
            if (jobSeeker != null) {
                // If job seeker exists, pass it to the JSP
                request.setAttribute("jobSeeker", jobSeeker);
            } else {
                // If no job seeker found, log and show a message
                LOGGER.log(Level.INFO, "No JobSeeker found for accountID: {0}", account.getId());
                request.setAttribute("errorJobSeeker", "No JobSeeker profile found for this account.");
            }
            
            // Forward to the profile JSP page
            request.getRequestDispatcher("view/user/userProfile.jsp").forward(request, response);
        } catch (Exception e) {
            // Log any exception that occurs
            LOGGER.log(Level.SEVERE, "Error while fetching job seeker information", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }
}