package controller.admin;

import dao.AccountDAO;
import dao.CompanyDAO;
import dao.JobPostingsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.JobPostings;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    // Khởi tạo các DAO để truy xuất dữ liệu từ DB
    AccountDAO accDao = new AccountDAO();
    CompanyDAO companyDao = new CompanyDAO();
    JobPostingsDAO jobPostingDao = new JobPostingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Lấy số liệu thống kê cho Seeker 
        int totalSeeker = accDao.findAllTotalRecord(3); // Tổng số seeker
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3); // Số seeker active
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3); // Số seeker inactive

        // Lấy số liệu thống kê cho Recruiter 
        int totalRecruiter = accDao.findAllTotalRecord(2); // Tổng số recruiter
        int totalRecruiterActive = accDao.findTotalRecordByStatus(true, 2); // Số recruiter active
        int totalRecruiterInactive = accDao.findTotalRecordByStatus(false, 2); // Số recruiter inactive

        // Lấy số liệu thống kê cho Company 
        int totalCompany = companyDao.findAllTotalRecord(); // Tổng số công ty
        int totalCompanyActive = companyDao.findTotalRecordByStatus(true); // Công ty active
        int totalCompanyInactive = companyDao.findTotalRecordByStatus(false); // Công ty inactive

        // Đưa số liệu lên request để hiển thị trên JSP
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);
        request.setAttribute("totalRecruiter", totalRecruiter);
        request.setAttribute("totalRecruiterActive", totalRecruiterActive);
        request.setAttribute("totalRecruiterInactive", totalRecruiterInactive);
        request.setAttribute("totalCompany", totalCompany);
        request.setAttribute("totalCompanyActive", totalCompanyActive);
        request.setAttribute("totalCompanyInactive", totalCompanyInactive);

        // Lấy danh sách 5 recruiter có nhiều job postings nhất 
        List<JobPostings> jobPostingsList = jobPostingDao.findTop5Recruiter();

        // Tạo Map để đếm số lượng bài đăng cho từng recruiter
        Map<Integer, Integer> recruiterPostCount = new HashMap<>();
        for (JobPostings posting : jobPostingsList) {
            int recruiterId = posting.getRecruiterID();
            recruiterPostCount.put(recruiterId, recruiterPostCount.getOrDefault(recruiterId, 0) + 1);
        }
        // Đưa Map này lên request để hiển thị trên JSP
        request.setAttribute("recruiterPostCount", recruiterPostCount);

        // Lấy dữ liệu để vẽ biểu đồ job posting theo trạng thái
        List<JobPostings> jobPostingsListFilter = jobPostingDao.filterJobPostingStatusForChart();

        // Khởi tạo Map để đếm số lượng theo trạng thái: Open, Closed, Violate
        Map<String, Integer> jobPostingStatusData = new HashMap<>();
        jobPostingStatusData.put("Open", 0);
        jobPostingStatusData.put("Closed", 0);
        jobPostingStatusData.put("Violate", 0);

        // Đếm số lượng job postings theo từng trạng thái
        for (JobPostings jobPosting : jobPostingsListFilter) {
            String status = jobPosting.getStatus(); // Trạng thái "Open", "Closed", "Violate"
            jobPostingStatusData.put(status, jobPostingStatusData.getOrDefault(status, 0) + 1);
        }

        // Đưa dữ liệu biểu đồ lên request để JSP sử dụng
        request.setAttribute("jobPostingStatusData", jobPostingStatusData);

        // Chuyển hướng sang trang Dashboard Admin
        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // POST ở đây cũng làm giống GET (lấy số liệu thống kê) để khi submit form vẫn giữ dữ liệu
        // Lấy số liệu thống kê cho Seeker 
        int totalSeeker = accDao.findAllTotalRecord(3);
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3);
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3);

        //  Lấy số liệu thống kê cho Recruiter 
        int totalRecruiter = accDao.findAllTotalRecord(2);
        int totalRecruiterActive = accDao.findTotalRecordByStatus(true, 2);
        int totalRecruiterInactive = accDao.findTotalRecordByStatus(false, 2);

        // Lấy số liệu thống kê cho Company
        int totalCompany = companyDao.findAllTotalRecord();
        int totalCompanyActive = companyDao.findTotalRecordByStatus(true);
        int totalCompanyInactive = companyDao.findTotalRecordByStatus(false);

        // Đưa số liệu lên request
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);
        request.setAttribute("totalRecruiter", totalRecruiter);
        request.setAttribute("totalRecruiterActive", totalRecruiterActive);
        request.setAttribute("totalRecruiterInactive", totalRecruiterInactive);
        request.setAttribute("totalCompany", totalCompany);
        request.setAttribute("totalCompanyActive", totalCompanyActive);
        request.setAttribute("totalCompanyInactive", totalCompanyInactive);

        //Top 5 recruiter có nhiều job postings nhất 
        List<JobPostings> jobPostingsList = jobPostingDao.findTop5Recruiter();
        Map<Integer, Integer> recruiterPostCount = new HashMap<>();
        for (JobPostings posting : jobPostingsList) {
            int recruiterId = posting.getRecruiterID();
            recruiterPostCount.put(recruiterId, recruiterPostCount.getOrDefault(recruiterId, 0) + 1);
        }
        request.setAttribute("recruiterPostCount", recruiterPostCount);

        // Biểu đồ job postings theo trạng thái 
        List<JobPostings> jobPostingsListFilter = jobPostingDao.filterJobPostingStatusForChart();
        Map<String, Integer> jobPostingStatusData = new HashMap<>();
        jobPostingStatusData.put("Open", 0);
        jobPostingStatusData.put("Closed", 0);
        jobPostingStatusData.put("Violate", 0);

        for (JobPostings jobPosting : jobPostingsListFilter) {
            String status = jobPosting.getStatus();
            jobPostingStatusData.put(status, jobPostingStatusData.getOrDefault(status, 0) + 1);
        }
        request.setAttribute("jobPostingStatusData", jobPostingStatusData);

        // Forward sang Dashboard
        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }
}
