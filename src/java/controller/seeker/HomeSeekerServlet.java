package controller.seeker;

import dao.CompanyDAO;
import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.JobPostings;
import model.Job_Posting_Category;
import model.PageControl;

@WebServlet(name = "HomeSeekerServlet", urlPatterns = {"/HomeSeeker"})
public class HomeSeekerServlet extends HttpServlet {

    private final JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    private final CompanyDAO companyDAO = new CompanyDAO();
    private final Job_Posting_CategoryDAO jobCategoryDAO = new Job_Posting_CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PageControl pageControl = new PageControl();
        
        // Parse and validate page parameter
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Fetch category information and filter active categories
        List<Job_Posting_Category> jobCategories = jobCategoryDAO.findAll();
        List<Job_Posting_Category> activeCategories = new ArrayList<>();
        for (Job_Posting_Category category : jobCategories) {
            if (category.isStatus()) {
                activeCategories.add(category);
            }
        }

        // Get filter and search parameters
        String minSalary = request.getParameter("minSalary") != null ? request.getParameter("minSalary") : "";
        String maxSalary = request.getParameter("maxSalary") != null ? request.getParameter("maxSalary") : "";
        String filterCategory = request.getParameter("filterCategory") != null ? request.getParameter("filterCategory") : "";
        String search = request.getParameter("search") != null ? request.getParameter("search") : "";

        // Retrieve job postings based on filters
        List<JobPostings> jobPostingsList = jobPostingsDAO.findAndfilterJobPostingsHome(minSalary, maxSalary, filterCategory, search, page);
        int totalRecord = jobPostingsDAO.findAndfilterAllHomeRecord(minSalary, maxSalary, filterCategory, search);

        // Set up URL pattern for pagination links
        String requestURL = request.getRequestURL().toString();
        pageControl.setUrlPattern(requestURL + "?minSalary=" + minSalary + "&maxSalary=" + maxSalary 
                + "&filterCategory=" + filterCategory + "&search=" + search + "&");

        // Calculate total pages for pagination
        int totalPage = (totalRecord + 11) / 12; // Ceiling division for total pages
        
        // Configure page control attributes
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);

        // Set attributes for request scope
        request.setAttribute("jobPostingsList", jobPostingsList);
        request.setAttribute("pageControl", pageControl);
        request.setAttribute("activeCategories", activeCategories);

        // Forward to JSP
        request.getRequestDispatcher("view/user/userHome.jsp").forward(request, response);
    }
}