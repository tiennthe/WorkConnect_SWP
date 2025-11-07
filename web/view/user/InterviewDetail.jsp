<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Interview Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <style>
      body { background-color: #f4f4f9; }
      h1 { font-size: 2.5rem; font-weight: bold; color: #333; margin: 30px 0; text-transform: uppercase; text-align:center; }
      .section-header { font-size: 1.2rem; color: #28a745; margin-bottom: 10px; border-bottom: 2px solid #28a745; padding-bottom: 6px; font-weight: bold; }
      .info-section { background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 20px; border-radius: 8px; margin-bottom: 20px; }
      thead th { background-color: #28a745; color: #fff; }
    </style>
  </head>
  <body>
    <jsp:include page="../common/user/header-user.jsp"></jsp:include>

    <div class="container mb-5 mt-4">
      <h1>Interview Details</h1>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <c:choose>
          <c:when test="${success eq 'confirmed'}">
            <div class="alert alert-success">Interview confirmed successfully.</div>
          </c:when>
          <c:when test="${success eq 'rescheduled'}">
            <div class="alert alert-success">Interview rescheduled successfully.</div>
          </c:when>
          <c:when test="${success eq 'rejected'}">
            <div class="alert alert-success">Interview rejected successfully.</div>
          </c:when>
          <c:otherwise>
            <div class="alert alert-success">${success}</div>
          </c:otherwise>
        </c:choose>
      </c:if>

      <c:if test="${empty interview}">
        <div class="alert alert-warning">Interview not found.</div>
      </c:if>

      <c:if test="${not empty interview}">
        <div class="row">
          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">Current Interview</h2>
              <p><strong>ID:</strong> ${interview.id}</p>
              <p><strong>Application ID:</strong> ${interview.applicationID}</p>
              <p><strong>Schedule Date:</strong> ${interview.scheduleAt}</p>
              <p><strong>Reason:</strong> <c:out value="${interview.reason != null ? interview.reason : '-'}"/></p>
              <p>
                <strong>Status:</strong>
                <c:choose>
                  <c:when test="${interview.status == 0}"><span class="badge bg-info text-dark"><i class="fa fa-clock"></i> Pending</span></c:when>
                  <c:when test="${interview.status == 1}"><span class="badge bg-warning text-dark"><i class="fa fa-rotate"></i> Rescheduled</span></c:when>
                  <c:when test="${interview.status == 2}"><span class="badge bg-success"><i class="fa fa-check-circle"></i> Confirmed</span></c:when>
                  <c:when test="${interview.status == 3}"><span class="badge bg-danger"><i class="fa fa-times-circle"></i> Rejected</span></c:when>
                </c:choose>
              </p>

              <div class="mt-3">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/interviews"><i class="fa fa-arrow-left"></i> Back</a>
                <c:if test="${interview.status != 2 && interview.status != 3}">
                  <form action="${pageContext.request.contextPath}/interviews" method="post" class="d-inline">
                    <input type="hidden" name="action" value="confirm" />
                    <input type="hidden" name="id" value="${interview.id}" />
                    <input type="hidden" name="status" value="2" />
                    <button type="submit" class="btn btn-success"><i class="fa fa-check"></i> Confirm</button>
                  </form>
                  <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#rescheduleModal"><i class="fa fa-calendar"></i> Reschedule</button>
                  <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal"><i class="fa fa-times"></i> Reject</button>
                </c:if>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="info-section">
              <h2 class="section-header">Interview History</h2>
              <c:if test="${empty history}"><div class="text-muted">No history.</div></c:if>
              <c:if test="${not empty history}">
                <table class="table table-bordered bg-white">
                  <thead><tr><th>ID</th><th>Schedule</th><th>Status</th></tr></thead>
                  <tbody>
                    <c:forEach var="h" items="${history}">
                      <tr>
                        <td>${h.id}</td>
                        <td>${h.scheduleAt}</td>
                        <td>
                          <c:choose>
                            <c:when test="${h.status == 0}"><span class="badge bg-info text-dark">Pending</span></c:when>
                            <c:when test="${h.status == 1}"><span class="badge bg-warning text-dark">Rescheduled</span></c:when>
                            <c:when test="${h.status == 2}"><span class="badge bg-success">Confirmed</span></c:when>
                            <c:when test="${h.status == 3}"><span class="badge bg-danger">Rejected</span></c:when>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:if>
            </div>
          </div>
        </div>
      </c:if>
    </div>

    <!-- Reschedule Modal -->
    <div class="modal fade" id="rescheduleModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Reschedule Interview</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/interviews" method="post">
            <div class="modal-body">
              <div class="mb-3">
                <label class="form-label">New date & time</label>
                <input type="datetime-local" name="scheduleAt" class="form-control" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Reason</label>
                <textarea name="reason" class="form-control" rows="4" placeholder="Explain the reason for rescheduling" required></textarea>
              </div>
              <input type="hidden" name="action" value="reschedule" />
              <input type="hidden" name="id" value="${interview.id}" />
              <input type="hidden" name="status" value="1" />
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-warning">Save</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Reject Interview</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/interviews" method="post">
            <div class="modal-body">
              <div class="mb-3">
                <label class="form-label">Reason</label>
                <textarea name="reason" class="form-control" rows="4" required></textarea>
                <input type="hidden" name="action" value="reject" />
                <input type="hidden" name="id" value="${interview.id}" />
                <input type="hidden" name="status" value="3" />
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-danger">Confirm Reject</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
  </html>
