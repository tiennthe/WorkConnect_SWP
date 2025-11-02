<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Account"%>
<%@page import="dao.AccountDAO"%>
<%@page import="model.JobPostings"%>
<%@page import="dao.JobPostingsDAO"%>
<!DOCTYPE html>
<html lang="en">
    <head>

        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- TinyMCE Script -->
        <script src="https://cdn.tiny.cloud/1/ygxzbqd4ej8z1yjswkp0ljn56qm4r6luix9l83auaajk3h3q/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    <head>
        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- TinyMCE Script -->
        <script src="https://cdn.tiny.cloud/1/ygxzbqd4ej8z1yjswkp0ljn56qm4r6luix9l83auaajk3h3q/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
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
            /* Các style hiện có của bạn giữ nguyên */

            /* Thêm style mới cho feedback details */
            .card {
                border: none;
                transition: all 0.3s ease;
            }

            .card:hover {
                box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15) !important;
            }

            .feedback-content {
                transition: all 0.3s ease;
            }

            .feedback-content:hover {
                transform: translateY(-2px);
            }

            .bg-light {
                background-color: #f8f9fa !important;
            }

            /* Hiệu ứng hover cho icons */
            .rounded-circle {
                transition: all 0.3s ease;
            }

            .rounded-circle:hover {
                transform: scale(1.1);
            }
            .input-group {
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border-radius: 0.375rem;
            }

            .input-group .input-group-text {
                background-color: #f8f9fa;
                border-color: #dee2e6;
                font-weight: 500;
                color: #495057;
            }

            .input-group .form-select {
                border-color: #dee2e6;
            }

            .input-group .form-control {
                border-color: #dee2e6;
            }

            .input-group .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
            }

            .input-group .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004a9f;
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

                                    <h6 class="fw-medium mb-30 text-center fs-2">Feedback Management</h6>

                                    <hr/>

                                    <!-- Filter and Search -->
                                    <form action="feedback" method="GET" class="mb-5 d-flex align-items-start gap-3" id="filterSearchForm" style="margin-left: 20px;">
                                        <!-- Dropdown filter by status -->
                                        <div class="input-group" style="width: auto;">
                                            <select class="form-select" name="filter" id="status" onchange="document.getElementById('filterSearchForm').submit()">
                                                <option value="0" ${param.filter == null || param.filter == '' ? 'selected' : ''}>All Status</option>
                                            <option value="1" ${param.filter == '1' ? 'selected' : ''}>Pending</option>
                                            <option value="2" ${param.filter == '2' ? 'selected' : ''}>Resolved</option>
                                            <option value="3" ${param.filter == '3' ? 'selected' : ''}>Reject</option>
                                        </select>
                                    </div>

                                    <!-- Search input and button in the same input group -->
                                    <div class="input-group" style="width: 500px;">
                                        <input type="text" name="search" class="form-control" placeholder="Feedback by" value="${param.search != null ? param.search : ''}">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </form>


                                <!-- Filter and Search end -->



                                <div class="seeker-list">
                                    <!--nofication-->
                                    <div class="toast-container position-fixed top-0 end-0 p-3">
                                        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                            <div class="toast-header bg-success text-white">
                                                <strong class="me-auto">Success</strong>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                                            </div>
                                            <div class="toast-body" id="successToastBody"></div>
                                        </div>

                                        <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                            <div class="toast-header bg-danger text-white">
                                                <strong class="me-auto">Error</strong>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                                            </div>
                                            <div class="toast-body" id="errorToastBody"></div>
                                        </div>
                                    </div>
                                    <!--nofication-end-->
                                    <table class="table table-bordered" style="text-align: center; vertical-align: middle;">
                                        <thead>
                                            <tr>
                                                <th>Feedback By</th>
                                                <th>Job Title</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                               Account account = new Account();
                                               AccountDAO accDao = new AccountDAO();
                                               JobPostings jobPost = new JobPostings();
                                               JobPostingsDAO jobPostDao = new JobPostingsDAO();
                                            %>
                                            <c:forEach items="${listFeedback}" var="feedback">
                                                <c:set var="accountId" value="${feedback.getAccountID()}"/>
                                                <c:set var="jobPostId" value="${feedback.getJobPostingID()}"/>
                                                <tr>
                                                    <!-- Full Name Column -->
                                                    <td>
                                                        <%
                                                            int accountId = (Integer) pageContext.getAttribute("accountId");
                                                            account = accDao.findUserById(accountId);
                                                            String name = "";
                                                            if(account != null){
                                                                name = account.getFullName();
                                                            }
                                                        %>
                                                        <%= name%>
                                                    </td>
                                                    <td>
                                                        <%
                                                            int jobPostId = (Integer) pageContext.getAttribute("jobPostId");
                                                            jobPost = jobPostDao.findJobPostingById(jobPostId);
                                                                String title = "";
                                                            if(jobPost != null){
                                                                title = jobPost.getTitle();
                                                               }
                                                        %>
                                                        <form action="${pageContext.request.contextPath}/job_posting" method="POST" style="display: inline;">
                                                            <input type="hidden" name="action" value="view">
                                                            <input type="hidden" name="jobPostID" value="${feedback.getJobPostingID()}">
                                                            <button type="submit" class="btn btn-link text-decoration-none" style="padding: 0;">
                                                                <%= title %>
                                                            </button>
                                                        </form>
                                                    </td>

                                                    <!-- Status Column -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${feedback.getStatus() == 1}">
                                                                <span style="background-color: yellow; color: black; padding: 5px; border-radius: 5px;">Pending</span>
                                                            </c:when>
                                                            <c:when test="${feedback.getStatus() == 2}">
                                                                <span style="background-color: green; color: white; padding: 5px; border-radius: 5px;">Resolved</span>
                                                            </c:when>
                                                            <c:when test="${feedback.getStatus() == 3}">
                                                                <span style="background-color: red; color: white; padding: 5px; border-radius: 5px;">Reject</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: gray;">This feedback was deleted</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- Action Column -->
                                                    <td>
                                                        <button 
                                                            class="btn btn-info" 
                                                            type="button" 
                                                            onclick="toggleDetails(${feedback.getFeedbackID()})" 
                                                            <c:if test="${feedback.getStatus() == 4}">disabled</c:if>>
                                                                <i class="fa fa-eye"></i> 
                                                            </button>

                                                            <div style="display: inline-flex; width: max-content;">
                                                                <!-- Resolved button -->
                                                                <button 
                                                                    class="btn btn-success" 
                                                                    type="button" 
                                                                    onclick="openResolvedModal(${feedback.getFeedbackID()})" 
                                                                title="Resolved" 
                                                                style="margin: 0 5px;"
                                                                <c:if test="${feedback.getStatus() == 4}">disabled</c:if>>
                                                                    <i class="fa-solid fa-check-circle"></i>
                                                                </button>

                                                                <!-- Reject button -->
                                                                <button 
                                                                    class="btn btn-warning" 
                                                                    type="button" 
                                                                    onclick="openRejectModal(${feedback.getFeedbackID()})" 
                                                                title="Reject" 
                                                                style="margin: 0 5px;"
                                                                <c:if test="${feedback.getStatus() == 4}">disabled</c:if>>
                                                                    <i class="fa-solid fa-times"></i>
                                                                </button>
                                                            </div>
                                                        </td>

                                                    </tr>

                                                    <!-- Row for Feedback Details -->
                                                    <tr id="details-${feedback.getFeedbackID()}" style="display: none;">
                                                    <td colspan="4">
                                                        <div class="card shadow-sm">
                                                            <div class="card-body">
                                                                <!-- Header with title -->
                                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                                    <h5 class="card-title text-success mb-0">
                                                                        <i class="fas fa-comment-dots me-2"></i>Feedback Details
                                                                    </h5>
                                                                </div>

                                                                <!-- Info row -->
                                                                <div class="row mb-3 pb-2 border-bottom">
                                                                    <div class="col-md-6">
                                                                        <div class="d-flex align-items-center">
                                                                            <div>
                                                                                <small class="text-muted">Feedback By</small>
                                                                                <p class="mb-0 fw-bold"><%= name %></p>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <div class="d-flex align-items-center">
                                                                            <div class="rounded-circle bg-info text-white p-2 me-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                                                                <i class="fas fa-calendar"></i>
                                                                            </div>
                                                                            <div>
                                                                                <small class="text-muted">Created At</small>
                                                                                <p class="mb-0 fw-bold">${feedback.getCreatedAt()}</p>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Content section -->
                                                                <div class="feedback-content">
                                                                    <h6 class="text-muted mb-2">
                                                                        <i class="fas fa-comment-alt me-2"></i>Content
                                                                    </h6>
                                                                    <div class="p-3 bg-light rounded">
                                                                        <p class="mb-0  text-start" style="white-space: pre-line;">${feedback.getContentFeedback()}</p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <!--modal for resolved-reject button-->
                                    <!-- Modal for Resolved Action -->
                                    <div class="modal fade" id="resolvedModal" tabindex="-1" aria-labelledby="resolvedModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header bg-success text-white">
                                                    <h5 class="modal-title" id="resolvedModalLabel">Resolve Feedback</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="feedback" method="POST">
                                                    <div class="modal-body">
                                                        <input type="hidden" id="resolved-feedback-id" name="feedback-id" value="">
                                                        <input type="hidden" name="action" value="resolved">
                                                        <div class="mb-3">
                                                            <label for="resolved-response" class="form-label">Enter your response for resolving this feedback:</label>
                                                            <textarea class="form-control" id="resolved-response" name="response" rows="4" required></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-success">Resolve</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Modal for Reject Action -->
                                    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header bg-warning text-dark">
                                                    <h5 class="modal-title" id="rejectModalLabel">Reject Feedback</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="feedback" method="POST">
                                                    <div class="modal-body">
                                                        <input type="hidden" id="reject-feedback-id" name="feedback-id" value="">
                                                        <input type="hidden" name="action" value="reject">
                                                        <div class="mb-3">
                                                            <label for="reject-response" class="form-label">Enter your reason for rejecting this feedback:</label>
                                                            <textarea class="form-control" id="reject-response" name="response" rows="4" required></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-warning">Reject</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <!--end modal-->


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
                                    <!-- Pagination -->



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
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>

            <script>
                                                                        function toggleDetails(feedbackId) {
                                                                            var detailsRow = document.getElementById("details-" + feedbackId);
                                                                            if (detailsRow.style.display === "none") {
                                                                                detailsRow.style.display = "table-row";
                                                                            } else {
                                                                                detailsRow.style.display = "none";
                                                                            }
                                                                        }
            </script>
            <script>
                function openResolvedModal(feedbackId) {
                    document.getElementById('resolved-feedback-id').value = feedbackId;
                    new bootstrap.Modal(document.getElementById('resolvedModal')).show();
                }

                function openRejectModal(feedbackId) {
                    document.getElementById('reject-feedback-id').value = feedbackId;
                    new bootstrap.Modal(document.getElementById('rejectModal')).show();
                }

                // Clear form when modals are hidden
                document.getElementById('resolvedModal').addEventListener('hidden.bs.modal', function () {
                    document.getElementById('resolved-response').value = '';
                });

                document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function () {
                    document.getElementById('reject-response').value = '';
                });
            </script>
            <script>
                // Function to show success toast
                function showSuccessToast(message) {
                    const successToast = document.getElementById('successToast');
                    const successToastBody = document.getElementById('successToastBody');

                    successToastBody.textContent = message;
                    const toast = new bootstrap.Toast(successToast);
                    toast.show();
                }

                // Function to show error toast
                function showErrorToast(message) {
                    const errorToast = document.getElementById('errorToast');
                    const errorToastBody = document.getElementById('errorToastBody');

                    errorToastBody.textContent = message;
                    const toast = new bootstrap.Toast(errorToast);
                    toast.show();
                }

                // Check for success message
                document.addEventListener('DOMContentLoaded', function () {
                    const successMessage = '${success}';
                    const errorMessage = '${error}';

                    if (successMessage && successMessage.trim() !== '') {
                        showSuccessToast(successMessage);
                    }

                    if (errorMessage && errorMessage.trim() !== '') {
                        showErrorToast(errorMessage);
                    }
                });
        </script>

        <script>
            tinymce.init({
                selector: 'textarea', // Initialize TinyMCE for all text areas
                plugins: 'advlist autolink lists link image charmap print preview anchor',
                toolbar: 'undo redo | formatselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat',
                menubar: true, // Disable the menubar
                branding: false, // Disable the TinyMCE branding
                height: 300, // Set the height of the editor
                setup: function (editor) {
                    editor.on('change', function () {
                        tinymce.triggerSave(); // Synchronize TinyMCE content with the form
                    });
                }
            });
        </script>
    </body>
</html>