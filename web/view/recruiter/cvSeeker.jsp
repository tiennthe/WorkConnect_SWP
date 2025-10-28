<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View CV</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Styles for CV view */
            .download-button {
                display: inline-block;
                margin-top: 20px;
                background-color: #007b5e;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }
            .download-button:hover {
                background-color: #005f46;
            }
            .back-button {
                display: inline-block;
                margin-top: 20px;
                color: #007b5e;
                text-decoration: none;
                font-weight: bold;
            }
            .back-button:hover {
                color: #005f46;
            }
            .cv-preview {
                margin-top: 20px;
                text-align: center;
            }

            .cv-container {
                max-width: 800px; /* Tăng kích thước từ 600px lên 800px */
                margin: 80px auto;
                padding: 30px; /* Tăng padding từ 20px lên 30px */
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 15px rgba(0, 0, 0, 0.15); /* Tăng độ mờ của shadow */
            }
            .cv-header {
                text-align: center;
                margin-bottom: 30px; /* Tăng khoảng cách bên dưới tiêu đề */
            }
            .cv-header h2 {
                color: #007b5e;
                font-weight: bold;
                font-size: 28px; /* Tăng kích thước chữ tiêu đề */
            }
            .cv-details label {
                font-weight: bold;
                color: #333;
            }
            .download-button, .back-button {
                padding: 12px 25px; /* Tăng kích thước nút */
                font-size: 16px; /* Tăng kích thước chữ trên nút */
            }
        </style>
    </head>
    <body>
        <div class="cv-container">
            <%@ include file="../recruiter/sidebar-re.jsp" %>
            <%@ include file="../recruiter/header-re.jsp" %>

            <div class="cv-header">
                <h2>CV Details</h2>
            </div>

            <div class="cv-details">
                <p><label>Upload Date:</label> <fmt:formatDate value="${cv.uploadDate}" pattern="dd-MM-yyyy" /></p>
                <p><label>Last Updated:</label> <fmt:formatDate value="${cv.lastUpdated}" pattern="dd-MM-yyyy" /></p>
            </div>

            <!-- Preview CV Section -->
            <div class="cv-preview">
                <c:choose>
                    <c:when test="${fn:endsWith(cv.filePath, '.png') || fn:endsWith(cv.filePath, '.jpg') || fn:endsWith(cv.filePath, '.jpeg')}">
                        <img src="${pageContext.request.contextPath}/${cv.filePath}" alt="CV Image" style="max-width:100%; border-radius:8px;">
                    </c:when>

                    <c:when test="${fn:endsWith(cv.filePath, '.pdf')}">
                        <embed src="${pageContext.request.contextPath}/${cv.filePath}" type="application/pdf" width="100%" height="500px" />
                    </c:when>


                    <c:when test="${fn:endsWith(cv.filePath, '.doc') || fn:endsWith(cv.filePath, '.docx')}">
                        <iframe src="https://docs.google.com/viewer?url=${pageContext.request.contextPath}/${cv.filePath}&embedded=true" width="100%" height="500px"></iframe>
                        </c:when>

                    <c:otherwise>
                        <p>Preview not available for this file type. Please download to view the CV.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Download CV Button -->
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/downloadCV?cvid=${cv.CVID}" class="download-button">
                    <i class="fas fa-download"></i> Download CV
                </a>
            </div>

            <!-- Back Button -->
            <div class="text-center">
                <a href="javascript:history.back()" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Applications
                </a>
            </div>
        </div>

        <%@ include file="../recruiter/footer-re.jsp" %>
    </body>
</html>