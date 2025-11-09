<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Interviews Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <style>
      .container { max-width: 90%; margin: auto; }
      .table { width: 100%; border-collapse: separate; border-spacing: 0; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
      .table thead th { background-color: #007b5e; color: #fff; text-align: center; padding: 15px; font-size: 16px; border: none; }
      .table tbody td { padding: 12px; text-align: center; font-size: 15px; color: #333; border-top: 1px solid #e0e0e0; border-left: 1px solid #e0e0e0; }
      .table tbody tr td:last-child { border-right: 1px solid #e0e0e0; }
      .table tbody tr:nth-child(odd) { background-color: #f9f9f9; }
      .table tbody tr:hover { background-color: #e6f2f1; }
      .badge { padding: 8px 12px; font-size: 14px; border-radius: 12px; color: #fff; }
      .badge.bg-warning { background-color: #ffc107; color: #000; }
      .badge.bg-success { background-color: #28a745; }
      .badge.bg-danger { background-color: #dc3545; }
      .badge.bg-secondary { background-color: #6c757d; }
      .badge.bg-dark { background-color: #343a40; }
      .btn-action { margin-right: 8px; color: #007b5e; font-size: 16px; text-decoration: none; transition: color .3s ease; }
      .btn-action:hover { color: #005f46; }
      .btn-success { background-color: #28a745; color: #fff; padding: 6px 12px; font-size: 14px; border: none; border-radius: 5px; transition: background-color .3s ease; }
      .btn-success:hover { background-color: #218838; }
      .btn-action i { margin-right: 5px; }
      .page-container { display: flex; flex-direction: column; min-height: 100vh; }
      .job-posting-container { display: flex; flex-direction: column; flex-grow: 1; }
      .content-wrapper { display: flex; flex-direction: column; min-height: 80vh; }
      .table-responsive { flex-grow: 1; }
      .pagination-container { margin-top: auto; padding-bottom: 20px; }
      .table-title { font-size: 24px; font-weight: bold; color: #007b5e; padding-top: 40px; margin-bottom: 20px; text-align: center; }
    </style>
  </head>
  <body>
    <div class="page-container d-flex flex-column min-vh-100">
      <%@ include file="../recruiter/sidebar-re.jsp" %>
      <%@ include file="../recruiter/header-re.jsp" %>
      <div class="job-posting-container flex-grow-1">
        <div class="container content-wrapper">
          <h2 class="table-title mt-4 mb-4">Interviews Management</h2>

      <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
      <c:if test="${not empty success}">
        <c:choose>
          <c:when test="${success eq 'confirmed'}"><div class="alert alert-success">Interview confirmed successfully.</div></c:when>
          <c:when test="${success eq 'rescheduled'}"><div class="alert alert-success">Interview rescheduled successfully.</div></c:when>
          <c:otherwise><div class="alert alert-success">${success}</div></c:otherwise>
        </c:choose>
      </c:if>

      <form action="${pageContext.request.contextPath}/interviewsManagement" method="get" class="mb-3">
        <div class="row g-2">
          <div class="col-12 col-md-4">
            <select name="status" class="form-select" onchange="this.form.submit()">
              <option value="" ${empty selectedStatus ? 'selected' : ''}>All Status</option>
              <option value="0" ${selectedStatus == '0' ? 'selected' : ''}>Pending</option>
              <option value="1" ${selectedStatus == '1' ? 'selected' : ''}>Rescheduled</option>
              <option value="2" ${selectedStatus == '2' ? 'selected' : ''}>Confirmed</option>
              <option value="3" ${selectedStatus == '3' ? 'selected' : ''}>Rejected</option>
            </select>
          </div>
        </div>
      </form>

      <c:if test="${empty interviews}">
        <div class="alert alert-info">No interviews to display.</div>
      </c:if>

      <c:if test="${not empty interviews}">
        <div class="table-responsive">
        <table class="table">
          <thead>
            <tr>
              <th>Application</th>
              <th>Schedule</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="iv" items="${interviews}">
              <tr>
                <td><c:out value="${jobPostingMap[iv.id]}"/></td>
                <td>${iv.scheduleAt}</td>
                <td>
                  <c:choose>
                    <c:when test="${iv.status == 0}"><span class="badge bg-info text-dark">Pending</span></c:when>
                    <c:when test="${iv.status == 1}"><span class="badge bg-warning text-dark">Rescheduled</span></c:when>
                    <c:when test="${iv.status == 2}"><span class="badge bg-success">Confirmed</span></c:when>
                    <c:when test="${iv.status == 3}"><span class="badge bg-danger">Rejected</span></c:when>
                  </c:choose>
                </td>
                <td>
                  <a class="btn btn-info btn-sm" href="${pageContext.request.contextPath}/interviewsManagement?action=details&id=${iv.id}">
                    <i class="fa-solid fa-eye"></i> View
                  </a>
                  <c:if test="${iv.status != 2 && iv.status != 3 && iv.createdBy != iv.recruiterID}">
                    <form action="${pageContext.request.contextPath}/interviewsManagement" method="post" class="d-inline">
                      <input type="hidden" name="action" value="confirm" />
                      <input type="hidden" name="id" value="${iv.id}" />
                      <button type="submit" class="btn btn-success btn-sm"><i class="fa fa-check"></i> Confirm</button>
                    </form>
                    <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#res-${iv.id}"><i class="fa fa-calendar"></i> Reschedule</button>
                  </c:if>
                </td>
              </tr>

              <!-- Reschedule Modal -->
              <div class="modal fade" id="res-${iv.id}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title">Reschedule Interview</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/interviewsManagement" method="post">
                      <div class="modal-body">
                        <div class="mb-3">
                          <label class="form-label">New date & time</label>
                          <input type="datetime-local" name="scheduleAt" class="form-control" required />
                        </div>
                        <div class="mb-3">
                          <label class="form-label">Reason</label>
                          <textarea name="reason" class="form-control" rows="3" required></textarea>
                        </div>
                        <input type="hidden" name="action" value="reschedule" />
                        <input type="hidden" name="id" value="${iv.id}" />
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-warning">Save</button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </c:forEach>
          </tbody>
        </table>
        </div>

        <nav aria-label="Page navigation" class="pagination-container mt-auto">
          <ul class="pagination justify-content-center">
            <c:if test="${currentPage > 1}">
              <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/interviewsManagement?page=${currentPage - 1}&status=${selectedStatus}" aria-label="Previous">
                  <span aria-hidden="true">&laquo; Previous</span>
                </a>
              </li>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
              <li class="page-item ${i == currentPage ? 'active' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/interviewsManagement?page=${i}&status=${selectedStatus}">${i}</a>
              </li>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
              <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/interviewsManagement?page=${currentPage + 1}&status=${selectedStatus}" aria-label="Next">
                  <span aria-hidden="true">Next &raquo;</span>
                </a>
              </li>
            </c:if>
          </ul>
        </nav>
      </c:if>
        </div>
      </div>
      <%@ include file="../recruiter/footer-re.jsp" %>
    </div>
    <script>
      (function () {
        function pad(n) { return String(n).padStart(2, '0'); }
        function toLocalDatetimeValue(date) {
          const d = new Date(date.getTime());
          d.setSeconds(0, 0);
          return [
            d.getFullYear(), '-', pad(d.getMonth() + 1), '-', pad(d.getDate()),
            'T', pad(d.getHours()), ':', pad(d.getMinutes())
          ].join('');
        }
        function clampPast(input) {
          const now = new Date();
          const min = toLocalDatetimeValue(now);
          input.setAttribute('min', min);
          if (input.value) {
            const selected = new Date(input.value);
            if (selected < now) input.value = min;
          }
        }
        document.addEventListener('DOMContentLoaded', function () {
          const inputs = document.querySelectorAll('input[type="datetime-local"][name="scheduleAt"]');
          inputs.forEach(function (input) {
            clampPast(input);
            input.addEventListener('focus', function(){ clampPast(input); });
            input.addEventListener('input', function(){ clampPast(input); });
            if (input.form) {
              input.form.addEventListener('submit', function (e) {
                const now = new Date();
                const val = input.value ? new Date(input.value) : null;
                if (!val || val < now) {
                  e.preventDefault();
                  clampPast(input);
                  if (input.reportValidity) {
                    input.setCustomValidity('Please choose a future date and time.');
                    input.reportValidity();
                    input.setCustomValidity('');
                  } else {
                    alert('Please choose a future date and time.');
                  }
                }
              });
            }
          });
          if (window.bootstrap) {
            document.querySelectorAll('.modal').forEach(function (m) {
              m.addEventListener('shown.bs.modal', function () {
                m.querySelectorAll('input[type="datetime-local"][name="scheduleAt"]').forEach(clampPast);
              });
            });
          }
        });
      })();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
  </html>
