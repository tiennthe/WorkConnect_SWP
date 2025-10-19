<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.JobPostings" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Applications</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Custom styles */
            body {
                background-color: #f4f4f9;
            }
            h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 30px;
                text-align: center;
                text-transform: uppercase;
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
            .badge {
                padding: 5px 10px;
                font-size: 0.9rem;
            }
            .btn-warning {
                background-color: #ffc107;
                border-color: #ffc107;
            }
            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
            }
        </style>
    </head>
    <body>
        <!-- Header Area -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>
            <!-- Header Area End -->

            <div class="container mt-5 mb-5">
                <h1 class="text-center">My Applications</h1>

                <!-- Display error or success message if any -->
            <c:if test="${not empty errorApplication}">
                <div class="alert alert-danger" role="alert">
                    ${errorApplication}
                </div>
            </c:if>

            <c:if test="${not empty successApplication}">
                <div class="alert alert-success" role="alert">
                    ${successApplication}
                </div>
            </c:if>

            <!-- Applications Table -->
            <c:if test="${not empty applications}">
                <form action="application" method="GET" class="mb-4">
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="" ${empty param.status ? 'selected' : ''}>All Status</option>
                        <option value="3" ${param.status == '3' ? 'selected' : ''}>Pending</option>
                        <option value="2" ${param.status == '2' ? 'selected' : ''}>Approved</option>
                        <option value="1" ${param.status == '1' ? 'selected' : ''}>Rejected</option>
                        <option value="0" ${param.status == '0' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </form>

                <table class="table table-bordered">
                    <thead class="thead-light">
                        <tr>
                            <th>Job Title</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${applications}">
                            <tr>
                                <td><c:out value="${jobPostingMap[app.applicationID]}" /></td>
                                <td>${app.appliedDate}</td>
                                <td>
                                    <!-- Display the violation message if it exists, otherwise display the status badge -->
                                    <c:choose>
                                        <c:when test="${applicationStatusMap[app.applicationID] == 'Violate'}">
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-triangle-exclamation"></i> Violate</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${app.status == 3}">
                                                    <span class="badge bg-info text-dark"><i class="fa fa-clock"></i> Pending</span>
                                                </c:when>
                                                <c:when test="${app.status == 2}">
                                                    <span class="badge bg-success"><i class="fa fa-check-circle"></i> Approved</span>
                                                </c:when>
                                                <c:when test="${app.status == 1}">
                                                    <span class="badge bg-danger"><i class="fa fa-times-circle"></i> Rejected</span>
                                                </c:when>
                                                <c:when test="${app.status == 0}">
                                                    <span class="badge bg-secondary"><i class="fa fa-ban"></i> Cancelled</span>
                                                </c:when>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <!-- View Button: Disabled if the job posting is "Violate" -->
                                    <button type="button" 
                                            class="btn btn-info btn-sm" 
                                            onclick="window.location.href = '${pageContext.request.contextPath}/ViewDetailApplication?action=details&applicationId=${app.applicationID}'"
                                            <c:if test="${applicationStatusMap[app.applicationID] == 'Violate'}">disabled</c:if>>
                                                <i class="fa-solid fa-eye"></i> View
                                            </button>

                                            <!-- Cancel Button: Disabled if the application status is not Pending (3) or the job posting is "Violate" -->
                                            <button type="button" 
                                                    class="btn btn-danger btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#cancelApplicationModal-${app.applicationID}"
                                            <c:if test="${app.status != 3 || applicationStatusMap[app.applicationID] == 'Violate'}">disabled</c:if>>
                                                <i class="fa fa-ban"></i> Cancel
                                            </button>
                                    </td>

                                </tr>

                                <!-- Modal for Cancel Application -->
                            <div class="modal fade" id="cancelApplicationModal-${app.applicationID}" tabindex="-1" aria-labelledby="cancelModalLabel-${app.applicationID}" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="cancelModalLabel-${app.applicationID}">Cancel Application</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/application" method="post">
                                        <div class="modal-body">
                                            <p>Are you sure you want to cancel this application?</p>
                                            <input type="hidden" name="action" value="cancel-application">
                                            <input type="hidden" name="applicationId" value="${app.applicationID}">
                                            <input type="hidden" name="status" value="0">
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" class="btn btn-danger">Confirm Cancel</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- End of Modal -->
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <!-- Pagination -->
            <nav aria-label="Page navigation" class="footer-container">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/application?page=${currentPage - 1}&status=${selectedStatus}" aria-label="Previous">
                                <span aria-hidden="true">&laquo; Previous</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/application?page=${i}&status=${selectedStatus}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/application?page=${currentPage + 1}&status=${selectedStatus}" aria-label="Next">
                                <span aria-hidden="true">Next &raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>


        </div>

        <!-- Footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

        <!-- Bootstrap and JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>