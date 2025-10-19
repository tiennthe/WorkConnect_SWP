<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>View Job Posting Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>

        <!-- Include header -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>

            <div class="container my-5">
            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getParameter("error") %>
            </div>
            <% } %>

            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getParameter("success") %>
            </div>
            <% } %>
            <c:if test="${not empty jobPost}">
                <div class="row">
                    <!-- Job Details Section -->
                    <div class="col-md-10">
                        <!-- Job Basic Info -->
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body">
                                <h1 class="card-title">${jobPost.title}</h1>
                                <hr>
                                <div class="row">
                                    <div class="col-md-4">
                                        <p><i class="fas fa-calendar-alt"></i> <strong>Post Date:</strong> ${jobPost.postedDate}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fas fa-hourglass-end"></i> <strong>Deadline:</strong> ${jobPost.closingDate}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-location-dot"></i> <strong>Location: </strong>${jobPost.location}</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-circle"></i> <strong>Status: </strong>${jobPost.status}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-money-bill"></i> <strong>Salary: </strong>${jobPost.minSalary} $ - ${jobPost.maxSalary} $</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <c:choose>
                                        <c:when test="${category != 'This category was deleted!'}">
                                            <!-- Hiển thị thông tin Category nếu Category hợp lệ -->
                                            <p><i class="fa-solid fa-list"></i> <strong>Job Category:</strong> ${category.name}</p>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Hiển thị thông báo lỗi nếu Category bị xóa hoặc không tồn tại -->
                                            <p><i class="fa-solid fa-list"></i> <strong>Job Category:</strong> This category was deleted!</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <!-- Sidebar Section for Application Form -->
                        <div class="card mb-4 shadow-sm">
                            <!-- Card Header -->

                            <!-- Card Body -->
                            <div class="card-body">
                                <!-- Error Message -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger text-center" role="alert">
                                        ${error}
                                    </div>
                                </c:if>

                                <c:if test="${empty existFavourJP}">
                                    <!-- Like Form -->
                                    <form action="${pageContext.request.contextPath}/jobPostingDetail?action=add-favourJP" method="post" class="mb-3">
                                        <input type="hidden" name="jobPostingIDF" value="${jobPost.jobPostingID}">
                                        <c:if test="${not empty jobSeekerF}">
                                            <input type="hidden" name="jobSeekerIDF" value="${jobSeekerF.jobSeekerID}">
                                        </c:if>
                                        <button type="submit" class="btn btn-outline-primary btn-block w-100">
                                            <i class="fas fa-thumbs-up"></i> Like
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${not empty existFavourJP}">
                                    <button class="btn btn-primary btn-block w-100 mb-3">
                                        <i class="fas fa-thumbs-up"></i> Liked
                                    </button>
                                </c:if>
                                <c:if test="${empty existingApplication}">
                                    <!-- Apply Job Form -->
                                    <c:if test="${not empty isOpenJP}">
                                    <form action="${pageContext.request.contextPath}/jobPostingDetail?action=add-application" method="post">
                                        <input type="hidden" name="jobPostingID" value="${jobPost.jobPostingID}">
                                        <c:if test="${not empty jobSeeker}">
                                            <input type="hidden" name="jobSeekerID" value="${jobSeeker.jobSeekerID}">
                                        </c:if>
                                        <c:if test="${not empty cv}">
                                            <input type="hidden" name="cvid" value="${cv.CVID}">
                                        </c:if>
                                        <button type="submit" class="btn btn-success btn-block w-100">
                                            <i class="fas fa-paper-plane"></i> Apply Job
                                        </button>
                                    </form>
                                    </c:if>
                                </c:if>
                                <c:if test="${not empty existingApplication}">
                                    <button class="btn btn-outline-success btn-block w-100">
                                        <i class="fas fa-paper-plane"></i> Applied Job
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Job Description -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="m-0">Description</h5>
                    </div>
                    <div class="card-body">
                        <p>${jobPost.description}</p>
                    </div>
                </div>

                <!-- Job Requirements -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="m-0">Requirements</h5>
                    </div>
                    <div class="card-body">
                        <p>${jobPost.requirements}</p>
                    </div>
                </div>
            </c:if>
        </div>
        <!--feedback-->
        <div class="container my-5">
            <c:if test="${not empty jobPost}">
                <!-- Existing Job Posting Code... -->
                <c:if test="${not empty notice}">
                    <div class="position-fixed top-0 end-0 p-3" style="z-index: 11">
                        <div id="liveToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body">
                                    ${notice}
                                </div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    </div>
                </c:if>
                <!-- Feedback Section -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="m-0">Feedback <i class="fas fa-comments"></i></h5>
                    </div>
                    <div class="card-body">
                        <!-- Feedback Form -->
                        <form action="${pageContext.request.contextPath}/feedbackSeeker?action=create" method="post">
                            <input type="hidden" name="jobPostingID" value="${jobPost.getJobPostingID()}">
                            <div class="mb-3">
                                <label for="feedbackContent" class="form-label">Leave your feedback:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-pencil-alt"></i></span>
                                    <textarea class="form-control" id="feedbackContent" name="content" rows="3" required placeholder="Enter your feedback here..."></textarea>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit Feedback
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>


        <!-- Include footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

        <!-- Bootstrap JS and Popper -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var toastEl = document.getElementById('liveToast');
                if (toastEl) {
                    var toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }
            });
        </script>
    </body>
</html>