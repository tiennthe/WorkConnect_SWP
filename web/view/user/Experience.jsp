<%-- 
    Document   : Experience
    Created on : Oct 14, 2025, 9:39:14 PM
    Author     : dungvthe173074
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Seeker's Experience</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
        <style>
            body {
                background-color: #f4f4f9;
            }
            h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 30px;
                text-transform: uppercase;
                position: relative;
            }
            h1::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 50px;
                height: 5px;
                background-color: #28a745;
            }
            table {
                border-collapse: separate;
                border-spacing: 0 15px;
            }
            thead th {
                background-color: #28a745;
                color: #fff;
                text-transform: uppercase;
                padding: 10px;
            }
            tbody tr {
                background-color: #f9f9f9;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border-radius: 5px;
            }
            tbody tr:hover {
                background-color: #e9ecef;
            }
            td {
                padding: 15px;
                vertical-align: middle;
            }
            button:hover {
                transform: scale(1.05);
                transition: transform 0.2s ease;
            }
            .btn-warning {
                background-color: #ffc107;
                border-color: #ffc107;
            }
            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
            }
            .modal-content {
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                border-radius: 10px;
            }
            .modal-header {
                border-bottom: 0;
                background-color: #28a745;
                color: white;
            }
        </style>
    </head>
    <body>
        <!-- Header Area -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>
            <!-- Header Area End -->

            <div class='container mt-5 mb-5'>
                <h1 class="text-center">Experience Profile</h1>



            <c:if test="${not empty errorJobSeeker}">
                <div class="alert alert-danger" role="alert">
                    ${errorJobSeeker} <a href="JobSeekerCheck">Click here!!</a>
                </div>
            </c:if>

            <c:if test="${empty errorJobSeeker}">
                <!-- Display error messages if any -->
                <c:if test="${not empty errorExperience}">
                    <div class="alert alert-danger" role="alert">
                        ${errorExperience}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <!-- Display success messages if any -->
                <c:if test="${not empty successExperience}">
                    <div class="alert alert-success" role="alert">
                        ${successExperience}
                    </div>
                </c:if>

                <!-- Display education details in a table -->
                <c:if test="${not empty wes}">
                    <table class="table table-bordered">
                        <thead class="thead-light">
                            <tr>
                                <th>Company Name</th>
                                <th>Job Title</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="we" items="${wes}">
                                <tr>
                                    <td>${we.companyName}</td>
                                    <td>${we.jobTitle}</td>
                                    <td>${we.startDate}</td>
                                    <td><c:if test="${not empty we.endDate}">${we.endDate}</c:if><c:if test="${empty we.endDate}">N/A</c:if></td>
                                    <td>${we.description}</td>
                                    <td>
                                        <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#updateExperienceModal-${we.experienceID}" 
                                                onclick="populateUpdateModal('${we.experienceID}', '${we.companyName}', '${we.jobTitle}', '${we.startDate}', '${we.endDate}', '${we.description}')">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete(${we.experienceID})">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>

                                <!-- Update Education Modal -->
                            <div class="modal fade" id="updateExperienceModal-${we.experienceID}" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-xl">
                                    <div class="modal-content">
                                        <div class="modal-header bg-warning text-white">
                                            <h5 class="modal-title" id="updateModalLabel">Update Experience</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="${pageContext.request.contextPath}/experience" method="post" id="updateExperienceForm-${we.experienceID}">
                                                <input type="hidden" name="action" value="update-experience">
                                                <input type="hidden" name="experienceID" value="${we.experienceID}">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="companyName">Institution</label>
                                                            <input type="text" class="form-control" id="companyName" name="companyName" value="${we.companyName}" required>
                                                        </div>

                                                        <div class="form-group mb-3">
                                                            <label for="jobTitle">Job Title</label>
                                                            <input type="text" class="form-control" id="jobTitle" name="jobTitle" value="${we.jobTitle}" required>
                                                        </div>

                                                        <div class="form-group mb-3">
                                                            <label for="description">Description</label>
                                                            <textarea id="description" name="description" class="form-control" placeholder="Enter work experience description" rows="3" required>${we.description}</textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="startDate">Start Date</label>
                                                            <input type="date" class="form-control" id="startDate" name="startDate" value="${we.startDate}" required>
                                                        </div>

                                                        <div class="form-group mb-3">
                                                            <label for="endDate">End Date</label>
                                                            <input type="date" class="form-control" id="endDate" name="endDate" value="${we.endDate}">
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" form="updateExperienceForm-${we.experienceID}" class="btn btn-warning">Update Experience</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Button to trigger the modal for adding/updating education -->
                <button type="button" class="btn btn-success mt-4" data-bs-toggle="modal" data-bs-target="#experienceModal">
                    Add Experience
                </button>
            </c:if>


        </div>

        <!-- Modal for adding/updating education -->
        <div class="modal fade" id="experienceModal" tabindex="-1" aria-labelledby="AddModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title" id="experienceModalLabel">Add Experience</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/experience" method="post" id="experienceForm">
                            <input type="hidden" name="action" value="add-experience">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="companyName">Company Name</label>
                                        <input type="text" class="form-control" id="companyName" name="companyName" value="${sessionScope.companyName}" required>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="jobTitle">Job Title</label>
                                        <input type="text" class="form-control" id="jobTitle" name="jobTitle" value="${sessionScope.jobTitle}" required>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="description">Description</label>
                                        <textarea id="description" name="description" class="form-control" placeholder="Enter work experience description" rows="3" required>${sessionScope.description}</textarea>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="startDate">Start Date</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" value="${sessionScope.startDateStr}" required>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="endDate">End Date</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" value="${sessionScope.endDateStr}">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" form="experienceForm" class="btn btn-success">Add Experience</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

            <script>
                function confirmDelete(experienceID) {
                    if (confirm("Are you sure you want to delete this experience record?")) {
                        // If confirmed, send an AJAX request to delete the education record
                        const xhr = new XMLHttpRequest();
                        xhr.open("POST", "${pageContext.request.contextPath}/experience", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                if (xhr.status === 200) {
                                    // Successfully deleted, reload the page or update the UI
                                    alert("Experience record deleted successfully.");
                                    location.reload(); // Reload the page to reflect changes
                                } else {
                                    alert("Error deleting experience record. Please try again.");
                                }
                            }
                        };
                        xhr.send("action=delete-experience&experienceID=" + experienceID);
                    }
                }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>

