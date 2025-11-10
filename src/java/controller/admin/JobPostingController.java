package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import dao.JobPostingsDAO;
import dao.Job_Posting_CategoryDAO;
import dao.RecruitersDAO;
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
import model.JobPostings;
import model.Job_Posting_Category;
import model.PageControl;
import model.Recruiters;
import utils.Email;

@WebServlet(name = "JobPostingController", urlPatterns = {"/job_posting"})
public class JobPostingController extends HttpServlet {

    // Khởi tạo các DAO
    JobPostingsDAO jobPostingsDAO = new JobPostingsDAO();
    RecruitersDAO reDao = new RecruitersDAO();
    AccountDAO accDao = new AccountDAO();
    Job_Posting_CategoryDAO cateDao = new Job_Posting_CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ---------- Lấy thông báo từ URL nếu có ----------
        String success = request.getParameter("success") != null ? request.getParameter("success") : "";
        String error = request.getParameter("error") != null ? request.getParameter("error") : "";
        String duplicate = request.getParameter("duplicate") != null ? request.getParameter("duplicate") : "";
        String duplicateEdit = request.getParameter("duplicateEdit") != null ? request.getParameter("duplicateEdit") : "";
        request.setAttribute("success", success);
        request.setAttribute("error", error);
        request.setAttribute("duplicate", duplicate);
        request.setAttribute("duplicateEdit", duplicateEdit);

        // ---------- Xử lý phân trang ----------
        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        int page;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) {
                page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // ---------- Lấy tham số filter và search từ JSP ----------
        String requestURL = request.getRequestURL().toString();
        String status = request.getParameter("filterStatus") != null ? request.getParameter("filterStatus") : "";
        String salaryRange = request.getParameter("filterSalary") != null ? request.getParameter("filterSalary") : "";
        String postDate = request.getParameter("filterDate") != null ? request.getParameter("filterDate") : "";
        String search = request.getParameter("search") != null ? request.getParameter("search") : "";

        // ---------- Lấy danh sách job postings theo filter và search ----------
        List<JobPostings> jobPostingsList = jobPostingsDAO.findAndfilterJobPostings(status, salaryRange, postDate, search, page);
        int totalRecord = jobPostingsDAO.findAndfilterAllRecord(status, salaryRange, postDate, search);

        // ---------- Cấu hình phân trang ----------
        pageControl.setUrlPattern(requestURL + "?filterStatus=" + status + "&filterSalary="
                + salaryRange + "&search=" + search + "&");
        request.setAttribute("jobPostingsList", jobPostingsList);
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0 ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE) + 1;
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        request.setAttribute("pageControl", pageControl);

        // ---------- Lấy danh sách các category job posting ----------
        List<Job_Posting_Category> listCate = cateDao.findAll();
        request.setAttribute("categoryList", listCate);

        // Chuyển sang trang quản lý job postings
        request.getRequestDispatcher("view/admin/jobPostManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String url = "";
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        // Xử lý các action POST
        switch (action) {
            case "violate": // Xử lý vi phạm job posting
                url = violateJobPosting(request);
                break;
            case "editCate": // Chỉnh sửa category
                url = editCategory(request);
                break;
            case "deleteCate": // Xóa category
                url = deleteCategory(request);
                break;
            case "addCate": // Thêm category
                url = addCategory(request);
                break;
            case "view": // Xem chi tiết job posting
                url = viewJobPosting(request);
                request.getRequestDispatcher(url).forward(request, response);
                return;
            default:
                url = "job_posting";
        }

        response.sendRedirect(url);
    }

    // ---------- Vi phạm Job Posting và gửi email ----------
    private String violateJobPosting(HttpServletRequest request) throws UnsupportedEncodingException {
        String url = "";
        try {
            int jobPostId = Integer.parseInt(request.getParameter("jobPostID"));
            JobPostings jobPost = jobPostingsDAO.findJobPostingById(jobPostId);
            int recruiterId = jobPost.getRecruiterID();
            Recruiters recruiters = reDao.findById(String.valueOf(recruiterId));
            Account account = accDao.findUserById(recruiters.getAccountID());
            String subject = "Job Posting Suspension Notice";
            String content = request.getParameter("response"); // Lấy nội dung email từ form
            Email.sendEmail(account.getEmail(), subject, content);
            jobPostingsDAO.violateJobPost(jobPostId);
            url = "job_posting?success=" + URLEncoder.encode("Violate job post and send email successfully!!", "UTF-8");
        } catch (MessagingException ex) {
            url = "job_posting?error=" + URLEncoder.encode("Have error in process violate job post and send email!!", "UTF-8");
        }
        return url;
    }

    // ---------- Xem chi tiết Job Posting ----------
    private String viewJobPosting(HttpServletRequest request) {
        int jobPostId = Integer.parseInt(request.getParameter("jobPostID"));
        JobPostings jobPost = jobPostingsDAO.findJobPostingById(jobPostId);
        request.setAttribute("jobPost", jobPost);
        return "view/admin/detailJobPosting.jsp";
    }

    // ---------- Chỉnh sửa Category ----------
    private String editCategory(HttpServletRequest request) throws UnsupportedEncodingException {
        String url = "";
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String nameCate = request.getParameter("newCategoryName");
        // Kiểm tra trùng tên với các category khác
        if (cateDao.checkDuplicateOther(categoryId, nameCate)) {
            url = "job_posting?duplicateEdit=" + URLEncoder.encode("This category is existed!!", "UTF-8");
        } else {
            cateDao.editCategory(categoryId, nameCate);
            url = "job_posting";
        }
        return url;
    }

    // ---------- Xóa Category ----------
    private String deleteCategory(HttpServletRequest request) {
        String categoryId = request.getParameter("categoryId");
        cateDao.delete(categoryId);
        return "job_posting";
    }

    // ---------- Thêm Category ----------
    private String addCategory(HttpServletRequest request) throws UnsupportedEncodingException {
        String url = "";
        String nameCate = request.getParameter("cateName");
        Job_Posting_Category jobPostCate = new Job_Posting_Category();
        jobPostCate.setName(nameCate);
        // Kiểm tra trùng tên
        if (cateDao.checkDuplicateName(nameCate)) {
            url = "job_posting?duplicate=" + URLEncoder.encode("This category is existed!!", "UTF-8");
        } else {
            cateDao.insert(jobPostCate);
            url = "job_posting";
        }
        return url;
    }
}
