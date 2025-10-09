<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" type="image/x-icon">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon-16x16.png" type="image/x-icon">
        <!-- Bootstrap for responsiveness -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            .g-recaptcha {
                transform: scale(0.85); /* Thu nhỏ reCAPTCHA */
                transform-origin: 0 0;  /* Căn chỉnh reCAPTCHA ở góc trên bên trái */
            }
        </style>

    </head>
    <body class="bg-light d-flex flex-column min-vh-100">
        <!-- Header Area -->
        <jsp:include page="../common/header-area.jsp"></jsp:include>

            <!-- Login Container -->
            <div class="container d-flex justify-content-center align-items-center flex-grow-1">
                <div class="card shadow-sm" style="width: 100%; max-width: 500px; margin-top: 20px; margin-bottom: 20px">
                    <div class="card-body">

                        <div class="mb-4 text-center position-relative">
                            <h4 class="card-title" style="font-weight: bolder">
                                Login Work<span style="color: green;">Connect</span>
                            </h4>
                            <a href="${pageContext.request.contextPath}/home" class="btn-close position-absolute top-0 end-0" aria-label="Close"></a>
                    </div>

                    <!-- Display error message if login fails -->
                    <c:if test="${requestScope.messLogin != null}">
                        <div class="alert alert-danger" role="alert">
                            ${requestScope.messLogin}
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope.changePWsuccess}">
                        <div class="alert alert-success" role="alert">${requestScope.changePWsuccess}</div>
                    </c:if>

                    <!-- Login Form -->
                    <form action="${pageContext.request.contextPath}/authen?action=login" method="post" id="login-form" onsubmit="return validateForm()">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" value="${cookie.cu.value}" required>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" value="${cookie.cp.value}" required>
                                <span class="input-group-text cursor-pointer" onclick="togglePassword('password')">
                                    👁️
                                </span>
                            </div>

                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe" ${(cookie.cr != null ? 'checked':'')}>
                                <label class="form-check-label" for="rememberMe">Remember Me</label>
                            </div>
                            <a href="${pageContext.request.contextPath}/view/authen/forgotPassword.jsp">Forgot Password?</a>
                        </div>

                        <!-- Google reCAPTCHA -->
                        <div class="g-recaptcha" data-sitekey="6LeVFEsqAAAAAFK_7xKTrV798KMOrnTYcVgfeMIa"></div>
                        <div id="error" class="text-danger mb-3"></div> <!-- Div to display reCAPTCHA errors -->

                        <!-- Login Button -->
                        <button type="button" onclick="checkCapCha()" class="btn btn-success w-100 my-3">Login</button>
                    </form>

                    <!-- Register Link -->
                    <p class="text-center">Don’t have an account? <a href="${pageContext.request.contextPath}/authen?action=sign-up">Register</a></p>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp"></jsp:include>

        <!-- JS logic -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        <script type="text/javascript">
                            function togglePassword() {
                                var input = document.getElementById("password");
                                var icon = document.getElementById("togglePassword");
                                if (input.type === "password") {
                                    input.type = "text";
                                    icon.textContent = '🙈'; // Change icon to indicate password is shown
                                } else {
                                    input.type = "password";
                                    icon.textContent = '👁️'; // Change icon back to indicate password is hidden
                                }
                            }

                            // Prevent entering spaces in username and password fields
                            function preventSpaces(event) {
                                if (event.key === " ") {
                                    event.preventDefault();
                                    alert("Username and Password cannot contain spaces!");
                                }
                            }

                            // Remove spaces when entering username
                            document.getElementById("username").addEventListener("input", function () {
                                this.value = this.value.replace(/\s/g, "");  // Remove all spaces
                            });

                            // Remove spaces when entering password
                            document.getElementById("password").addEventListener("input", function () {
                                this.value = this.value.replace(/\s/g, "");  // Remove all spaces
                            });

                            function validateForm() {
                                var username = document.getElementById("username").value;
                                var password = document.getElementById("password").value;

                                // Trim spaces from start and end
                                username = username.trim();
                                password = password.trim();

                                // Check for spaces anywhere in username or password
                                if (/\s/.test(username) || /\s/.test(password)) {
                                    alert("Username and Password cannot contain spaces!");
                                    return false;  // Prevent form submission
                                }

                                return true;  // Allow submission if no errors
                            }

                            document.getElementById("login-form").onsubmit = function () {
                                return validateForm();
                            };

                            // Attach event listeners to prevent space input
                            document.getElementById("username").addEventListener("keydown", preventSpaces);
                            document.getElementById("password").addEventListener("keydown", preventSpaces);

                            function checkCapCha() {
                                var form = document.getElementById("login-form");
                                var error = document.getElementById("error");
                                const response = grecaptcha.getResponse();
                                if (response) {
                                    form.submit();
                                } else {
                                    error.textContent = "Please verify that you are not a robot";
                                }
                            }
        </script>
    </body>
</html>
