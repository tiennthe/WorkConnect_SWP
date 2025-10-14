<%-- 
    Document   : verifyRecruiter
    Created on : Oct 14, 2025, 8:30:37 PM
    Author     : mTuan1
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Recruiter Authentication</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            body, html {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            /* Main content with padding for sidebar */
            .main-content {
                margin-left: 260px;
                padding: 20px;
                padding-top: 100px; /* Adjust for header */
                background-color: #f7f8fa;
                min-height: 100vh;
                animation: fadeIn 0.8s ease-in-out; /* Fade-in effect for page load */
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            /* Form card styling */
            .card {
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                margin: 0 auto;
                max-width: 600px;
                padding: 30px;
                background-color: #fff;
                transition: transform 0.3s ease, box-shadow 0.3s ease; /* Card hover effect */
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            }

            .card-header {
                text-align: center;
                font-size: 24px;
                color: #389354;
                margin-bottom: 30px;
                font-weight: bold;
            }

            .form-label {
                font-weight: bold;
                color: #333;
            }

            .form-control {
                border-radius: 8px;
                padding: 12px;
                font-size: 16px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Input hover and focus effect */
            }

            .form-control:hover {
                border-color: #5cb85c;
                box-shadow: 0 0 5px rgba(56, 147, 84, 0.2);
            }

            .form-control:focus {
                border-color: #389354;
                box-shadow: 0 0 8px rgba(56, 147, 84, 0.5);
            }

            /* Button styling */
            .btn-submit {
                background-color: #389354;
                color: white;
                border: none;
                padding: 12px;
                font-size: 16px;
                border-radius: 50px;
                width: 100%;
                transition: background-color 0.3s ease, transform 0.2s ease; /* Button hover effect */
            }

            .btn-submit:hover {
                background-color: #2a823d;
                transform: translateY(-3px);
            }

            .btn-submit:active {
                background-color: #207a30;
                transform: scale(0.98); /* Slightly shrink the button when clicked */
            }

            /* Image preview */
            .preview-img {
                width: 100px;
                height: 100px;
                border: 1px solid #ddd;
                margin-top: 10px;
                display: none;
                border-radius: 8px;
                object-fit: cover;
                opacity: 0;
                transition: opacity 0.5s ease; /* Fade-in effect for image */
            }

            .preview-img.show {
                display: block;
                opacity: 1; /* When the image is shown, it fades in */
            }

            /* Alert messages */
            .alert {
                border-radius: 50px;
                padding: 10px 20px;
                animation: bounceIn 0.5s ease-in-out;
            }

            @keyframes bounceIn {
                0% {
                    transform: scale(0.9);
                    opacity: 0.5;
                }
                70% {
                    transform: scale(1.05);
                    opacity: 1;
                }
                100% {
                    transform: scale(1);
                }
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding-top: 80px;
                }

                header, footer {
                    width: 100%;
                    left: 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>

        <!-- Header -->
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Main content -->
        <div class="main-content">
            <div class="card">
                <div class="card-header">Verify Your Account</div>
                <form action="${pageContext.request.contextPath}/verifyRecruiter" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
                    <!-- Company ID input -->
                    <div class="mb-3">
                        <label for="businessCode" class="form-label">Business code:</label>
                        <input type="text" class="form-control" id="businessCode" name="businessCode" placeholder="e.g. 12345" value="${param.businessCode != null ? param.businessCode : ''}" required>
                    </div>

                    <!-- Position input -->
                    <div class="mb-3">
                        <label for="position" class="form-label">Position</label>
                        <input type="text" class="form-control" id="position" name="position" placeholder="e.g. Recruiter" value="${param.position != null ? param.position : ''}" required>
                    </div>

                    <!-- Upload Front of Citizen ID -->
                    <div class="mb-3">
                        <label for="frontCitizenID" class="form-label">Front of Citizen ID</label>
                        <input type="file" class="form-control" id="frontCitizenID" name="frontCitizenID" accept="image/*" onchange="previewImage(this, 'frontPreview')" required>
                        <img id="frontPreview" class="preview-img" alt="Front Citizen ID">
                    </div>

                    <!-- Upload Back of Citizen ID -->
                    <div class="mb-3">
                        <label for="backCitizenID" class="form-label">Back of Citizen ID</label>
                        <input type="file" class="form-control" id="backCitizenID" name="backCitizenID" accept="image/*" onchange="previewImage(this, 'backPreview')" required>
                        <img id="backPreview" class="preview-img" alt="Back Citizen ID">
                    </div>

                    <!-- Error and success messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">${error}</div>
                    </c:if>
                    <c:if test="${not empty verify}">
                        <div class="alert alert-success text-center">${verify}</div>
                    </c:if>

                    <!-- Submit button -->
                    <button type="submit" class="btn btn-submit">Submit Request</button>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>

        <!-- JavaScript -->
        <script>
            function previewImage(input, imageId) {
                const file = input.files[0];
                const imgElement = document.getElementById(imageId);

                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        imgElement.src = e.target.result;
                        imgElement.classList.add('show'); // Add class to trigger fade-in effect
                    }
                    reader.readAsDataURL(file);
                }
            }

            function validateForm() {
                var companyId = document.getElementById("companyId").value;
                var regex = /^[0-9]+$/;
                if (!regex.test(companyId)) {
                    alert("Company ID must be a number.");
                    return false;
                }
                return true;
            }
        </script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
