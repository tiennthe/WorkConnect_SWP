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

@WebServlet(name = "SeekerAdminController", urlPatterns = {"/seekers"})
public class SeekerAdminController extends HttpServlet {

    AccountDAO dao = new AccountDAO(); // DAO xử lý Account (job seeker)

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

        // Xác định action
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "view-list-seekers":
                url = "view/admin/seekerManagement.jsp";
                break;
            default:
                url = "view/admin/seekerManagement.jsp";
        }

        // Lấy giá trị filter và search từ JSP
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";
        List<Account> listSeekers = null;
        String requestURL = request.getRequestURL().toString();
        int totalRecord = 0;

        // Nếu có search
        if (!searchQuery.isEmpty()) {
            switch (filter) {
                case "all":
                    listSeekers = dao.searchUserByName(searchQuery, 3, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery, 3);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
                    break;
                case "active":
                    listSeekers = dao.searchUserByNameAndStatus(searchQuery, true, 3, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, true, 3);
                    pageControl.setUrlPattern(requestURL + "?filter=active&searchQuery=" + searchQuery + "&");
                    break;
                case "inactive":
                    listSeekers = dao.searchUserByNameAndStatus(searchQuery, false, 3, page);
                    totalRecord = dao.findTotalRecordByNameAndStatus(searchQuery, false, 3);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive&searchQuery=" + searchQuery + "&");
                    break;
                default:
                    listSeekers = dao.searchUserByName(searchQuery, 3, page);
                    totalRecord = dao.findTotalRecordByName(searchQuery, 3);
                    pageControl.setUrlPattern(requestURL + "?searchQuery=" + searchQuery + "&");
            }
        } else { // Không search
            switch (filter) {
                case "all":
                    listSeekers = dao.findAllUserByRoleId(3, page);
                    totalRecord = dao.findAllTotalRecord(3);
                    pageControl.setUrlPattern(requestURL + "?");
                    break;
                case "active":
                    listSeekers = dao.filterUserByStatus(true, 3, page);
                    totalRecord = dao.findTotalRecordByStatus(true, 3);
                    pageControl.setUrlPattern(requestURL + "?filter=active&");
                    break;
                case "inactive":
                    listSeekers = dao.filterUserByStatus(false, 3, page);
                    totalRecord = dao.findTotalRecordByStatus(false, 3);
                    pageControl.setUrlPattern(requestURL + "?filter=inactive&");
                    break;
                default:
                    listSeekers = dao.findAllUserByRoleId(3, page);
                    totalRecord = dao.findAllTotalRecord(3);
                    pageControl.setUrlPattern(requestURL + "?");
            }
        }

        request.setAttribute("listSeekers", listSeekers);

        // Tính tổng số trang
        int totalPage = (totalRecord % RECORD_PER_PAGE == 0) ? (totalRecord / RECORD_PER_PAGE) : (totalRecord / RECORD_PER_PAGE + 1);
        pageControl.setPage(page);
        pageControl.setTotalRecord(totalRecord);
        pageControl.setTotalPages(totalPage);
        request.setAttribute("pageControl", pageControl);

        // Forward đến JSP quản lý job seeker
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
                url = deactive(request); // vô hiệu hóa job seeker
                break;
            case "active":
                url = active(request); // kích hoạt job seeker
                break;
            case "view-detail":
                url = viewDetail(request); // xem chi tiết job seeker
                request.getRequestDispatcher(url).forward(request, response);
                return;
            default:
                url = "view/admin/seekerManagement.jsp";
        }

        response.sendRedirect(url);
    }

    // ------------------- Vô hiệu hóa job seeker -------------------
    private String deactive(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-seeker"));
        Account account = dao.findUserById(id);
        dao.deactiveAccount(account);
        return "seekers";
    }

    // ------------------- Kích hoạt job seeker -------------------
    private String active(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-seeker"));
        Account account = dao.findUserById(id);
        dao.activeAccount(account);
        return "seekers";
    }

    // ------------------- Xem chi tiết job seeker -------------------
    private String viewDetail(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id-seeker"));
        Account account = dao.findUserById(id);
        request.setAttribute("accountView", account);
        return "view/admin/viewDetailUser.jsp";
    }
}
