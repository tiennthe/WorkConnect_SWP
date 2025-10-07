<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Seeker's Education</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
                <h1 class="text-center">Education Profile</h1>



            <c:if test="${not empty errorJobSeeker}">
                <div class="alert alert-danger" role="alert">
                    ${errorJobSeeker} <a href="JobSeekerCheck">Click here!!</a>
                </div>
            </c:if>

            <c:if test = "${empty errorJobSeeker}">
                <!-- Display error messages if any -->
                <c:if test="${not empty errorEducation}">
                    <div class="alert alert-danger" role="alert">
                        ${errorEducation}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <!-- Display success messages if any -->
                <c:if test="${not empty successEducation}">
                    <div class="alert alert-success" role="alert">
                        ${successEducation}
                    </div>
                </c:if>

                <!-- Display education details in a table -->
                <c:if test="${not empty edus}">
                    <table class="table table-bordered">
                        <thead class="thead-light">
                            <tr>
                                <th>Institution</th>
                                <th>Degree</th>
                                <th>Field of Study</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Degree Image</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="edu" items="${edus}">
                                <tr>
                                    <td>${edu.institution}</td>
                                    <td>${edu.degree}</td>
                                    <td>${edu.fieldOfStudy}</td>
                                    <td>${edu.startDate}</td>
                                    <td><c:if test="${not empty edu.endDate}">${edu.endDate}</c:if><c:if test="${empty edu.endDate}">N/A</c:if></td>
                                    <td><img src="${edu.getDegreeImg()}" alt="Certificate" class="img-fluid img-thumbnail" style="max-width: 100px;"
                                             data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showImage('${edu.getDegreeImg()}')"></td>
                                    <td>
                                        <button type="button" class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#updateEducationModal-${edu.educationID}" 
                                                onclick="populateUpdateModal('${edu.educationID}', '${edu.institution}', '${edu.degree}', '${edu.fieldOfStudy}', '${edu.startDate}', '${edu.endDate}', '${edu.getDegreeImg()}')">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete('${edu.educationID}')">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>

                                <!-- Update Education Modal -->
                            <div class="modal fade" id="updateEducationModal-${edu.educationID}" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-xl">
                                    <div class="modal-content">
                                        <div class="modal-header bg-success text-white">
                                            <h5 class="modal-title" id="updateModalLabel">Update Education</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="${pageContext.request.contextPath}/education" method="post" id="updateEducationForm-${edu.educationID}" enctype="multipart/form-data">
                                                <input type="hidden" name="action" value="update-education">
                                                <input type="hidden" name="educationID" value="${edu.educationID}">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="institution">Institution</label>
                                                            <input type="text" class="form-control" id="institution" name="institution" value="${edu.institution}" required>
                                                        </div>

                                                        <div class="form-group mb-3">
                                                            <label for="degree">Degree</label>
                                                            <select class="form-select" id="degree" name="degree" required>
                                                                <option value="Bachelor" <c:if test="${edu.degree == 'Bachelor'}">selected</c:if>>Bachelor</option>
                                                                <option value="Master" <c:if test="${edu.degree == 'Master'}">selected</c:if>>Master</option>
                                                                <option value="PhD" <c:if test="${edu.degree == 'PhD'}">selected</c:if>>PhD</option>
                                                                <option value="Different" <c:if test="${edu.degree == 'Different'}">selected</c:if>>Different</option>
                                                                </select>
                                                            </div>

                                                            <div class="form-group mb-3">
                                                                <label for="fieldofstudy">Field of Study</label>
                                                                <input type="text" class="form-control" id="fieldofstudy" name="fieldofstudy" value="${edu.fieldOfStudy}" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="startDate">Start Date</label>
                                                            <input type="date" class="form-control" id="startDate" name="startDate" value="${edu.startDate}" required>
                                                        </div>

                                                        <div class="form-group mb-3">
                                                            <label for="endDate">End Date</label>
                                                            <input type="date" class="form-control" id="endDate" name="endDate" value="${edu.endDate}">
                                                        </div>
                                                        <span style="color: green; font-style: italic">If you haven't graduated yet and are still in school, you can enter your anticipated graduation date here.</span>
                                                        <div class="form-group mb-3">
                                                            <label for="certificate">Load your degree</label>
                                                            <input type="file" class="form-control" id="certificate" name="degreeImg"  accept="image/*" required>
                                                        </div>
                                                    </div>
                                                </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" form="updateEducationForm-${edu.educationID}" class="btn btn-success">Update Education</button>
                                        </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Button to trigger the modal for adding/updating education -->
                <button type="button" class="btn btn-success mt-4" data-bs-toggle="modal" data-bs-target="#educationModal">
                    Add Education
                </button>
            </c:if>


        </div>

        <!-- Modal for adding/updating education -->
        <div class="modal fade" id="educationModal" tabindex="-1" aria-labelledby="AddModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title" id="educationModalLabel">Add Education</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/education" method="post" id="educationForm" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="add-education">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="institution">Institution</label>
                                        <input type="text" class="form-control" id="institution" name="institution" value="${sessionScope.institution}" required>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="degree">Degree</label>
                                        <select class="form-select" id="degree" name="degree" required>
                                            <option value="Bachelor" <c:if test="${sessionScope.degree == 'Bachelor'}">selected</c:if>>Bachelor</option>
                                            <option value="Master" <c:if test="${sessionScope.degree == 'Master'}">selected</c:if>>Master</option>
                                            <option value="PhD" <c:if test="${sessionScope.degree == 'PhD'}">selected</c:if>>PhD</option>
                                            <option value="Different" <c:if test="${sessionScope.degree == 'Different'}">selected</c:if>>Different</option>
                                        </select>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="fieldofstudy">Field of Study</label>
                                        <input type="text" class="form-control" id="fieldofstudy" name="fieldofstudy" value="${sessionScope.fieldofstudy}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="startDate">Start Date</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" value="${sessionScope.startDateStr}" required>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="endDate">End Date</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" value="${sessionScope.endDateStr}" required>
                                    </div>
                                    <span style="color: green; font-style: italic">If you haven't graduated yet and are still in school, you can enter your anticipated graduation date here.</span>
                                    <div class="form-group mb-3">
                                        <label for="degreeImg">Load your degree</label>
                                        <input type="file" class="form-control" id="degreeImg" name="degreeImg" accept="image/*" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" form="educationForm" class="btn btn-success" id="submitEducationForm">Add Education</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Image</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img id="modalImage" src="" alt="Image" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Image</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img id="modalImage" src="" alt="Image" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>


        <!-- Footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

            <script>
                function confirmDelete(educationID) {
                    if (confirm("Are you sure you want to delete this education record?")) {
                        // If confirmed, send an AJAX request to delete the education record
                        const xhr = new XMLHttpRequest();
                        xhr.open("POST", "${pageContext.request.contextPath}/education", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                if (xhr.status === 200) {
                                    // Successfully deleted, reload the page or update the UI
                                    alert("Education record deleted successfully.");
                                    location.reload(); // Reload the page to reflect changes
                                } else {
                                    alert("Error deleting education record. Please try again.");
                                }
                            }
                        };
                        xhr.send("action=delete-education&educationID=" + educationID);
                    }
                }

                function showImage(imageUrl) {
                    document.getElementById('modalImage').src = imageUrl;
                }

                
        </script>

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>
