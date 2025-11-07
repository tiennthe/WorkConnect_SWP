package controller.seeker;

import constant.CommonConst;
import dao.InterviewsDAO;
import dao.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Account;
import model.Interviews;
import model.JobSeekers;

@WebServlet(name = "InterviewsServlet", urlPatterns = {"/interviews"})
public class InterviewsServlet extends HttpServlet {

    private final InterviewsDAO interviewsDAO = new InterviewsDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

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

        List<Interviews> list = interviewsDAO.findBySeekerId(seeker.getJobSeekerID());
        request.setAttribute("interviews", list);
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
        response.sendRedirect("interviews?action=details&id=" + interviewId + (ok ? "&success=confirmed" : "&error=update"));
    }

    private void handleReschedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int interviewId = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        Date newDate = Date.valueOf(request.getParameter("scheduleAt"));

        if (!ownsInterview(request.getSession(), interviewId)) {
            response.sendRedirect("interviews?error=unauthorized");
            return;
        }

        boolean ok = interviewsDAO.updateScheduleAndStatus(interviewId, newDate, status);
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
        response.sendRedirect("interviews?action=details&id=" + interviewId + (ok ? "&success=rejected" : "&error=update"));
    }

    private boolean ownsInterview(HttpSession session, int interviewId) {
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) return false;
        JobSeekers seeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (seeker == null) return false;
        Interviews it = interviewsDAO.findById(interviewId);
        return it != null && it.getSeekerID() == seeker.getJobSeekerID();
    }
}

