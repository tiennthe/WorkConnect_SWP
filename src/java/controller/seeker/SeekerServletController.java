package controller.seeker;

import constant.CommonConst;
import dao.JobSeekerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.JobSeekers;

@WebServlet(name = "SeekerServletController", urlPatterns = {"/seeker"})
public class SeekerServletController extends HttpServlet {

    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get action parameter
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        // Handle GET requests based on the action
        switch (action) {
            case "join-job-seeking":
                url = "JobSeekerCheck";
                break;

//            case "checkJobSeeker":
//                url = checkJobSeeker(request);
//                break;

            default:
                url = "view/authen/login.jsp"; // Default page if no action matches
                break;
        }

        // Forward to the appropriate page
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get action parameter
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        // Handle POST requests based on the action
        switch (action) {
            case "join-job-seeking":
                url = joinJobSeeking(request);
                break;

//            case "checkJobSeeker":
//                url = checkJobSeeker(request);
//                break;

            default:
                url = "JobSeekerCheck"; // Default URL if no action matches
        }

        // Forward to the appropriate page
        response.sendRedirect(url);
    }

    // Bật chức năng tìm việc để ghi vào DB JobSeeker
    private String joinJobSeeking(HttpServletRequest request) {
        String url = null;

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        // Log để kiểm tra Account có được nhận từ session không
        if (account == null) {
            System.out.println("Account is null. User might not be logged in.");
            request.setAttribute("error", "Unable to join job seeking. Please log in first.");
            url= "view/authen/login.jsp";
        }

        int accountId = account.getId();
        request.setAttribute("accountid", accountId);

        // Kiểm tra việc tạo đối tượng JobSeeker
        JobSeekers jobSeeker = new JobSeekers();
        jobSeeker.setAccountID(accountId);

        try {
            // Kiểm tra xem có lỗi trong khi chèn dữ liệu vào DB không
            jobSeekerDAO.insert(jobSeeker);
            System.out.println("Job seeker inserted successfully with AccountID: " + accountId);
            request.setAttribute("joinsuccess", "Confirmed! You have successfully joined Job Seeking.");
            url = "JobSeekerCheck";
        } catch (Exception e) {
            // Log ngoại lệ khi xảy ra lỗi
            System.out.println("Error inserting job seeker: " + e.getMessage());
            request.setAttribute("joinerror", "Failed to join job seeking. Please try again later.");
        }

        return url;
    }
    
    //Nhap CV
    
    
    //Nhap thong tin hoc van
    
    
    //Nhap thong tin so thich
}