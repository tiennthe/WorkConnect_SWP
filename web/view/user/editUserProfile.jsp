<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- CSS -->
    <title>Edit Seeker Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <!-- Header Area -->
    <jsp:include page="../common/user/header-user.jsp"></jsp:include>

    <!-- Content Area -->
    <div class="container">
            <!-- Main Content -->
                <form action="${pageContext.request.contextPath}/authen?action=edit-profile" method="POST" id="profile-form" enctype="multipart/form-data">
                    <div class="card my-3">
                        <div class="card-header">
                            <h5>My Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-3">
                                <c:if test="${empty sessionScope.account.getAvatar()}">
                                    <img id="preview" src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="" width="150">
                                </c:if>
                                <c:if test="${not empty sessionScope.account.getAvatar()}">
                                    <img id="preview" src="${sessionScope.account.getAvatar()}" alt="" width="150">
                                </c:if>
                            </div>
                            <div class="mb-3">
                                <label for="file" class="form-label">Upload New Photo</label>
                                <input type="file" class="form-control" id="file" name="avatar" onchange="previewImage(event)">
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="lname" class="form-label">Last Name</label>
                                    <input type="text" name="lastName" id="lname" class="form-control" placeholder="Last Name" readonly="" required value="${sessionScope.account.getLastName()}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="fname" class="form-label">First Name</label>
                                    <input type="text" name="firstName" id="fname" class="form-control" placeholder="First Name" readonly="" required value="${sessionScope.account.getFirstName()}">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" name="phone" id="phone" class="form-control" placeholder="+84" required value="${sessionScope.account.getPhone()}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="dob" class="form-label">Date of Birth</label>
                                    <input type="date" name="date" id="dob" class="form-control" readonly="" value="${sessionScope.account.getDob()}">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <input type="text" id="genderDisplay" class="form-control" value="${sessionScope.account.gender == true ? 'Male' : 'Female'}" readonly>
                                    <input type="hidden" name="gender" id="genderHidden">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="add" class="form-label">Address</label>
                                    <input type="text" name="address" id="add" class="form-control" placeholder="Your Address" required value="${sessionScope.account.getAddress()}">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" name="email" id="email" class="form-control" value="${sessionScope.account.getEmail()}" required readonly>
                            </div>
                            <c:if test="${requestScope.error != null}">
                                <div class="alert alert-danger text-center">
                                    ${requestScope.error}
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="text-center mb-3">
                        <button type="submit" class="btn btn-success">Save Profile</button>
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
    <!-- Content Area End -->

    <!-- Footer -->
    <jsp:include page="../common/footer.jsp"></jsp:include>
    <jsp:include page="../common/user/common-js-user.jsp"></jsp:include>
    <script>
        function previewImage(event) {
            var input = event.target;
            if (!input.files || !input.files[0]) return;

            var reader = new FileReader();
            reader.onload = function (e) {
                var output = document.getElementById('preview');
                if (output) {
                    output.src = e.target.result;
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</body>
</html>
