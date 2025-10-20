<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Job_Posting_Category"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Job Posting Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <!-- Include header -->
        <jsp:include page="../view/common/header-area.jsp"></jsp:include>

            <div class="container mb-5 mt-5">
            <c:if test="${not empty jobPost}">
                <div class="row">
                    <!-- Job Details Section -->
                    <div class="col-md-10">
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body">
                                <h1 class="card-title">${jobPost.getTitle()}</h1>
                                <hr>
                                <div class="row">
                                    <div class="col-md-4">
                                        <p><i class="fas fa-calendar-alt"></i> <strong>Post Date:</strong> ${jobPost.getPostedDate()}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fas fa-hourglass-end"></i> <strong>Deadline:</strong> ${jobPost.getClosingDate()}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-location-dot"></i> <strong>Location: </strong>${jobPost.getLocation()}</p>
                                    </div>
                                </div>
                                <div class="row">

                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-circle"></i> <strong>Status: </strong>${jobPost.getStatus()}</p>
                                    </div>
                                    <div class="col-md-4">
                                        <p><i class="fa-solid fa-money-bill"></i> <strong>Salary: </strong>${jobPost.getMinSalary()} $ - ${jobPost.getMaxSalary()} $</p>
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

                    <!-- Sidebar Section for Extra Details (Optional) -->
                    <c:if test="${empty sessionScope.account}">
                        <div class="col-md-2">
                            <div class="card mb-4 shadow-sm">
                                <div class="card-header bg-success text-white">
                                    <h5 class="m-0">Apply Job</h5>
                                </div>
                                <div class="card-body">
                                    <p>You must be <a href="${pageContext.request.contextPath}/authen" style="text-decoration: none">login</a> with Seeker role to apply job. Regard!</p>
                                </div>
                            </div>

                        </div>
                    </c:if>
                </div>
                <!-- Job Description -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="m-0">Description</h5>
                    </div>
                    <div class="card-body">
                        <p>${jobPost.getDescription()}</p>
                    </div>
                </div>

                <!-- Job Requirements -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="m-0">Requirements</h5>
                    </div>
                    <div class="card-body">
                        <p>${jobPost.getRequirements()}</p>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Include footer -->
        <jsp:include page="../view/common/footer.jsp"></jsp:include>

        <!-- Bootstrap JS and Popper -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>