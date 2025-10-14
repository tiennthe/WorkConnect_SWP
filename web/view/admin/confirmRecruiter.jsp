<%-- 
    Document   : confirmRecruiter
    Created on : Oct 14, 2025, 8:30:16 AM
    Author     : tiennthe
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.CompanyDAO"%>
<%@page import="dao.AccountDAO"%>
<%@page import="model.Company"%>
<%@page import="model.Account"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
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
            .table-responsive {
                margin-top: 20px;
            }
            .verify-badge {
                font-size: 1.2em;
            }
            .verify-badge.verified {
                color: green;
            }
            .verify-badge.unverified {
                color: red;
            }
            .table-title {
                text-align: center;
                margin-bottom: 20px;
            }
            .btn-verify {
                padding: 5px 10px;
                margin: 0 5px;
                border: none;
                cursor: pointer;
                border-radius: 50%;
            }
            .btn-confirm {
                background-color: #28a745;
                color: white;
            }
            .btn-reject {
                background-color: #dc3545;
                color: white;
            }
            .notification-box {
                padding: 15px;
                border-radius: 5px;
                margin: 20px 0;
                font-size: 16px;
                font-weight: bold;
                text-align: center;
            }

            .notification-box.error {
                background-color: #f8d7da; /* Nền đỏ nhạt */
                color: #721c24; /* Màu chữ đỏ đậm */
                border: 1px solid #f5c6cb; /* Viền đỏ nhạt */
            }

        </style>
    </head>
    <body>
        <!-- header area -->
        <jsp:include page="../common/admin/header-admin.jsp"></jsp:include>
            <!-- header area end -->

            <!-- content area -->
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-2">
                        <!--Side bar-->
                    <jsp:include page="../common/admin/sidebar-admin.jsp"></jsp:include>
                        <!--side bar-end-->
                    </div>

                    <div class="col-md-10">
                        <!--content-main can fix-->
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-12">
                                    <h2 class="mt-4 mb-4 table-title">Recruiter Confirm</h2>
                                    <div class="table-responsive">
                                        <!--search recruiter-->
                                        <form action="${pageContext.request.contextPath}/confirm" method="GET">
                                        <div class="d-flex justify-content-center mb-3">
                                            <input type="text" id="searchRecruiter"  name="searchQuery" class="form-control" style="width: 60%;" placeholder="Search for name...">
                                            <button type="submit" class="btn btn-primary ms-2">Search</button>
                                        </div>
                                    </form>

                                    <!--search recruiter end-->       
                                    <table class="table table-striped table-hover" style="border: 2px">
                                        <thead class="table-success">
                                            <tr>
                                                <th>Name</th>
                                                <th>Verify</th>
                                                <th>Company</th>
                                                <th>Front Citizen</th>
                                                <th>Back Citizen</th>
                                                <th>Position</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                         // Tạo một đối tượng CompanyDAO
                                            CompanyDAO companyDao = new CompanyDAO();
                                         // tao doi tuong account 
                                            AccountDAO accountDao = new AccountDAO();
                                            %>
                                            <c:forEach items="${listConfirm}" var="recruiter">
                                                <c:if test="${recruiter.isIsVerify() == false}">
                                                    <c:set var="accountId" value="${recruiter.getAccountID()}" />
                                                    <%int accountId = (Integer) pageContext.getAttribute("accountId");%>
                                                    <tr>
                                                        <td>
                                                            <%
                                                                Account account = accountDao.findUserById(accountId);
                                                            %>
                                                            <%= account.getFullName() %>
                                                        </td>

                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/confirm" method="POST" class="d-inline">
                                                                <input type="hidden" name="recruiterId" value="${recruiter.getRecruiterID()}">
                                                                <input type="hidden" name="action" value="confirm">
                                                                <button type="submit" class="btn-verify btn-confirm" onclick="return confirmAction('confirm')">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/confirm" method="POST" class="d-inline">
                                                                <input type="hidden" name="recruiterId" value="${recruiter.getRecruiterID()}">
                                                                <input type="hidden" name="action" value="reject">
                                                                <button type="submit" class="btn-verify btn-reject" onclick="return confirmAction('reject')">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </form>
                                                        </td>


                                                        <td>

                                                            <%
                                                                List<Company> companies = companyDao.getCompanyNameByAccountId(accountId);
                                                                String companyName = "";
                                                                if (companies != null && !companies.isEmpty()) {
                                                                    companyName = companies.get(0).getName(); // Lấy tên công ty từ danh sách
                                                                }
                                                            %>
                                                            <%= companyName %> <!-- Hiển thị tên công ty -->
                                                        </td>
                                                        <td>
                                                            <img src="${recruiter.getFrontCitizenImage()}" alt="Front Citizen Image" class="img-fluid img-thumbnail" style="max-width: 100px;" 
                                                                 data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showImage('${recruiter.getFrontCitizenImage()}')">
                                                        </td>
                                                        <td>
                                                            <img src="${recruiter.getBackCitizenImage()}" alt="Back Citizen Image" class="img-fluid img-thumbnail" style="max-width: 100px;" 
                                                                 data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showImage('${recruiter.getBackCitizenImage()}')">
                                                        </td>


                                                        <td>${recruiter.getPosition()}</td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>

                                        </tbody>
                                    </table>
                                    <!--hien thi thong bao-->
                                    <c:if test="${not empty notice}">
                                        <tr>
                                            <td colspan="4">
                                                <div class="notification-box error">
                                                    <p>${notice}</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <!--button back-->
                                    <div class="d-flex justify-content-start mt-3 mb-3">
                                        <a href="recruiters" class="btn btn-success">
                                            <i class="fas fa-arrow-left me-2"></i>Back
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--content-main can fix end-->
                </div>

                <!-- Back to Top Button -->


                <!-- Footer -->
            </div>
        </div>

        <!-- Rest of the file remains unchanged -->

        <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas" aria-labelledby="offcanvasLabel">
            <!-- Offcanvas content remains unchanged -->
        </div>
        <!--modal hien thi anh citizen-->
        <!-- Modal to display image -->
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
        <!--end modal-->
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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
                                                                     function confirmAction() {
                                                                         return confirm("Are you sure you want to confirm this recruiter?");
                                                                     }
        </script>
        <script>
            function showImage(imageUrl) {
                document.getElementById('modalImage').src = imageUrl;
            }
        </script>

    </body>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</html>
