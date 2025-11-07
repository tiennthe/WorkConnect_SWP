<%@ page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Interview Detail</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <style>
      .container {
        max-width: 90%;
        margin: auto;
      }
      .table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      .table thead th {
        background-color: #007b5e;
        color: #fff;
        text-align: center;
        padding: 15px;
        font-size: 16px;
        border: none;
      }
      .table-title {
        font-size: 24px;
        font-weight: bold;
        color: #007b5e;
        padding-top: 40px;
        margin-bottom: 20px;
        text-align: center;
      }
      .page-container {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
      }
      .job-posting-container {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
      }
      .content-wrapper {
        display: flex;
        flex-direction: column;
        min-height: 80vh;
      }
    </style>
  </head>
  <body>
    <div class="page-container d-flex flex-column min-vh-100">
      <%@ include file="../recruiter/sidebar-re.jsp" %> <%@ include
      file="../recruiter/header-re.jsp" %>
      <div class="job-posting-container flex-grow-1">
        <div class="container content-wrapper">
          <h2 class="table-title mt-4 mb-4">Interview Details</h2>

          <c:if test="${not empty error}"
            ><div class="alert alert-danger">${error}</div></c:if
          >
          <c:if test="${not empty success}">
            <c:choose>
              <c:when test="${success eq 'confirmed'}"
                ><div class="alert alert-success">
                  Interview confirmed successfully.
                </div></c:when
              >
              <c:when test="${success eq 'rescheduled'}"
                ><div class="alert alert-success">
                  Interview rescheduled successfully.
                </div></c:when
              >
              <c:otherwise
                ><div class="alert alert-success">${success}</div></c:otherwise
              >
            </c:choose>
          </c:if>

          <c:if test="${empty interview}"
            ><div class="alert alert-warning">Interview not found.</div></c:if
          >

          <c:if test="${not empty interview}">
            <div class="row">
              <div class="col-md-6">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title">Current Interview</h5>
                    <p><strong>ID:</strong> ${interview.id}</p>
                    <p>
                      <strong>Application ID:</strong>
                      ${interview.applicationID}
                    </p>
                    <p><strong>Schedule:</strong> ${interview.scheduleAt}</p>
                    <p>
                      <strong>Reason:</strong>
                      <c:out
                        value="${interview.reason != null ? interview.reason : '-'}"
                      />
                    </p>
                    <p><strong>Created By:</strong> <c:out value="${createdByName}"/></p>
                    <p>
                      <strong>Status:</strong>
                      <c:choose>
                        <c:when test="${interview.status == 0}"
                          ><span class="badge bg-info text-dark"
                            >Pending</span
                          ></c:when
                        >
                        <c:when test="${interview.status == 1}"
                          ><span class="badge bg-warning text-dark"
                            >Rescheduled</span
                          ></c:when
                        >
                        <c:when test="${interview.status == 2}"
                          ><span class="badge bg-success"
                            >Confirmed</span
                          ></c:when
                        >
                        <c:when test="${interview.status == 3}"
                          ><span class="badge bg-danger">Rejected</span></c:when
                        >
                      </c:choose>
                    </p>
                    <a
                      class="btn btn-secondary"
                      href="${pageContext.request.contextPath}/interviewsManagement"
                      >Back</a
                    >
                    <c:if
                      test="${interview.status != 2 && interview.status != 3 && interview.createdBy != interview.recruiterID}"
                    >
                      <form
                        action="${pageContext.request.contextPath}/interviewsManagement"
                        method="post"
                        class="d-inline"
                      >
                        <input type="hidden" name="action" value="confirm" />
                        <input
                          type="hidden"
                          name="id"
                          value="${interview.id}"
                        />
                        <button type="submit" class="btn btn-success">
                          Confirm
                        </button>
                      </form>
                      <button
                        class="btn btn-warning"
                        data-bs-toggle="modal"
                        data-bs-target="#resModal"
                      >
                        Reschedule
                      </button>
                    </c:if>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title">Interview History</h5>
                    <c:if test="${empty history}"
                      ><div class="text-muted">No history.</div></c:if
                    >
                    <c:if test="${not empty history}">
                      <table class="table">
                        <thead>
                          <tr>
                            <th>ID</th>
                            <th>Schedule</th>
                            <th>Status</th>
                            <th>Reason</th>
                            <th>Created By</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="h" items="${history}">
                            <tr>
                              <td>${h.id}</td>
                              <td>${h.scheduleAt}</td>
                              <td>
                                <c:choose>
                                  <c:when test="${h.status == 0}"
                                    ><span class="badge bg-info text-dark"
                                      >Pending</span
                                    ></c:when
                                  >
                                  <c:when test="${h.status == 1}"
                                    ><span class="badge bg-warning text-dark"
                                      >Rescheduled</span
                                    ></c:when
                                  >
                                  <c:when test="${h.status == 2}"
                                    ><span class="badge bg-success"
                                      >Confirmed</span
                                    ></c:when
                                  >
                                  <c:when test="${h.status == 3}"
                                    ><span class="badge bg-danger"
                                      >Rejected</span
                                    ></c:when
                                  >
                                </c:choose>
                              </td>
                              <td><c:out value="${h.reason}" /></td>
                              <td><c:out value="${createdByNameMap[h.id]}" /></td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </c:if>
                  </div>
                </div>
              </div>
            </div>
          </c:if>
        </div>
      </div>
      <%@ include file="../recruiter/footer-re.jsp" %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
