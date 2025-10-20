package controller.recruiter;

import constant.CommonConst;
import dao.ApplicationDAO;
import dao.CompanyDAO;
import dao.JobPostingsDAO;
import dao.JobSeekerDAO;
import dao.Job_Posting_CategoryDAO;
import dao.RecruitersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Company;
import model.JobPostings;
import model.Job_Posting_Category;
import model.Recruiters;
import validate.Validation;

@WebServlet(name = "JobPost", urlPatterns = {"/jobPost"})
public class JobPost extends HttpServlet {

    JobPostingsDAO dao = new JobPostingsDAO();
    RecruitersDAO recruitersDAO = new RecruitersDAO();
    Validation valid = new Validation();
    Job_Posting_CategoryDAO category = new Job_Posting_CategoryDAO();
    CompanyDAO cdao = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            // If user is not logged in, redirect to login
            response.sendRedirect("view/authen/login.jsp");
            return;
        }

        // Fetch the recruiter info using the account ID
        Recruiters recruiters = recruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
        //JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (recruiters == null) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
            dispatcher.forward(request, response);
        } else {
            Company company = cdao.findCompanyById(recruiters.getCompanyID());
            if (company == null || !company.isVerificationStatus() || !recruiters.isIsVerify()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/verifyRecruiter.jsp");
                dispatcher.forward(request, response);
            } else {
                // Lấy tham số tìm kiếm và phân trang từ request
                String searchJP = request.getParameter("searchJP") != null ? request.getParameter("searchJP") : "";
                String sortField = request.getParameter("sort") != null ? request.getParameter("sort") : "JobPostingID";
                int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int pageSize = 10;  // Số lượng bản ghi trên mỗi trang

                List<JobPostings> jobList;
                int totalRecords;

                // Kiểm tra nếu có từ khóa tìm kiếm
                if (!searchJP.isEmpty()) {
                    // Gọi DAO method để tìm kiếm và phân trang
                    jobList = dao.searchJobPostingByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID(), page);
                    totalRecords = dao.findTotalRecordByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID());  // Đếm tổng kết quả tìm kiếm
                    if (jobList.isEmpty()) {
                        request.setAttribute("NoJP", "No found");
                    }
                } else {
                    // Nếu không có từ khóa tìm kiếm, lấy tất cả dữ liệu và phân trang
                    jobList = dao.findJobPostingsWithFilterAndRecruiterID(sortField, recruiters.getRecruiterID(), page, pageSize);
                    totalRecords = dao.countTotalJobPostingsByRecruiterID(recruiters.getRecruiterID());  // Đếm tổng số bản ghi
                }

                // Tính toán tổng số trang
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                // Lấy danh sách tất cả các Application liên quan đến JobPostings của recruiter
                // Gửi các thông tin cần thiết về JSP
                request.setAttribute("listJobPosting", jobList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
                request.setAttribute("sortField", sortField);
                request.setAttribute("searchJP", searchJP);  // Để giữ lại từ khóa tìm kiếm khi phân trang

                // Chuyển hướng đến trang quản lý Job Posting
                RequestDispatcher dispatcher = request.getRequestDispatcher("/view/recruiter/jobPost-manager.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "add-jp":
                url = addJobPosting(request, response);
                break;
            case "updateJobPost":
                url = updateJP(request, response);
                break;
            default:
                url = "view/recruiter/jobPost-manager.jsp";
                break;
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private String addJobPosting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp";
        }

        Recruiters recruiters = recruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
        if (recruiters == null) {
            return "view/authen/login.jsp";
        }

        try {
            // Lấy các tham số từ request
            String jobTitle = request.getParameter("jobTitle");
            String jobDescription = request.getParameter("jobDescription");
            String jobRequirements = request.getParameter("jobRequirements");
            String jobLocation = request.getParameter("jobLocation");
            double minSalary = Double.parseDouble(request.getParameter("minSalary"));
            double maxSalary = Double.parseDouble(request.getParameter("maxSalary"));
            String jobStatus = request.getParameter("jobStatus");
            Date postedDate = Date.valueOf(request.getParameter("postedDate"));
            Date closingDate = Date.valueOf(request.getParameter("closingDate"));
            String jobCategory = request.getParameter("jobCategory"); // Lấy giá trị từ danh sách có sẵn

            // Lưu lại lựa chọn khi có lỗi
            request.setAttribute("selectedJobCategory", jobCategory);

            // Lấy danh sách job categories từ cơ sở dữ liệu
            List<Job_Posting_Category> jobCategories = category.findAll();
            request.setAttribute("jobCategories", jobCategories);

            // Đặt lại dữ liệu form để giữ lại thông tin đã nhập khi có lỗi
            request.setAttribute("jobTitle", jobTitle);
            request.setAttribute("jobDescription", jobDescription);
            request.setAttribute("jobRequirements", jobRequirements);
            request.setAttribute("jobLocation", jobLocation);
            request.setAttribute("minSalary", minSalary);
            request.setAttribute("maxSalary", maxSalary);
            request.setAttribute("postedDate", postedDate);
            request.setAttribute("closingDate", closingDate);
            request.setAttribute("jobStatus", jobStatus);

            List<String> erMess = new ArrayList<>();

            // Xác thực dữ liệu đầu vào
            if (jobCategory == null || jobCategory.trim().isEmpty()) {
                erMess.add("Please select a job category.");
            }

            JobPostings jobPost = new JobPostings();
            int jobCategoryId = Integer.parseInt(jobCategory); // Sử dụng jobCategory đã chọn
            jobPost.setJob_Posting_CategoryID(jobCategoryId);

            jobPost.setRecruiterID(recruiters.getRecruiterID());
            jobPost.setTitle(jobTitle);
            jobPost.setDescription(jobDescription);
            jobPost.setRequirements(jobRequirements);
            jobPost.setLocation(jobLocation);
            jobPost.setMinSalary(minSalary);
            jobPost.setMaxSalary(maxSalary);
            jobPost.setStatus(jobStatus);
            jobPost.setPostedDate(postedDate);
            jobPost.setClosingDate(closingDate);

            // Thêm các thông báo lỗi nếu có
            if (!valid.checkAtLeast30Chars(jobDescription)) {
                erMess.add("Description too short");
            }
            if (!valid.checkAtLeast30Chars(jobRequirements)) {
                erMess.add("Requirements too short");
            }
            if (!valid.isValidDateRange(postedDate) || !valid.isValidDateRange(closingDate)) {
                erMess.add("Date must be between 1990 and 2500");
            }
            if (!valid.isStartDateBeforeEndDate(postedDate, closingDate)) {
                erMess.add("Closing date must be after posting date");
            }
            if (!valid.isToday(postedDate)) {
                erMess.add("Post date must be the current date");
            }
            if (!valid.isValidSalary(minSalary) || !valid.isValidSalary(maxSalary) || !valid.isMaxSalaryGreaterThanMin(maxSalary, minSalary)) {
                erMess.add("Invalid salary range");
            }

            // Nếu có lỗi, chuyển hướng về trang thêm với thông báo lỗi
            if (!erMess.isEmpty()) {
                request.setAttribute("erMess", erMess);
                url = "view/recruiter/addJobPosting.jsp";
            } else {
                // Nếu hợp lệ, lưu bài đăng vào cơ sở dữ liệu
                dao.insert(jobPost);

                // Phân trang cho danh sách bài đăng
                String searchJP = request.getParameter("searchJP") != null ? request.getParameter("searchJP") : "";
                String sortField = request.getParameter("sort") != null ? request.getParameter("sort") : "JobPostingID";
                int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int pageSize = 10;

                List<JobPostings> jobList;
                int totalRecords;

                if (!searchJP.isEmpty()) {
                    jobList = dao.searchJobPostingByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID(), page);
                    totalRecords = dao.findTotalRecordByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID());
                } else {
                    jobList = dao.findJobPostingsWithFilterAndRecruiterID(sortField, recruiters.getRecruiterID(), page, pageSize);
                    totalRecords = dao.countTotalJobPostingsByRecruiterID(recruiters.getRecruiterID());
                }

                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
                request.setAttribute("listJobPosting", jobList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
                request.setAttribute("sortField", sortField);
                request.setAttribute("searchJP", searchJP);

                // Chuyển hướng đến trang quản lý bài đăng
                //url = "view/recruiter/jobPost-manager.jsp";
                url = "view/recruiter/jobPost-manager.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erMess", "An error occurred while adding the job posting.");
            url = "view/recruiter/addJobPosting.jsp";
        }
        return url;
    }

    private String updateJP(HttpServletRequest request, HttpServletResponse response) {
        String url;
        int idJP = Integer.parseInt(request.getParameter("JobPostingID"));

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) {
            return "view/authen/login.jsp";
        }

        Recruiters recruiters = recruitersDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
        if (recruiters == null) {
            return "view/authen/login.jsp";
        }

        // Lấy thông tin bài đăng từ DAO
        JobPostings jobPost = dao.findJobPostingById(idJP);
        request.setAttribute("selectedJobCategory", jobPost.getJob_Posting_CategoryID());

        // Lấy các tham số từ form
        String jobTitle = request.getParameter("jobTitle");
        String jobDescription = request.getParameter("jobDescription");
        String jobRequirements = request.getParameter("jobRequirements");
        String jobLocation = request.getParameter("jobLocation");
        double minSalary = Double.parseDouble(request.getParameter("minSalary"));
        double maxSalary = Double.parseDouble(request.getParameter("maxSalary"));
        String jobStatus = request.getParameter("jobStatus");
        Date postedDate = Date.valueOf(request.getParameter("postedDate"));
        Date closingDate = Date.valueOf(request.getParameter("closingDate"));

        // Lấy giá trị cho jobCategory
        String jobCategoryIdStr = request.getParameter("jobCategory");
        int jobCategoryId = Integer.parseInt(jobCategoryIdStr);
        jobPost.setJob_Posting_CategoryID(jobCategoryId);

        // Lấy danh sách các danh mục từ cơ sở dữ liệu và đặt vào request
        List<Job_Posting_Category> jobCategories = category.findAll();
        request.setAttribute("jobCategories", jobCategories);
        request.setAttribute("selectedJobCategory", jobCategoryIdStr);

        // Cập nhật thông tin jobPost
        jobPost.setRecruiterID(recruiters.getRecruiterID());
        jobPost.setTitle(jobTitle);
        jobPost.setDescription(jobDescription);
        jobPost.setRequirements(jobRequirements);
        jobPost.setLocation(jobLocation);
        jobPost.setMinSalary(minSalary);
        jobPost.setMaxSalary(maxSalary);
        jobPost.setStatus(jobStatus);
        jobPost.setPostedDate(postedDate);
        jobPost.setClosingDate(closingDate);

        // Kiểm tra và lưu các lỗi nếu có
        List<String> erMess = new ArrayList<>();
        if (!valid.checkAtLeast30Chars(jobDescription)) {
            erMess.add("Description too short");
        }
        if (!valid.checkAtLeast30Chars(jobRequirements)) {
            erMess.add("Requirements too short");
        }
        if (!valid.isValidDateRange(postedDate) || !valid.isValidDateRange(closingDate)) {
            erMess.add("Date must be between 1990 and 2500");
        }
        if (!valid.isStartDateBeforeEndDate(postedDate, closingDate)) {
            erMess.add("Closing date must be after posting date");
        }
        if (!valid.isValidSalary(minSalary) || !valid.isValidSalary(maxSalary) || !valid.isMaxSalaryGreaterThanMin(maxSalary, minSalary)) {
            erMess.add("Invalid salary range");
        }
        if (!valid.isToday(postedDate)) {
            erMess.add("Post date must be the current date");
        }

        if (!erMess.isEmpty()) {
            // Truyền danh sách lỗi và dữ liệu hiện có về lại trang editJP.jsp
            request.setAttribute("eM", erMess);
            request.setAttribute("jobTitle", jobTitle);
            request.setAttribute("jobDescription", jobDescription);
            request.setAttribute("jobRequirements", jobRequirements);
            request.setAttribute("jobLocation", jobLocation);
            request.setAttribute("minSalary", minSalary);
            request.setAttribute("maxSalary", maxSalary);
            request.setAttribute("postedDate", postedDate);
            request.setAttribute("closingDate", closingDate);
            request.setAttribute("jobStatus", jobStatus);
            url = "view/recruiter/editJP.jsp";
        } else {
            dao.updateJobPosting(jobPost);
            int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            String sortField = request.getParameter("sort") != null ? request.getParameter("sort") : "JobPostingID";
            String searchJP = request.getParameter("searchJP") != null ? request.getParameter("searchJP") : "";
            int pageSize = 10;

            List<JobPostings> listJobPosting;
            int totalRecords;

            if (!searchJP.isEmpty()) {
                listJobPosting = dao.searchJobPostingByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID(), page);
                totalRecords = dao.findTotalRecordByTitleAndRecruiterID(searchJP, recruiters.getRecruiterID());
            } else {
                listJobPosting = dao.findJobPostingsWithFilterAndRecruiterID(sortField, recruiters.getRecruiterID(), page, pageSize);
                totalRecords = dao.countTotalJobPostingsByRecruiterID(recruiters.getRecruiterID());
            }

            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            request.setAttribute("listJobPosting", listJobPosting);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("sortField", sortField);
            request.setAttribute("searchJP", searchJP);

            url = "view/recruiter/jobPost-manager.jsp";
        }

        return url;
    }

}