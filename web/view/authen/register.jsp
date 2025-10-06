<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Register</title>
        <jsp:include page="../common/authen/common-css-authen.jsp"></jsp:include>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        </head>
        <body>
            <!-- Header Area -->
        <jsp:include page="../common/header-area.jsp"></jsp:include>
            <!-- Header Area End -->

            <div class="container" style="margin-top: 20px; margin-bottom: 20px">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title text-center">Create A Free Account</h5>
                                <p class="text-center">Choose your Account Type</p>

                                <div class="d-flex justify-content-center mb-3">
                                    <button class="btn btn-outline-success me-2 active" data-role="seeker">Seeker</button>
                                    <button class="btn btn-outline-success" data-role="recruiter">Recruiter</button>
                                </div>

                                <form action="${pageContext.request.contextPath}/authen?action=sign-up" method="POST" class="d-flex flex-column gap-3">
                                <input type="hidden" name="role" value="3" />

                                <div class="mb-3">
                                    <label for="lastname" class="form-label">Last Name</label>
                                    <input type="text" name="lastname" id="lastname" class="form-control" placeholder="Enter last name" value="${requestScope.lname}" required>
                                    <span class="text-danger">${errorLname}</span>
                                </div>

                                <div class="mb-3">
                                    <label for="firstname" class="form-label">First Name</label>
                                    <input type="text" name="firstname" id="firstname" class="form-control" placeholder="Enter first name" value="${requestScope.fname}" required>
                                    <span class="text-danger">${errorFname}</span>
                                </div>

                                <div class="mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select name="gender" id="gender" class="form-select">
                                        <option value="male" ${gender == 'male' ? 'selected' : ''}>Male</option>
                                        <option value="female" ${gender == 'female' ? 'selected' : ''}>Female</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="dob" class="form-label">Date of Birth</label>
                                    <input type="date" name="dob" id="dob" class="form-control" value="${requestScope.dob}" required>
                                    <span class="text-danger">${errorDob}</span>
                                </div>
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" name="username" id="username" class="form-control" placeholder="Enter username" value="${requestScope.username}" required>
                                    <span class="text-danger">${errorUsernameExits}</span>
                                    <span class="text-danger">${errorUsername}</span>
                                </div>

                                <div class="mb-3">
                                    <label for="signemail" class="form-label">Your Email</label>
                                    <input type="email" name="email" id="signemail" class="form-control" placeholder="Enter your email" value="${requestScope.email}" required>
                                    <span class="text-danger">${errorEmail}</span>
                                </div>

                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" value="${requestScope.password}" required>
                                        <span class="input-group-text cursor-pointer" onclick="togglePassword('password')">
                                            👁️
                                        </span>
                                    </div>
                                    <small class="form-text text-muted">! Password must be 8-20 characters, containing at least one letter and one special character.</small>
                                    <span class="text-danger">${errorPassword}</span>
                                </div>

                                <div class="mb-3">
                                    <button type="submit" class="btn btn-success w-100">Register</button>
                                </div>
                            </form>
                            <p class="text-center">Have an account? <a href="${pageContext.request.contextPath}/view/authen/login.jsp" class="text-primary">Login</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp"></jsp:include>
        <jsp:include page="../common/authen/common-js-authen.jsp"></jsp:include>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('button[data-role]');
                const hiddenInput = document.querySelector('input[name="role"]');

                buttons.forEach(button => {
                    button.addEventListener('click', function () {
                        buttons.forEach(btn => btn.classList.remove('active')); // Remove 'active' from all buttons
                        this.classList.add('active'); // Add 'active' to clicked button

                        const role = this.getAttribute('data-role'); // Get role from button
                        hiddenInput.value = (role === 'seeker') ? '3' : '2'; // Set role value
                    });
                });

                // Set initial value based on the button that has 'active' class
                const activeButton = document.querySelector('button.active');
                if (activeButton) {
                    hiddenInput.value = activeButton.getAttribute('data-role') === 'seeker' ? '3' : '2';
                }
            });

            function togglePassword(id) {
                var input = document.getElementById(id);
                if (input.type === "password") {
                    input.type = "text";
                } else {
                    input.type = "password";
                }
            }

            // Prevent spaces in username and password fields
            document.getElementById("username").addEventListener("input", function () {
                this.value = this.value.replace(/\s/g, "");  // Remove all spaces
            });

            document.getElementById("password").addEventListener("input", function () {
                this.value = this.value.replace(/\s/g, "");  // Remove all spaces
            });
        </script>
    </body>
</html>
