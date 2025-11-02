/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.seeker;

import constant.CommonConst;
import dao.FeedbackDAO;
import dao.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Feedback;
import model.JobSeekers;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedbackSeeker"})
public class FeedbackServlet extends HttpServlet {

    FeedbackDAO feedbackDao = new FeedbackDAO();
    JobSeekerDAO jobSeekerDao = new JobSeekerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        //lay ve list cac feedback theo accountid
        List<Feedback> list = feedbackDao.findFeedbackByAccountID(account.getId());
        request.setAttribute("feedbackList", list);
        request.getRequestDispatcher("view/user/Feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "";
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        switch (action) {
            case "delete":
                url = deleteFeedback(request);
                break;
            case "create":
                url = createFeedback(request);
                break;
            case "edit":
                url = editFeedback(request);
                break;
            default:
                throw new AssertionError();
        }
        response.sendRedirect(url);
    }

    private String deleteFeedback(HttpServletRequest request) {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        feedbackDao.changeStatus(feedbackId, 4);
        return "feedbackSeeker";
    }

    private String createFeedback(HttpServletRequest request) throws UnsupportedEncodingException {
        String url = "";
        //lay ve accountid
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (!checkJoinJobSeeker(account)) {
            int jobPostId = Integer.parseInt(request.getParameter("jobPostingID"));
            url = "jobPostingDetail?action=" + URLEncoder.encode("details", "UTF-8")
                    + "&idJP=" + URLEncoder.encode(String.valueOf(jobPostId), "UTF-8")
                    + "&notice=" + URLEncoder.encode("You must join job seeker first!!", "UTF-8");
        } else {
            String content = request.getParameter("content");
            int jobPostId = Integer.parseInt(request.getParameter("jobPostingID"));
            //set vao doi tuong feedback de insert
            Feedback feedback = new Feedback();
            feedback.setAccountID(account.getId());
            feedback.setJobPostingID(jobPostId);
            feedback.setContentFeedback(content);
            feedbackDao.insert(feedback);
            url = "jobPostingDetail?action=" + URLEncoder.encode("details", "UTF-8")
                    + "&idJP=" + URLEncoder.encode(String.valueOf(jobPostId), "UTF-8")
                    + "&notice=" + URLEncoder.encode("Send feedback successfully!!", "UTF-8");
        }
        return url;
    }

    private String editFeedback(HttpServletRequest request) {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        String content = request.getParameter("content");
        feedbackDao.updateFeedback(feedbackId, content);
        return "feedbackSeeker";
    }

    private boolean checkJoinJobSeeker(Account account) {
        List<JobSeekers> list = jobSeekerDao.findAll();
        for (JobSeekers jobSeekers : list) {
            if (jobSeekers.getAccountID() == account.getId()) {
                return true;
            }
        }
        return false;
    }

}