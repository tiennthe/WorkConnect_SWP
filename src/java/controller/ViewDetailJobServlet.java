/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobPostings;
import model.Job_Posting_Category;
import validate.Validation;

@WebServlet(name="ViewDetailJobServlet", urlPatterns={"/viewdetail"})
public class ViewDetailJobServlet extends HttpServlet {
       Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();

    JobPostingsDAO dao = new JobPostingsDAO();
    Validation valid = new Validation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "details":
                url = viewJP(request, response);
                break;
            default:
                url = "view/ViewJobPosting.jsp";
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private String viewJP(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = null;
        int idJP = Integer.parseInt(request.getParameter("idJP"));
        JobPostings jobPost = dao.findJobPostingById(idJP);
        request.setAttribute("jobPost", jobPost);
        Job_Posting_Category category = categoryDAO.findJob_Posting_CategoryNameByJobPostingID(idJP);
            if (category.isStatus()) {
                request.setAttribute("category", category); // Đặt với tên 'category'
            } else {
                request.setAttribute("category", "This category was deleted!");
            }
        url = "view/ViewJobPosting.jsp";
        return url;
    }

}