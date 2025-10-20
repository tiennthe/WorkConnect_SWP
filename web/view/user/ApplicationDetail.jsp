<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Application Detail</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
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
        content: "";
        position: absolute;
        bottom: -10px;
        left: 50%;
        transform: translateX(-50%);
        width: 50px;
        height: 5px;
        background-color: #28a745;
      }
      .section-header {
        font-size: 1.6rem;
        color: #28a745;
        margin-bottom: 20px;
        border-bottom: 2px solid #28a745;
        padding-bottom: 8px;
        font-weight: bold;
      }
      .info-section {
        background: white;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
      }
      .info-section p {
        font-size: 1rem;
        color: #555;
      }
      .info-section p strong {
        color: #333;
        font-weight: 600;
      }
      .btn {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }
      .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }
      iframe {
        border: 1px solid #ddd;
        border-radius: 8px;
      }
    </style>
  </head>
  <body>
    <jsp:include page="../common/user/header-user.jsp"></jsp:include>

    <div class="container mb-5 mt-5">
      <h1 class="text-center">Application Details</h1>

      <c:if test="${not empty errorApplication}">
        <div class="alert alert-danger" role="alert">${errorApplication}</div>
      </c:if>

      <c:if test="${empty errorApplication}">
        <div class="row">
          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">Information</h2>
              <c:if test="${not empty account}">
                <p><strong>Fullname:</strong> ${account.fullName}</p>
                <p><strong>Date of birth:</strong> ${account.dob}</p>
                <p><strong>Phone Number:</strong> ${account.phone}</p>
                <p><strong>Email:</strong> ${account.email}</p>
                <p>
                  <strong>Gender:</strong> ${account.gender ? 'Male' : 'Female'}
                </p>
                <p><strong>Address:</strong> ${account.address}</p>
              </c:if>
            </div>
          </div>
          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">Application Information</h2>
              <c:if test="${not empty application}">
                <p><strong>Applied Date:</strong> ${application.appliedDate}</p>
                <p>
                  <strong>Status:</strong>
                  <c:choose>
                    <c:when test="${application.status == 3}">
                      <span class="badge bg-info text-dark"
                        ><i class="fa fa-clock"></i> Pending</span
                      >
                    </c:when>
                    <c:when test="${application.status == 2}">
                      <span class="badge bg-success"
                        ><i class="fa fa-check-circle"></i> Approved</span
                      >
                    </c:when>
                    <c:when test="${application.status == 1}">
                      <span class="badge bg-danger"
                        ><i class="fa fa-times-circle"></i> Rejected</span
                      >
                    </c:when>
                    <c:when test="${application.status == 0}">
                      <span class="badge bg-secondary"
                        ><i class="fa fa-ban"></i> Cancelled</span
                      >
                    </c:when>
                  </c:choose>
                </p>
              </c:if>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">Job Posting Details</h2>
              <c:if test="${not empty jobPost}">
                <p><strong>Title:</strong> ${jobPost.title}</p>
                <p><strong>Location:</strong> ${jobPost.location}</p>
                <p>
                  <strong>Salary:</strong> ${jobPost.minSalary} $ -
                  ${jobPost.maxSalary} $
                </p>
                <c:choose>
                  <c:when test="${category != 'This category was deleted!'}">
                    <!-- Hiển thị thông tin Category nếu Category hợp lệ -->
                    <p><strong>Job Category:</strong> ${category.name}</p>
                  </c:when>
                  <c:otherwise>
                    <!-- Hiển thị thông báo lỗi nếu Category bị xóa hoặc không tồn tại -->
                    <p>
                      <strong>Job Category:</strong> This category was deleted!
                    </p>
                  </c:otherwise>
                </c:choose>
                <p><strong>Description:</strong> ${jobPost.description}</p>
                <p><strong>Requirement:</strong> ${jobPost.requirements}</p>
              </c:if>
              <c:if test="${empty jobPost}">
                <p>Job posting details are not available.</p>
              </c:if>
            </div>
          </div>

          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">CV Details</h2>
              <c:if test="${not empty cv}">
                <iframe
                  src="cv?action=view-cv"
                  height="500px"
                  width="100%"
                  allowfullscreen=""
                  frameborder="0"
                ></iframe>
              </c:if>
              <c:if test="${empty cv}">
                <p>CV details are not available.</p>
              </c:if>
            </div>
          </div>
        </div>
      </c:if>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>

    <!-- Bootstrap and JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
