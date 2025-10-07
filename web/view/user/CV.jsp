<%@page import="model.CV"%>
<%@page import="model.JobSeekers"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Seeker's CV</title>
        <!-- Bootstrap CSS -->
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
        <!-- Header area -->
        <jsp:include page="../common/user/header-user.jsp"></jsp:include>
            <!-- Header area end -->

            <div class="container mt-5 mb-5">
                <h1 class="text-center">Manage Your CV</h1>

                <!-- Display success or error messages -->

            <c:if test="${not empty errorJobSeeker}">
                <div class="alert alert-danger" role="alert">
                    ${errorJobSeeker} <a href="JobSeekerCheck">Click here!!</a>
                </div>
            </c:if>

            <c:if test = "${empty errorJobSeeker}">
                <c:if test="${not empty successCV}">
                    <div class="alert alert-success" role="alert">
                        ${successCV}
                    </div>
                </c:if>

                <c:if test="${not empty errorCV}">
                    <div class="alert alert-danger" role="alert">
                        ${errorCV}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <!-- Check if there's a CV -->
                <c:if test="${not empty cvFilePath}">
                    <!-- Display View CV button -->
                    <div class="d-grid gap-2 mb-1">
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#updateCVModal">
                            Update CV
                        </button>
                    </div>
                    <div class="mb-4">
                        <iframe src="cv?action=view-cv" height="1200px" width="100%" allowfullscreen="" frameborder="0"></iframe>
                    </div>

                    <!-- Form to update CV -->


                </c:if>

                <c:if test="${empty cvFilePath}">
                    <!-- Form to upload CV if not present -->
                    <form action="${pageContext.request.contextPath}/cv?action=upload-cv" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="cvFile" class="form-label">Upload CV</label>
                            <input type="file" class="form-control" id="cvFile" name="cvUploadFile" accept=".pdf" required>
                        </div>
                        <span style="color: green">Note: <strong>Upload file less than 10MB (or 10 240KB)</strong></span><br/>
                        <button type="submit" class="btn btn-success">Upload CV</button>
                    </form>
                </c:if>
            </c:if>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="updateCVModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h2 class="modal-title fs-5" id="exampleModalLabel">Update CV</h2>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/cv?action=update-cv" method="post" enctype="multipart/form-data">
                        <div class="modal-body">

                            <div class="mb-3">
                                <label for="cvFile" class="form-label">Update CV</label>
                                <input type="file" class="form-control" id="cvFile" name="cvFileU" accept=".pdf" required>
                            </div>
                            <span style="color: green">Note: <strong>Upload file less than 10MB (or 10 240KB)</strong></span>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-success">Update CV</button>
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
        <script>
            document.getElementById("cvFile").onchange = function () {
                const file = this.files[0];
                if (file.size > 10 * 1024 * 1024) {  // 10MB
                    alert("File size exceeds the 10MB limit. Please choose a smaller file.");
                    this.value = "";  // Reset the input
                }
            };
            document.getElementById("cvFileU").onchange = function () {
                const file = this.files[0];
                if (file.size > 10 * 1024 * 1024) {  // 10MB
                    alert("File size exceeds the 10MB limit. Please choose a smaller file.");
                    this.value = "";  // Reset the input
                }
            };

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

        <!-- Bootstrap JS and Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>
