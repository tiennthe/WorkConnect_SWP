<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.JobPostings"%>
<%@page import="dao.JobPostingsDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Seeker's Education</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                background-color: #f4f4f9;
            }
            h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 30px;
                text-transform: uppercase;
                position: relative;
            }
            h1::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 50px;
                height: 5px;
                background-color: #28a745;
            }
            table {
                border-collapse: separate;
                border-spacing: 0 15px;
            }
            thead th {
                background-color: #28a745;
                color: #fff;
                text-transform: uppercase;
                padding: 10px;
            }
            tbody tr {
                background-color: #f9f9f9;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border-radius: 5px;
            }
            tbody tr:hover {
                background-color: #e9ecef;
            }
            td {
                padding: 15px;
                vertical-align: middle;
            }
            button:hover {
                transform: scale(1.05);
                transition: transform 0.2s ease;
            }
            .btn-warning {
                background-color: #ffc107;
                border-color: #ffc107;
            }
            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
            }
            .modal-content {
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                border-radius: 10px;
            }
            .modal-header {
                border-bottom: 0;
                background-color: #28a745;
                color: white;
            }
        </style>
    </head>
    <body>
        <!-- Header Area -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>
            <!-- Header Area End -->
            <div class="container mt-5">
                <h1 class="text-center">My Feedback</h1>

                <table class="table table-hover mt-3 table-bordered">
                    <thead class="thead">
                        <tr>
                            <th>Content</th>
                            <th>Status</th>
                            <th>Job Title</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        JobPostings jobPost = new JobPostings();
                        JobPostingsDAO jobPostDao = new JobPostingsDAO();
                    %>
                    <c:forEach var="feedback" items="${feedbackList}">
                        <c:if test="${feedback.getStatus() != 4}">
                            <tr>
                                <td>${feedback.getContentFeedback()}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${feedback.getStatus() == 1}">
                                            <span class="badge bg-info">Pending</span>
                                        </c:when>
                                        <c:when test="${feedback.getStatus() == 2}">
                                            <span class="badge bg-success">Resolved</span>
                                        </c:when>
                                        <c:when test="${feedback.getStatus() == 3}">
                                            <span class="badge bg-secondary ">Reject</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning">Delete</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:set var="jobPostId" value="${feedback.getJobPostingID()}"/>
                                    <%
                                        int jobPostId = (Integer) pageContext.getAttribute("jobPostId");
                                        jobPost = jobPostDao.findJobPostingById(jobPostId);
                                        String title = "";
                                        if(jobPost != null){
                                            title = jobPost.getTitle();
                                        }
                                    %>
                                    <a href="${pageContext.request.contextPath}/jobPostingDetail?action=details&idJP=${feedback.getJobPostingID()}" class="text-decoration-none">
                                        <%= title %>
                                    </a>
                                </td>
                                <td class="text-center">
                                    <form action="feedbackSeeker" method="post" style="display:inline;">
                                        <input type="hidden" name="feedbackId" value="${feedback.getFeedbackID()}"/>
                                        <input type="hidden" name="action" value="delete"/>
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-warning btn-sm" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editFeedbackModal" 
                                            data-feedback-id="${feedback.getFeedbackID()}"
                                            data-feedback-content="${feedback.getContentFeedback()}"
                                            <c:if test="${feedback.getStatus() != 1}">disabled</c:if>>
                                                <i class="fas fa-edit"></i> Edit
                                            </button>    
                                    </td>
                                </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Edit Feedback Modal -->
        <div class="modal fade" id="editFeedbackModal" tabindex="-1" aria-labelledby="editFeedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="feedbackSeeker" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editFeedbackModalLabel">Edit Feedback</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editFeedbackContent" class="form-label">Feedback Content</label>
                                <textarea class="form-control" id="editFeedbackContent" name="content" rows="4" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" name="action" value="edit"/>
                            <input type="hidden" id="editFeedbackId" name="feedbackId"/>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <button type="button" class="btn btn-primary position-fixed" id="back-to-top" style="bottom: 20px; right: 20px;">
                <i class="fas fa-arrow-up"></i>
            </button>
        <!-- Footer -->
        <jsp:include page="../common/footer.jsp"></jsp:include>



        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        <script>
            // Gán dữ liệu cho modal edit khi nút Edit được ấn
            var editFeedbackModal = document.getElementById('editFeedbackModal');
            editFeedbackModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                var feedbackId = button.getAttribute('data-feedback-id');
                var feedbackContent = button.getAttribute('data-feedback-content');

                var modalContent = editFeedbackModal.querySelector('#editFeedbackContent');
                var modalFeedbackId = editFeedbackModal.querySelector('#editFeedbackId');

                modalContent.value = feedbackContent;
                modalFeedbackId.value = feedbackId;
            });
            
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
    </body>
</html>