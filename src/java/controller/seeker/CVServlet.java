package controller.seeker;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.sql.Date;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

import constant.CommonConst;
import dao.CVDAO;
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
import model.CV;
import model.JobSeekers;

@WebServlet(name = "CVServlet", urlPatterns = {"/cv"})

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 20 * 1024 * 1024 // 20MB
)

public class CVServlet extends HttpServlet {

    private final CVDAO cvDAO = new CVDAO();
    private final JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "view/user/CV.jsp"; // Default page to forward to
        String error = request.getParameter("error") != null ? request.getParameter("error") : "";
        request.setAttribute("error", error);
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        switch (action) {
            case "view-cv":
                viewCV(request, response);
                return; // Stop further processing

            case "update-cv":
                url = "view/user/CV.jsp";
                break;

            default: {
                // Default action to display the CV page
                HttpSession session = request.getSession();
                Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

                if (account == null) {
                    response.sendRedirect("view/authen/login.jsp"); // Redirect if not logged in
                    return;
                }

                JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));

                if (jobSeeker != null) {
                    CV cv = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
                    if (cv != null) {
                        request.setAttribute("cvFilePath", cv.getFilePath());
                    }
                } else {
                    // Set the error message to display on the CV page
                    error = "You are not currently a member of Job Seeker. Please join to use this function.";
                    request.setAttribute("errorJobSeeker", error);
                }
            }
            break;
        }

        // Forward to the determined URL
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;
        switch (action) {
            case "upload-cv":
                url = uploadCV(request);
                break;
            case "update-cv":
                url = updateCV(request);
                break;
            default:
                url = "cv"; // Default URL if no action matches
        }
        response.sendRedirect(url);
    }

    // Upload CV
    public String uploadCV(HttpServletRequest request) throws IOException, ServletException {
        String url;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account == null) {
            url = "view/authen/login.jsp"; // Redirect if the user is not logged in
        }

        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");
        if (jobSeeker == null) {
            try {
                url = "cv?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        CV existingCV = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
        if (existingCV != null) {
            try {
                url = "cv?error=" + URLEncoder.encode("CV already exists. Please update it instead.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            Part part = request.getPart("cvUploadFile");
            if (part == null || part.getSize() <= 0) {
                try {
                    url = "cv?error=" + URLEncoder.encode("No file uploaded. Please select a CV file.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            // Validate that the uploaded file is a PDF
            String fileName = part.getSubmittedFileName();
            if (!fileName.toLowerCase().endsWith(".pdf")) {
                try {
                    url = "cv?error=" + URLEncoder.encode("Invalid file type. Please upload a PDF file.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            // Define the directory path for storing CV files
            String path = request.getServletContext().getRealPath("cvFiles");
            File dir = new File(path);
            if (!dir.exists()) {
                dir.mkdirs(); // Create the directory if it doesn't exist
            }

            // Save the uploaded file
            File cvFile = new File(dir, fileName);
            part.write(cvFile.getAbsolutePath());

            // Insert CV record into the database
            CV newCV = new CV();
            newCV.setJobSeekerID(jobSeeker.getJobSeekerID());
            newCV.setFilePath(request.getContextPath() + "/cvFiles/" + cvFile.getName());
            newCV.setUploadDate(Date.valueOf(LocalDate.now()));
            cvDAO.insert(newCV);

            // Set success message and return to the CV page
            request.setAttribute("successCV", "CV uploaded successfully.");
            url = "cv";
        } catch (Exception e) {
            // Handle any other errors during the upload process
            e.printStackTrace();
            request.setAttribute("error", "File upload exceeds the maximum allowed size (10MB).");
            url = "cv"; // Redirect with generic error
        }
        return url;
    }

    // Update CV
    public String updateCV(HttpServletRequest request) throws IOException, ServletException {
        String url;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) {
            url = "view/authen/login.jsp";
        }
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(account.getId() + "");
        
        CV existingCV = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
        if (existingCV == null) {
            try {
                url = "cv?error=" + URLEncoder.encode("No CV found. Please upload one first.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            Part part = request.getPart("cvFileU");
            if (part == null || part.getSize() <= 0) {
                try {
                    url = "cv?error=" + URLEncoder.encode("No file uploaded. Please select a CV file.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            // Kiểm tra kích thước file (ví dụ giới hạn 10MB = 10 * 1024 * 1024 bytes)
            long fileSize = part.getSize();
            long maxSize = 10 * 1024 * 1024; // 10MB
            if (fileSize > maxSize) {
                try {
                    url = "cv?error=" + URLEncoder.encode("File size exceeds the 10MB limit. Please upload a smaller file.", "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            String path = request.getServletContext().getRealPath("cvFiles");
            File dir = new File(path);
            // Create directory if it doesn't exist
            if (!dir.exists()) {
                dir.mkdirs();
            }
            // Save updated file
            File cvFile = new File(dir, part.getSubmittedFileName());
            part.write(cvFile.getAbsolutePath());
            // Update CV record in the database
            existingCV.setFilePath(request.getContextPath() + "/cvFiles/" + cvFile.getName());
            existingCV.setUploadDate(Date.valueOf(LocalDate.now()));
            cvDAO.updateCV(existingCV);

            request.setAttribute("successCV", "CV updated successfully.");
            url = "cv";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "File upload failed due to an unexpected error.");
            url = "cv";
        }
        return url;
    }

    // View CV
    private String viewCV(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String url = null;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        if (account == null) {
            url = "view/authen/login.jsp"; // Redirect if user is not logged in
        }
        JobSeekers jobSeeker = jobSeekerDAO.findJobSeekerIDByAccountID(String.valueOf(account.getId()));
        if (jobSeeker == null) {
            try {
                url = "cv?error=" + URLEncoder.encode("You are not currently a member of Job Seeker. Please join to use this function.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(CVServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        CV cv = cvDAO.findCVbyJobSeekerID(jobSeeker.getJobSeekerID());
        if (cv == null) {
            request.setAttribute("errorCV", "No CV found for this Job Seeker.");
            url = "cv";

        }

        // Get the file path from the database
        String filePath = cv.getFilePath(); // Example: /cvFile/1721092306015_6454ae59431b066cbfda5ca4_PE1-SWR-Sample.pdf
        String rootPath = request.getServletContext().getRealPath("/");

        // Ensure the path uses the 'cvFile' directory
        String relativeFilePath = filePath.replace("JobSeeker/cvFiles/", "cvFiles/");

        // Concatenate root and file path
        String absoluteFilePath = rootPath + relativeFilePath;

        // Normalize the file path slashes for Windows systems
        absoluteFilePath = absoluteFilePath.replace("/", "\\").replace("\\\\", "\\");

        File file = new File(absoluteFilePath);
        if (!file.exists()) {
            request.setAttribute("errorCV", "File not found.");
            url = "view/user/CV.jsp";
        }

        // Set response headers and content type for PDF viewing
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

        // Stream the file content to the browser
        try {
            Files.copy(file.toPath(), response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            e.printStackTrace(); // Log the error for debugging
            request.setAttribute("errorCV", "Error displaying CV: " + e.getMessage());
            url = "view/user/CV.jsp";
        }
        return url;
    }
}
