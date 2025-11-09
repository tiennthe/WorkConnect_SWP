/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import dao.AccountDAO;
import dao.ApplicationDAO;
import dao.CVDAO;
import dao.EducationDAO;
import dao.JobPostingsDAO;
import dao.InterviewsDAO;
import dao.WorkExperienceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Account;
import model.Applications;
import model.CV;
import model.Education;
import model.WorkExperience;
import model.Interviews;
import utils.Email;


@WebServlet(name = "ApplicationSeekersController", urlPatterns = {"/applicationSeekers"})
public class ApplicationSeekersController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ApplicationSeekersController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApplicationSeekersController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }


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
        String action = request.getParameter("action");
        action = action != null ? action : "";
        switch (action) {
            case "reject":

                break;
            case "accept":

                break;
            case "viewProfile":
                this.viewProfile(request, response);
                break;
            case "viewCV":
                this.viewCV(request, response);
                break;
            case "viewEducation":
                this.viewEducation(request, response);
                break;
            case "viewWorkExperience":
                this.viewWorkExperience(request, response);
                break;
            default:
                this.getApplicationByJobPost(request, response);
        }
    }

    private void viewWorkExperience(HttpServletRequest request, HttpServletResponse response) {
        try {
            WorkExperienceDAO workDao = new WorkExperienceDAO();
            String accountId = request.getParameter("id");
            List<WorkExperience> workExperience = workDao.findWorkExperiencesbyJobSeekerID(Integer.parseInt(accountId));
            request.setAttribute("WorkExperience", workExperience);
            request.getRequestDispatcher("view/recruiter/workExperienceSeeker.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void viewEducation(HttpServletRequest request, HttpServletResponse response) {
        try {
            EducationDAO eduDao = new EducationDAO();
            String accountId = request.getParameter("id");
            List<Education> educations = eduDao.findEducationbyJobSeekerID(Integer.parseInt(accountId));
            request.setAttribute("educations", educations);
            request.getRequestDispatcher("view/recruiter/educationSeeker.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void viewCV(HttpServletRequest request, HttpServletResponse response) {
        try {
            CVDAO cvDao = new CVDAO();
            String accountId = request.getParameter("id");
            CV cv = cvDao.findCVbyJobSeekerID(Integer.parseInt(accountId));
            if (cv != null) {
                String cvPath[] = cv.getFilePath().split("/");
                String cvPathHandle = "./" + cvPath[2] + "/" + cvPath[3];
                String filePath = cvPathHandle;
                cv.setFilePath(filePath);
                request.setAttribute("cv", cv);
            }
            request.getRequestDispatcher("view/recruiter/cvSeeker.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response) {
        try {
            AccountDAO accountDao = new AccountDAO();
            String accountId = request.getParameter("id");
            Account account = accountDao.findUserById(Integer.parseInt(accountId));
            request.setAttribute("account", account);
            request.getRequestDispatcher("view/recruiter/accountSeeker.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    private void getApplicationByJobPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            ApplicationDAO applicationDao = new ApplicationDAO();
            JobPostingsDAO jp = new JobPostingsDAO();

            String jobPostId = request.getParameter("jobPostId");
            int jobPostIdInt = Integer.parseInt(jobPostId);

            // Nhận tham số tìm kiếm và lọc từ request
            String searchName = request.getParameter("searchName") != null ? request.getParameter("searchName") : "";
            String statusFilter = request.getParameter("statusFilter") != null ? request.getParameter("statusFilter") : "";
            String dateFilter = request.getParameter("dateFilter") != null ? request.getParameter("dateFilter") : "";
            int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int pageSize = 10;

            // Gọi hàm trong DAO để tìm kiếm và lọc ứng dụng
            List<Applications> applications = applicationDao.findApplicationsByFilters(jobPostIdInt, searchName, statusFilter, dateFilter, page, pageSize);
            int totalRecords = applicationDao.countApplicationsByFilters(jobPostIdInt, searchName, statusFilter, dateFilter);

            // Tính toán số trang
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Lấy tiêu đề và trạng thái của JobPost
            String jobPostingTitle = jp.getJobPostingTitleByJobPostingId(jobPostIdInt);
            String jobPostingStatus = jp.findJobPostingStatusByJobPostingId(jobPostIdInt);

            request.setAttribute("jobPostingTitle", jobPostingTitle);
            request.setAttribute("jobPostingStatus", jobPostingStatus);
            request.setAttribute("applications", applications);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

            // Đặt lại các giá trị tìm kiếm và lọc để giữ lại khi chuyển trang
            request.setAttribute("searchName", searchName);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("dateFilter", dateFilter);

            request.getRequestDispatcher("view/recruiter/manageApplications.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ApplicationDAO applicationDao = new ApplicationDAO();
        try {
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            int status = Integer.parseInt(request.getParameter("status"));
            String scheduleRaw = request.getParameter("scheduleAt");
            Timestamp scheduleDate = null;
            if (status == 2) {
                if (scheduleRaw == null || scheduleRaw.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/applicationSeekers?error=scheduleRequired&jobPostId=" + request.getParameter("jobPostId"));
                    return;
                }
                // Expect yyyy-MM-ddTHH:mm from datetime-local; normalize to yyyy-MM-dd HH:mm:ss
                String ts = scheduleRaw.replace('T', ' ');
                if (ts.length() == 16) ts = ts + ":00";
                scheduleDate = Timestamp.valueOf(ts);

                // Server-side validation: not in the past and not more than 1 month ahead
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime max = now.plusMonths(1);
                LocalDateTime chosen = scheduleDate.toLocalDateTime();
                if (chosen.isBefore(now) || chosen.isAfter(max)) {
                    response.sendRedirect(request.getContextPath() + "/applicationSeekers?error=invalidDate&jobPostId=" + request.getParameter("jobPostId"));
                    return;
                }
            }
            String emailContent = request.getParameter("emailContent"); // Nội dung tùy chỉnh từ người dùng

            // Cập nhật trạng thái của đơn xin việc trong cơ sở dữ liệu
            applicationDao.ChangeStatusApplication(applicationId, status);

            Applications application = applicationDao.getDetailApplication(applicationId);
            String applicantEmail = application.getJobSeeker().getAccount().getEmail();

            // Nội dung email mẫu
            String subject = "[Company] Notification about the job you applied for";
            String greeting = "Dear " + application.getJobSeeker().getAccount().getFullName() + ",<br><br>";
            String footer = "<br><br>Best regards,<br>Thank you very much.";

            // Nội dung mẫu cho trúng tuyển và từ chối
            String successContent = "Congratulations! We are pleased to inform you that your application has been successful. "
                    + "Please find the details below:<br><br>";
            String rejectContent = "We regret to inform you that after careful consideration, we have decided not to move forward with your application. "
                    + "We appreciate the time you invested in your application. Please feel free to apply again in the future.<br><br>";

            // Create interview when status is Agree (2)
            Integer createdInterviewId = null;
            if (status == 2) {
                try {
                    dao.JobPostingsDAO jpDao = new dao.JobPostingsDAO();
                    dao.InterviewsDAO ivDao = new dao.InterviewsDAO();
                    int seekerId = application.getJobSeekerID();
                    int recruiterId = jpDao.findJobPostingById(application.getJobPostingID()).getRecruiterID();

                    model.Interviews interview = new model.Interviews();
                    interview.setApplicationID(applicationId);
                    interview.setRecruiterID(recruiterId);
                    interview.setSeekerID(seekerId);
                    interview.setReason(null);
                    interview.setStatus(0); // Pending
                    interview.setScheduleAt(scheduleDate);
                    interview.setCreatedBy(recruiterId);

                    createdInterviewId = ivDao.insert(interview);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            // Chọn nội dung mẫu dựa trên status (trúng tuyển hay bị từ chối)
            String emailBody;
            if (status == 2) { // Giả sử 2 là trúng tuyển
                emailBody = greeting + successContent + emailContent + footer;
            } else if (status == 1) { // Giả sử 1 là từ chối
                emailBody = greeting + rejectContent + emailContent + footer;
            } else {
                emailBody = greeting + emailContent + footer; // Trường hợp khác nếu có
            }

            // Gửi email nếu có email của ứng viên
            // Append schedule info and interview link when Agree
            if (status == 2) {
                String scheduleDisplay = (scheduleRaw != null) ? scheduleRaw.replace('T', ' ') : (scheduleDate != null ? scheduleDate.toString() : "");
                String baseUrl = request.getScheme() + "://" + request.getServerName()
                        + ((request.getServerPort() == 80 || request.getServerPort() == 443) ? "" : ":" + request.getServerPort())
                        + request.getContextPath();
                String interviewLink = (createdInterviewId != null)
                        ? (baseUrl + "/interviews?action=details&id=" + createdInterviewId)
                        : "";
                String scheduleInfo = "<br><strong>Schedule:</strong> " + scheduleDisplay + "<br>";
                String linkInfo = (createdInterviewId != null) ? ("<br><a href=\"" + interviewLink + "\">View Interview Details</a>") : "";
                emailBody = emailBody.replace(footer, scheduleInfo + linkInfo + footer);
            }

            Email email = new Email();
            if (applicantEmail != null && !applicantEmail.isEmpty()) {
                try {
                    email.sendEmail(applicantEmail, subject, emailBody);
                    System.out.println("Email đã được gửi đến " + applicantEmail);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/applicationSeekers?error=emailFailed&jobPostId=" + application.getJobPostingID());
                    return;
                }
            }

            response.sendRedirect(request.getContextPath() + "/applicationSeekers?success=true&jobPostId=" + application.getJobPostingID());

        } catch (Exception e) {
            applicationDao.ChangeStatusApplication(Integer.parseInt(request.getParameter("applicationId")), 3);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
