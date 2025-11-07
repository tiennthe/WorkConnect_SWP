package controller.recruiter;

import constant.CommonConst;
import dao.ApplicationDAO;
import dao.InterviewsDAO;
import dao.JobPostingsDAO;
import dao.RecruitersDAO;
import dao.JobSeekerDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Account;
import model.Applications;
import model.Interviews;
import model.JobPostings;
import model.Recruiters;

@WebServlet(name = "InterviewsManagementServlet", urlPatterns = {"/interviewsManagement"})
public class InterviewsManagementServlet extends HttpServlet {

    private final InterviewsDAO interviewsDAO = new InterviewsDAO();
    private final RecruitersDAO recruitersDAO = new RecruitersDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("details".equalsIgnoreCase(action)) {
            viewDetails(request, response);
            return;
        }
        list(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement");
            return;
        }
        switch (action) {
            case "confirm":
                handleConfirm(request, response);
                break;
            case "reschedule":
                handleReschedule(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/interviewsManagement");
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Integer recruiterId = getRecruiterId(request.getSession());
        if (recruiterId == null) {
            response.sendRedirect(request.getContextPath() + "/view/authen/login.jsp");
            return;
        }

        String statusParam = request.getParameter("status");
        int page = parsePage(request);
        int pageSize = CommonConst.RECORD_PER_PAGE;

        List<Interviews> list;
        int totalRecords;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                int status = Integer.parseInt(statusParam);
                list = interviewsDAO.findLatestByRecruiterIdAndStatus(recruiterId, status, page, pageSize);
                totalRecords = interviewsDAO.countLatestByRecruiterIdAndStatus(recruiterId, status);
                request.setAttribute("selectedStatus", statusParam);
            } catch (NumberFormatException ex) {
                list = interviewsDAO.findLatestByRecruiterId(recruiterId, page, pageSize);
                totalRecords = interviewsDAO.countLatestByRecruiterId(recruiterId);
            }
        } else {
            list = interviewsDAO.findLatestByRecruiterId(recruiterId, page, pageSize);
            totalRecords = interviewsDAO.countLatestByRecruiterId(recruiterId);
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
        request.getRequestDispatcher("view/recruiter/Interviews.jsp").forward(request, response);
    }

    private void viewDetails(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Integer recruiterId = getRecruiterId(request.getSession());
        if (recruiterId == null) {
            response.sendRedirect(request.getContextPath() + "/view/authen/login.jsp");
            return;
        }
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement");
            return;
        }
        int id = Integer.parseInt(idRaw);
        Interviews interview = interviewsDAO.findById(id);
        if (interview == null || interview.getRecruiterID() != recruiterId) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?error=notfound");
            return;
        }
        List<Interviews> history = interviewsDAO.findHistoryByInterviewId(id);
        java.util.Map<Integer,String> createdByNameMap = new java.util.HashMap<>();
        if (interview != null) {
            createdByNameMap.put(interview.getId(), resolveCreatedByName(interview));
        }
        for (Interviews h : history) {
            createdByNameMap.put(h.getId(), resolveCreatedByName(h));
        }
        request.setAttribute("interview", interview);
        request.setAttribute("history", history);
        request.setAttribute("createdByNameMap", createdByNameMap);
        request.setAttribute("createdByName", createdByNameMap.get(interview.getId()));
        request.getRequestDispatcher("view/recruiter/InterviewDetail.jsp").forward(request, response);
    }

    private String resolveCreatedByName(Interviews iv) {
        try {
            if (iv.getCreatedBy() == iv.getSeekerID()) {
                model.JobSeekers seeker = jobSeekerDAO.findJobSeekerIDByJobSeekerID(String.valueOf(iv.getSeekerID()));
                if (seeker != null && seeker.getAccount() != null) return seeker.getAccount().getFullName();
            }
            if (iv.getCreatedBy() == iv.getRecruiterID()) {
                model.Recruiters r = recruitersDAO.findById(String.valueOf(iv.getRecruiterID()));
                if (r != null) {
                    model.Account acc = accountDAO.findUserById(r.getAccountID());
                    if (acc != null) return acc.getFullName();
                }
            }
        } catch (Exception ignored) {}
        return String.valueOf(iv.getCreatedBy());
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer recruiterId = getRecruiterId(request.getSession());
        if (recruiterId == null) {
            response.sendRedirect(request.getContextPath() + "/view/authen/login.jsp");
            return;
        }
        int interviewId = Integer.parseInt(request.getParameter("id"));
        Interviews current = interviewsDAO.findById(interviewId);
        if (current == null || current.getRecruiterID() != recruiterId) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?error=notfound");
            return;
        }
        boolean ok = interviewsDAO.updateStatus(interviewId, 2);
        if (ok) {
            notifySeeker(request, interviewId, "confirmed", null, null);
        }
        response.sendRedirect(request.getContextPath() + "/interviewsManagement?action=details&id=" + interviewId + (ok ? "&success=confirmed" : "&error=update"));
    }

    private void handleReschedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer recruiterId = getRecruiterId(request.getSession());
        if (recruiterId == null) {
            response.sendRedirect(request.getContextPath() + "/view/authen/login.jsp");
            return;
        }
        int interviewId = Integer.parseInt(request.getParameter("id"));
        Interviews current = interviewsDAO.findById(interviewId);
        if (current == null || current.getRecruiterID() != recruiterId) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?error=notfound");
            return;
        }
        String dateStr = request.getParameter("scheduleAt");
        String reason = request.getParameter("reason");
        String ts = dateStr != null ? dateStr.replace('T', ' ') : null;
        if (ts == null || ts.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?action=details&id=" + interviewId + "&error=invalidDate");
            return;
        }
        if (ts.length() == 16) ts = ts + ":00";
        Timestamp newDate = Timestamp.valueOf(ts);

        // Create new interview record (status = 1 Rescheduled)
        Interviews newIv = new Interviews();
        newIv.setApplicationID(current.getApplicationID());
        newIv.setRecruiterID(current.getRecruiterID());
        newIv.setSeekerID(current.getSeekerID());
        newIv.setReason(reason);
        newIv.setStatus(1);
        newIv.setScheduleAt(newDate);
        newIv.setCreatedBy(current.getRecruiterID());
        int newId = interviewsDAO.insert(newIv);
        if (newId > 0) {
            // Keep application status aligned (5 used as rescheduled)
            new ApplicationDAO().ChangeStatusApplication(current.getApplicationID(), 5);
            notifySeeker(request, newId, "rescheduled", newDate, reason);
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?action=details&id=" + newId + "&success=rescheduled");
        } else {
            response.sendRedirect(request.getContextPath() + "/interviewsManagement?action=details&id=" + interviewId + "&error=create");
        }
    }

    private void notifySeeker(HttpServletRequest request, int interviewId, String action, java.sql.Timestamp scheduleAt, String reason) {
        try {
            Interviews iv = interviewsDAO.findById(interviewId);
            if (iv == null) return;
            Applications app = applicationDAO.getDetailApplication(iv.getApplicationID());
            if (app == null) return;
            model.JobSeekers seeker = jobSeekerDAO.findJobSeekerIDByJobSeekerID(String.valueOf(app.getJobSeekerID()));
            if (seeker == null) return;
            model.Account acc = accountDAO.findUserById(seeker.getAccountID());
            if (acc == null || acc.getEmail() == null || acc.getEmail().isEmpty()) return;

            String subject = "Interview " + action + " by recruiter";
            StringBuilder body = new StringBuilder();
            body.append("Dear ").append(acc.getFullName()).append(",<br><br>");
            if ("confirmed".equals(action)) {
                body.append("Your interview has been confirmed.");
            } else if ("rescheduled".equals(action)) {
                body.append("Your interview has been rescheduled.");
            } else {
                body.append("Your interview has an update.");
            }
            if (scheduleAt != null) {
                body.append("<br>New schedule: ").append(scheduleAt.toString());
            }
            if (reason != null && !reason.trim().isEmpty()) {
                body.append("<br>Reason: ").append(escapeHtml(reason));
            }
            String baseUrl = request.getScheme() + "://" + request.getServerName()
                    + ((request.getServerPort() == 80 || request.getServerPort() == 443) ? "" : ":" + request.getServerPort())
                    + request.getContextPath();
            body.append("<br><a href=\"").append(baseUrl).append("/interviews?action=details&id=").append(interviewId).append("\">View details</a>");
            body.append("<br><br>Best regards,");

            new utils.Email().sendEmail(acc.getEmail(), subject, body.toString());
        } catch (Exception ignored) {}
    }

    private String escapeHtml(String s) {
        return s == null ? null : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    private Integer getRecruiterId(HttpSession session) {
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) return null;
        Recruiters r = recruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
        return r == null ? null : r.getRecruiterID();
    }

    private int parsePage(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
