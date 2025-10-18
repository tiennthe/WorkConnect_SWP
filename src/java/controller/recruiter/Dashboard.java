/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import constant.CommonConst;
import dao.CompanyDAO;
import dao.RecruitersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Company;
import model.Recruiters;

/**
 *
 * @author quang
 */
@WebServlet(name = "Dashboard", urlPatterns = {"/Dashboard"})
public class Dashboard extends HttpServlet {

    RecruitersDAO RecruitersDAO = new RecruitersDAO();
    CompanyDAO cdao = new CompanyDAO();
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            // If user is not logged in, redirect to login
            response.sendRedirect("view/authen/login.jsp");
            return;
        }
        
        Recruiters recruiters = RecruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
        if (recruiters == null) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
            dispatcher.forward(request, response);
        }else{
            Company company = cdao.findCompanyById(recruiters.getCompanyID());
            if (company == null || !company.isVerificationStatus() || !recruiters.isIsVerify()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
                dispatcher.forward(request, response);
            }else{
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/dashboard.jsp");
                dispatcher.forward(request, response);
            }
        }
    }
}
