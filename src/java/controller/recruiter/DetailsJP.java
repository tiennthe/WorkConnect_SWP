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
import validate.Validation;

@WebServlet(name = "DetailsJP", urlPatterns = {"/detailsJP"})
public class DetailsJP extends HttpServlet {

    Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();
    JobPostingsDAO dao = new JobPostingsDAO();
    Validation valid = new Validation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        if ("details".equals(action)) {
            url = viewJP(request, response);
        } else {
            url = "view/recruiter/viewJP.jsp";
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private String viewJP(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url;
        int idJP = Integer.parseInt(request.getParameter("idJP"));

        // Lấy chi tiết công việc từ DAO
        JobPostings jobPost = dao.findJobPostingById(idJP);

        // Lấy danh mục công việc của jobPost
        Job_Posting_Category category = categoryDAO.findJob_Posting_CategoryNameByJobPostingID(idJP);
        request.setAttribute("category", category); // Đặt với tên 'category'

        // Đặt chi tiết công việc và danh mục vào request
        request.setAttribute("jobPost", jobPost);

        // Chuyển hướng tới trang chi tiết công việc
        url = "view/recruiter/viewJP.jsp";
        return url;
    }
}