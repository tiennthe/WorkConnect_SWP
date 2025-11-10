package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import dao.CompanyDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import model.Account;
import model.Company;
import model.PageControl;
import utils.Email;

@MultipartConfig // Cho phép xử lý upload file
@WebServlet(name = "CompanyAdminController", urlPatterns = {"/companies"})
public class CompanyAdminController extends HttpServlet {

    CompanyDAO dao = new CompanyDAO(); // DAO để thao tác dữ liệu công ty
    AccountDAO accDao = new AccountDAO(); // DAO để thao tác dữ liệu tài khoản

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông báo notice (nếu có) từ request sau khi xử lý POST
        String notice = request.getParameter("notice") != null ? request.getParameter("notice") : "";
        request.setAttribute("notice", notice);

        // Lấy số trang từ request
        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        int page;
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) {
                page = 1; // Nếu page <= 1 thì mặc định là 1
            }
        } catch (NumberFormatException e) {
            page = 1; // Nếu không parse được thì mặc định là 1
        }

        // Lấy action từ request
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        // Lấy filter từ dropdown (all, accept, violate)
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";

        // Lấy giá trị tìm kiếm từ thanh search
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";

        List<Company> listCompanies; // Danh sách công ty để hiển thị
        String requestURL = request.getRequestURL().toString(); // URL hiện tại
        int totalRecord = 0; // Tổng số bản ghi

        // Xử lý tìm kiếm theo searchQuery
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "all":
                    // Tìm tất cả các công ty theo từ khóa
                    listCompanies = dao.searchCompaniesByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
                    break;
                case "accept":
                    // Tìm các công ty đã được chấp nhận
                    listCompanies = dao.searchCompaniesByNameAndStatus(searchQuery, true, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, true);
                    pageControl.setUrlPattern(requestURL + "?filter=accept&searchQuery=" + searchQuery + "&");
                    break;
                case "violate":
                    // Tìm các công ty vi phạm
                    listCompanies = dao.searchCompaniesByNameAndStatus(searchQuery, false, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, false);
                    pageControl.setUrlPattern(requestURL + "?filter=violate&searchQuery=" + searchQuery + "&");
                    break;
                default:
                    // Mặc định tìm tất cả
                    listCompanies = dao.searchCompaniesByName(searchQuery, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else {
            // Nếu không có searchQuery, chỉ lọc theo filter
            switch (filter) {
                case "all":
                    listCompanies = dao.findAllCompany(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "accept":
                    listCompanies = dao.filterCompanyByStatus(true, page);
                    totalRecord = dao.findTotalRecordByStatus(true);
                    pageControl.setUrlPattern(requestURL + "?filter=accept&");
                    break;
                case "violate":
                    listCompanies = dao.filterCompanyByStatus(false, page);
                    totalRecord = dao.findTotalRecordByStatus(false);
                    pageControl.setUrlPattern(requestURL + "?filter=violate&");
                    break;
                default:
                    listCompanies = dao.findAllCompany(page);
                    totalRecord = dao.findAllTotalRecord();
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }

        // Đưa danh sách công ty lên request để JSP hiển thị
        request.setAttribute("listCompanies", listCompanies);

        // Tính tổng số trang
        int totalPage = (totalRecord % RECORD_PER_PAGE) == 0 
                        ? (totalRecord / RECORD_PER_PAGE) 
                        : (totalRecord / RECORD_PER_PAGE) + 1;

        // Cập nhật thông tin phân trang
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        request.setAttribute("pageControl", pageControl);

        // Xử lý action GET
        switch (action) {
            case "view":
                // Xem chi tiết công ty
                url = viewDetailCompany(request);
                break;
            default:
                url = "view/admin/companyManagement.jsp";
        }

        // Forward sang JSP tương ứng
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        response.setContentType("application/json");

        // Xử lý các action POST: violate, accept
        switch (action) {
            case "violate":
                url = violateCompany(request);
                break;
            case "accept":
                url = accepetCompany(request);
                break;
            default:
                url = "companies";
        }

        // Redirect về trang danh sách công ty sau khi xử lý
        response.sendRedirect(url);
    }

    // Xử lý hủy kích hoạt công ty và gửi email thông báo
    private String violateCompany(HttpServletRequest request) throws UnsupportedEncodingException {
        try {
            int id = Integer.parseInt(request.getParameter("id-company"));
            Company company = dao.findCompanyById(id);
            Account account = accDao.findUserById(company.getAccountId());

            // Tạo nội dung email thông báo
            String subjectMail = "Notification: Suspension of " + company.getName() + " on the Platform";
            String contentMail = "Dear " + account.getFullName() + ",\n"
                    + "\n"
                    + "Công ty " + company.getName() + " đã bị tạm ngưng vì nhận được nhiều báo cáo.\n"
                    + "Tất cả tin tuyển dụng sẽ không hiển thị công khai cho đến khi vấn đề được giải quyết.\n"
                    + "\n"
                    + "Nếu có thắc mắc, vui lòng liên hệ bộ phận hỗ trợ.\n"
                    + "Best regards";

            // Gửi email
            Email.sendEmail(account.getEmail(), subjectMail, contentMail);

            // Cập nhật trạng thái công ty
            dao.violateCompany(company);

            return "companies?notice=" + URLEncoder.encode("Deactive and send Email successfully!", "UTF-8");
        } catch (MessagingException ex) {
            return "companies?notice=" + URLEncoder.encode("Deactive and send Email process have error!!", "UTF-8");
        }
    }

    // Xử lý kích hoạt công ty và gửi email thông báo
    private String accepetCompany(HttpServletRequest request) throws UnsupportedEncodingException {
        try {
            int id = Integer.parseInt(request.getParameter("id-company"));
            Company company = dao.findCompanyById(id);
            Account account = accDao.findUserById(company.getAccountId());

            // Tạo nội dung email thông báo
            String subjectMail = "Notification: Your Company Has Been Reactivated on Our Platform";
            String contentMail = "Dear " + account.getFullName() + ",\n"
                    + "\n"
                    + "Công ty " + company.getName() + " đã được kích hoạt trở lại. Bạn có thể tiếp tục đăng tin tuyển dụng.\n"
                    + "\n"
                    + "Cảm ơn và liên hệ nếu cần hỗ trợ.\n"
                    + "Best regards";

            // Gửi email
            Email.sendEmail(account.getEmail(), subjectMail, contentMail);

            // Cập nhật trạng thái công ty
            dao.acceptCompany(company);

            return "companies?notice=" + URLEncoder.encode("Active and send Email successfully!", "UTF-8");
        } catch (MessagingException ex) {
            return "companies?notice=" + URLEncoder.encode("Active and send Email process have error!!", "UTF-8");
        }
    }

    // Xem chi tiết công ty
    private String viewDetailCompany(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Company companyDetail = dao.findCompanyById(id);
        request.setAttribute("CompanyDetail", companyDetail);
        return "view/admin/viewDetailCompany.jsp";
    }

    // Lấy đường dẫn ảnh giấy phép kinh doanh và lưu vào server
    private String getBusinessLicenseImg(String businessLicense, HttpServletRequest request) {
        String imagePath = null;
        try {
            Part part = request.getPart(businessLicense);

            // Nếu không upload file thì trả về null
            if (part == null || part.getSubmittedFileName() == null || part.getSubmittedFileName().trim().isEmpty()) {
                imagePath = null;
            } else {
                // Thư mục lưu ảnh trong project
                String path = request.getServletContext().getRealPath("images");
                File dir = new File(path);
                if (!dir.exists()) {
                    dir.mkdirs(); // Tạo thư mục nếu chưa tồn tại
                }

                // Lưu file vào thư mục
                File image = new File(dir, part.getSubmittedFileName());
                part.write(image.getAbsolutePath());

                // Lấy đường dẫn để hiển thị trong JSP
                imagePath = request.getContextPath() + "/images/" + image.getName();
            }
        } catch (Exception e) {
            e.printStackTrace();
            imagePath = null;
        }
        return imagePath;
    }
}
