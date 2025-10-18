<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="model.Job_Posting_Category"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Job Posting</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Main content layout with reduced width */
            .job-posting-container {
                flex: 1;
                padding: 20px;
                margin-left: 260px;
                margin-top: 80px;
                box-sizing: border-box;
                background-color: #f5f5f5;
                min-height: calc(100vh - 140px);
                display: flex;
                justify-content: center;
            }

            .job-posting-content {
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                max-width: 800px; /* Reduced width */
                width: 100%;
                display: flex;
                flex-direction: column;
                gap: 15px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .job-posting-content:hover {
                transform: scale(1.02);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            .job-posting-header {
                text-align: center;
                margin-bottom: 20px;
            }

            .job-posting-header h2 {
                color: #007b5e;
                font-weight: bold;
                transition: color 0.3s ease;
            }

            /* Field styling with animation */
            .job-detail-full,
            .job-detail {
                background-color: #f0f8f5;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: background-color 0.3s ease, box-shadow 0.3s ease;
            }

            .job-detail-full:hover,
            .job-detail:hover {
                background-color: #e0f3ea;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
            }

            .job-detail-full h5, .job-detail h5 {
                color: #007b5e;
                font-weight: bold;
                margin-bottom: 5px;
                transition: color 0.3s ease;
            }

            .job-detail-full p, .job-detail p {
                margin-bottom: 0;
                color: #333;
            }

            .job-detail {
                display: flex;
                justify-content: space-between;
                gap: 15px;
            }

            .job-detail div {
                width: 48%;
            }

            /* Button styling */
            .btn-apply {
                background-color: #007b5e;
                color: white;
                padding: 10px 25px;
                font-size: 16px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin-top: 20px;
                align-self: center;
                transition: background-color 0.3s ease, transform 0.3s ease;
            }

            .btn-apply:hover {
                background-color: #005f46;
                transform: scale(1.05);
            }

            .status-violate {
                color: red;
                font-weight: bold;
                opacity: 0.5;
            }

        </style>
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>

        <!-- Include Header -->
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Main content for Viewing Job Posting -->
        <div class="job-posting-container">
            <!-- Job Posting Details -->
            <div class="job-posting-content">
                <div class="job-posting-header">
                    <h2>${jobPost.getTitle()}</h2>
                </div>

                <!-- Full-row details with adaptive content length -->
                <div class="job-detail-full">
                    <h5>Description:</h5>
                    <p>${jobPost.getDescription()}</p>
                </div>
                <div class="job-detail-full">
                    <h5>Requirements:</h5>
                    <p>${jobPost.getRequirements()}</p>
                </div>

                <!-- Two-column layout for remaining details -->
                <div class="job-detail">
                    <div>
                        <h5>Status:</h5>
                        <p>
                            <c:if test="${jobPost.getStatus() == 'Violate'}">
                                <span class="status-violate">${jobPost.getStatus()}</span>
                            </c:if>
                            <c:if test="${jobPost.getStatus() != 'Violate'}">
                                ${jobPost.getStatus()}
                            </c:if>
                        </p>
                    </div>

                    <div>
                        <h5>Date Posted:</h5>
                        <p><fmt:formatDate value="${jobPost.getPostedDate()}" pattern="dd-MM-yyyy"/></p>
                    </div>
                </div>

                <div class="job-detail">
                    <div>
                        <h5>Closing Date:</h5>
                        <p><fmt:formatDate value="${jobPost.getClosingDate()}" pattern="dd-MM-yyyy"/></p>
                    </div>
                    <div>
                        <h5>Location:</h5>
                        <p>${jobPost.getLocation()}</p>
                    </div>
                </div>

                <div class="job-detail">
                    <div>
                        <h5>Min Salary $:</h5>
                        <p><fmt:formatNumber value="${jobPost.getMinSalary()}" type="number" groupingUsed="true"/></p>
                    </div>
                    <div>
                        <h5>Max Salary $:</h5>
                        <p><fmt:formatNumber value="${jobPost.getMaxSalary()}" type="number" groupingUsed="true"/></p>
                    </div>
                </div>

                <% 
                    Job_Posting_Category category = (Job_Posting_Category) request.getAttribute("category");
                    if (category != null) {
                %>
                <div class="job-detail">
                    <div>
                        <h5>Job Category:</h5>
                        <p><%= category.getName() %></p>
                    </div>
                </div>
                <% } else { %>
                <div class="job-detail">
                    <h5>Job Category:</h5>
                </div>
                <% } %>

                <a href="javascript:window.history.back();" class="btn-apply">Back</a>
            </div>
        </div>

        <!-- Include Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>
    </body>
</html>