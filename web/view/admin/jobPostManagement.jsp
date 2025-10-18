<%-- 
    Document   : jobPostManagement
    Created on : Oct 18, 2025, 2:36:47 PM
    Author     : tuananh
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Account"%>
<%@page import="dao.AccountDAO"%>
<%@page import="model.Recruiters"%>
<%@page import="dao.RecruitersDAO"%>
<%@page import="model.Job_Posting_Category"%>
<%@page import="dao.Job_Posting_CategoryDAO"%>
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
        <!-- TinyMCE Script -->
        <script src="https://cdn.tiny.cloud/1/ygxzbqd4ej8z1yjswkp0ljn56qm4r6luix9l83auaajk3h3q/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
        <!-- Add custom styles -->

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
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
                        <div class="container-fluid p-4">

                            <!-- Tab Navigation -->
                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link active" id="jobPostingTab" data-bs-toggle="tab" href="#jobPostingContent" role="tab" aria-controls="jobPostingContent" aria-selected="true">Job Posting</a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link" id="categoryTab" data-bs-toggle="tab" href="#categoryContent" role="tab" aria-controls="categoryContent" aria-selected="false">Category</a>
                                </li>
                            </ul>
                            <div class="tab-content" id="myTabContent">
                                <!-- Job Posting Tab -->
                                <div class="tab-pane fade show active" id="jobPostingContent" role="tabpanel" aria-labelledby="jobPostingTab">
                                    <!-- Nội dung Job Posting Management ở đây -->
                                    <div class="container-fluid p-4">
                                        <h6 class="fw-medium mb-30 text-center fs-2">JOB POSTING MANAGEMENT</h6>
                                        <!-- Filter Section -->
                                        <form action="job_posting" method="get" id="filterForm">
                                            <div class="row mb-4">
                                                <div class="col-md-2">
                                                    <label for="statusFilter" class="form-label">Status</label>
                                                    <select id="statusFilter" class="form-select" name="filterStatus" onchange="document.getElementById('filterForm').submit();">
                                                        <option value="all" ${param.filterStatus == 'all' ? 'selected' : ''}>All</option>
                                                    <option value="open" ${param.filterStatus == 'open' ? 'selected' : ''}>Open</option>
                                                    <option value="closed" ${param.filterStatus == 'closed' ? 'selected' : ''}>Closed</option>
                                                    <option value="violate" ${param.filterStatus == 'violate' ? 'selected' : ''}>Violate</option>
                                                </select>
                                            </div>

                                            <div class="col-md-2">
                                                <label for="salaryFilter" class="form-label">Salary</label>
                                                <select id="salaryFilter" class="form-select" name="filterSalary" onchange="document.getElementById('filterForm').submit();">
                                                    <option value="all" ${param.filterSalary == 'all' ? 'selected' : ''}>All</option>
                                                    <option value="0-1000" ${param.filterSalary == '0-1000' ? 'selected' : ''}>0-1000 USD</option>
                                                    <option value="1000+" ${param.filterSalary == '1000+' ? 'selected' : ''}>1000+ USD</option>
                                                    <option value="2000+" ${param.filterSalary == '2000+' ? 'selected' : ''}>2000+ USD</option>
                                                </select>
                                            </div>

                                            <div class="col-md-3">
                                                <label for="postDateFilter" class="form-label">Post Date</label>
                                                <input type="date" id="postDateFilter" class="form-control" name="filterDate" value="${param.filterDate}" onchange="document.getElementById('filterForm').submit();">
                                            </div>

                                            <div class="col-md-5">
                                                <label for="searchInput" class="form-label">Search</label>
                                                <div class="input-group">
                                                    <input type="text" id="searchInput" class="form-control" name="search" placeholder="Created By" value="${param.search}">
                                                    <button type="submit" class="btn btn-primary" id="searchButton">Search</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>

                                    <!-- Job Posting Management Table -->
                                    <div class="table-responsive">
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
                                        <table class="table table-bordered table-striped">
                                            <thead class="table-success">
                                                <tr>
                                                    <th>Create By</th>
                                                    <th>Title</th>
                                                    <th>Salary</th>
                                                    <th>Location</th>
                                                    <th>Category</th>
                                                    <th>Status</th>
                                                    <th>Post Date</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    //tao cac doi tuong
                                                    Account account = new Account();
                                                    Recruiters recruiters = new Recruiters();
                                                    Job_Posting_Category jobCate = new Job_Posting_Category();
                                                    //tao cac DAO
                                                    AccountDAO accDao = new AccountDAO();
                                                    RecruitersDAO reDao = new RecruitersDAO();
                                                    Job_Posting_CategoryDAO jobCateDao = new Job_Posting_CategoryDAO();
                                                %>
                                                <c:forEach items="${jobPostingsList}" var="jobPost">
                                                    <c:set var="recruiterId" value="${jobPost.getRecruiterID()}"/>
                                                    <c:set var="cateId" value="${jobPost.getJob_Posting_CategoryID()}"/>
                                                    <!-- Sample Data -->
                                                    <tr>
                                                        <td>
                                                            <%
                                                            int recruiterId = (Integer) pageContext.getAttribute("recruiterId");
                                                            //tim recruiter theo id
                                                            recruiters = reDao.findById(String.valueOf(recruiterId));
                                                            account = accDao.findUserById(recruiters.getAccountID());
                                                            String accountName = "";
                                                            if(account != null){
                                                                accountName = account.getFullName();
                                                                }
                                                            %>
                                                            <%= accountName%>
                                                        </td>
                                                        <td>${jobPost.getTitle()}</td>
                                                        <td>${jobPost.getMinSalary()} - ${jobPost.getMaxSalary()}(USD)</td>
                                                        <td>${jobPost.getLocation()}</td>
                                                        <td>
                                                            <%
                                                                int cateId = (Integer) pageContext.getAttribute("cateId");
                                                                jobCate = jobCateDao.findJob_Posting_CategoryByID(cateId);
                                                                String cateName = "";
                                                                if(jobCate != null){
                                                                    cateName = jobCate.getName();
                                                                }
                                                            %>
                                                            <%= cateName%>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${jobPost.getStatus() == 'Open'}">
                                                                    <span class="badge bg-success">Open</span>
                                                                </c:when>
                                                                <c:when test="${jobPost.getStatus() == 'Closed'}">
                                                                    <span class="badge bg-danger">Closed</span>
                                                                </c:when>
                                                                <c:when test="${jobPost.getStatus() == 'Violate'}">
                                                                    <span class="badge bg-warning text-dark">Violate</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${jobPost.getStatus()}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>${jobPost.getPostedDate()}</td>
                                                        <td>
                                                            <form action="job_posting" method="POST" style="display:inline;">
                                                                <input type="hidden" name="action" value="view">
                                                                <input type="hidden" name="jobPostID" value="${jobPost.getJobPostingID()}">
                                                                <button type="submit" class="btn btn-info btn-sm">
                                                                    <i class="fas fa-eye"></i> 
                                                                </button>
                                                            </form>


                                                            <button 
                                                                type="button" 
                                                                class="btn btn-warning btn-sm" 
                                                                onclick="openResolvedModal(${jobPost.getJobPostingID()})"
                                                                <c:if test="${jobPost.getStatus() == 'Violate'}">disabled</c:if>
                                                                    >
                                                                    <i class="fas fa-exclamation-triangle"></i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                        <!-- Thêm các hàng dữ liệu khác tại đây -->
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
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
                            </div>
                            <!--job posting tab end-->
                            <!-- Category Management Tab Content -->
                            <div class="tab-pane fade" id="categoryContent" role="tabpanel" aria-labelledby="categoryTab">
                                <div class="container-fluid p-4">
                                    <h6 class="fw-medium mb-30 text-center fs-2">CATEGORY MANAGEMENT</h6>
                                    <!--nofication-->



                                    <!-- Add Category Button -->
                                    <div class="text-right mb-3">
                                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                            Add Category
                                        </button>
                                    </div>
                                    <!-- Category Management Table -->
                                    <div class="table-responsive">
                                        <div class="toast-container position-fixed top-0 end-0 p-3">
                                            <!-- Toast for duplicate -->
                                            <div id="duplicateToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                                <div class="toast-header bg-danger text-white">
                                                    <strong class="me-auto">Error</strong>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                                                </div>
                                                <div class="toast-body" id="duplicateToastBody">
                                                    ${duplicate}
                                                </div>
                                            </div>

                                            <!-- Toast for duplicateEdit -->
                                            <div id="duplicateEditToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                                <div class="toast-header bg-danger text-white">
                                                    <strong class="me-auto">Error</strong>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                                                </div>
                                                <div class="toast-body" id="duplicateEditToastBody">
                                                    ${duplicateEdit}
                                                </div>
                                            </div>
                                        </div>

                                        <table class="table table-bordered table-striped">
                                            <thead class="table-primary">
                                                <tr>
                                                    <th>Category Name</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${categoryList}" var="category">
                                                    <c:if test="${category.isStatus() == true}">
                                                        <tr>
                                                            <td>${category.getName()}</td>
                                                            <td>
                                                                <!-- Edit and Delete buttons for each category -->
                                                                <button type="button" class="btn btn-warning btn-sm" onclick="openEditCategoryModal(${category.getId()}, '${category.getName()}')">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <form action="job_posting" method="POST" style="display:inline;">
                                                                    <input type="hidden" name="action" value="deleteCate">
                                                                    <input type="hidden" name="categoryId" value="${category.getId()}">
                                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                                        <i class="fas fa-trash-alt"></i>
                                                                    </button>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <!-- Modal-Edit-Cate -->
                                            <div class="modal fade" id="editCategoryModal" tabindex="-1" role="dialog" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
                                                <div class="modal-dialog" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editCategoryModalLabel">Edit Category</h5>

                                                        </div>
                                                        <div class="modal-body">
                                                            <form id="editCategoryForm" action="job_posting" method="POST">
                                                                <input type="hidden" name="action" value="editCate">
                                                                <input type="hidden" name="categoryId" id="editCategoryId">
                                                                <div class="form-group">
                                                                    <label for="newCategoryName">New Category Name</label>
                                                                    <input type="text" name="newCategoryName" class="form-control" id="newCategoryName" required>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-success">Save</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Modal for Add Category -->
                                            <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
                                                <div class="modal-dialog" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="addCategoryModalLabel">Add Category</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form id="addCategoryForm" action="job_posting" method="POST">
                                                                <input type="hidden" name="action" value="addCate">
                                                                <div class="form-group">
                                                                    <label for="newCategoryName">Category Name</label>
                                                                    <input type="text" name="cateName" class="form-control" id="newCategoryName" required>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-success">Add</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>                
                    </div>
                </div>


                <!-- Footer -->

            </div>
        </div>
    </div>
    <!-- Modal for Violate Action -->
    <div class="modal fade" id="resolvedModal" tabindex="-1" aria-labelledby="resolvedModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="resolvedModalLabel">Violate Content</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="job_posting" method="POST">
                    <div class="modal-body">
                        <input type="hidden" id="resolved-feedback-id" name="jobPostID" value="">
                        <input type="hidden" name="action" value="violate">
                        <div class="mb-3">
                            <label for="resolved-response" class="form-label">Enter notification of violating job posting:</label>
                            <textarea class="form-control" id="resolved-response" name="response" rows="4" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Send</button>
                    </div>
                </form>
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



    </body>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    <script>
        function openResolvedModal(jobPostId) {
            document.getElementById('resolved-feedback-id').value = jobPostId;
            new bootstrap.Modal(document.getElementById('resolvedModal')).show();
        }

        // Clear form when modals are hidden
        document.getElementById('resolvedModal').addEventListener('hidden.bs.modal', function () {
            document.getElementById('resolved-response').value = '';
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
    // Đặt sự kiện lắng nghe cho các tab
    document.addEventListener('DOMContentLoaded', function () {
        const tabTriggers = document.querySelectorAll('[data-bs-toggle="tab"]');
        tabTriggers.forEach(tab => {
            tab.addEventListener('shown.bs.tab', function (event) {
                localStorage.setItem('activeTab', event.target.id);
            });
        });

        // Kiểm tra tab nào đã được lưu và kích hoạt nó
        const activeTab = localStorage.getItem('activeTab');
        if (activeTab) {
            const tabElement = document.getElementById(activeTab);
            const tab = new bootstrap.Tab(tabElement);
            tab.show();
        }
    });
</script>
<script>
    function openEditCategoryModal(categoryId, categoryName) {
        // Điền thông tin vào modal
        document.getElementById('editCategoryId').value = categoryId;
        document.getElementById('newCategoryName').value = categoryName;

        // Mở modal
        $('#editCategoryModal').modal('show');
    }
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Hiển thị Toast cho duplicate nếu không rỗng
        if ("${duplicate}" !== "") {
            document.getElementById('duplicateToastBody').innerHTML = "${duplicate}";
            var duplicateToast = new bootstrap.Toast(document.getElementById('duplicateToast'));
            duplicateToast.show();
        }

        // Hiển thị Toast cho duplicateEdit nếu không rỗng
        if ("${duplicateEdit}" !== "") {
            document.getElementById('duplicateEditToastBody').innerHTML = "${duplicateEdit}";
            var duplicateEditToast = new bootstrap.Toast(document.getElementById('duplicateEditToast'));
            duplicateEditToast.show();
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





</html>