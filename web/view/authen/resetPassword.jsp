<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot password - Reset Password</title>
    <!-- Favicon -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon-16x16.png" type="image/x-icon">
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
  </head>
  <body>
    <!-- header area -->
    <jsp:include page="../common/header-area.jsp"></jsp:include>
    <!-- header area end -->

    <div class="container" id="forgotModal" style="max-width: 500px">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="p-4">
            <h6 class="mb-4">Reset Your Password</h6>

            <!-- OTP confirmation form -->
            <form
              action="authen?action=reset-password"
              method="POST"
              class="d-flex flex-column gap-3"
            >
              <div class="form-group">
                <label for="password" class="fw-medium text-dark"
                  >Password</label
                >
                <div class="input-group">
                  <input
                    type="password"
                    name="password"
                    id="password"
                    class="form-control"
                    placeholder="Enter your new password"
                    required
                    onkeydown="preventSpaces(event)"
                  />
                  <span
                    class="input-group-text cursor-pointer"
                    onclick="togglePassword('password')"
                  >
                    👁️
                  </span>
                </div>

                <label for="confirmPassword" class="fw-medium text-dark mt-3"
                  >Confirm New Password</label
                >
                <div class="input-group">
                  <input
                    type="password"
                    name="confirmPassword"
                    id="confirmPassword"
                    class="form-control"
                    placeholder="Confirm your new password"
                    required
                    onkeydown="preventSpaces(event)"
                  />
                  <span
                    class="input-group-text cursor-pointer"
                    onclick="togglePassword('confirmPassword')"
                  >
                    👁️
                  </span>
                </div>
              </div>

              <!-- Error message if OTP is incorrect -->
              <c:if test="${requestScope.error != null}">
                <div class="text-danger text-center">${requestScope.error}</div>
              </c:if>

              <div class="form-group my-3">
                <button type="submit" class="btn btn-success w-100">
                  Change Password
                </button>
              </div>
            </form>

            <!-- Link to login page -->
            <div class="text-center mt-3">
              <span class="fw-medium"
                >Remember Your Password?
                <a
                  href="${pageContext.request.contextPath}/view/authen/login.jsp"
                  class="text-primary"
                  >Login</a
                ></span
              >
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer and JS includes -->
    <jsp:include page="../common/footer.jsp"></jsp:include>
    <jsp:include page="../common/authen/common-js-authen.jsp"></jsp:include>
  </body>

  <script>
    // Prevent entering spaces in password fields
    function preventSpaces(event) {
      if (event.key === " ") {
        event.preventDefault(); // Prevent the space from being entered
        alert("Passwords cannot contain spaces.");
      }
    }

    function togglePassword(id) {
      var input = document.getElementById(id);
      if (input.type === "password") {
        input.type = "text";
      } else {
        input.type = "password";
      }
    }
  </script>
</html>
