package controller.recruiter;

import constant.CommonConst;
import dao.CompanyDAO;
import dao.RecruitersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Company;
import model.Recruiters;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
@WebServlet(name = "VerifyRecruiter", urlPatterns = {"/verifyRecruiter"})
public class VerifyRecruiter extends HttpServlet {

    RecruitersDAO reDAO = new RecruitersDAO();
    CompanyDAO companyDao = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        List<Company> companies = companyDao.findAll();
        request.setAttribute("companyList", companies);
        request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        String businessCode = request.getParameter("businessCode");
        String position = request.getParameter("position");

        try {
            // Check if a verification request has already been submitted => ko cho gui lan 2
            Recruiters existingRecruiter = reDAO.findRecruitersbyAccountID(String.valueOf(account.getId()));
            if (existingRecruiter != null && !existingRecruiter.isIsVerify()) {
                // If there's an existing unverified request, show error message
                request.setAttribute("error", "Your verification request is already pending approval.");
                request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
                return;
            }
            // Check if the businessCode belongs to the recruiter's own company
            if (!companyDao.doesBusinessCodeExist(businessCode, account.getId())) {
                // If the business code does not exist for the given account, show specific error message
                request.setAttribute("error", "Invalid Business Code.");
                request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
                return;
            }

            // Check if the company is active
            if (!companyDao.isCompanyActive(businessCode)) {
                // If the company is inactive, show specific error message
                request.setAttribute("error", "Company is not active.");
                request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
                return;
            }

            // Retrieve CompanyID based on BusinessCode since it's valid
            int companyId = companyDao.getCompanyIdByBusinessCode(businessCode);

            // File uploads for citizen ID
            Part frontCitizenIDPart = request.getPart("frontCitizenID");
            Part backCitizenIDPart = request.getPart("backCitizenID");

            if (frontCitizenIDPart.getSubmittedFileName().equals(backCitizenIDPart.getSubmittedFileName())) {
                request.setAttribute("error", "You cannot upload the same file for both Front and Back Citizen ID.");
                request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
                return;
            }

            String frontCitizenIDFileName = saveFile(frontCitizenIDPart, "uploads/citizen_ids");
            String backCitizenIDFileName = saveFile(backCitizenIDPart, "uploads/citizen_ids");

            // Create new recruiter entry
            Recruiters recruiter = new Recruiters();
            recruiter.setAccountID(account.getId());
            recruiter.setCompanyID(companyId);
            recruiter.setPosition(position);
            recruiter.setIsVerify(false);  // Set verification status to pending
            recruiter.setFrontCitizenImage(frontCitizenIDFileName);
            recruiter.setBackCitizenImage(backCitizenIDFileName);

            reDAO.insert(recruiter);

            request.setAttribute("verify", "Your verification request has been sent.");
            request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Database error occurred.");
            request.getRequestDispatcher("view/recruiter/verifyRecruiter.jsp").forward(request, response);
            e.printStackTrace();
        }
    }
// Helper method to save the uploaded file and return the file path

    private String saveFile(Part filePart, String uploadDir) throws IOException {
        // Create directories if they don't exist
        Path uploadPath = Paths.get(getServletContext().getRealPath("/") + uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Lấy tên file từ filePart
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Kiểm tra nếu file đã tồn tại
        Path filePath = uploadPath.resolve(fileName);
        if (Files.exists(filePath)) {
            // Tạo tên file mới bằng cách thêm timestamp vào file
            String newFileName = System.currentTimeMillis() + "_" + fileName;
            filePath = uploadPath.resolve(newFileName);
            fileName = newFileName;
        }

        // Lưu file
        Files.copy(filePart.getInputStream(), filePath);

        // Trả về đường dẫn tương đối đến file
        return uploadDir + "/" + fileName;
    }
}
