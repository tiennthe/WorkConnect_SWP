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
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Feedback;
import model.PageControl;
import utils.Email;

@WebServlet(name = "ManageFeedBackController", urlPatterns = {"/feedback"})
public class ManageFeedBackController extends HttpServlet {

    FeedbackDAO dao = new FeedbackDAO(); // DAO xử lý Feedback
    AccountDAO accDao = new AccountDAO(); // DAO xử lý Account

    // ------------------- Xử lý GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông báo từ URL nếu có
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        request.setAttribute("success", success);
        request.setAttribute("error", error);

        // Phân trang
        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        int page;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Lấy giá trị filter và search từ JSP
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";
        List<Feedback> list;
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;

        // Nếu có search
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "0": // Tìm tất cả theo từ khóa
                    list = dao.searchFeedbackByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?search=" + searchQuery + "&");
                    break;
                case "1": // Tìm theo từ khóa và trạng thái 1
                case "2": // Tìm theo từ khóa và trạng thái 2
                case "3": // Tìm theo từ khóa và trạng thái 3
                    int status = Integer.parseInt(filter);
                    list = dao.searchFeedbackByNameAndStatus(searchQuery, status, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, status);
                    pageControl.setUrlPattern(requestURL + "?filter=" + status + "&search=" + searchQuery + "&");
                    break;
                default: // Mặc định tìm tất cả
                    list = dao.searchFeedbackByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else { // Không có search, chỉ filter
            switch (filter) {
                case "0":
                    list = dao.findAllGroupByName(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "1":
                case "2":
                case "3":
                    int status = Integer.parseInt(filter);
                    list = dao.filterFeedbackByStatus(status, page);
                    totalRecord = dao.findTotalRecordByStatus(status);
                    pageControl.setUrlPattern(requestURL + "?filter=" + status + "&");
                    break;
                default:
                    list = dao.findAllGroupByName(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }

        request.setAttribute("listFeedback", list);

        // Tính tổng số trang
        int totalPage = (totalRecord % RECORD_PER_PAGE == 0) ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE + 1);
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        request.setAttribute("pageControl", pageControl);

        request.getRequestDispatcher("view/admin/feedbackManagement.jsp").forward(request, response);
    }

    // ------------------- Xử lý POST -------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

    // ------------------- Xem chi tiết feedback -------------------
    private String viewDetailFeedback(HttpServletRequest request, HttpServletResponse response) {
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        Feedback feedbackFound = dao.findFeedbackById(id);
        if (feedbackFound != null) {
            request.setAttribute("feedbackFound", feedbackFound);
        } else {
            request.setAttribute("error-view", "Have defect in view detail process!!");
        }
        return "view/admin/detailFeedback.jsp";
    }

    // ------------------- Xử lý resolved feedback -------------------
    private String resolvedFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        String responseFeedback = request.getParameter("response");
        Feedback feedbackFound = dao.findFeedbackById(id);
        Account account = accDao.findUserById(feedbackFound.getAccountID());
        String url;

        if (feedbackFound != null && feedbackFound.getStatus() != 3) { // Trạng thái khác rejected
            String subject = "Response from Admin Regarding Your Feedback";
            String content = responseFeedback;
            try {
                Email.sendEmail(account.getEmail(), subject, content); // gửi email
                dao.changeStatus(id, 2); // đổi trạng thái resolved
                url = "feedback?success=" + URLEncoder.encode("Resolved and sent notification to " + account.getFullName() + " successfully!!!", "UTF-8");
            } catch (MessagingException ex) {
                url = "feedback?error=" + URLEncoder.encode("Have error in process of resolve!!!", "UTF-8");
            }
        } else {
            url = "feedback?error=" + URLEncoder.encode("This feedback of " + account.getFullName() + " was rejected!!", "UTF-8");
        }
        return url;
    }

    // ------------------- Xử lý reject feedback -------------------
    private String rejectFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        String responseFeedback = request.getParameter("response");
        Feedback feedbackFound = dao.findFeedbackById(id);
        Account account = accDao.findUserById(feedbackFound.getAccountID());
        String url;

        if (feedbackFound != null && feedbackFound.getStatus() != 2) { // Trạng thái khác resolved
            String subject = "Response from Admin Regarding Your Feedback";
            String content = responseFeedback;
            try {
                Email.sendEmail(account.getEmail(), subject, content);
                dao.changeStatus(id, 3); // đổi trạng thái rejected
                url = "feedback?success=" + URLEncoder.encode("Reject and sent notification to " + account.getFullName() + " successfully!!!", "UTF-8");
            } catch (MessagingException ex) {
                url = "feedback?error=" + URLEncoder.encode("Have error in process of resolve!!!", "UTF-8");
            }
        } else {
            url = "feedback?error=" + URLEncoder.encode("This feedback of " + account.getFullName() + " was resolved!!", "UTF-8");
        }
        return url;
    }

    // ------------------- Xóa feedback -------------------
    private String deleteFeedback(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        int id = Integer.parseInt(request.getParameter("feedback-id"));
        Feedback feedbackFound = dao.findFeedbackById(id);
        String url;
        if (feedbackFound != null && feedbackFound.getStatus() != 1) { // Không xóa feedback mới chưa xử lý
            dao.deleteFeedback(feedbackFound);
            url = "feedback";
        } else {
            url = "feedback?error=" + URLEncoder.encode("Can not delete, you must handle the feedback!!", "UTF-8");
        }
        return url;
    }
}
