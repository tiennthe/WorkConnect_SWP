/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.JobPostings;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    AccountDAO accDao = new AccountDAO();
    CompanyDAO companyDao = new CompanyDAO();
    JobPostingsDAO jobPostingDao = new JobPostingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get seeker record
        int totalSeeker = accDao.findAllTotalRecord(3);
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3);
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3);
        //get recruiter record
        int totalRecruiter = accDao.findAllTotalRecord(2);
        int totalRecruiterActive = accDao.findTotalRecordByStatus(true, 2);
        int totalRecruiterInactive = accDao.findTotalRecordByStatus(false, 2);
        //get company record
        int totalCompany = companyDao.findAllTotalRecord();
        int totalCompanyActive = companyDao.findTotalRecordByStatus(true);
        int totalCompanyInactive = companyDao.findTotalRecordByStatus(false);
        //set vao request
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);
        request.setAttribute("totalRecruiter", totalRecruiter);
        request.setAttribute("totalRecruiterActive", totalRecruiterActive);
        request.setAttribute("totalRecruiterInactive", totalRecruiterInactive);
        request.setAttribute("totalCompany", totalCompany);
        request.setAttribute("totalCompanyActive", totalCompanyActive);
        request.setAttribute("totalCompanyInactive", totalCompanyInactive);

        // Sử dụng hàm findTop5Recruiter từ jobPostingDao để lấy danh sách JobPostings
        List<JobPostings> jobPostingsList = jobPostingDao.findTop5Recruiter();

        // Tạo một Map để đếm số lượng bài đăng cho từng RecruiterID
        Map<Integer, Integer> recruiterPostCount = new HashMap<>();

        for (JobPostings posting : jobPostingsList) {
            int recruiterId = posting.getRecruiterID();
            recruiterPostCount.put(recruiterId, recruiterPostCount.getOrDefault(recruiterId, 0) + 1);
        }
        // Đưa recruiterPostCount vào request scope để JSP có thể sử dụng
        request.setAttribute("recruiterPostCount", recruiterPostCount);

        // Khởi tạo JobPostingDAO và lấy danh sách JobPostings
        JobPostingsDAO jobPostingDao = new JobPostingsDAO();
        List<JobPostings> jobPostingsListFilter = jobPostingDao.filterJobPostingStatusForChart();

        // Đếm số lượng job postings theo từng trạng thái
        Map<String, Integer> jobPostingStatusData = new HashMap<>();
        jobPostingStatusData.put("Open", 0);
        jobPostingStatusData.put("Closed", 0);
        jobPostingStatusData.put("Violate", 0);

        for (JobPostings jobPosting : jobPostingsListFilter) {
            String status = jobPosting.getStatus(); // Giả sử hàm getStatus() trả về chuỗi "Open", "Closed", hoặc "Violate"
            jobPostingStatusData.put(status, jobPostingStatusData.getOrDefault(status, 0) + 1);
        }

        // Đặt dữ liệu vào request attribute để chuyển tới JSP
        request.setAttribute("jobPostingStatusData", jobPostingStatusData);
        //chuyen trang
        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get seeker record
        int totalSeeker = accDao.findAllTotalRecord(3);
        int totalSeekerActive = accDao.findTotalRecordByStatus(true, 3);
        int totalSeekerInactive = accDao.findTotalRecordByStatus(false, 3);
        //get recruiter record
        int totalRecruiter = accDao.findAllTotalRecord(2);
        int totalRecruiterActive = accDao.findTotalRecordByStatus(true, 2);
        int totalRecruiterInactive = accDao.findTotalRecordByStatus(false, 2);
        //get company record
        int totalCompany = companyDao.findAllTotalRecord();
        int totalCompanyActive = companyDao.findTotalRecordByStatus(true);
        int totalCompanyInactive = companyDao.findTotalRecordByStatus(false);
        //set vao request
        request.setAttribute("totalSeeker", totalSeeker);
        request.setAttribute("totalSeekerActive", totalSeekerActive);
        request.setAttribute("totalSeekerInactive", totalSeekerInactive);
        request.setAttribute("totalRecruiter", totalRecruiter);
        request.setAttribute("totalRecruiterActive", totalRecruiterActive);
        request.setAttribute("totalRecruiterInactive", totalRecruiterInactive);
        request.setAttribute("totalCompany", totalCompany);
        request.setAttribute("totalCompanyActive", totalCompanyActive);
        request.setAttribute("totalCompanyInactive", totalCompanyInactive);

        // Sử dụng hàm findTop5Recruiter từ jobPostingDao để lấy danh sách JobPostings
        List<JobPostings> jobPostingsList = jobPostingDao.findTop5Recruiter();

        // Tạo một Map để đếm số lượng bài đăng cho từng RecruiterID
        Map<Integer, Integer> recruiterPostCount = new HashMap<>();

        for (JobPostings posting : jobPostingsList) {
            int recruiterId = posting.getRecruiterID();
            recruiterPostCount.put(recruiterId, recruiterPostCount.getOrDefault(recruiterId, 0) + 1);
        }

        // Đưa recruiterPostCount vào request scope để JSP có thể sử dụng
        request.setAttribute("recruiterPostCount", recruiterPostCount);

        // Khởi tạo JobPostingDAO và lấy danh sách JobPostings
        JobPostingsDAO jobPostingDao = new JobPostingsDAO();
        List<JobPostings> jobPostingsListFilter = jobPostingDao.filterJobPostingStatusForChart();

        // Đếm số lượng job postings theo từng trạng thái
        Map<String, Integer> jobPostingStatusData = new HashMap<>();
        jobPostingStatusData.put("Open", 0);
        jobPostingStatusData.put("Closed", 0);
        jobPostingStatusData.put("Violate", 0);

        for (JobPostings jobPosting : jobPostingsListFilter) {
            String status = jobPosting.getStatus(); // Giả sử hàm getStatus() trả về chuỗi "Open", "Closed", hoặc "Violate"
            jobPostingStatusData.put(status, jobPostingStatusData.getOrDefault(status, 0) + 1);
        }

        // Đặt dữ liệu vào request attribute để chuyển tới JSP
        request.setAttribute("jobPostingStatusData", jobPostingStatusData);
        //chuyen trang
        request.getRequestDispatcher("view/admin/adminHome.jsp").forward(request, response);
    }

}