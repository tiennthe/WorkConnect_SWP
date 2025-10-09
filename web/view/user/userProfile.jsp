<%-- 
    Document   : userProfile
    Created on : Oct 07, 2025, 5:20:27 PM
    Author     : Admin
--%>

<%@page import="model.Account"%>
<%@page import="model.JobSeekers"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Seeker Profile</title>
        <!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" type="image/x-icon">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon-16x16.png" type="image/x-icon">
        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .custom-badge {
                font-size: 1.2rem; /* Adjust font size as needed */
                padding: 10px 20px; /* Adds padding for a bigger badge */
                margin-top: 10px; /* Adds some spacing around the badge */
                border-radius: 8px; /* Optional: rounds the badge corners */
            }
        </style>

    </head>
    <body class="template-dashboard">
        <!-- header area -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>
            <!-- header area end -->

            <div class="container mt-5 mb-5">
                <div>
                <c:if test="${jobSeeker != null}">
                    <div>
                        <span class="badge custom-badge bg-success">Your JobSeeker ID: #${jobSeeker.getJobSeekerID()}</span>
                    </div>

                </c:if>

                <!-- If jobSeeker is null, show the alternative content -->
                <c:if test="${jobSeeker == null}">
                    <div>
                        <h2>Aren't you a Job Seeker yet?</h2>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalJoinJobSeeker">
                            Join Job Seeker
                        </button>
                    </div>
                </c:if>

                <!-- Display error message if available -->
                <c:if test="${not empty errorJobSeeker}">
                    <div style="color: red;">
                        ${error}
                    </div>
                </c:if>
            </div>
            <div class="row">
                <!-- Sidebar Section -->
                <div class="col-md-3 sidebar p-3">
                    <h5 class="text-center text-dark">User Menu</h5>
                    <ul class="nav nav-tabs flex-column" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="profile-tab" data-bs-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="true">Profile</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" id="deactivate-account-tab" data-bs-toggle="tab" href="#deactivate-account" role="tab" aria-controls="deactivate-account" aria-selected="false">Deactivate Account</a>
                        </li>
                    </ul>
                </div>

                <!-- Main Content Section -->
                <div class="col-md-9">
                    <c:set var="isJobSeeker" value="${not empty jobSeekerInfo}" />
                    <div class="tab-content">
                        <!-- Profile Tab -->
                        <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                            <h4 class="mb-3">Profile Information</h4>
                            <form class="p-4 rounded shadow-sm bg-light">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="author__image mb-3 text-center">
                                            <c:if test="${empty sessionScope.account.avatar}">
                                                <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="rounded-circle" width="150" height="150">
                                            </c:if>
                                            <c:if test="${!empty sessionScope.account.avatar}">
                                                <img src="${sessionScope.account.avatar}" alt="Avatar" class="rounded-circle" width="150" height="150">
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="col-md-9">
                                        <div class="mb-3">
                                            <label for="fullName" class="form-label">Full Name</label>
                                            <input type="text" id="name" class="form-control" placeholder="Full Name" required readonly value="${sessionScope.account.fullName}">
                                        </div>
                                        <div class="mb-3">
                                            <label for="dob" class="form-label">Date of Birth</label>
                                            <input type="date" id="dob" class="form-control" required readonly value="${sessionScope.account.dob}">
                                        </div>

                                    </div>
                                </div>





                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" id="email" class="form-control" placeholder="WorkConnect@gmail.com" required readonly value="${sessionScope.account.email}">
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="text" id="phone" class="form-control" placeholder="+84" required readonly value="${sessionScope.account.phone}">
                                </div>

                                <div class="mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <input type="text" id="genderDisplay" class="form-control" value="${sessionScope.account.gender == true ? 'Male' : 'Female'}" readonly>
                                    <input type="hidden" name="gender" id="genderHidden">
                                </div>
                                <div class="mb-3">
                                    <label for="add" class="form-label">Address</label>
                                    <input type="text" id="add" class="form-control" placeholder="Your Address" required readonly value="${sessionScope.account.address}">
                                </div>
                                <button type="button" class="btn btn-info" id="editProfile" onclick="location.href = '${pageContext.request.contextPath}/authen?action=edit-profile'">Edit Profile</button>
                            </form>
                        </div>

                        <!-- Deactivate Account Tab -->
                        <div class="tab-pane fade" id="deactivate-account" role="tabpanel" aria-labelledby="deactivate-account-tab">
                            <h6>Deactivate Your Account</h6>
                            <p>Are you sure you want to deactivate your account?</p>
                            <c:if test="${requestScope.error != null}">
                                <div style="color: red; text-align: center;">
                                    ${requestScope.error}
                                </div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/authen?action=deactivate-account" method="POST">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Please Enter Your Login Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Enter your password" required onkeydown="preventSpaces(event)">
                                        <span class="input-group-text cursor-pointer" onclick="togglePassword('currentPassword')">
                                            👁️
                                        </span>
                                    </div>
                                </div>
                                <p class="text-danger">
                                    <strong>Note:</strong> After your account is deactivated, you will temporarily be unable to use it. If you wish to reactivate your account, please contact the Admin for assistance.
                                </p>
                                <button type="submit" class="btn btn-danger">Deactivate Account</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!--Modal-->
            <div class="modal fade" id="modalJoinJobSeeker" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Join Job Seeking</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <!-- Success message block -->
                        <c:if test="${!empty requestScope.joinsuccess}">
                            <div class="alert alert-success m-3">
                                ${requestScope.joinsuccess}
                            </div>
                            <div class="modal-footer">
                                <a href="${pageContext.request.contextPath}/view/user/userHome.jsp" class="btn btn-success">Go to Home</a>
                            </div>
                        </c:if>

                        <!-- Error message block -->
                        <c:if test="${!empty requestScope.joinerror}">
                            <div class="alert alert-danger m-3">
                                ${requestScope.joinerror}
                            </div>
                        </c:if>

                        <!-- Form and confirmation button (displayed only if no success message) -->
                        <c:if test="${empty requestScope.joinsuccess}">
                            <div class="modal-body">
                                <h5>Are you sure you want to join job seeking?</h5>
                            </div>
                            <form id="confirmForm" action="${pageContext.request.contextPath}/seeker?action=join-job-seeking" method="post" style="display: inline;">
                                <input type="hidden" name="accountid" value="${sessionScope.account.id}">
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-primary">Confirm</button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </div>



            </div>
            <button type="button" class="btn btn-primary position-fixed" id="back-to-top" style="bottom: 20px; right: 20px;">
                <i class="fas fa-arrow-up"></i>
            </button>
        </div>

        <!-- Footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>
            <!-- all plugin js -->
        <jsp:include page="../common/user/common-js-user.jsp"></jsp:include>
        </body>
        <script>
            // Prevent entering spaces in password fields
            function preventSpaces(event) {
                if (event.key === " ") {
                    event.preventDefault();  // Prevent the space from being entered
                    alert("Passwords cannot contain spaces.");
                }
            }

            function togglePassword(id) {
                var input = document.getElementById(id);
                if (input.type === "password") {
                    input.type = "text";
                } else {
                    input.type = "password";
                }
            }

            function toggleEndDate() {
                const checkbox = document.getElementById('currentlyStudying');
                const endDateField = document.getElementById('endDate');
                if (checkbox.checked) {
                    endDateField.disabled = true;
                    endDateField.value = ''; // Reset value if checked
                } else {
                    endDateField.disabled = false;
                }
            }

            // Kiểm tra trạng thái tab từ server và đặt tab đó là active
            var activeTab = '${activeTab != null ? activeTab : ""}';
            if (activeTab) {
                var myTab = new bootstrap.Tab(document.querySelector(activeTab));
                myTab.show();
            }
            // Back to top button
            const backToTopButton = document.getElementById('back-to-top');

            window.onscroll = function () {
                if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                    backToTopButton.style.display = 'block';
                } else {
                    backToTopButton.style.display = 'none';
                }
            };

            backToTopButton.addEventListener('click', function () {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</html>
