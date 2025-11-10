package controller.admin;

import static constant.CommonConst.RECORD_PER_PAGE;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.PageControl;

@WebServlet(name = "RecruiterAdminController", urlPatterns = {"/recruiters"})
public class RecruiterAdminController extends HttpServlet {

    AccountDAO dao = new AccountDAO(); // DAO xử lý Account (recruiter)

    // ------------------- Xử lý GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PageControl pageControl = new PageControl();
        String pageRaw = request.getParameter("page");
        int page;

        // Validate page
        try {
            page = Integer.parseInt(pageRaw);
            if (page <= 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Xác định action để forward tới đúng JSP
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "view-list-seekers": 
                url = "view/admin/recruiterManagement.jsp";
                break;
            default:
                url = "view/admin/recruiterManagement.jsp";
        }

        // Lấy giá trị filter và search từ JSP
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";
        List<Account> listRecruiters = null;
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;

        // Nếu có search
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "all": // tìm tất cả
                    listRecruiters = dao.searchUserByName(searchQuery, 2, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery, 2);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
                    break;
                case "active": // chỉ active
                    listRecruiters = dao.searchUserByNameAndStatus(searchQuery, true, 2, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, true, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=active&searchQuery=" + searchQuery + "&");
                    break;
                case "inactive": // chỉ inactive
                    listRecruiters = dao.searchUserByNameAndStatus(searchQuery, false, 2, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, false, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive&searchQuery=" + searchQuery + "&");
                    break;
                default:
                    listRecruiters = dao.searchUserByName(searchQuery, 2, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery, 2);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else { // Không search, chỉ filter
            switch (filter) {
                case "all":
                    listRecruiters = dao.findAllUserByRoleId(2, page);
                    totalRecord = dao.findAllTotalRecord(2);
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "active":
                    listRecruiters = dao.filterUserByStatus(true, 2, page);
                    totalRecord = dao.findTotalRecordByStatus(true, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=active&");
                    break;
                case "inactive":
                    listRecruiters = dao.filterUserByStatus(false, 2, page);
                    totalRecord = dao.findTotalRecordByStatus(false, 2);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive&");
                    break;
                default:
                    listRecruiters = dao.findAllUserByRoleId(2, page);
                    totalRecord = dao.findAllTotalRecord(2);
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }

        request.setAttribute("listRecruiters", listRecruiters);

        // Tính tổng số trang
        int totalPage = (totalRecord % RECORD_PER_PAGE == 0) ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE + 1);
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        request.setAttribute("pageControl", pageControl);

        // Forward đến JSP quản lý recruiter
        request.getRequestDispatcher(url).forward(request, response);
    }

    // ------------------- Xử lý POST -------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "deactive":
                url = deactive(request); // vô hiệu hóa recruiter
                break;
            case "active":
                url = active(request); // kích hoạt recruiter
                break;
            case "view-detail":
                url = viewDetail(request); // xem chi tiết recruiter
                request.getRequestDispatcher(url).forward(request, response);
                return;
            default:
                url = "view/admin/recruiterManagement.jsp";
        }

        response.sendRedirect(url);
    }

    // ------------------- Vô hiệu hóa recruiter -------------------
    private String deactive(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        dao.deactiveAccount(account);
        return "seekers"; // quay về danh sách recruiters
    }

    // ------------------- Kích hoạt recruiter -------------------
    private String active(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        dao.activeAccount(account);
        return "seekers";
    }

    // ------------------- Xem chi tiết recruiter -------------------
    private String viewDetail(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-recruiter"));
        Account account = dao.findUserById(id);
        request.setAttribute("accountView", account);
        return "view/admin/viewDetailUser.jsp";
    }
}
