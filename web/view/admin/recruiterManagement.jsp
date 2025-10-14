<%-- 
    Document   : recruiterManagement
    Created on : Oct 14, 2024, 1:26:38 AM
    Author     : tiennthe
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.CompanyDAO"%>
<%@page import="dao.RecruitersDAO"%>
<%@page import="model.Company"%>
<%@page import="model.Recruiters"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>

        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <!-- Add custom styles -->
        <style>
            .recruiter-status.active {
                color: green; /* Active recruiters in green */
                font-weight: bold;
            }
            .recruiter-status.inactive {
                color: red; /* Inactive recruiters in red */
                font-weight: bold;
            }
            .status-approved {
                background-color: rgba(25, 135, 84, 0.1);
                color: #198754;
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: 500;
            }

            .status-pending {
                background-color: rgba(220, 53, 69, 0.1);
                color: #dc3545;
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: 500;
            }
            .status-not-yet {
                background-color: rgba(255, 193, 7, 0.1); /* Màu vàng nhạt cho nền */
                color: #ffc107; /* Màu vàng cho chữ */
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: 500;
            }
            .table-bordered td .form-check {
                display: flex;
                justify-content: center; /* Căn giữa theo chiều ngang */
                align-items: center; /* Căn giữa theo chiều dọc */
            }   
            .table-bordered thead th {
                background-color: #28a745; /* Màu xanh lá cây */
                color: #ffffff; /* Màu trắng cho chữ để dễ đọc */
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
                        <!--tao doi tuong companyDao de lay ve ten company-->

                        <!--end-->
                        <h6 class="fw-medium mb-30 text-center fs-2">RECRUITER ACCOUNT MANAGEMENT</h6>
                        <div class="container-fluid" style="margin-bottom: 20px; margin-top: 20px">
                            <div class="dash__content">
                                <!-- sidebar menu -->
                                <div class="sidebar__menu d-md-block d-lg-none">
                                    <div class="sidebar__action"><i class="fa-sharp fa-regular fa-bars"></i> Sidebar</div>
                                </div>
                                <!-- sidebar menu end -->
                                <div class="d-flex justify-content-between align-items-center mb-3 ms-2">
                                    <!--drop-down filter recruiter-->
                                    <div class="filter-dropdown">
                                        <form action="${pageContext.request.contextPath}/recruiters" method="GET">
                                        <label for="recruiter-filter">Filter </label>
                                        <select id="recruiter-filter" name="filter" onchange="this.form.submit()">
                                            <option value="all" ${param.filter == null || param.filter == 'all' ? 'selected' : ''}>All Recruiters</option>
                                            <option value="active" ${param.filter == 'active' ? 'selected' : ''}>Active Recruiters</option>
                                            <option value="inactive" ${param.filter == 'inactive' ? 'selected' : ''}>Inactive Recruiters</option>
                                        </select>
                                    </form>
                                </div>

                                <!-- Confirm Recruiter button -->
                                <form action="${pageContext.request.contextPath}/confirm" method="GET">
                                    <input type="hidden" name="action" value="confirm-recruiter">
                                    <button type="submit" class="btn btn-success">Confirm Recruiter</button>
                                </form>
                            </div>

                            <hr/>
                            <!--search recruiter-->
                            <form action="${pageContext.request.contextPath}/recruiters" method="GET">
                                <div class="d-flex justify-content-center mb-3">
                                    <input type="hidden" name="filter" value="${param.filter != null ? param.filter : 'all'}"> <!-- Thay đổi tại đây -->
                                    <input type="text" id="searchRecruiter"  name="searchQuery" class="form-control" style="width: 60%;" placeholder="Search for name...">
                                    <button type="submit" class="btn btn-primary ms-2">Search</button>
                                </div>
                            </form>

                            <!--search recruiter end-->
                            <div class="recruiter-list">
                                <table class="table table-bordered" style="text-align: center; vertical-align: middle;">
                                    <thead>
                                        <tr>
                                            <th>Avatar</th>
                                            <th>Full Name</th>
                                            <th>Company</th>
                                            <th>Approval Status</th>
                                            <th>Status Account</th>
                                            <th>View</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Table rows will go here (populated dynamically) -->
                                        <%
                                         // Tạo một đối tượng CompanyDAO
                                            CompanyDAO companyDao = new CompanyDAO();
                                         // Tao mot doi tuong Recruiter
                                            RecruitersDAO recruitersDao = new RecruitersDAO();
                                        %>
                                        <c:forEach items="${listRecruiters}" var="recruiter">
                                            <c:set var="recruiterId" value="${recruiter.getId()}" />
                                            <tr>
                                                <!-- Avatar Column -->
                                                <td>
                                                    <c:if test="${empty recruiter.getAvatar()}">
                                                        <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="seeker-avatar" style="width: 50px; height: 50px; border-radius: 50%;">
                                                    </c:if>
                                                    <c:if test="${not empty recruiter.getAvatar()}">
                                                        <img src="${recruiter.getAvatar()}" alt="Avatar" class="seeker-avatar" style="width: 50px; height: 50px; border-radius: 50%;">
                                                    </c:if>    
                                                </td>

                                                <!-- Full Name Column -->
                                                <td>${recruiter.getFullName()}</td>
                                                <!--Company Name Column-->
                                                <td>
                                                    <%
                                                        int recruiterAccountId = (Integer) pageContext.getAttribute("recruiterId");
                                                        List<Company> companies = companyDao.getCompanyNameByAccountId(recruiterAccountId);
                                                        String companyName = "";
                                                        String statusClassCom = "";
                                                        if (companies != null && !companies.isEmpty()) {
                                                            companyName = companies.get(0).getName(); // Lấy tên công ty từ danh sách
                                                        }else{
                                                            companyName = "Not yet registered";
                                                            statusClassCom = "status-not-yet";
                                                        }
                                                    %>
                                                    <span class="<%= statusClassCom %>"><%= companyName %></span> <!-- Hiển thị tên công ty -->
                                                </td>
                                                <!--verifiaction column-->
                                                <td>
                                                    <%
                                                    Recruiters recruiters = recruitersDao.findRecruitersbyAccountID(String.valueOf(recruiterAccountId));
                                                    String verification = "";
                                                    String statusClass = "";
                                                    if(recruiters != null){
                                                        verification = recruiters.isIsVerify() == true ? "Approved" : "Pending";
                                                        statusClass = recruiters.isIsVerify() == true ? "status-approved" : "status-pending";
                                                    }else{
                                                        verification = "None";
                                                        statusClass = "status-not-yet";
                                                        }
                                                    %>
                                                    <span class="<%= statusClass %>"><%= verification %></span>
                                                </td>
                                                <!-- Status Column -->
                                                <td>
                                                    <div class="form-check form-switch">
                                                        <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheck${recruiter.id}" ${recruiter.isActive ? 'checked' : ''} data-recruiter-id="${recruiter.id}">
                                                        <label class="form-check-label" for="flexSwitchCheck${recruiter.id}"></label>
                                                    </div>
                                                </td>

                                                <!-- Action Column -->
                                                <td>
                                                    <form action="recruiters?action=view-detail" method="POST">
                                                        <input type="hidden" name="id-recruiter" value="${recruiter.getId()}">
                                                        <button class="btn btn-info" type="submit">
                                                            <i class="fa fa-eye"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                 <!-- Pagination -->
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination justify-content-center" id="pagination">
                                            <c:if test="${pageControl.getPage() > 1}">
                                                <li class="page-item">
                                                    <a
                                                        class="page-link"
                                                        href="${pageControl.getUrlPattern()}page=${pageControl.getPage()-1}"
                                                        aria-label="Previous"
                                                        >
                                                        <span aria-hidden="true">&laquo; Previous</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            <!-- Tính toán để chỉ hiển thị 5 trang tại một thời điểm -->
                                            <c:set
                                                var="startPage"
                                                value="${pageControl.getPage() - 2 > 0 ? pageControl.getPage() - 2 : 1}"
                                                />
                                            <c:set
                                                var="endPage"
                                                value="${startPage + 4 <= pageControl.getTotalPages() ? startPage + 4 : pageControl.getTotalPages()}"
                                                />
                                            <!-- Nút để quay lại nhóm trang trước (nếu có) -->
                                            <c:if test="${startPage > 1}">
                                                <li class="page-item">
                                                    <a
                                                        class="page-link"
                                                        href="${pageControl.getUrlPattern()}page=${startPage-1}"
                                                        >...</a
                                                    >
                                                </li>
                                            </c:if>
                                            <!-- Hiển thị các trang trong khoảng từ startPage đến endPage -->
                                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                <li
                                                    class="page-item <c:if test='${i == pageControl.getPage()}'>active</c:if>"
                                                        >
                                                        <a
                                                            class="page-link"
                                                            href="${pageControl.getUrlPattern()}page=${i}"
                                                        >${i}</a
                                                    >
                                                </li>
                                            </c:forEach>
                                            <!-- Nút để chuyển sang nhóm trang tiếp theo (nếu có) -->
                                            <c:if test="${endPage < pageControl.getTotalPages()}">
                                                <li class="page-item">
                                                    <a
                                                        class="page-link"
                                                        href="${pageControl.getUrlPattern()}page=${endPage + 1}"
                                                        >...</a
                                                    >
                                                </li>
                                            </c:if>
                                            <!-- Nút Next để đi đến nhóm trang tiếp theo -->
                                            <c:if test="${pageControl.getPage() < pageControl.getTotalPages()}">
                                                <li class="page-item">
                                                    <a
                                                        class="page-link"
                                                        href="${pageControl.getUrlPattern()}page=${pageControl.getPage() + 1}"
                                                        aria-label="Next"
                                                        >
                                                        <span aria-hidden="true">Next &raquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>



                                <!-- Add more recruiters here -->
                            </div>
                        </div>
                    </div>
                </div>
                <!-- content area end -->

                <!-- Back to Top Button -->
                <!--                <button type="button" class="btn btn-primary position-fixed" id="rts-back-to-top" style="bottom: 20px; right: 20px;">
                                    <i class="fas fa-arrow-up"></i>
                                </button>-->
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
                <a href="#" class="small__btn d-xl-flex fill__btn border-6 font-xs" aria-label="Job Posting Button">Add Job</a>
            </div>
        </div>
        <div class="offcanvas-body p-0">
            <div class="rts__offcanvas__menu overflow-hidden">
                <div class="offcanvas__menu"></div>
            </div>
            <p class="max-auto font-20 fw-medium text-center text-decoration-underline mt-4">Our Social Links</p>
            <div class="rts__social d-flex justify-content-center gap-3 mt-3">
                <a href="https://facebook.com" aria-label="facebook">
                    <i class="fa-brands fa-facebook"></i>
                </a>
                <a href="https://instagram.com" aria-label="instagram">
                    <i class="fa-brands fa-instagram"></i>
                </a>
                <a href="https://linkedin.com" aria-label="linkedin">
                    <i class="fa-brands fa-linkedin"></i>
                </a>
                <a href="https://pinterest.com" aria-label="pinterest">
                    <i class="fa-brands fa-pinterest"></i>
                </a>
                <a href="https://youtube.com" aria-label="youtube">
                    <i class="fa-brands fa-youtube"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Theme Preloader Start -->
    <div class="loader-wrapper">
        <div class="loader"></div>
        <div class="loader-section section-left"></div>
        <div class="loader-section section-right"></div>
    </div>
    <!-- Theme Preloader End -->

    <!-- Back to Top Button -->
    <button type="button" class="rts__back__top" id="rts-back-to-top">
        <i class="fas fa-arrow-up"></i>
    </button>

    <!-- Include common JavaScript files -->
    <jsp:include page="../common/admin/common-js-admin.jsp"></jsp:include>

        <!-- Custom script for recruiter status switcher -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
                                            $(document).ready(function () {
                                                $('.form-check-input').change(function () {
                                                    var recruiterId = $(this).data('recruiter-id');
                                                    var isActive = this.checked;

                                                    $.ajax({
                                                        url: '${pageContext.request.contextPath}/recruiters',
                                                        type: 'POST',
                                                        data: {
                                                            action: isActive ? 'active' : 'deactive',
                                                            'id-recruiter': recruiterId
                                                        },
                                                        success: function (response) {
                                                            console.log('Recruiter status updated successfully');
                                                        },
                                                        error: function (xhr, status, error) {
                                                            console.error('Error updating recruiter status');
                                                            $(this).prop('checked', !isActive);
                                                        }
                                                    });
                                                });
                                            });
    </script>
    





    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</body>
</html>