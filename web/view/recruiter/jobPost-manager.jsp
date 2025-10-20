<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib
uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Job Posting Management</title>
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Font Awesome for icons -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <style>
      /* Main layout using flexbox */
      .page-container {
        display: flex;
        flex-direction: column;
        min-height: 100vh; /* Ensure the container takes full height */
      }

      /* Main content layout */
      .job-posting-container {
        flex: 1; /* Allows this section to expand */
        padding: 20px;
        margin-left: 240px; /* Adjust for sidebar */
        padding-top: 60px; /* Adjust for header */
        background-color: #f5f5f5; /* Light background */
        display: flex;
        flex-direction: column; /* Ensure content is stacked vertically */
      }

      /* Ensure table takes available space */
      .table-wrapper {
        flex: 1; /* Table section will expand to take up available space */
      }

      /* Center and style header section */
      .header-section {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
      }

      .header-section h2 {
        color: #007b5e;
        font-weight: bold;
        font-size: 26px;
        margin-top: 80px;
      }

      /* Search bar, Add New Job, and Filter positioning */
      .controls-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 90%; /* Match width of the table */
        margin: 0 auto 20px; /* Center and position above the table */
      }

      /* Add new job button */
      .btn-add-job {
        background-color: #007b5e;
        color: white;
        padding: 10px 20px;
        font-size: 15px;
        border-radius: 5px;
        text-decoration: none;
        display: inline-block;
        transition: background-color 0.3s ease;
      }

      .btn-add-job i {
        margin-right: 5px;
      }

      .btn-add-job:hover {
        background-color: #005f46;
      }

      /* Search bar styling */
      .search-container {
        display: flex;
        justify-content: flex-end;
      }

      .search-box {
        width: 250px;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-right: none;
        border-radius: 5px 0 0 5px;
        font-size: 14px;
        outline: none;
        height: 42px;
      }

      .search-button {
        background-color: #007b5e;
        border: none;
        padding: 8px 15px;
        border-radius: 0 5px 5px 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 42px;
        cursor: pointer;
      }

      .search-button i {
        color: white;
        font-size: 16px;
      }

      /* Filter buttons styling */
      .filter-buttons {
        display: flex;
        gap: 10px;
      }

      .filter-buttons .btn-filter {
        background-color: #f8f9fa;
        border: 1px solid #007b5e;
        color: #007b5e;
        padding: 7px 11px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-decoration: none;
      }

      .filter-buttons .btn-filter:hover {
        background-color: #007b5e;
        color: white;
      }

      /* Table styling */
      table {
        width: 90%;
        margin: 0 auto;
        border-collapse: collapse;
        background-color: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      table thead th {
        background-color: #007b5e;
        color: white;
        padding: 15px;
        text-align: center; /* Center the headers */
        font-size: 16px;
      }

      table tbody td {
        padding: 12px;
        border: 1px solid #ddd;
        text-align: center;
        font-size: 14px;
      }

      /* Action buttons styling */
      .btn-action {
        margin-right: 20px; /* Increase spacing between action buttons */
        background-color: transparent;
        color: #007b5e;
        font-size: 16px;
        cursor: pointer;
        text-decoration: none;
      }

      .btn-action:last-child {
        margin-right: 0;
      }

      .btn-action:hover {
        color: #005f46;
      }

      .text-danger {
        color: #dc3545;
      }

      .text-danger:hover {
        color: #c82333;
      }

      /* Pagination */
      .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 20px;
        padding-bottom: 20px;
      }

      .pagination button,
      .pagination span {
        padding: 8px 15px;
        border: none;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px;
        margin: 0 5px;
      }

      .pagination button {
        background-color: #007bff;
        color: white;
      }

      .pagination button:hover {
        background-color: #0056b3;
      }

      .pagination .page-number.active {
        background-color: #007bff;
        color: white;
      }

      /* Error message styling */
      .error-message {
        color: #f08080;
        padding: 20px;
        border-radius: 5px;
        text-align: center;
        margin-top: 20px;
        font-weight: bold;
      }

      .job-title-violate {
        color: red;
        font-weight: bold;
        opacity: 0.5; /* Làm mờ tiêu đề và icon */
      }

      .job-title-violate .fa-exclamation-triangle {
        color: red;
        margin-left: 5px;
      }

      .status-violate {
        font-weight: bold;
      }

      .edit-violate {
        color: red; /* Màu đỏ cho icon */
        cursor: not-allowed; /* Thay đổi con trỏ để cho thấy không thể nhấn */
        opacity: 0.5;
      }

      .status-violate {
        color: red;
        font-weight: bold;
        opacity: 0.5;
      }

      .date-violate {
        color: red;
        font-weight: bold;
        opacity: 0.5; /* Làm mờ nội dung */
      }

      table tbody tr:hover {
        background-color: #e0f7fa; /* Màu nền sáng hơn khi hover */
        transition: background-color 0.3s ease; /* Hiệu ứng chuyển đổi mượt */
      }
    </style>
  </head>
  <body>
    <div class="page-container">
      <!-- Include Sidebar -->
      <%@ include file="../recruiter/sidebar-re.jsp" %>

      <!-- Include Header -->
      <%@ include file="../recruiter/header-re.jsp" %>

      <!-- Main content for Job Posting Management -->
      <div class="job-posting-container">
        <!-- Centered Header section -->
        <div class="header-section">
          <h2>Job Posting Management</h2>
        </div>

        <!-- Search bar, Add New Job, and Filters -->
        <div class="controls-container">
          <!-- Add New Job Button -->

          <a
            href="${pageContext.request.contextPath}/AddJobPosting"
            class="btn-add-job"
          >
            <i class="fas fa-plus"></i> Add New Job
          </a>

          <!-- Filter Buttons -->
          <div class="filter-buttons">
            <a
              href="${pageContext.request.contextPath}/jobPost?sort=title&page=1&searchJP=${searchJP}"
              class="btn-filter"
              >Filter by Title A-Z</a
            >
            <a
              href="${pageContext.request.contextPath}/jobPost?sort=postedDate&page=1&searchJP=${searchJP}"
              class="btn-filter"
              >Filter by Post Date</a
            >
            <a
              href="${pageContext.request.contextPath}/jobPost?sort=status&page=1&searchJP=${searchJP}"
              class="btn-filter"
              >Filter by Status</a
            >
          </div>
          <!-- Search bar -->
          <form
            action="${pageContext.request.contextPath}/jobPost"
            method="get"
            class="search-container"
          >
            <input
              type="text"
              name="searchJP"
              class="search-box"
              placeholder="Search by job title"
            />
            <button type="submit" class="search-button">
              <i class="fas fa-search"></i>
            </button>
          </form>
        </div>

        <!-- Table for displaying job postings -->
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Job Title</th>
                <th>Date Posted</th>
                <th>Status</th>
                <th>Actions</th>
                <th>Applications</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="i" items="${listJobPosting}">
                <tr>
                  <td>
                    <c:if test="${i.getStatus() == 'Violate'}">
                      <span class="job-title-violate">
                        ${i.getTitle()}
                        <i
                          class="fas fa-exclamation-triangle"
                          title="Violate"
                        ></i>
                      </span>
                    </c:if>
                    <c:if test="${i.getStatus() != 'Violate'}">
                      ${i.getTitle()}
                    </c:if>
                  </td>

                  <td>
                    <c:if test="${i.getStatus() == 'Violate'}">
                      <span class="date-violate">
                        <fmt:formatDate
                          value="${i.getPostedDate()}"
                          pattern="dd-MM-yyyy"
                        />
                      </span>
                    </c:if>
                    <c:if test="${i.getStatus() != 'Violate'}">
                      <fmt:formatDate
                        value="${i.getPostedDate()}"
                        pattern="dd-MM-yyyy"
                      />
                    </c:if>
                  </td>

                  <td>
                    <c:if test="${i.getStatus() == 'Violate'}">
                      <span class="status-violate">${i.getStatus()}</span>
                    </c:if>
                    <c:if test="${i.getStatus() != 'Violate'}">
                      ${i.getStatus()}
                    </c:if>
                  </td>

                  <td>
                    <a
                      href="${pageContext.request.contextPath}/detailsJP?action=details&idJP=${i.getJobPostingID()}"
                      class="btn-action"
                    >
                      <i class="fas fa-eye"></i>
                    </a>

                    <c:choose>
                      <c:when test="${i.getStatus() == 'Violate'}">
                        <span
                          class="btn-action edit-violate"
                          onclick="showEditWarning()"
                        >
                          <i class="fas fa-edit"></i>
                        </span>
                      </c:when>
                      <c:otherwise>
                        <a
                          href="${pageContext.request.contextPath}/updateJP?idJP=${i.getJobPostingID()}"
                          class="btn-action"
                        >
                          <i class="fas fa-edit"></i>
                        </a>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td>
                    <c:if test="${i.application.size() !=  0}">
                      <a
                        href="${pageContext.request.contextPath}/applicationSeekers?action=view&jobPostId=${i.getJobPostingID()}"
                        class="btn-action text-info"
                      >
                        <i class="fas fa-arrow-up"></i>
                      </a>
                    </c:if>
                    <c:if test="${i.application.size() ==  0}"> Not yet </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Error message if no job postings found -->
        <c:if test="${not empty requestScope.NoJP}">
          <div class="error-message">${requestScope.NoJP}</div>
        </c:if>

        <!-- Pagination controls -->
        <nav aria-label="Page navigation" class="footer-container">
          <ul class="pagination justify-content-center">
            <!-- Nút Previous để quay lại nhóm trang trước đó -->
            <c:if test="${currentPage > 1}">
              <li class="page-item">
                <a
                  class="page-link"
                  href="${pageContext.request.contextPath}/jobPost?page=${currentPage - 1}&sort=${sortField}&searchJP=${searchJP}"
                  aria-label="Previous"
                >
                  <span aria-hidden="true">&laquo; Previous</span>
                </a>
              </li>
            </c:if>

            <!-- Tính toán để chỉ hiển thị 5 trang tại một thời điểm -->
            <c:set
              var="startPage"
              value="${currentPage - 2 > 0 ? currentPage - 2 : 1}"
            />
            <c:set
              var="endPage"
              value="${startPage + 4 <= totalPages ? startPage + 4 : totalPages}"
            />

            <!-- Nút để quay lại nhóm trang trước (nếu có) -->
            <c:if test="${startPage > 1}">
              <li class="page-item">
                <a
                  class="page-link"
                  href="${pageContext.request.contextPath}/jobPost?page=${startPage - 1}&sort=${sortField}&searchJP=${searchJP}"
                  >...</a
                >
              </li>
            </c:if>

            <!-- Hiển thị các trang trong khoảng từ startPage đến endPage -->
            <c:forEach var="i" begin="${startPage}" end="${endPage}">
              <li
                class="page-item <c:if test='${i == currentPage}'>active</c:if>"
              >
                <a
                  class="page-link"
                  href="${pageContext.request.contextPath}/jobPost?page=${i}&sort=${sortField}&searchJP=${searchJP}"
                  >${i}</a
                >
              </li>
            </c:forEach>

            <!-- Nút để chuyển sang nhóm trang tiếp theo (nếu có) -->
            <c:if test="${endPage < totalPages}">
              <li class="page-item">
                <a
                  class="page-link"
                  href="${pageContext.request.contextPath}/jobPost?page=${endPage + 1}&sort=${sortField}&searchJP=${searchJP}"
                  >...</a
                >
              </li>
            </c:if>

            <!-- Nút Next để đi đến nhóm trang tiếp theo -->
            <c:if test="${currentPage < totalPages}">
              <li class="page-item">
                <a
                  class="page-link"
                  href="${pageContext.request.contextPath}/jobPost?page=${currentPage + 1}&sort=${sortField}&searchJP=${searchJP}"
                  aria-label="Next"
                >
                  <span aria-hidden="true">Next &raquo;</span>
                </a>
              </li>
            </c:if>
          </ul>
        </nav>
      </div>

      <!-- Include Footer -->
      <%@ include file="../recruiter/footer-re.jsp" %>
    </div>

    <script>
      function showEditWarning() {
        alert(
          "This Job Posting cannot be edited because it has a status of 'Violate'"
        );
      }
    </script>
  </body>
</html>
