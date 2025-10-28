<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Work Experience</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                background-color: #f8f9fa;
            }

            .profile-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 80px);
                padding: 20px;
                margin-left: 240px;
                padding-top: 80px;
                background-color: #f8f9fa;
            }

            .profile-card {
                background-color: white;
                padding: 40px 50px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                max-width: 800px;
                width: 100%;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            .form-section h2 {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 25px;
                color: #16a085;
                text-align: center;
            }

            .profile-info table {
                width: 100%;
                margin-bottom: 20px;
            }

            .profile-info td {
                padding: 15px;
                font-size: 16px;
                color: #333;
                text-align: left; /* Căn trái cho tất cả các ô */
            }

            .profile-info td:first-child {
                font-weight: bold;
                color: #555;
                width: 35%;
            }

            .degree-img {
                max-width: 100px;
                height: auto;
                border-radius: 5px;
                margin-top: 10px;
                display: block;
                margin-left: auto;
                margin-right: auto;
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
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Profile Container -->
        <div class="profile-container">
            <div class="profile-card">

                <div class="form-section">
                    <h2>View Work Experience</h2>
                    <c:forEach var="experience" items="${WorkExperience}">
                        <div class="profile-info">
                            <table>
                                <tr>
                                    <td>Company Name:</td>
                                    <td>${experience.companyName}</td>
                                </tr>
                                <tr>
                                    <td>Job Title:</td>
                                    <td>${experience.jobTitle}</td>
                                </tr>
                                <tr>
                                    <td>Start Date:</td>
                                    <td><fmt:formatDate value="${experience.startDate}" pattern="dd-MM-yyyy" /></td>
                                </tr>
                                <tr>
                                    <td>End Date:</td>
                                    <td><fmt:formatDate value="${experience.endDate}" pattern="dd-MM-yyyy" /></td>
                                </tr>
                                <tr>
                                    <td>Description:</td>
                                    <td>${experience.description}</td>
                                </tr>
                            </table>
                        </div>
                                <hr/>
                    </c:forEach>
                    <!-- Back Button -->
                    <div class="text-center">
                        <a href="javascript:history.back()" class="back-button">
                            <i class="fas fa-arrow-left"></i> Back to Applications
                        </a>
                    </div>
                </div>

            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>
    </body>
</html>