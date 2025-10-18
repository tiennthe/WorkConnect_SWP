<%-- 
    Document   : editCompany
    Created on : Oct 14, 2025, 8:15:52 PM
    Author     : quang
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Company</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- TinyMCE Script -->
        <script src="https://cdn.tiny.cloud/1/ygxzbqd4ej8z1yjswkp0ljn56qm4r6luix9l83auaajk3h3q/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
        <style>
            :root {
                --primary-color: #28a745;
                --primary-hover: #218838;
                --border-radius: 8px;
                --shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .main-content {
                padding: 1.25rem;
                margin-left: 250px;
                background-color: #f8f9fa;
                min-height: calc(100vh - 60px);
            }

            .card {
                border: none;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
                background-color: white;
                margin-bottom: 1.5rem;
            }

            .card-header {
                background-color: var(--primary-color);
                color: white;
                border-radius: var(--border-radius) var(--border-radius) 0 0;
                padding: 1rem;
                font-size: 1.1rem;
                font-weight: 600;
                border: none;
            }

            .card-header i {
                margin-right: 0.5rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            .form-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border: 1px solid #dee2e6;
                padding: 0.625rem;
                border-radius: var(--border-radius);
                transition: all 0.2s ease;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            }

            .form-control:disabled,
            .form-control[readonly] {
                background-color: #f8f9fa;
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .alert-warning {
                background-color: #fff3cd;
                border-color: #ffeeba;
                color: #856404;
                font-size: 0.875rem;
                padding: 0.75rem;
                border-radius: var(--border-radius);
                margin-top: 0.5rem;
            }

            .alert-warning i {
                margin-right: 0.5rem;
            }

            .img-thumbnail {
                border-radius: var(--border-radius);
                padding: 0.25rem;
                max-width: 300px;
                height: auto;
                border: 1px solid #dee2e6;
                transition: all 0.2s ease;
            }

            .img-thumbnail:hover {
                box-shadow: var(--shadow);
            }

            .form-footer {
                padding: 1rem;
                background-color: #f8f9fa;
                border-top: 1px solid #dee2e6;
                border-radius: 0 0 var(--border-radius) var(--border-radius);
                display: flex;
                justify-content: flex-start;
            }

            .btn-success {
                background-color: var(--primary-color);
                border: none;
                padding: 0.625rem 1.25rem;
                font-weight: 500;
                border-radius: var(--border-radius);
                transition: all 0.2s ease;
            }

            .btn-success:hover {
                background-color: var(--primary-hover);
                transform: translateY(-1px);
            }

            .btn-success i {
                margin-right: 0.5rem;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 1rem;
                }

                .card-body {
                    padding: 1rem;
                }

                .row > div {
                    margin-bottom: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../recruiter/sidebar-re.jsp" %>

        <div class="main-content">
            <%@ include file="../recruiter/header-re.jsp" %>
            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">
                    ${success}
                </div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-edit"></i> Edit Your Company Information
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-warning" role="alert">
                            ${error}
                        </div>
                    </c:if>
                    <c:if test="${empty error}">
                        <form id="editCompanyForm" action="${pageContext.request.contextPath}/company?action=edit" method="POST">
                            <input type="hidden" name="companyId" value="${requestScope.company.getId()}">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="companyName" class="form-label">Company Name</label>
                                    <input type="text" class="form-control" id="companyName" name="name" 
                                           value="${requestScope.company.getName()}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="companyLocation" class="form-label">Location</label>
                                    <input type="text" class="form-control" id="companyLocation" name="location" 
                                           value="${requestScope.company.getLocation()}" required>
                                </div>

                                <div class="col-md-6">
                                    <label for="companyDescription" class="form-label">Description</label>
                                    <textarea class="form-control" id="companyDescription" name="description" 
                                              required><p>${requestScope.company.getDescription()}</p></textarea>
                                </div>

                                <div class="col-md-6">
                                    <label for="businessCode" class="form-label">Business Code</label>
                                    <input type="text" class="form-control" id="businessCode" name="businessCode" 
                                           value="${requestScope.company.getBusinessCode()}" readonly>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-circle"></i> Business code cannot be edited.
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Business License</label>
                                    <div class="border rounded p-2 bg-light">
                                        <img src="${requestScope.company.getBusinessLicenseImage()}" 
                                             alt="Business License" class="img-thumbnail d-block mx-auto">
                                    </div>
                                </div>
                            </div>

                            <div class="form-footer">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>

        <%@ include file="../recruiter/footer-re.jsp" %>
        <script>
            tinymce.init({
                selector: 'textarea', // Initialize TinyMCE for all text areas
                plugins: 'advlist autolink lists link image charmap print preview anchor',
                toolbar: 'undo redo | formatselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat',
                menubar: true, // Disable the menubar
                branding: false, // Disable the TinyMCE branding
                height: 300, // Set the height of the editor
                setup: function (editor) {
                    editor.on('change', function () {
                        tinymce.triggerSave(); // Synchronize TinyMCE content with the form
                    });
                }
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>