package controller.seeker;

import constant.CommonConst;
import constant.InterviewConst;
import dao.ApplicationDAO;
import dao.InterviewsDAO;
import dao.JobPostingsDAO;
import dao.JobSeekerDAO;
import dao.RecruitersDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import model.Account;
import model.Interviews;
import model.Applications;
import model.JobPostings;
import model.JobSeekers;
import model.Recruiters;
import utils.Email;

@WebServlet(name = "InterviewsServlet", urlPatterns = {"/interviews"})
public class InterviewsServlet extends HttpServlet {

    private final InterviewsDAO interviewsDAO = new InterviewsDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    private final RecruitersDAO recruitersDAO = new RecruitersDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("details".equalsIgnoreCase(action)) {
            viewInterviewDetails(request, response);
            return;
        }

        listInterviews(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("interviews");
            return;
        }

        switch (action) {
            case "confirm":
                handleConfirm(request, response);
                break;
            case "reschedule":
                handleReschedule(request, response);
                break;
            case "reject":
                handleReject(request, response);
                break;
            default:
                response.sendRedirect("interviews");
        }
    }

    private void listInterviews(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) {
            response.sendRedirect("view/authen/login.jsp");
            return;
        }

        JobSeekers seeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (seeker == null) {
            request.setAttribute("errorJobSeeker", "You are not currently a member of Job Seeker. Please join to use this function.");
            request.getRequestDispatcher("view/user/Interviews.jsp").forward(request, response);
            return;
        }

        String statusParam = request.getParameter("status");
        if (request.getParameter("success") != null) {
            request.setAttribute("success", request.getParameter("success"));
        }
        if (request.getParameter("error") != null) {
            request.setAttribute("error", request.getParameter("error"));
        }
        int page = parsePage(request);
        int pageSize = CommonConst.RECORD_PER_PAGE;

        List<Interviews> list;
        int totalRecords;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                int status = Integer.parseInt(statusParam);
                list = interviewsDAO.findBySeekerIdAndStatus(seeker.getJobSeekerID(), status, page, pageSize);
                totalRecords = interviewsDAO.countBySeekerIdAndStatus(seeker.getJobSeekerID(), status);
                request.setAttribute("selectedStatus", statusParam);
            } catch (NumberFormatException ex) {
                list = interviewsDAO.findBySeekerId(seeker.getJobSeekerID(), page, pageSize);
                totalRecords = interviewsDAO.countBySeekerId(seeker.getJobSeekerID());
            }
        } else {
            list = interviewsDAO.findBySeekerId(seeker.getJobSeekerID(), page, pageSize);
            totalRecords = interviewsDAO.countBySeekerId(seeker.getJobSeekerID());
        }

        java.util.Map<Integer, String> jobPostingMap = new java.util.HashMap<>();
        for (Interviews iv : list) {
            Applications app = applicationDAO.getDetailApplication(iv.getApplicationID());
            if (app != null) {
                JobPostings jp = jobPostingsDAO.findJobPostingById(app.getJobPostingID());
                if (jp != null) jobPostingMap.put(iv.getId(), jp.getTitle());
            }
        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        request.setAttribute("interviews", list);
        request.setAttribute("jobPostingMap", jobPostingMap);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("view/user/Interviews.jsp").forward(request, response);
    }

    private void viewInterviewDetails(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("interviews");
            return;
        }
        int id = Integer.parseInt(idRaw);
        Interviews interview = interviewsDAO.findById(id);
        if (interview == null) {
            response.sendRedirect("interviews");
            return;
        }
        if (request.getParameter("success") != null) {
            request.setAttribute("success", request.getParameter("success"));
        }
        if (request.getParameter("error") != null) {
            request.setAttribute("error", request.getParameter("error"));
        }
        List<Interviews> history = interviewsDAO.findHistoryByInterviewId(id);
        request.setAttribute("interview", interview);
        request.setAttribute("history", history);
        request.getRequestDispatcher("view/user/InterviewDetail.jsp").forward(request, response);
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int interviewId = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));

        // Safety: ensure the requester is the owner
        if (!ownsInterview(request.getSession(), interviewId)) {
            response.sendRedirect("interviews?error=unauthorized");
            return;
        }

        boolean ok = interviewsDAO.updateStatus(interviewId, status);
        if (ok) {
            notifyRecruiter(request, interviewId, "confirmed", null, null);
        }
        response.sendRedirect("interviews?action=details&id=" + interviewId + (ok ? "&success=confirmed" : "&error=update"));
    }

    private void handleReschedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int interviewId = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        String dateStr = request.getParameter("scheduleAt");
        String reason = request.getParameter("reason");
        // Existing UI uses <input type="date">; set time to 00:00:00
        Timestamp newDate = Timestamp.valueOf(dateStr + " 00:00:00");

        if (!ownsInterview(request.getSession(), interviewId)) {
            response.sendRedirect("interviews?error=unauthorized");
            return;
        }

        boolean ok = interviewsDAO.updateScheduleStatusAndReason(interviewId, newDate, status, reason);
        if (ok) {
            notifyRecruiter(request, interviewId, "rescheduled", newDate, reason);
        }
        response.sendRedirect("interviews?action=details&id=" + interviewId + (ok ? "&success=rescheduled" : "&error=update"));
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int interviewId = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        String reason = request.getParameter("reason");

        if (!ownsInterview(request.getSession(), interviewId)) {
            response.sendRedirect("interviews?error=unauthorized");
            return;
        }

        boolean ok = interviewsDAO.rejectWithReason(interviewId, reason, status);
        if (ok) {
            notifyRecruiter(request, interviewId, "rejected", null, reason);
        }
        response.sendRedirect("interviews?action=details&id=" + interviewId + (ok ? "&success=rejected" : "&error=update"));
    }

    private void notifyRecruiter(HttpServletRequest request, int interviewId, String action, java.sql.Timestamp scheduleAt, String reason) {
        try {
            Interviews iv = interviewsDAO.findById(interviewId);
            if (iv == null) return;
            Applications app = applicationDAO.getDetailApplication(iv.getApplicationID());
            if (app == null) return;
            JobPostings jp = jobPostingsDAO.findJobPostingById(app.getJobPostingID());
            if (jp == null) return;
            Recruiters re = recruitersDAO.findById(String.valueOf(jp.getRecruiterID()));
            if (re == null) return;
            model.Account recruiterAcc = accountDAO.findUserById(re.getAccountID());
            if (recruiterAcc == null || recruiterAcc.getEmail() == null || recruiterAcc.getEmail().isEmpty()) return;

            String subject = "Interview " + action + " by candidate";
            StringBuilder body = new StringBuilder();
            body.append("Dear Recruiter,<br><br>");
            body.append("The candidate has ").append(action).append(" an interview for Application ID ").append(app.getApplicationID()).append(".<br>");
            if (scheduleAt != null) {
                body.append("New schedule: ").append(scheduleAt.toString()).append("<br>");
            }
            if (reason != null && !reason.trim().isEmpty()) {
                body.append("Reason: ").append(escapeHtml(reason)).append("<br>");
            }
            String baseUrl = request.getScheme() + "://" + request.getServerName()
                    + ((request.getServerPort() == 80 || request.getServerPort() == 443) ? "" : ":" + request.getServerPort())
                    + request.getContextPath();
            String link = baseUrl + "/applicationSeekers?jobPostId=" + app.getJobPostingID();
            body.append("<br><a href=\"").append(link).append("\">View Applications</a>");
            body.append("<br><br>Best regards,");

            new Email().sendEmail(recruiterAcc.getEmail(), subject, body.toString());
        } catch (Exception ignore) {
        }
    }

    private String escapeHtml(String s) {
        return s == null ? null : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    private boolean ownsInterview(HttpSession session, int interviewId) {
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) return false;
        JobSeekers seeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (seeker == null) return false;
        Interviews it = interviewsDAO.findById(interviewId);
        return it != null && it.getSeekerID() == seeker.getJobSeekerID();
    }

    private int parsePage(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
