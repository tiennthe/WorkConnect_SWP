/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import dao.Job_Posting_CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Job_Posting_Category;

@WebServlet(name = "AddJobPosting", urlPatterns = {"/AddJobPosting"})
public class AddJobPosting extends HttpServlet {

    Job_Posting_CategoryDAO categoryDAO = new Job_Posting_CategoryDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            // Lấy danh sách danh mục từ cơ sở dữ liệu
            List<Job_Posting_Category> categories = categoryDAO.findAll();

            // Đặt danh sách này vào attribute để JSP có thể truy cập
            request.setAttribute("jobCategories", categories);

            // Chuyển hướng tới trang JSP
            request.getRequestDispatcher("view/recruiter/addJobPosting.jsp").forward(request, response);
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }
}