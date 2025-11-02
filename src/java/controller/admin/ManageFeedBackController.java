/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import dao.FeedbackDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.Company;
import model.Feedback;
import model.PageControl;
import utils.Email;

@WebServlet(name = "ManageFeedBackController", urlPatterns = {"/feedback"})
public class ManageFeedBackController extends HttpServlet {

    FeedbackDAO dao = new FeedbackDAO();
    AccountDAO accDao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        request.setAttribute("success", success);
        request.setAttribute("error", error);
        // get ve pageNumber
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
        //        get ve gia tri cua drop-down filter
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        //        get ve gia tri tu thanh search
        String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";
        List<Feedback> list;
        //get ve url
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "0":
                    // Tìm tất cả các công ty theo từ khóa
                    list = dao.searchFeedbackByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?search=" + searchQuery + "&");
                    break;
                case "1":
                    // Tìm các công ty đã được chấp nhận theo từ khóa
                    list = dao.searchFeedbackByNameAndStatus(searchQuery, 1, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, 1);
                    pageControl.setUrlPattern(requestURL + "?filter=1&search=" + searchQuery + "&");
                    break;
                case "2":
                    // Tìm các công ty vi phạm theo từ khóa
                    list = dao.searchFeedbackByNameAndStatus(searchQuery, 2, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=2&search=" + searchQuery + "&");
                    break;
                case "3":
                    // Tìm các công ty vi phạm theo từ khóa
                    list = dao.searchFeedbackByNameAndStatus(searchQuery, 3, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, 3);
                    pageControl.setUrlPattern(requestURL + "?filter=3&search=" + searchQuery + "&");
                    break;
                default:
                    // Mặc định sẽ tìm tất cả các công ty theo từ khóa
                    list = dao.searchFeedbackByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        }else {
            //get ve request URL
            //total record

            switch (filter) {
                case "0":
                    list = dao.findAllGroupByName(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "1":
                    list = dao.filterFeedbackByStatus(1, page);
                    totalRecord = dao.findTotalRecordByStatus(1);
                    pageControl.setUrlPattern(requestURL + "?filter=1" + "&");
                    break;
                case "2":
                    list = dao.filterFeedbackByStatus(2, page);
                    totalRecord = dao.findTotalRecordByStatus(2);
                    pageControl.setUrlPattern(requestURL + "?filter=2" + "&");
                    break;
                case "3":
                    list = dao.filterFeedbackByStatus(3, page);
                    totalRecord = dao.findTotalRecordByStatus(3);
                    pageControl.setUrlPattern(requestURL + "?filter=3" + "&");
                    break;
                default:
                    list = dao.findAllGroupByName(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }
            request.setAttribute("listFeedback", list);
//total page
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0 ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE) + 1;
        //set total record, total page, page to pageControl
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        //set attribute pageControl 
        request.setAttribute("pageControl", pageControl);
        request.getRequestDispatcher("view/admin/feedbackManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get ve action
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url = "";
        switch (action) {
            case "resolved":
                url = resolvedFeedback(request, response);
                break;
            case "reject":
                url = rejectFeedback(request, response);
                break;
            case "delete":
                url = deleteFeedback(request, response);
                break;
            case "view":
                url = viewDetailFeedback(request, response);
                request.getRequestDispatcher(url).forward(request, response);
                return;
            default:
                throw new AssertionError();
        }
        response.sendRedirect(url);
    }

    private String viewDetailFeedback(HttpServletRequest request, HttpServletResponse response) {
        String url = "";
        //lay ve id
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        // lay ve feedback theo id
        Feedback feedbackFound = dao.findFeedbackById(id);
        if (feedbackFound != null) {
            request.setAttribute("feedbackFound", feedbackFound);
            url = "view/admin/detailFeedback.jsp";
        } else {
            request.setAttribute("error-view", "Have defect in view detail process!!");
            url = "view/admin/detailFeedback.jsp";
        }
        return url;
    }

    private String resolvedFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {

        String url = "";
        //lay ve response
        String responseFeedback = request.getParameter("response");
        //lay ve id
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        //lay ve feedback theo id
        Feedback feedbackFound = dao.findFeedbackById(id);
        Account account = accDao.findUserById(feedbackFound.getAccountID());
        if (feedbackFound != null && feedbackFound.getStatus() != 3) {
            //xu li gui mail
            String subject = "Response from Admin Regarding Your Feedback";
            String content = responseFeedback;
            try {
                //doi trang thai theo id va set trang thai bang 2(Resolved)
                Email.sendEmail(account.getEmail(), subject, content);
                dao.changeStatus(id, 2);
                url = "feedback?success=" + URLEncoder.encode("Resolved and sent nofication to " + account.getFullName() + " successfully!!!", "UTF-8");
            } catch (MessagingException ex) {
                url = "feedback?error=" + URLEncoder.encode("Have error in process of resolve!!!", "UTF-8");
            }
        } else {
            url = "feedback?error=" + URLEncoder.encode("This feedback of " + account.getFullName() + " was rejected!!", "UTF-8");
        }
        return url;
    }

    private String rejectFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String url = "";
        String responseFeedback = request.getParameter("response");
        //lay ve id
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        //lay ve feedback theo id
        Feedback feedbackFound = dao.findFeedbackById(id);
        Account account = accDao.findUserById(feedbackFound.getAccountID());
        //xử lí: trạng thái feedback phải khác resolved
        if (feedbackFound != null && feedbackFound.getStatus() != 2) {
            //xu li gui mail
            String subject = "Response from Admin Regarding Your Feedback";
            String content = responseFeedback;
            try {
                //doi trang thai theo id va set trang thai bang 2(Resolved)
                Email.sendEmail(account.getEmail(), subject, content);
                dao.changeStatus(id, 3);
                url = "feedback?success=" + URLEncoder.encode("Reject and sent nofication to " + account.getFullName() + " successfully!!!", "UTF-8");
            } catch (MessagingException ex) {
                url = "feedback?error=" + URLEncoder.encode("Have error in process of resolve!!!", "UTF-8");
            }
        } else {
            url = "feedback?error=" + URLEncoder.encode("This feedback of " + account.getFullName() + " was resolved!!", "UTF-8");
        }
        return url;
    }

    private String deleteFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String url = "";
        //lay ve id
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        //lay ve feedback theo id
        Feedback feedbackFound = dao.findFeedbackById(id);
        if (feedbackFound != null && feedbackFound.getStatus() != 1) {
            //doi trang thai theo id va set trang thai bang 3(Resolved)
            dao.deleteFeedback(feedbackFound);
            url = "feedback";
        } else {
            url = "feedback?error=" + URLEncoder.encode("Can not delete, you must handle the feedback!!", "UTF-8");
        }
        return url;
    }

}