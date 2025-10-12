<%-- 
    Document   : seekerManagement
    Created on : Oct 13, 2025, 01:27:49 AM
    Author     : sonmthe28
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
                        <div class="container-fluid" style="margin-bottom: 20px; margin-top: 20px">
                            <div class="dash__content">
                                <!-- sidebar menu -->
                                <div class="sidebar__menu d-md-block d-lg-none">
                                    <div class="sidebar__action"><i class="fa-sharp fa-regular fa-bars"></i> Sidebar</div>
                                </div>
                                <!-- sidebar menu end -->
                                <div class="dash__overview">

                                    <h6 class="fw-medium mb-30 text-center fs-2">SEEKER ACCOUNT MANAGEMENT</h6>
                                    <div class="d-flex justify-content-between align-items-center mb-3 ms-2">
                                        <!--drop-down filter seeker-->
                                        <div class="filter-dropdown">
                                            <form action="${pageContext.request.contextPath}/seekers" method="GET">
                                            <label for="seeker-filter">Filter</label>
                                            <select id="seeker-filter" name="filter" onchange="this.form.submit()">
                                                <option value="all" ${param.filter == null || param.filter == 'all' ? 'selected' : ''}>All Seekers</option>
                                                <option value="active" ${param.filter == 'active' ? 'selected' : ''}>Active Seekers</option>
                                                <option value="inactive" ${param.filter == 'inactive' ? 'selected' : ''}>Inactive Seekers</option>
                                            </select>
                                        </form>
                                    </div>
                                </div>
                                <hr/>
                                <!--search seeker-->
                                <form action="${pageContext.request.contextPath}/seekers" method="GET">
                                    <div class="d-flex justify-content-center mb-3">
                                        <input type="hidden" name="filter" value="${param.filter != null ? param.filter : 'all'}"> <!-- Thay đổi tại đây -->
                                        <input type="text" id="searchSeeker"  name="searchQuery" class="form-control" style="width: 60%;" placeholder="Search for name...">
                                        <button type="submit" class="btn btn-primary ms-2">Search</button>
                                    </div>
                                </form>

                                <!--search seeker end-->
                                <div class="seeker-list">
                                    <table class="table table-bordered" style="text-align: center; vertical-align: middle;">
                                        <thead>
                                            <tr>
                                                <th>Avatar</th>
                                                <th>Full Name</th>
                                                <th>Status Account</th>
                                                <th>View</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Table rows will go here (populated dynamically) -->
                                            <c:forEach items="${listSeekers}" var="seeker">
                                                <tr>
                                                    <!-- Avatar Column -->
                                                    <td>
                                                        <c:if test="${empty seeker.getAvatar()}">
                                                            <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="seeker-avatar" style="width: 50px; height: 50px; border-radius: 50%;">
                                                        </c:if>
                                                        <c:if test="${not empty seeker.getAvatar()}">
                                                            <img src="${seeker.getAvatar()}" alt="Avatar" class="seeker-avatar" style="width: 50px; height: 50px; border-radius: 50%;">
                                                        </c:if>    
                                                    </td>

                                                    <!-- Full Name Column -->
                                                    <td>${seeker.getFullName()}</td>

                                                    <!-- Status Column -->
                                                    <td>
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheck${seeker.id}" ${seeker.isActive ? 'checked' : ''} data-seeker-id="${seeker.id}">
                                                            <label class="form-check-label" for="flexSwitchCheck${seeker.id}">

                                                            </label>
                                                        </div>
                                                    </td>
                                                    <!-- Action Column -->
                                                    <td>
                                                        <form action="seekers?action=view-detail" method="POST">
                                                            <input type="hidden" name="id-seeker" value="${seeker.getId()}">
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


                                    <!-- Add more seekers here -->
                                </div>
                            </div>
                        </div>
                        <!-- content area end -->

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
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>
                                                $(document).ready(function () {
                                                    $('.form-check-input').change(function () {
                                                        var seekerId = $(this).data('seeker-id');
                                                        var isActive = this.checked;
                                                        var label = $(this).siblings('.form-check-label');

                                                        $.ajax({
                                                            url: '${pageContext.request.contextPath}/seekers',
                                                            type: 'POST',
                                                            data: {
                                                                action: isActive ? 'active' : 'deactive',
                                                                'id-seeker': seekerId
                                                            },
                                                            success: function (response) {
                                                                console.log('Seeker status updated successfully');

                                                            },
                                                            error: function (xhr, status, error) {
                                                                console.error('Error updating seeker status');
                                                                $(this).prop('checked', !isActive);

                                                            }
                                                        });
                                                    });
                                                });
        </script>   


    </body>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</html>