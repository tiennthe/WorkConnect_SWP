<%-- 
    Document   : deactiveAccountRecruiter
    Created on : Oct 14, 2025, 8:59:24 PM
    Author     : mTuan1
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Deactivate Account</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .main-content {
                margin-left: 260px; /* Space for the sidebar */
                padding: 20px;
                min-height: calc(100vh - 100px); /* Ensure full height */
            }

            .deactivate-card {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                padding: 30px;
                max-width: 600px;
                margin: 0 auto;
            }

            .deactivate-card h6 {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #dc3545;
            }

            .deactivate-card p {
                font-size: 16px;
                margin-bottom: 20px;
            }

            .form-label {
                font-weight: bold;
            }

            .input-group .input-group-text {
                cursor: pointer;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 5px;
            }

            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 5px;
            }

            .btn-primary:hover, .btn-danger:hover {
                opacity: 0.9;
            }

            .text-danger strong {
                font-weight: bold;
            }

            .btn-group {
                display: flex;
                justify-content: space-between;
            }

            /* Hover effect for the card */
            .deactivate-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>

        <!-- Include Header -->
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Main Content Section -->
        <div class="main-content">
            <div class="deactivate-card">
                <h6>Deactivate Your Account</h6>
                <p>Are you sure you want to deactivate your account?</p>

                <!-- Error message if password is incorrect -->
                <c:if test="${requestScope.error != null}">
                    <div class="alert alert-danger text-center">
                        ${requestScope.error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/authen?action=deactivate-account" method="POST">
                    <!-- Password Input -->
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Please Enter Your Login Password</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Enter your password" required onkeydown="preventSpaces(event)">
                            <span class="input-group-text" onclick="togglePasswordVisibility('currentPassword')">
                                👁️
                            </span>
                        </div>
                    </div>

                    <p class="text-danger">
                        <strong>Note:</strong> After your account is deactivated, you will temporarily be unable to use it. If you wish to reactivate your account, please contact the Admin for assistance.
                    </p>

                    <!-- Button Group (Cancel and Deactivate) -->
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary" onclick="cancelDeactivation()">Cancel</button>
                        <button type="submit" class="btn btn-danger">Deactivate Account</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Include Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>

        <!-- JavaScript -->
        <script>
            // Toggle password visibility
            function togglePasswordVisibility(id) {
                const passwordField = document.getElementById(id);
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                } else {
                    passwordField.type = 'password';
                }
            }

            // Prevent spaces in the password
            function preventSpaces(event) {
                if (event.key === " ") {
                    event.preventDefault();
                    alert("Passwords cannot contain spaces.");
                }
            }

            // Cancel button to go back to the previous page
            function cancelDeactivation() {
                window.history.back(); // Navigates to the previous page
            }
        </script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
