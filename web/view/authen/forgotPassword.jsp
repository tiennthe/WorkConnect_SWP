<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <jsp:include page="../common/authen/common-css-authen.jsp"></jsp:include>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <style>
      body {
        background-color: #f8f9fa; /* Light background for the body */
      }
      .card {
        border: none; /* Remove default card border */
        border-radius: 1rem; /* Rounded corners for the card */
      }
      .card-body {
        padding: 2rem; /* Padding for the card body */
      }
      .btn-primary {
        background-color: #007bff; /* Custom primary button color */
        border: none; /* Remove border */
        border-radius: 0.5rem; /* Rounded corners for buttons */
      }
      .btn-primary:hover {
        background-color: #0056b3; /* Darker shade on hover */
      }
      .text-danger {
        font-weight: bold; /* Bold error message */
      }
    </style>
  </head>
  <body>
    <!-- Header Area -->
    <jsp:include page="../common/header-area.jsp"></jsp:include>
    <!-- Header Area End -->

    <div
      class="container d-flex justify-content-center align-items-center"
      style="margin-top: 20px; margin-bottom: 20px"
    >
      <div class="col-md-6">
        <div class="card shadow-sm">
          <!-- Added shadow for depth -->
          <div class="card-body">
            <h3 class="text-center mb-4">Forgot Password</h3>
            <!-- Title for the form -->
            <form
              action="${pageContext.request.contextPath}/authen?action=forgot-password"
              method="post"
            >
              <div class="mb-3">
                <label for="fmail" class="form-label">Your Email</label>
                <input
                  type="email"
                  name="email"
                  id="fmail"
                  class="form-control"
                  placeholder="Enter your email"
                  required
                />
              </div>
              <c:if test="${requestScope.error != null}">
                <div class="text-danger text-center mb-3">
                  ${requestScope.error}
                </div>
              </c:if>
              <button type="submit" class="btn btn-success w-100">
                Send OTP
              </button>
            </form>
            <div class="text-center mt-3">
              <span
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

    <jsp:include page="../common/footer.jsp"></jsp:include>
    <jsp:include page="../common/authen/common-js-authen.jsp"></jsp:include>
  </body>
</html>
