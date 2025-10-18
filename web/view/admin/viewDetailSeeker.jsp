<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Education"%>
<%@page import="model.JobSeekers"%>
<%@page import="dao.EducationDAO"%>
<%@page import="dao.JobSeekerDAO"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>

        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <head>
        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <!-- Add custom styles -->
        <style>
            .seeker-status.active {
                color: green; /* Active seekers in green */
                font-weight: bold;
            }
            .seeker-status.inactive {
                color: red; /* Inactive seekers in red */
                font-weight: bold;
            }
        </style>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <!-- header area -->
        <jsp:include page="../common/admin/header-admin.jsp"></jsp:include>
            <!-- header area end -->

            <!-- content area -->
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-3">
                        <!--Side bar-->
                    <jsp:include page="../common/admin/sidebar-admin.jsp"></jsp:include>
                        <!--side bar-end-->
                    </div>


                    <div class="col-md-9">

                        <!--content-main can fix-->
                        <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                        <c:if test="${requestScope.accountView.getRoleId() == 3}">
                            <h4 class="mb-3 text-center fs-2">Profile Seeker</h4>
                        </c:if>
                        <c:if test="${requestScope.accountView.getRoleId() == 2}">
                            <h4 class="mb-3 text-center fs-2">Profile Recruiter</h4>
                        </c:if>

                        <form class="p-4 rounded shadow-sm bg-light">
                            <!-- Avatar và Thông tin người dùng -->
                            <!-- Avatar và Thông tin người dùng -->
                            <div class="d-flex align-items-start">
                                <!-- Avatar -->
                                <div class="me-4 text-start">
                                    <c:if test="${empty requestScope.accountView.avatar}">
                                        <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="rounded-circle" width="150" height="150">
                                    </c:if>
                                    <c:if test="${!empty requestScope.accountView.avatar}">
                                        <img src="${requestScope.accountView.avatar}" alt="Avatar" class="rounded-circle" width="150" height="150">
                                    </c:if>
                                    <!-- Nút Xem Chi Tiết Giáo Dục và Kinh Nghiệm -->
                                    <c:if test="${requestScope.accountView.getRoleId() == 3}">
                                        <div class="mt-3">
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#educationModal">
                                                Detail Education
                                            </button>
                                        </div>
                                        <div class="mt-2">
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#experienceModal">
                                                Detail Experience
                                            </button>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Thông tin người dùng -->
                                <div class="w-100">
                                    <div class="row">
                                        <!-- Full Name -->
                                        <div class="col-md-6 mb-3">
                                            <label for="lastName" class="form-label">Last Name</label>
                                            <input type="text" id="lastName" class="form-control" placeholder="Last Name" required readonly value="${requestScope.accountView.lastName}">
                                        </div>
                                        <!-- First Name -->
                                        <div class="col-md-6 mb-3">
                                            <label for="firstName" class="form-label">First Name</label>
                                            <input type="text" id="firstName" class="form-control" placeholder="First Name" required readonly value="${requestScope.accountView.firstName}">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- Phone -->
                                        <div class="col-md-6 mb-3">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <input type="text" id="phone" class="form-control" placeholder="+84" required readonly value="${requestScope.accountView.phone}">
                                        </div>
                                        <!-- Date of Birth -->
                                        <div class="col-md-6 mb-3">
                                            <label for="dob" class="form-label">Date of Birth</label>
                                            <input type="date" id="dob" class="form-control" required readonly value="${requestScope.accountView.dob}">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- Gender -->
                                        <div class="col-md-6 mb-3">
                                            <label for="genderDisplay" class="form-label">Gender</label>
                                            <input type="text" id="genderDisplay" class="form-control" value="${requestScope.accountView.gender == true ? 'Male' : 'Female'}" readonly>
                                        </div>
                                        <!-- Address -->
                                        <div class="col-md-6 mb-3">
                                            <label for="address" class="form-label">Address</label>
                                            <input type="text" id="address" class="form-control" placeholder="Your Address" required readonly value="${requestScope.accountView.address}">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- Email -->
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" id="email" class="form-control" placeholder="jobpath@gmail.com" required readonly value="${requestScope.accountView.email}">
                                        </div>
                                        <!-- Create At -->
                                        <div class="col-md-6 mb-3">
                                            <label for="createAt" class="form-label">Create At</label>
                                            <input type="text" id="createAt" class="form-control" required readonly value="${requestScope.accountView.createAt}">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Back Button -->
                            <div class="text-center mt-4">
                                <c:if test="${requestScope.accountView.roleId == 3}">
                                    <button type="button" class="btn btn-info" onclick="location.href = '${pageContext.request.contextPath}/seekers'">Back</button>
                                </c:if>
                                <c:if test="${requestScope.accountView.roleId == 2}">
                                    <button type="button" class="btn btn-info" onclick="location.href = '${pageContext.request.contextPath}/recruiters'">Back</button>
                                </c:if>
                            </div>
                        </form>
                    </div>
                    <!-- Modal để hiển thị thông tin Education -->
                    <div class="modal fade" id="educationModal" tabindex="-1" aria-labelledby="educationModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="educationModalLabel">Education Details</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Table hiển thị thông tin Education -->
                                    <c:set var="accountId" value="${requestScope.accountView.getId()}" />
                                    <!--tạo các đối tượng cần dùng-->
                                    <% 
                                        Education education = new Education();
                                        EducationDAO educationDao = new EducationDAO();
                                        JobSeekers jobSeeker = new JobSeekers();
                                        JobSeekerDAO jobSeekerDao = new JobSeekerDAO();
                                    %>
                                    <table class="table table-bordered text-center">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Institution</th>
                                                <th>Degree</th>
                                                <th>Field Of Study</th>
                                                <th>Start Date</th>
                                                <th>End Date</th>
                                                <th>Certificate</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!--lay ve education theo accountId-->
                                            <%
                                                //lay ve id cua jobseeker theo accountid
                                                int accountId = (Integer) pageContext.getAttribute("accountId");
                                                jobSeeker = jobSeekerDao.findJobSeekerIDByAccountID(String.valueOf(accountId));
                                                if(jobSeeker != null){
                                                List<Education> listEdu = educationDao.findEducationbyJobSeekerID(jobSeeker.getJobSeekerID());
                                                for(Education edu: listEdu){
                                                
                                                
                                                // duyet listEdu
                                            %>
                                            <tr>
                                                <td>
                                                    <%= edu.getInstitution()%>
                                                </td>
                                                <td><%= edu.getDegree()%></td>
                                                <td><%= edu.getFieldOfStudy()%></td>
                                                <td><%= edu.getStartDate()%></td>
                                                <td><%= edu.getEndDate()%></td>
                                                <td>
                                                    <img src="<%= edu.getDegreeImg() %>" alt="Certificate" style="max-width: 100px; height: auto;">
                                                </td>
                                            </tr>
                                            <%
                                                }
                                              }else{
                                            %>    
                                            <tr>
                                                <td colspan="6">No education found.</td>
                                            </tr>
                                            <%}%> 

                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>   

                    <!-- Back to Top Button -->
                    <button type="button" class="btn btn-primary position-fixed" id="rts-back-to-top" style="bottom: 20px; right: 20px;">
                        <i class="fas fa-arrow-up"></i>
                    </button>

                    <!-- Footer -->

                </div>
            </div>
        </div>



        <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas" aria-labelledby="offcanvasLabel">
            <div class="offcanvas-header p-0 mb-5 mt-4">
                <a href="index.html" class="offcanvas-title" id="offcanvasLabel">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/header__one.svg" alt="logo">
                </a> 
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <!-- login offcanvas -->
            <div class="mb-4 d-block d-sm-none">
                <div class="header__right__btn d-flex justify-content-center gap-3">
                    <!--                    <a href="#" class="small__btn no__fill__btn border-6 font-xs" aria-label="Login Button" data-bs-toggle="modal" data-bs-target="#loginModal"> <i class="rt-login"></i>Sign In</a>-->
                    <a href="#" class="small__btn d-xl-flex fill__btn border-6 font-xs" aria-label="Job Posting Button">Add Job</a>
                </div>
            </div>
            <div class="offcanvas-body p-0">
                <div class="rts__offcanvas__menu overflow-hidden">
                    <div class="offcanvas__menu"></div>
                </div>
                <p class="max-auto font-20 fw-medium text-center text-decoration-underline mt-4">Our Social Links</p>
                <div class="rts__social d-flex justify-content-center gap-3 mt-3">
                    <a href="https://facebook.com"  aria-label="facebook">
                        <i class="fa-brands fa-facebook"></i>
                    </a>
                    <a href="https://instagram.com"  aria-label="instagram">
                        <i class="fa-brands fa-instagram"></i>
                    </a>
                    <a href="https://linkedin.com"  aria-label="linkedin">
                        <i class="fa-brands fa-linkedin"></i>
                    </a>
                    <a href="https://pinterest.com"  aria-label="pinterest">
                        <i class="fa-brands fa-pinterest"></i>
                    </a>
                    <a href="https://youtube.com"  aria-label="youtube">
                        <i class="fa-brands fa-youtube"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- THEME PRELOADER START -->
        <div class="loader-wrapper">
            <div class="loader">
            </div>
            <div class="loader-section section-left"></div>
            <div class="loader-section section-right"></div>
        </div>
        <!-- THEME PRELOADER END -->
        <button type="button" class="rts__back__top" id="rts-back-to-top">
            <i class="fas fa-arrow-up"></i>
        </button>
        <!-- all plugin js -->
        <jsp:include page="../common/admin/common-js-admin.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>