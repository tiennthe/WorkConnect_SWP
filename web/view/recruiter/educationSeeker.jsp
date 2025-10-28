<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Education</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                background-color: #f8f9fa;
            }

            .profile-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 80px);
                padding: 20px;
                margin-left: 240px;
                padding-top: 80px;
                background-color: #f8f9fa;
            }

            .profile-card {
                background-color: white;
                padding: 40px 50px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                max-width: 800px;
                width: 100%;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            .form-section h2 {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 25px;
                color: #16a085;
                text-align: center;
            }

            .profile-info table {
                width: 100%;
                margin-bottom: 20px;
            }

            .profile-info td {
                padding: 15px;
                font-size: 16px;
                color: #333;
                text-align: left; /* Căn trái cho tất cả các ô */
            }

            .profile-info td:first-child {
                font-weight: bold;
                color: #555;
                width: 35%;
            }

            .degree-img {
                max-width: 100px;
                height: auto;
                border-radius: 5px;
                margin-top: 10px;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }

            .back-button {
                display: inline-block;
                margin-top: 20px;
                color: #007b5e;
                text-decoration: none;
                font-weight: bold;
            }

            .back-button:hover {
                color: #005f46;
            }

            .degree-img-container {
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
            }

            .degree-img {
                max-width: 100px;
                height: auto;
                border-radius: 5px;
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .modal {
                display: none; /* Ẩn modal mặc định */
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.8); /* Màu nền mờ */
            }

            .modal-content {
                margin: auto;
                display: block;
                max-width: 90%;
                max-height: 90%;
                border-radius: 10px;
                transition: transform 0.3s ease;
            }

            .close {
                position: absolute;
                top: 10px;
                right: 25px;
                color: #fff;
                font-size: 35px;
                font-weight: bold;
                cursor: pointer;
            }

            .degree-img-container {
                display: flex;
                justify-content: flex-start; /* Căn ảnh sát lề trái */
                align-items: center;
                position: relative;
            }

            .degree-img {
                max-width: 100px;
                height: auto;
                border-radius: 5px;
                cursor: pointer;
                transition: transform 0.3s ease;
                margin: 0; /* Loại bỏ khoảng cách xung quanh ảnh */
            }

        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>
        <%@ include file="../recruiter/header-re.jsp" %>

        <!-- Profile Container -->
        <div class="profile-container">
            <div class="profile-card">

                <div class="form-section">
                    <h2>View Education</h2>
                    <c:forEach var="education" items="${educations}">
                        <div class="profile-info">
                            <table>
                                <tr>
                                    <td>Institution:</td>
                                    <td>${education.institution}</td>
                                </tr>
                                <tr>
                                    <td>Degree:</td>
                                    <td>${education.degree}</td>
                                </tr>
                                <tr>
                                    <td>Field of Study:</td>
                                    <td>${education.fieldOfStudy}</td>
                                </tr>
                                <tr>
                                    <td>Start Date:</td>
                                    <td><fmt:formatDate value="${education.startDate}" pattern="dd-MM-yyyy" /></td>
                                </tr>
                                <tr>
                                    <td>End Date:</td>
                                    <td><fmt:formatDate value="${education.endDate}" pattern="dd-MM-yyyy" /></td>
                                </tr>
                                <tr>
                                    <td>Degree Image:</td>
                                    <td>
                                        <c:if test="${not empty education.degreeImg}">
                                            <div class="degree-img-container">
                                                <img src="${pageContext.request.contextPath}/${education.degreeImg}" alt="Degree Image" class="degree-img" onclick="openModal(this)">
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>


                            </table>
                        </div>
                                <hr/>
                    </c:forEach>
                    <!-- Back Button -->
                    <div class="text-center">
                        <a href="javascript:history.back()" class="back-button">
                            <i class="fas fa-arrow-left"></i> Back to Applications
                        </a>
                    </div>
                </div>

            </div>
        </div>
        <!-- Modal -->
        <div id="myModal" class="modal">
            <span class="close">&times;</span>
            <img class="modal-content" id="img01">
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>
        <script>
            // Hàm mở modal
            function openModal(imgElement) {
                var modal = document.getElementById("myModal");
                var modalImg = document.getElementById("img01");
                modal.style.display = "block";
                modalImg.src = imgElement.src;
            }

            // Đóng modal khi bấm vào nút close
            var closeBtn = document.getElementsByClassName("close")[0];
            closeBtn.onclick = function () {
                var modal = document.getElementById("myModal");
                modal.style.display = "none";
            };

            // Đóng modal khi bấm vào bất cứ đâu ngoài ảnh
            window.onclick = function (event) {
                var modal = document.getElementById("myModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };
        </script>

    </body>
</html>