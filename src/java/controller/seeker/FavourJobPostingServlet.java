/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.seeker;

import constant.CommonConst;
import dao.FavourJobPostingDAO;
import dao.JobPostingsDAO;
import dao.JobSeekerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.FavourJobPosting;
import model.JobPostings;
import model.JobSeekers;

@WebServlet(name = "FavourJobPostingServlet", urlPatterns = {"/FavourJobPosting"})
public class FavourJobPostingServlet extends HttpServlet {

    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    private final JobPostingsDAO jobPostingDAO = new JobPostingsDAO();
    private final FavourJobPostingDAO favourJPDAO = new FavourJobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = parsePage(request);
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("view/authen/login.jsp");
            return;
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if ("delete-favourJP".equals(action)) {
            response.sendRedirect(deleteFavourJP(request, response));
            return;
        }

        if (jobSeeker != null) {
            try {
                viewListFavourJP(request, response);
            } catch (Exception e) {
                Logger.getLogger(ApplicationServlet.class.getName()).log(Level.SEVERE, "Error accessing the database.", e);
                request.setAttribute("error", "Database error occurred.");
            }
        } else {
            request.setAttribute("errorJobSeeker", "You are not currently a member of Job Seeker. Please join to use this function.");
        }

        request.getRequestDispatcher("view/user/FavourJobPosting.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete-favourJP".equals(action)) {
            response.sendRedirect(deleteFavourJP(request, response));
        } else {
            response.sendRedirect("home");
        }
    }

    public String deleteFavourJP(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (jobSeeker == null) {
            try {
                return "FavourJobPosting?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(ApplicationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            int favourJPId = Integer.parseInt(request.getParameter("favourJPId"));

            favourJPDAO.deleteJobPosting(favourJPId);
            request.setAttribute("successApplication", "Job application canceled successfully.");
        } catch (NumberFormatException e) {
            Logger.getLogger(ApplicationServlet.class.getName()).log(Level.WARNING, "Invalid application ID or status", e);
            request.setAttribute("error", "Invalid application ID or status.");
        }

        return "FavourJobPosting";
    }

    public String viewListFavourJP(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, IOException {
        int page = parsePage(request);
        int pageSize = 10;

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker == null) {
            String errorMsg = "You are not currently a member of Job Seeker. Please join to use this function.";
            response.sendRedirect("FavourJobPosting?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            return null;
        }

        List<FavourJobPosting> favourJPs = favourJPDAO.getAllJobPostingsByJobSeeker(jobSeeker.getJobSeekerID(), page, pageSize);
        int totalRecords = favourJPDAO.countTotalFavourJPsByJSID(jobSeeker.getJobSeekerID());

        Map<Integer, String> jobPostingMap = new HashMap<>();
        Map<Integer, String> favourJPMap = new HashMap<>();

        for (FavourJobPosting favourJP : favourJPs) {
            JobPostings jobPosting = jobPostingDAO.findJobPostingById(favourJP.getJobPostingID());
            if (jobPosting != null) {
                jobPostingMap.put(favourJP.getFavourJPID(), jobPosting.getTitle());
            }

            if ("Violate".equals(jobPosting.getStatus())) {
                // Set a custom status message for applications with violated job postings
                favourJPMap.put(favourJP.getFavourJPID(), "Violate");
            } 
        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        request.setAttribute("favourJPs", favourJPs);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("jobPostingMap", jobPostingMap);
        request.setAttribute("favourJPMap", favourJPMap);
        return "FavourJobPosting";
    }

    private int parsePage(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            return 1; // default to page 1 if parsing fails
        }
    }
}