<%-- 
    Document   : changePW-re
    Created on : Oct 14, 2025, 8:50:33 PM
    Author     : mTuan1
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Change Password</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Ensure the header is fixed */
            header {
                position: fixed;
                top: 0;
                left: 260px; /* Leave space for sidebar */
                width: calc(100% - 260px); /* Adjust the width for header */
                background-color: #389354;
                height: 70px;
                z-index: 1000;
                display: flex;
                align-items: center;
                padding: 0 20px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                color: white;
            }

            /* Sidebar styling */
            .sidebar {
                height: 100vh;
                width: 260px;
                position: fixed;
                top: 0;
                left: 0;
                background-color: #fff;
                padding-top: 20px;
                border-right: 1px solid #ddd;
            }

            /* Ensure the content starts below the header */
            .password-container {
                margin-left: 260px; /* Ensure it does not overlap the sidebar */
                padding-top: 100px; /* Add top padding to avoid overlap with fixed header */
                min-height: calc(100vh - 70px); /* Adjust for header height */
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: #f8f9fa; /* Light background */
            }

            /* Card styling for password form */
            .password-card {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15); /* Soft shadow for depth */
                max-width: 450px;
                width: 100%;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin-top: 60px;
            }

            /* Card hover effect */
            .password-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            /* Centering the title */
            .password-card h2 {
                text-align: center;
                margin-bottom: 30px;
                color: #39874e; /* Bright red for emphasis */
                font-weight: bold;
                font-size: 24px;
            }

            /* Styling for form labels */
            .password-card label {
                margin-bottom: 8px;
            }

            /* General form input styling */
            .password-card .form-control {
                border: 1px solid #ced4da;
                border-radius: 8px;
                padding: 12px;
                font-size: 15px;
                transition: border-color 0.3s;
            }

            .password-card .form-control:focus {
                border-color: #28a745;
                box-shadow: 0 0 8px rgba(40, 167, 69, 0.2); /* Green glow effect */
            }

            /* Button styling */
            .password-card .btn {
                padding: 10px;
                font-size: 15px;
                border-radius: 50px;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            /* Primary button style */
            .password-card .btn-success {
                background-color: #28a745;
                border: none;
                width: 100%;
            }

            .password-card .btn-success:hover {
                background-color: #218838;
                transform: translateY(-3px);
            }

            /* Secondary button style */
            .password-card .btn-secondary {
                background-color: #6c757d;
                border: none;
                width: 100%;
            }

            .password-card .btn-secondary:hover {
                background-color: #5a6268;
                transform: translateY(-3px);
            }

            /* Password visibility toggle */
            .toggle-password {
                position: absolute;
                top: 35px;
                right: 15px;
                cursor: pointer;
                color: #007bff;
                font-size: 14px;
            }

            .toggle-password:hover {
                color: #0056b3;
            }

            /* Error message styling */
            .error-message {
                color: #ff6b6b;
                margin-top: 10px;
                font-size: 14px;
                background-color: #ffecec;
                border: 1px solid #f5c6cb;
                padding: 12px;
                border-radius: 8px;
                font-weight: bold;
                text-align: center;
                margin-bottom: 23px;
            }

            /* Password note styling */
            .password-note {
                font-size: 12px;
                color: gray;
                margin-top: 5px;
                display: none; /* Hidden by default */
            }

            /* Form group spacing */
            .form-group {
                margin-bottom: 20px;
                position: relative;
            }

            /* Align buttons on the same row */
            .btn-group {
                display: flex;
                gap: 10px;
            }
        </style>
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>

        <!-- Include Header -->
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Password Change Form -->
        <div class="password-container">
            <div class="password-card">
                <h2>Change Password</h2>
                <form action="${pageContext.request.contextPath}/authen?action=change-password" method="POST" onsubmit="return validateForm()">
                    <div class="form-group position-relative">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" class="form-control" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('currentPassword', this)">Show</span>
                    </div>
                    <div class="form-group position-relative">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('newPassword', this)">Show</span>
                        <p id="passwordNote" class="password-note">Passwords must be 8 to 20 characters long and include numbers, letters, and special characters.</p>
                    </div>
                    <div class="form-group position-relative">
                        <label for="retypePassword">Retype Password</label>
                        <input type="password" id="retypePassword" name="retypePassword" class="form-control" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('retypePassword', this)">Show</span>
                    </div>
                    <c:if test="${not empty requestScope.changePWfail}">
                        <div class="error-message">${requestScope.changePWfail}</div>
                    </c:if>
                    <div class="btn-group">
                        <button type="submit" class="btn btn-success">Update</button>
                        <button type="button" class="btn btn-secondary" onclick="cancelChangePassword()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>

        <!-- JavaScript -->
        <script>
            function togglePasswordVisibility(id, element) {
                var input = document.getElementById(id);
                if (input.type === "password") {
                    input.type = "text";
                    element.textContent = "Hide";
                } else {
                    input.type = "password";
                    element.textContent = "Show";
                }
            }

            function cancelChangePassword() {
                window.location.href = "${pageContext.request.contextPath}/view/recruiter/viewRecruiterProfile.jsp";
            }

            var newPasswordInput = document.getElementById('newPassword');
            var passwordNote = document.getElementById('passwordNote');

            newPasswordInput.addEventListener('focus', function () {
                passwordNote.style.display = 'block';
            });

            newPasswordInput.addEventListener('blur', function () {
                passwordNote.style.display = 'none';
            });

            function preventSpaces(event) {
                if (event.key === " ") {
                    event.preventDefault();
                    alert("Passwords cannot contain spaces.");
                }
            }

            function validateForm() {
                var currentPassword = document.getElementById("currentPassword").value;
                var newPassword = document.getElementById("newPassword").value;
                var retypePassword = document.getElementById("retypePassword").value;

                if (currentPassword.includes(" ") || newPassword.includes(" ") || retypePassword.includes(" ")) {
                    alert("Passwords cannot contain spaces.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>
