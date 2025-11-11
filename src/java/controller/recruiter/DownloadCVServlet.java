/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recruiter;

import dao.CVDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;  //mã hóa cv có tiếng việt tránh gây lỗi khi download
import java.nio.charset.StandardCharsets;
import model.CV;


@WebServlet("/downloadCV")
public class DownloadCVServlet extends HttpServlet {

    private static final int BUFFER_SIZE = 4096;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy CVID từ request
        String cvid = request.getParameter("cvid");
        CVDAO cvDao = new CVDAO();
        CV cv = cvDao.findCVbyJobSeekerID(Integer.parseInt(cvid));
        if (cv == null || cv.getFilePath() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "CV not found");
            return;
        }

        String cvPath[] = cv.getFilePath().split("/");
        String cvPathHandle = "./" + cvPath[2] + "/" + cvPath[3];
        String filePath = getServletContext().getRealPath("/") + cvPathHandle;
        System.out.println(filePath);

        File file = new File(filePath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        response.setContentType("application/octet-stream");
        response.setContentLength((int) file.length());

        // Mã hóa tên file để hỗ trợ tiếng Việt
        String encodedFileName = URLEncoder.encode(file.getName(), StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // Gửi tệp đến client
        try (FileInputStream inStream = new FileInputStream(file); OutputStream outStream = response.getOutputStream()) {
            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}