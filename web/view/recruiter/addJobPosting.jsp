<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Job Posting</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- TinyMCE Script -->
        <script src="https://cdn.tiny.cloud/1/ygxzbqd4ej8z1yjswkp0ljn56qm4r6luix9l83auaajk3h3q/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>

        <style>
            /* General form container styles */
            .job-posting-container {
                flex: 1;
                padding: 40px;
                margin-left: 260px;
                margin-top: 80px;
                box-sizing: border-box;
                background-color: #f9f9f9;
                display: flex;
                justify-content: center;
                align-items: flex-start;
            }

            /* Form card styling with hover effect */
            .job-posting-card {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 10px;
                border: 1px solid #ddd;
                max-width: 850px;
                width: 100%;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .job-posting-card:hover {
                transform: scale(1.02);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
            }

            /* Title styling */
            .job-posting-card h2 {
                text-align: center;
                margin-bottom: 30px;
                font-weight: bold;
                color: #007b5e;
            }

            /* Label and input field styling with hover effect */
            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 15px;
                color: #389354;
            }

            .form-control {
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 12px;
                font-size: 15px;
                background-color: #f0f8f5;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 20px;
            }

            .form-control:focus {
                border-color: #007b5e;
                box-shadow: 0 0 5px rgba(0, 123, 94, 0.5);
            }

            /* Button styling with hover effect */
            .btn-group {
                display: flex;
                justify-content: flex-start;
                gap: 20px;
                margin-top: 20px;
            }

            .btn-success, .btn-secondary {
                padding: 12px 24px;
                font-size: 16px;
                border-radius: 5px;
                transition: background-color 0.3s ease, transform 0.3s ease;
            }

            .btn-success {
                background-color: #007b5e;
                border: none;
                color: white;
            }

            .btn-secondary {
                background-color: #6c757d;
                border: none;
                color: white;
            }

            .btn-success:hover {
                background-color: #005f46;
                transform: scale(1.05);
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                transform: scale(1.05);
            }

            /* Checkbox styling */
            .form-check {
                margin-top: 20px;
            }

            /* Error and success message styling */
            .alert {
                margin-top: 20px;
                border-radius: 5px;
            }

        </style>
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>
        <!-- Include Header -->
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Job Posting Form -->
        <div class="job-posting-container">
            <div class="job-posting-card">
                <a href="${pageContext.request.contextPath}/jobPost" class="btn btn-outline-secondary mb-3">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
                <form id="jobPostingForm" action="${pageContext.request.contextPath}/jobPost?action=add-jp" method="POST" onsubmit="return validateForm()">
                    <h2>Add Job Posting</h2>

                    <!-- Title -->
                    <div class="form-group">
                        <label for="jobTitle">Job Title:</label>
                        <input type="text" id="jobTitle" name="jobTitle" class="form-control" placeholder="Enter job title" value="${fn:escapeXml(jobTitle)}" required>
                    </div>

                    <!-- Description -->
                    <div class="form-group">
                        <label for="jobDescription">Job Description:</label>
                        <textarea id="jobDescription" name="jobDescription" class="form-control" placeholder="Enter job description" rows="6">${fn:escapeXml(jobDescription)}</textarea>
                    </div>

                    <!-- Requirements -->
                    <div class="form-group">
                        <label for="jobRequirements">Job Requirements:</label>
                        <textarea id="jobRequirements" name="jobRequirements" class="form-control" placeholder="Enter job requirements" rows="6">${fn:escapeXml(jobRequirements)}</textarea>
                    </div>

                    <!-- Two-column row for Min Salary, Max Salary -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="minSalary">Min Salary $:</label>
                                <input type="number" id="minSalary" name="minSalary" class="form-control" placeholder="Enter minimum salary" value="${minSalary}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="maxSalary">Max Salary $:</label>
                                <input type="number" id="maxSalary" name="maxSalary" class="form-control" placeholder="Enter maximum salary" value="${maxSalary}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Location -->
                    <div class="form-group">
                        <label for="jobLocation">Location:</label>
                        <input type="text" id="jobLocation" name="jobLocation" class="form-control" placeholder="Enter job location" value="${fn:escapeXml(jobLocation)}" required>
                    </div>

                    <!-- Status and Posted Date -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="jobStatus">Status:</label>
                                <select id="jobStatus" name="jobStatus" class="form-control" required>
                                    <option value="Open" <c:if test="${jobStatus == 'Open'}">selected</c:if>>Open</option>
<!--                                    <option value="Filled" <c:if test="${jobStatus == 'Filled'}">selected</c:if>>Filled</option>
                                    <option value="Closed" <c:if test="${jobStatus == 'Closed'}">selected</c:if>>Closed</option>-->
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="postedDate">Posted Date:</label>
                                    <input type="date" id="postedDate" name="postedDate" class="form-control" value="${postedDate}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Closing Date and Category -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="closingDate">Closing Date:</label>
                                <input type="date" id="closingDate" name="closingDate" class="form-control" value="${closingDate}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="jobCategory">Job Category:</label>
                                <select id="jobCategory" name="jobCategory" class="form-control" required>
                                    <option value="">Select Job Category</option>
                                    <c:forEach var="category" items="${jobCategories}">
                                        <c:if test="${category.status == true}">
                                            <option value="${category.id}" <c:if test="${category.id == selectedJobCategory}">selected</c:if>>${category.name}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Checkbox -->
                    <div class="form-check">
                        <input type="checkbox" id="jobPathAgreement" name="jobPathAgreement" class="form-check-input" required>
                        <label class="form-check-label" for="jobPathAgreement">
                            I have read and agree to Job Path's Terms of Service
                        </label>
                    </div>

                    <!-- Error Message -->
                    <c:if test="${not empty erMess}">
                        <div class="alert alert-danger" role="alert">
                            <ul>
                                <c:forEach var="error" items="${erMess}">
                                    <li>${error}</li>
                                    </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <!-- Success Message -->
                    <c:if test="${not empty successPost}">
                        <div class="alert alert-success">
                            ${successPost}
                        </div>
                    </c:if>

                    <!-- Buttons -->
                    <div class="btn-group">
                        <button type="submit" class="btn btn-success">Save Job</button>
                        <button type="button" class="btn btn-secondary" onclick="clearForm()">Reset</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Include Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>

        <!-- JavaScript to handle form reset and validation -->
        <script>
            function clearForm() {
                // Manually reset each input field by ID
                document.getElementById("jobTitle").value = '';
                document.getElementById("minSalary").value = '';
                document.getElementById("maxSalary").value = '';
                document.getElementById("jobLocation").value = '';
                document.getElementById("postedDate").value = '';
                document.getElementById("closingDate").value = '';
                document.getElementById("jobStatus").selectedIndex = 0;
                document.getElementById("jobCategory").selectedIndex = 0;
                document.getElementById("jobPathAgreement").checked = false;

                // Manually clear TinyMCE fields
                tinymce.get("jobDescription").setContent('');
                tinymce.get("jobRequirements").setContent('');
            }

            // Initialize TinyMCE with required validation check
            tinymce.init({
                selector: 'textarea',
                plugins: 'advlist autolink lists link image charmap print preview anchor',
                toolbar: 'undo redo | formatselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat',
                branding: false,
                height: 300,
                setup: function (editor) {
                    editor.on('change', function () {
                        tinymce.triggerSave();
                    });
                }
            });

            // Custom form validation for TinyMCE fields
            function validateForm() {
                let description = tinymce.get("jobDescription").getContent();
                let requirements = tinymce.get("jobRequirements").getContent();

                if (description.trim() === "" || requirements.trim() === "") {
                    alert("Please fill in the required fields: Job Description and Job Requirements.");
                    return false;
                }
                return true;
            }
        </script>

    </body>
</html>