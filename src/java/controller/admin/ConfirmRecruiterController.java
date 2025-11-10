package controller.admin;

import dao.AccountDAO;
import dao.RecruitersDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Recruiters;
import utils.Email;

@WebServlet(name = "ConfirmRecruiterController", urlPatterns = {"/confirm"})
public class ConfirmRecruiterController extends HttpServlet {

    private static final RecruitersDAO dao = new RecruitersDAO(); // DAO thao tác bảng Recruiters

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Recruiters> listConfirm = null; // Danh sách các recruiter chờ xác nhận
        String url = "view/admin/confirmRecruiter.jsp"; // Trang JSP hiển thị danh sách

        // Lấy thông báo notice nếu có (ví dụ sau khi POST xử lý)
        String notice = request.getParameter("notice") != null ? request.getParameter("notice") : "";

        // Lấy giá trị search từ thanh search
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";

        // Nếu có searchQuery thì tìm theo tên, ngược lại lấy tất cả
        if (!searchQuery.isEmpty()) {
            listConfirm = dao.searchByName(searchQuery);
        } else {
            listConfirm = dao.findAll();
        }

        // Đưa dữ liệu và thông báo lên request
        request.setAttribute("listConfirm", listConfirm);
        request.setAttribute("notice", notice);

        // Forward sang JSP hiển thị
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy action từ request (confirm hoặc reject)
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "confirm":
                // Xác nhận recruiter
                url = confirm(request, response);
                break;
            case "reject":
                // Từ chối recruiter
                url = reject(request, response);
                break;
            default:
                throw new AssertionError(); // Nếu action không hợp lệ
        }

        // Redirect về trang danh sách sau khi xử lý
        response.sendRedirect(url);
    }

    // Xác nhận recruiter và gửi email thông báo
    private String confirm(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            AccountDAO accountDao = new AccountDAO(); // DAO để lấy email tài khoản
            String recruiterId = request.getParameter("recruiterId"); // Lấy id recruiter từ request

            // Lấy recruiter theo id để lấy accountID
            Recruiters recruiter = dao.findById(recruiterId);
            Account accountFound = accountDao.findUserById(recruiter.getAccountID());

            // Tạo nội dung email thông báo đã được xác nhận
            String subject = "Your Recruiter Request Has Been Approved";
            String content = "Dear " + accountFound.getFullName() + ",\n"
                    + "\n"
                    + "Chúng tôi vui mừng thông báo rằng yêu cầu trở thành recruiter của bạn đã được chấp thuận. Bạn có thể sử dụng các tính năng tuyển dụng để quản lý tin tuyển dụng và tìm ứng viên.\n"
                    + "\n"
                    + "Cảm ơn bạn đã lựa chọn nền tảng của chúng tôi.\n"
                    + "Best regards,";

            // Gửi email
            Email.sendEmail(accountFound.getEmail(), subject, content);

            // Cập nhật trạng thái recruiter là đã xác nhận
            dao.updateVerification(recruiterId, true);

        } catch (MessagingException ex) {
            // Nếu lỗi gửi email
            return "confirm?notice=" + URLEncoder.encode("Exist error in send email and confirm process!!", "UTF-8");
        }

        // Trả về URL kèm thông báo thành công
        return "confirm?notice=" + URLEncoder.encode("Send email and confirm recruiter successfully!!", "UTF-8");
    }

    // Từ chối recruiter và gửi email thông báo
    private String reject(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            AccountDAO accountDao = new AccountDAO();
            String recruiterId = request.getParameter("recruiterId");

            // Lấy recruiter theo id để lấy accountID
            Recruiters recruiter = dao.findById(recruiterId);
            Account accountFound = accountDao.findUserById(recruiter.getAccountID());

            // Tạo nội dung email thông báo từ chối
            String subject = "Your Recruiter Request on Our Platform";
            String content = "Dear " + accountFound.getFullName() + ",\n"
                    + "\n"
                    + "Cảm ơn bạn đã quan tâm trở thành recruiter. Sau khi xem xét, yêu cầu của bạn chưa đủ điều kiện để được chấp thuận.\n"
                    + "\n"
                    + "Nếu có thắc mắc hoặc cần giải thích thêm, vui lòng liên hệ chúng tôi.\n"
                    + "Sincerely";

            // Gửi email
            Email.sendEmail(accountFound.getEmail(), subject, content);

            // Xóa recruiter khỏi cơ sở dữ liệu
            dao.deleteRecruiter(recruiterId);

        } catch (MessagingException ex) {
            // Nếu lỗi gửi email
            return "confirm?notice=" + URLEncoder.encode("Exist error in send email and reject process!!", "UTF-8");
        }

        // Trả về URL kèm thông báo thành công
        return "confirm?notice=" + URLEncoder.encode("Send email and reject recruiter successfully!!", "UTF-8");
    }

}
