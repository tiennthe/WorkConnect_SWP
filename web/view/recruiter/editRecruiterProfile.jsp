<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                background-color: #f8f9fa;
            }

            /* Profile container styling */
            .profile-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 80px); /* Adjust for full height excluding header */
                padding: 20px;
                margin-left: 240px;
                padding-top: 80px;
                background-color: #f8f9fa;
            }

            /* Card styling for the profile section */
            .profile-card {
                background-color: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
                max-width: 600px; /* Tăng kích thước khung */
                width: 100%;
                display: flex;
                justify-content: space-between;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            /* Hover effect for card */
            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            /* Styling for avatar and user details */
            .profile-sidebar {
                text-align: center;
                margin-right: 30px;
            }

            .profile-sidebar img {
                width: 140px;
                height: 140px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 15px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .profile-sidebar img:hover {
                transform: scale(1.1);
            }

            .profile-sidebar h4 {
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 20px;
                color: #2c3e50;
            }

            .form-section {
                flex: 1;
            }

            .form-section h2 {
                font-size: 22px; /* Slightly bigger title */
                font-weight: bold;
                margin-bottom: 15px;
                color: #16a085;
            }

            /* Styling for input fields and buttons */
            .form-group label {
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 14px; /* Bigger label text */
                color: #2c3e50;
            }

            .form-control {
                padding: 10px; /* Increased padding for better spacing */
                height: 40px; /* Increased input height */
                border-radius: 8px;
                border: 1px solid #ced4da;
                transition: border-color 0.3s;
            }

            .form-control:focus {
                border-color: #16a085;
                box-shadow: 0 0 8px rgba(22, 160, 133, 0.2);
            }

            .btn-success {
                margin-top: 16px;
                padding: 12px 18px;
                font-size: 16px; /* Adjusted button text size */
                border-radius: 30px;
                background-color: #28a745;
                border: none;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .btn-success:hover {
                background-color: #148f77;
                transform: translateY(-3px);
            }

            /* Success and error message styling */
            .alert {
                margin-top: 15px;
                padding: 12px;
                border-radius: 8px;
            }

            .alert-success {
                background-color: #e9f7ef;
                color: #2e7d32;
                border-left: 5px solid #2e7d32;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border-left: 5px solid #721c24;
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
                <!-- Sidebar with avatar and introduction -->
                <div class="profile-sidebar">
                    <c:if test="${empty sessionScope.account.getAvatar()}">
                        <img id="avatar-preview" src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="User Avatar">
                    </c:if>
                    <c:if test="${!empty sessionScope.account.getAvatar()}">
                        <img id="avatar-preview" src="${sessionScope.account.getAvatar()}" alt="User Avatar">
                    </c:if>
                    <h4>${sessionScope.account.getFullName()}</h4>
                </div>

                <!-- Profile content (Form) -->
                <div class="form-section">
                    <h2>Edit Profile</h2>
                    <form action="${pageContext.request.contextPath}/authen?action=edit-profile" method="POST" enctype="multipart/form-data">
                        <!-- Avatar Upload -->
                        <div class="form-group">
                            <label for="avatar">Change Avatar</label>
                            <input type="file" class="form-control" id="avatar" name="avatar" accept="image/*" onchange="previewAvatar(event)">
                        </div>

                        <!-- Full Name -->
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" readonly="" value="${sessionScope.account.getLastName()}" required>
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="firstName">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" readonly="" value="${sessionScope.account.getFirstName()}" required>
                            </div>
                        </div>

                        <!-- Email (Read-only) -->
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="${sessionScope.account.getEmail()}" readonly>
                        </div>

                        <!-- Phone -->
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.account.getPhone()}" required>
                        </div>

                        <!-- Gender -->
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <input type="text" id="genderDisplay" class="form-control" value="${sessionScope.account.gender == true ? 'Male' : 'Female'}" readonly>
                            <input type="hidden" name="gender" id="genderHidden">
                        </div>

                        <!-- Address -->
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" class="form-control" id="address" name="address" value="${sessionScope.account.getAddress()}" required>
                        </div>

                        <!-- Date of Birth -->
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <input type="date" class="form-control" id="dob" name="date" readonly="" value="${sessionScope.account.getDob()}" required>
                        </div>

                        <!-- Save Button -->
                        <div class="form-group">
                            <button type="submit" class="btn btn-success">Update Profile</button>
                        </div>
                    </form>

                    <!-- Display success or error messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert">
                            ${successMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty errorsMessage}">
                        <div class="alert alert-danger" role="alert">
                            <ul>
                                <c:forEach var="error" items="${errorsMessage}">
                                    <li>${error}</li>
                                    </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- JavaScript to preview the uploaded avatar image -->
        <script>
            function previewAvatar(event) {
                var reader = new FileReader();
                reader.onload = function () {
                    var output = document.getElementById('avatar-preview');
                    output.src = reader.result;
                };
                reader.readAsDataURL(event.target.files[0]);
            }
        </script>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>
    </body>
</html>