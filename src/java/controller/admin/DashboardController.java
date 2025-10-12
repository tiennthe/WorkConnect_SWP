/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    AccountDAO accDao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get seeker record
        int totalSeeker = accDao.findAllTotalRecord(3);
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3);
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3);
        //set vao request
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);

        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get seeker record
        int totalSeeker = accDao.findAllTotalRecord(3);
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3);
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3);
        
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);
        //chuyen trang
        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }

}