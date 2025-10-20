/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.AccountDAO;
import dao.RecruitersDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Recruiters;
import utils.Email;

@WebServlet(name = "ConfirmRecruiterController", urlPatterns = {"/confirm"})
public class ConfirmRecruiterController extends HttpServlet {

    private static final RecruitersDAO dao = new RecruitersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Recruiters> listConfirm = null;
        String url = "view/admin/confirmRecruiter.jsp";
        //get ve thong bao neu co
        String notice = request.getParameter("notice") != null ? request.getParameter("notice") : "";
        //get ve thong tin search
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";
        if (!searchQuery.isEmpty()) {
            listConfirm = dao.searchByName(searchQuery);
        } else {
            listConfirm = dao.findAll();
        }
        request.setAttribute("listConfirm", listConfirm);
        request.setAttribute("notice", notice);
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "confirm":
                url = confirm(request, response);
                break;
            case "reject":
                url = reject(request, response);
                break;
            default:
                throw new AssertionError();
        }
        response.sendRedirect(url);
    }

    private String confirm(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            //tao doi tuong account de lay ve mail
            AccountDAO accountDao = new AccountDAO();
            String recruiterId = request.getParameter("recruiterId");
            //lay recruiter theo id de lay ve id cua account do
            Recruiters recruiter = dao.findById(recruiterId);
            Account accountFound = accountDao.findUserById(recruiter.getAccountID());
            //gui email ve email cua account vua tim duoc
            String subject = "Your Recruiter Request Has Been Approved";
            String content = "Dear " + accountFound.getFullName() + ",\n"
                    + "\n"
                    + "We are pleased to inform you that your request to become a recruiter on our platform has been approved. You now have access to recruitment features to help manage job postings and find top candidates.\n"
                    + "\n"
                    + "Thank you for choosing our platform to grow your team. Should you need any assistance, feel free to reach out.\n"
                    + "\n"
                    + "Best regards,";
            Email.sendEmail(accountFound.getEmail(), subject, content);
            dao.updateVerification(recruiterId, true);

        } catch (MessagingException ex) {
            return "confirm?notice=" + URLEncoder.encode("Exist error in send email and confirm process!!", "UTF-8");
        }
        return "confirm?notice=" + URLEncoder.encode("Send email and confirm recruiter successfully!!", "UTF-8");
    }

    private String reject(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            //tao doi tuong account de lay ve mail
            AccountDAO accountDao = new AccountDAO();
            String recruiterId = request.getParameter("recruiterId");
            //lay recruiter theo id de lay ve id cua account do
            Recruiters recruiter = dao.findById(recruiterId);
            Account accountFound = accountDao.findUserById(recruiter.getAccountID());
            //gui email ve email cua account vua tim duoc
            String subject = "Your Recruiter Request on Our Platform";
            String content = "Dear " + accountFound.getFullName() + ",\n"
                    + "\n"
                    + "Thank you for your interest in becoming a recruiter on our platform. After reviewing your request, we regret to inform you that it did not meet the requirements for approval at this time.\n"
                    + "\n"
                    + "If you have any questions or would like further clarification, please don't hesitate to contact us.\n"
                    + "\n"
                    + "Sincerely";
            Email.sendEmail(accountFound.getEmail(), subject, content);
            dao.deleteRecruiter(recruiterId);

        } catch (MessagingException ex) {
            return "confirm?notice=" + URLEncoder.encode("Exist error in send email and reject process!!", "UTF-8");
        }
        return "confirm?notice=" + URLEncoder.encode("Send email and reject recruiter successfully!!", "UTF-8");
    }

}