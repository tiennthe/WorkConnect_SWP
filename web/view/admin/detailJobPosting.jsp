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
        <title>Job Posting Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Custom font and layout */

            .card {
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                border-radius: 10px;
            }
            .card-header {
                background-color: #4CAF50;
                color: white;
                font-size: 1.25rem;
                font-weight: bold;
                text-align: center;
            }
            .detail-item {
                padding: 10px 0;
                font-size: 1rem;
                display: flex;
                align-items: center;
            }
            .detail-item i {
                color: #28a745;
                margin-right: 8px;
            }
            .detail-item strong {
                color: #333;
                font-weight: bold;
                margin-right: 5px;
            }
            .back-btn {
                margin-top: 20px;
                display: flex;
                justify-content: flex-start;
            }
            .detail-item {
                display: flex;
                align-items: center;
            }

            .detail-item p {
                margin: 0;
                padding-left: 5px;
                font-size: 1rem;
                flex: 1; /* Ensures that all details are aligned in a row */
            }

            .detail-item strong {
                min-width: 100px; /* Adjust this value based on the desired label width */
            }
            .detail-item.long-text {
                display: block; /* Chuyển thành khối để nội dung có thể xuống dòng */
                padding-top: 10px;
            }

            .detail-item.long-text p {
                padding-left: 20px; /* Căn lề một chút để tách biệt nội dung */
                white-space: pre-wrap; /* Giúp xuống dòng nếu nội dung dài */
            }

        </style>
    </head>
    <body>
        <!-- header area -->
        <jsp:include page="../common/admin/header-admin.jsp"></jsp:include>

            <!-- content area -->
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-2">
                        <!-- Side bar -->
                    <jsp:include page="../common/admin/sidebar-admin.jsp"></jsp:include>
                    </div>
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
                <div class="col-md-10">
                    <div class="card mt-5 ms-3">
                        <div class="card-header">
                            Job Posting Details
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <c:set var="recruiterId" value="${jobPost.getRecruiterID()}"/>
                                <c:set var="cateId" value="${jobPost.getJob_Posting_CategoryID()}"/>
                                <!-- Detail fields with icons -->

                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-user"></i> <strong>Created By:</strong>
                                    <p>
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
                                    </p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-heading"></i> <strong>Title:</strong>
                                    <p>${jobPost.getTitle()}</p>
                                </div>
                                <div class="col-md-6 detail-item long-text">
                                    <i class="fas fa-align-left"></i> <strong>Description:</strong>
                                    <p>${jobPost.getDescription()}</p>
                                </div>
                                <div class="col-md-6 detail-item long-text">
                                    <i class="fas fa-tasks"></i> <strong>Requirement:</strong>
                                    <p>${jobPost.getRequirements()}</p>
                                </div>

                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-dollar-sign"></i> <strong>Salary:</strong>
                                    <p>${jobPost.getMinSalary()} - ${jobPost.getMaxSalary()}(USD)</p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-map-marker-alt"></i> <strong>Location:</strong>
                                    <p>${jobPost.getLocation()}</p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-calendar-alt"></i> <strong>Post Date:</strong>
                                    <p>${jobPost.getPostedDate()}</p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-calendar-times"></i> <strong>Closing Date:</strong>
                                    <p>${jobPost.getClosingDate()}</p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-briefcase"></i> <strong>Category:</strong>
                                    <p>
                                        <%
                                                        int cateId = (Integer) pageContext.getAttribute("cateId");
                                                        jobCate = jobCateDao.findJob_Posting_CategoryByID(cateId);
                                                        String cateName = "";
                                                        if(jobCate != null){
                                                            cateName = jobCate.getName();
                                                        }
                                        %>
                                        <%= cateName%>
                                    </p>
                                </div>
                                <div class="col-md-6 detail-item">
                                    <i class="fas fa-info-circle"></i> <strong>Status:</strong>
                                    <p>${jobPost.getStatus()}</p>
                                </div>
                            </div>

                            <!-- Back Button -->
                            <div class="back-btn">
                                <button onclick="history.back();" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="../common/admin/common-js-admin.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>