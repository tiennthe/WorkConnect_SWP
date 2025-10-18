<%-- 
    Document   : viewRecruiterProfile
    Created on : Oct 18, 2025, 2:06:15 PM
    Author     : tiennthe
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Profile</title>
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

            /* Profile container styling */
            .profile-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 80px); /* Adjust for full height excluding header */
                padding: 20px;
                margin-left: 240px;
                padding-top: 80px;
                background-color: #f8f9fa;
            }

            /* Card styling for the profile section */
            .profile-card {
                background-color: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
                max-width: 750px; /* Increased width for better content space */
                width: 100%;
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap; /* Allows wrapping of content */
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            /* Hover effect for card */
            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            /* Styling for avatar and user details */
            .profile-sidebar {
                text-align: center;
                margin-right: 30px;
                flex: 1 1 200px; /* Ensures flexibility and space for content */
            }

            .profile-sidebar img {
                width: 140px;
                height: 140px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 15px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .profile-sidebar img:hover {
                transform: scale(1.1);
            }

            .profile-sidebar h4 {
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 22px;
                color: #2c3e50;
            }

            .form-section {
                flex: 2 1 400px; /* Larger flex size to take up more space */
            }

            .form-section h2 {
                font-size: 22px;
                font-weight: bold;
                margin-bottom: 15px;
                color: #16a085;
            }

            /* Styling for profile information */
            .profile-info {
                width: 100%;
                margin-top: 20px;
            }

            .profile-info table {
                width: 100%;
                margin-bottom: 20px;
            }

            .profile-info td {
                padding: 12px;
                font-size: 16px;
                color: #333;
            }

            .profile-info td:first-child {
                font-weight: bold;
                color: #555;
                text-align: right;
                padding-right: 15px;
                width: 35%;
            }

            .profile-info td:last-child {
                text-align: left;
            }

            .edit-profile-btn {
                text-align: center;
                margin-top: 20px;
            }

            .edit-profile-btn a {
                padding: 12px 18px;
                font-size: 16px;
                background-color: #28a745;
                color: #fff;
                border-radius: 30px;
                text-decoration: none;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .edit-profile-btn a:hover {
                background-color: #148f77;
                transform: translateY(-3px);
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
                <!-- Sidebar with avatar and introduction -->
                <div class="profile-sidebar">
                    <c:if test="${empty sessionScope.account.getAvatar()}">
                        <img id="avatar-preview" src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="User Avatar">
                    </c:if>
                    <c:if test="${!empty sessionScope.account.getAvatar()}">
                        <img id="avatar-preview" src="${sessionScope.account.getAvatar()}" alt="User Avatar">
                    </c:if>
                    <h4>${sessionScope.account.getFullName()}</h4>
                    <p>Recruiter Information</p>
                </div>

                <!-- Profile Information -->
                <div class="form-section">
                    <h2>Profile Details</h2>
                    <div class="profile-info">
                        <table>
                            <tr>
                                <td>Name:</td>
                                <td>${sessionScope.account.getFullName()}</td>
                            </tr>
                            <tr>
                                <td>Email:</td>
                                <td>${sessionScope.account.getEmail()}</td>
                            </tr>
                            <tr>
                                <td>Phone:</td>
                                <td>${sessionScope.account.getPhone()}</td>
                            </tr>
                            <tr>
                                <td>Gender:</td>
                                <td>${sessionScope.account.isGender() == true ? 'Male' : 'Female'}</td>
                            </tr>
                            <tr>
                                <td>Address:</td>
                                <td>${sessionScope.account.getAddress()}</td>
                            </tr>
                            <tr>
                                <td>Date of Birth:</td>
                                <td>${sessionScope.account.getDob()}</td>
                            </tr>
                        </table>
                    </div>

                    <!-- Edit Profile Button -->
                    <div class="edit-profile-btn">
                        <a href="${pageContext.request.contextPath}/view/recruiter/editRecruiterProfile.jsp">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>
    </body>
</html>