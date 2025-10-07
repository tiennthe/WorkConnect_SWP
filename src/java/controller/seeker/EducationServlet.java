package controller.seeker;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import constant.CommonConst;
import dao.EducationDAO;
import dao.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Account;
import model.Education;
import model.JobSeekers;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)

@WebServlet(name = "EducationServlet", urlPatterns = {"/education"})
public class EducationServlet extends HttpServlet {

    private final EducationDAO eduDAO = new EducationDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the error parameter from the request, typically set in doPost
        String error = request.getParameter("error") != null ? request.getParameter("error") : "";
        request.setAttribute("error", error);
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url = "view/user/Education.jsp"; // Default URL for forwarding

        switch (action) {
            case "update-education":
                // Forward to the education update page
                url = "view/user/education.jsp";
                break;

            default: {
                // Default action to display education page or handle error
                HttpSession session = request.getSession();
                Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

                if (account == null) {
                    response.sendRedirect("view/authen/login.jsp"); // Redirect to login if not logged in
                    return;
                }

                JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

                if (jobSeeker != null) {
                    try {
                        // Attempt to view education details
                        url = viewEducation(request, response);
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.getWriter().println("Database error.");
                        url = "view/user/education.jsp"; // Set URL to education page in case of exception
                    }
                } else {
                    // Set error message if job seeker information is missing
                    error = "You are not currently a member of Job Seeker. Please join to use this function.";
                    request.setAttribute("errorJobSeeker", error);
                    url = "view/user/education.jsp"; // Forward to education page to show the error message
                }
                break;
            }
        }

        // Forward to the designated page with any relevant error or data attributes set
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        switch (action) {
            case "add-education":
                url = addEducation(request);
                break;
            case "update-education":
                url = updateEducation(request);
                break;
            case "delete-education": // New case for delete action
                url = deleteEducation(request);
                break;
            default:
                url = "home"; // Default URL if no action matches
        }

        response.sendRedirect(url);
    }

    // Upload CV
    public String addEducation(HttpServletRequest request) throws IOException, ServletException {
        String url = null; // URL to navigate to after processing
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");
        List<Education> edus = eduDAO.findEducationbyJobSeekerID(jobSeeker.getJobSeekerID());
        if (jobSeeker != null) {
            try {
                String institution = request.getParameter("institution");
                String degree = request.getParameter("degree");
                String fieldofstudy = request.getParameter("fieldofstudy");
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");

                Part degreeImgPart = request.getPart("degreeImg");
                String uploadDir = "uploads/degreeImgs";
                String degreeImgName = saveFile(degreeImgPart, uploadDir);

                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);

                Calendar startCal = Calendar.getInstance();
                startCal.setTime(startDate);

                Calendar endCal = Calendar.getInstance();
                endCal.setTime(endDate);

                boolean isCertificate = "Certificate".equals(degree);
                int yearsDiff = endCal.get(Calendar.YEAR) - startCal.get(Calendar.YEAR);
                int monthsDiff = endCal.get(Calendar.MONTH) - startCal.get(Calendar.MONTH);

                // Calculate total months between startDate and endDate
                int totalMonths = yearsDiff * 12 + monthsDiff;

                // If it's not a Certificate degree and total months is below 24, show an error
                if (!isCertificate && totalMonths < 24) {
                    try {
                        url = "education?error=" + URLEncoder.encode("End date must be at least 2 years after the start date.", "UTF-8");
                        session.setAttribute("institution", institution);
                        session.setAttribute("degree", degree);
                        session.setAttribute("fieldofstudy", fieldofstudy);
                        session.setAttribute("startDateStr", startDateStr);
                        session.setAttribute("endDateStr", endDateStr);
                    } catch (UnsupportedEncodingException ex) {
                        Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    // Create and populate the Education object
                    Education eduAdd = new Education();
                    eduAdd.setJobSeekerID(jobSeeker.getJobSeekerID());
                    eduAdd.setInstitution(institution);
                    eduAdd.setDegree(degree);
                    eduAdd.setFieldOfStudy(fieldofstudy);
                    eduAdd.setStartDate(startDate);
                    eduAdd.setEndDate(endDate);
                    eduAdd.setDegreeImg(degreeImgName);

                    session.removeAttribute("institution");
                    session.removeAttribute("degree");
                    session.removeAttribute("fieldofstudy");
                    session.removeAttribute("startDateStr");
                    session.removeAttribute("endDateStr");

                    eduDAO.insert(eduAdd);
                    // Continue processing eduAdd as needed (e.g., save to the database)
                    request.setAttribute("successEducation", "Profile add successfully.");
                    request.setAttribute("edus", edus);
                    request.setAttribute("jobSeeker", jobSeeker);
                    url = "education"; // Điều hướng đến trang Education
                }
            } catch (Exception e) {
                e.printStackTrace(); // Log the exception for debugging
                try {
                    url = "education?error=" + URLEncoder.encode("An error occurred while uploading the profile. Please try again.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                url = "education"; // Redirect back to Education upload page with error
            }
        } else {
            try {
                url = "education?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return url; // Return the URL to navigate to
    }

    //Update CV
    public String updateEducation(HttpServletRequest request) throws IOException, ServletException {
        String url = null; // URL to navigate to after processing
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        List<Education> edus = eduDAO.findEducationbyJobSeekerID(jobSeeker.getJobSeekerID());
        if (jobSeeker != null && edus != null) { // Thay đổi để check đúng edu khác null
            try {
                String educationIDStr = request.getParameter("educationID");
                String institution = request.getParameter("institution");
                String degree = request.getParameter("degree");
                String fieldofstudy = request.getParameter("fieldofstudy");
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");

                Part degreeImgPart = request.getPart("degreeImg");
                String uploadDir = "uploads/degreeImgs";
                String degreeImgName = saveFile(degreeImgPart, uploadDir);

                int educationID = Integer.parseInt(educationIDStr);
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr); // Mặc định là null

                Calendar startCal = Calendar.getInstance();
                startCal.setTime(startDate);

                Calendar endCal = Calendar.getInstance();
                endCal.setTime(endDate);

                boolean isCertificate = "Certificate".equals(degree);
                // Tính số năm giữa 2 ngày
                int yearsDiff = endCal.get(Calendar.YEAR) - startCal.get(Calendar.YEAR);
                int monthsDiff = endCal.get(Calendar.MONTH) - startCal.get(Calendar.MONTH);

                // Tính tổng số tháng giữa startDate và endDate
                int totalMonths = yearsDiff * 12 + monthsDiff;

                // Nếu tổng số tháng dưới 24, không lưu và trả về thông báo lỗi
                if (!isCertificate && totalMonths < 24) {
                    try {
                        url = "education?error=" + URLEncoder.encode("End date must be at least 2 years after the start date.", "UTF-8");
                    } catch (UnsupportedEncodingException ex) {
                        Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    Education edu = new Education();

                    // Tạo đối tượng Education
                    edu.setEducationID(educationID);
                    edu.setInstitution(institution);
                    edu.setDegree(degree);
                    edu.setFieldOfStudy(fieldofstudy);
                    edu.setStartDate(startDate);
                    edu.setEndDate(endDate);
                    edu.setDegreeImg(degreeImgName);

                    // Cập nhật bản ghi trong CSDL
                    eduDAO.updateEducation(edu);
                    request.setAttribute("successEducation", "Profile updated successfully.");
                    request.setAttribute("edus", edus);
                    request.setAttribute("jobSeeker", jobSeeker);
                    url = "education"; // Điều hướng đến trang Education
                }
            } catch (Exception e) {
                e.printStackTrace(); // Log the exception for debugging
                try {
                    url = "education?error=" + URLEncoder.encode("An error occurred while uploading the profile. Please try again.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                url = "education"; // Redirect back to Education upload page with error
            }
        } else {
            request.setAttribute("error", "No Job Seeker found for the current account.");
            url = "JobSeekerCheck";
        }

        return url; // Return the URL to navigate to
    }

    private String viewEducation(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            return "view/authen/login.jsp"; // Redirect if user is not logged in
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");

        if (jobSeeker == null) {
            try {
                url = "education?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(EducationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // Lấy danh sách học vấn thay vì một đối tượng học vấn đơn lẻ
        List<Education> educationList = eduDAO.findEducationbyJobSeekerID(jobSeeker.getJobSeekerID());

        if (educationList == null || educationList.isEmpty()) {
            request.setAttribute("errorEducation", "No Education found for this Job Seeker.");
            url = "view/user/education.jsp";
        }

        // Set danh sách học vấn vào request attribute
        request.setAttribute("edus", educationList);

        // Forward to the education view page
        url = "view/user/education.jsp";
        return url;
    }

    // New method to delete education
    public String deleteEducation(HttpServletRequest request) throws IOException, ServletException {
        String url; // URL to navigate to after processing
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

        if (jobSeeker != null) {
            try {
                String educationIDStr = request.getParameter("educationID");
                int educationID = Integer.parseInt(educationIDStr);

                // Delete the education record
                eduDAO.deleteEducation(educationID);
                request.setAttribute("successEducation", "Education deleted successfully.");
            } catch (Exception e) {
                e.printStackTrace(); // Log the exception for debugging
                request.setAttribute("errorEducation", "An error occurred while deleting the education record. Please try again.");
            }
        } else {
            request.setAttribute("error", "No Job Seeker found for the current account.");
            url = "JobSeekerCheck";
        }

        url = "education"; // Redirect back to the education page
        return url; // Return the URL to navigate to
    }

    private String saveFile(Part filePart, String uploadDir) throws IOException {
        // Resolve the absolute path for the upload directory
        Path uploadPath = Paths.get(getServletContext().getRealPath("/") + uploadDir);

        // Create directories if they don't exist
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Get the file name from the uploaded part
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Check if the file already exists; if so, add a timestamp to create a unique file name
        Path filePath = uploadPath.resolve(fileName);
        if (Files.exists(filePath)) {
            String fileExtension = "";
            int dotIndex = fileName.lastIndexOf('.');

            if (dotIndex > 0) {
                fileExtension = fileName.substring(dotIndex);
                fileName = fileName.substring(0, dotIndex);
            }

            // Append timestamp for uniqueness
            fileName = fileName + "_" + System.currentTimeMillis() + fileExtension;
            filePath = uploadPath.resolve(fileName);
        }

        // Save the file
        Files.copy(filePart.getInputStream(), filePath);

        // Return the relative path to the saved file
        return uploadDir + "/" + fileName;
    }

}
