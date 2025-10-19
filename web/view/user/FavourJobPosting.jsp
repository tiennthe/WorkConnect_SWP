<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.JobPostings" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Favourite Job Posting</title>
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

            <div class="container mb-5 mt-5">
                <h1 class="text-center">My Favourite Job Posting</h1>

            <c:if test="${not empty errorFavourJP}">
                <div class="alert alert-danger" role="alert">
                    ${errorFavourJP}
                </div>
            </c:if>

            <c:if test="${not empty successFavourJP}">
                <div class="alert alert-success" role="alert">
                    ${successFavourJP}
                </div>
            </c:if>

            <c:if test="${not empty favourJPs}">
                <table class="table table-bordered">
                    <thead class="thead-light">
                        <tr>
                            <th>Job Title</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="fjp" items="${favourJPs}">
                            <tr>

                                <td><c:out value="${jobPostingMap[fjp.favourJPID]}" /></td>
                                <td>
                                    <button type="button" 
                                            class="btn btn-info btn-sm" 
                                            onclick="window.location.href = '${pageContext.request.contextPath}/jobPostingDetail?action=details&idJP=${fjp.jobPostingID}'"
                                            <c:if test="${favourJPMap[fjp.favourJPID] == 'Violate'}">disabled</c:if>>
                                                <i class="fa-solid fa-eye"></i> View
                                            </button> 
                                            <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteFavourJPModal-${fjp.favourJPID}">
                                                <i class="fa fa-trash"></i> Unlike
                                            </button>
                                                <c:if test="${favourJPMap[fjp.favourJPID] == 'Violate'}">
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-triangle-exclamation"></i> This job posting is violated!</span>
                                    </c:if>
                                    </td>
                                    
                                </tr>

                                <!-- Modal for Cancel Application -->
                            <div class="modal fade" id="deleteFavourJPModal-${fjp.favourJPID}" tabindex="-1" aria-labelledby="cancelModalLabel-${app.applicationID}" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="deleteFavourJPModal-${fjp.favourJPID}">Unlike Job Posting</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/FavourJobPosting" method="post">
                                        <div class="modal-body">
                                            <p>Are you sure you want to unlike this job posting?</p>
                                            <input type="hidden" name="action" value="delete-favourJP">
                                            <input type="hidden" name="favourJPId" value="${fjp.favourJPID}">
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" class="btn btn-danger">Confirm Unlike</button>
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
                <nav aria-label="Page navigation" class="footer-container">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/FavourJobPosting?page=${currentPage - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo; Previous</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/FavourJobPosting?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/FavourJobPosting?page=${currentPage + 1}" aria-label="Next">
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