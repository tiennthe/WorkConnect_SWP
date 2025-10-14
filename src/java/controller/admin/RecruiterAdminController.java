/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.PageControl;

@WebServlet(name = "RecruiterAdminController", urlPatterns = {"/recruiters"})
public class RecruiterAdminController extends HttpServlet {

    AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        //valid page
        int page;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        ///get ve action 
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "view-list-seekers":
                url = "view/admin/recruiterManagement.jsp";
                break;
            default:
                url = "view/admin/recruiterManagement.jsp";
        }
        //lay ve id de view profile
        // get ve danh sach list seeker
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        //get ve gia tri search by name
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";
        List<Account> listRecruiters = null;
        //get ve request URL
        String requestURL = request.getRequestURL().toString();
        //total record
        int totalRecord = 0;
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "all":
                    listRecruiters = dao.searchUserByName(searchQuery, 2, page); // Tìm tất cả
                    totalRecord = dao.findTotalRecordByName(searchQuery, 2);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
                    break;
                case "active":
                    listRecruiters = dao.searchUserByNameAndStatus(searchQuery, true, 2, page); // Chỉ tìm active
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, true, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=active&searchQuery=" + searchQuery + "&");
                    break;
                case "inactive":
                    listRecruiters = dao.searchUserByNameAndStatus(searchQuery, false, 2, page); // Chỉ tìm inactive
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, false, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive&searchQuery=" + searchQuery + "&");
                    break;
                default:
                    listRecruiters = dao.searchUserByName(searchQuery, 2, page); // Mặc định là tất cả
                    totalRecord = dao.findTotalRecordByName(searchQuery, 2);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else {
            switch (filter) {

                case "all":
                    listRecruiters = dao.findAllUserByRoleId(2, page);
                    totalRecord = dao.findAllTotalRecord(2);
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "active":
                    listRecruiters = dao.filterUserByStatus(true, 2, page);
                    totalRecord = dao.findTotalRecordByStatus(true, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=active" + "&");
                    break;
                case "inactive":
                    listRecruiters = dao.filterUserByStatus(false, 2, page);
                    totalRecord = dao.findTotalRecordByStatus(false, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive" + "&");
                    break;
                default:
                    listRecruiters = dao.findAllUserByRoleId(2, page);
                    totalRecord = dao.findAllTotalRecord(2);
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }
        request.setAttribute("listRecruiters", listRecruiters);
        // Handle GET requests based on the action
        //total page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0 ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE) + 1;
        //set total record, total page, page to pageControl
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        //set attribute pageControl 
        request.setAttribute("pageControl", pageControl);
        

        // Forward to the appropriate page
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "deactive":
                url = deactive(request);
                break;
            case "active":
                url = active(request);
                break;
            case "view-detail":
                url = viewDetail(request);
                request.getRequestDispatcher(url).forward(request, response);
                return;

            default:
                url = "view/admin/recruiterManagement.jsp";
        }
        response.sendRedirect(url);
    }

    private String deactive(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        dao.deactiveAccount(account);
        return "seekers";
    }

    private String active(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        dao.activeAccount(account);
        return "seekers";
    }

    private String viewDetail(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        request.setAttribute("accountView", account);
        return "view/admin/viewDetailUser.jsp";
    }

    
}