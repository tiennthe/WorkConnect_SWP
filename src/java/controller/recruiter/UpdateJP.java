package controller.recruiter;

import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.JobPostings;
import model.Job_Posting_Category;

@WebServlet(name = "UpdateJP", urlPatterns = {"/updateJP"})
public class UpdateJP extends HttpServlet {
    Job_Posting_CategoryDAO jbDao = new Job_Posting_CategoryDAO();
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("idJP"));
        JobPostingsDAO dao = new JobPostingsDAO();
        JobPostings jp = dao.findJobPostingById(id);
        
        request.setAttribute("selectedJobCategory", jp.getJob_Posting_CategoryID());
        List<Job_Posting_Category> jobCategories = jbDao.findAll();
        request.setAttribute("jobCategories", jobCategories);
        request.setAttribute("jobPost", jp);
        request.getRequestDispatcher("view/recruiter/editJP.jsp").forward(request, response);
    } 
}