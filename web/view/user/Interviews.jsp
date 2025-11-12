<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Interviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <style>
      body { background-color: #f4f4f9; }
      h1 { font-size: 2.2rem; font-weight: bold; color: #333; margin: 25px 0; text-align: center; text-transform: uppercase; }
      thead th { background-color: #28a745; color: #fff; text-transform: uppercase; }
      .badge { padding: 6px 10px; font-size: 0.9rem; }
    </style>
  </head>
  <body>
    <jsp:include page="../common/user/header-user.jsp"></jsp:include>

    <div class="container mt-4 mb-5">
      <h1>My Interviews</h1>

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

      <c:if test="${empty interviews}">
        <div class="alert alert-info">You have no interviews yet.</div>
      </c:if>

      <c:if test="${not empty interviews}">
        <form action="interviews" method="get" class="mb-3">
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

        <table class="table table-bordered bg-white">
          <thead>
            <tr>
              <th>Job Title</th>
              <th>Schedule Date</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="iv" items="${interviews}">
              <tr>
                <td><c:out value="${jobPostingMap[iv.id]}"/></td>
                <td>${iv.scheduleAt}</td>
                <td>
                  <c:choose>
                    <c:when test="${iv.status == 0}"><span class="badge bg-info text-dark"><i class="fa fa-clock"></i> Pending</span></c:when>
                    <c:when test="${iv.status == 1}"><span class="badge bg-warning text-dark"><i class="fa fa-rotate"></i> Rescheduled</span></c:when>
                    <c:when test="${iv.status == 2}"><span class="badge bg-success"><i class="fa fa-check-circle"></i> Confirmed</span></c:when>
                    <c:when test="${iv.status == 3}"><span class="badge bg-danger"><i class="fa fa-times-circle"></i> Rejected</span></c:when>
                  </c:choose>
                </td>
                <td>
                  <a class="btn btn-info btn-sm" href="${pageContext.request.contextPath}/interviews?action=details&id=${iv.id}">
                    <i class="fa-solid fa-eye"></i> View
                  </a>

                  <c:if test="${iv.status != 2 && iv.status != 3 && iv.createdBy != iv.seekerID}">
                    <!-- Confirm -->
                    <form action="${pageContext.request.contextPath}/interviews" method="post" class="d-inline" data-loading="true">
                      <input type="hidden" name="action" value="confirm" />
                      <input type="hidden" name="id" value="${iv.id}" />
                      <input type="hidden" name="status" value="2" />
                      <button type="submit" class="btn btn-success btn-sm" data-loading-button data-loading-text="Confirming..."><i class="fa fa-check"></i> Confirm</button>
                    </form>

                    <!-- Reschedule trigger -->
                    <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#reschedule-${iv.id}">
                      <i class="fa fa-calendar"></i> Reschedule
                    </button>

                    <!-- Reject trigger -->
                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#reject-${iv.id}">
                      <i class="fa fa-times"></i> Reject
                    </button>
                  </c:if>
                </td>
              </tr>

              <!-- Reschedule Modal -->
              <div class="modal fade" id="reschedule-${iv.id}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title">Reschedule Interview</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/interviews" method="post" data-loading="true">
                      <div class="modal-body">
                        <div class="mb-3">
                          <label class="form-label">New date & time</label>
                          <input type="datetime-local" name="scheduleAt" class="form-control" required />
                        </div>
                        <div class="mb-3">
                          <label class="form-label">Reason</label>
                          <textarea name="reason" class="form-control" rows="3" placeholder="Explain the reason" required></textarea>
                        </div>
                        <input type="hidden" name="action" value="reschedule" />
                        <input type="hidden" name="id" value="${iv.id}" />
                        <input type="hidden" name="status" value="1" />
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-warning" data-loading-button data-loading-text="Scheduling...">Save</button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>

              <!-- Reject Modal -->
              <div class="modal fade" id="reject-${iv.id}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title">Reject Interview</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/interviews" method="post" data-loading="true">
                      <div class="modal-body">
                        <div class="mb-3">
                          <label class="form-label">Reason</label>
                          <textarea name="reason" class="form-control" rows="4" required></textarea>
                          <input type="hidden" name="action" value="reject" />
                          <input type="hidden" name="id" value="${iv.id}" />
                          <input type="hidden" name="status" value="3" />
                        </div>
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger" data-loading-button data-loading-text="Rejecting...">Confirm Reject</button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>

            </c:forEach>
          </tbody>
        </table>
        <!-- Pagination -->
        <nav aria-label="Page navigation" class="footer-container">
          <ul class="pagination justify-content-center">
            <c:if test="${currentPage > 1}">
              <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/interviews?page=${currentPage - 1}&status=${selectedStatus}" aria-label="Previous">
                  <span aria-hidden="true">&laquo; Previous</span>
                </a>
              </li>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
              <li class="page-item ${i == currentPage ? 'active' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/interviews?page=${i}&status=${selectedStatus}">${i}</a>
              </li>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
              <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/interviews?page=${currentPage + 1}&status=${selectedStatus}" aria-label="Next">
                  <span aria-hidden="true">Next &raquo;</span>
                </a>
              </li>
            </c:if>
          </ul>
        </nav>
      </c:if>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>
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
        function bounds() {
          const now = new Date();
          now.setSeconds(0,0);
          const max = new Date(now.getTime());
          max.setMonth(max.getMonth() + 1);
          return { now, max };
        }
        function clampRange(input) {
          const { now, max } = bounds();
          const minStr = toLocalDatetimeValue(now);
          const maxStr = toLocalDatetimeValue(max);
          input.setAttribute('min', minStr);
          input.setAttribute('max', maxStr);
          if (input.value) {
            const selected = new Date(input.value);
            if (selected < now) input.value = minStr;
            if (selected > max) input.value = maxStr;
          }
        }
        document.addEventListener('DOMContentLoaded', function () {
          const inputs = document.querySelectorAll('input[type="datetime-local"][name="scheduleAt"]');
          inputs.forEach(function (input) {
            clampRange(input);
            input.addEventListener('focus', function(){ clampRange(input); });
            input.addEventListener('input', function(){ clampRange(input); });
            if (input.form) {
              input.form.addEventListener('submit', function (e) {
                const { now, max } = bounds();
                const val = input.value ? new Date(input.value) : null;
                if (!val || val < now || val > max) {
                  e.preventDefault();
                  clampRange(input);
                  if (input.reportValidity) {
                    input.setCustomValidity('Please choose a date/time within the next month.');
                    input.reportValidity();
                    input.setCustomValidity('');
                  } else {
                    alert('Please choose a date/time within the next month.');
                  }
                }
              });
            }
          });
          if (window.bootstrap) {
            document.querySelectorAll('.modal').forEach(function (m) {
              m.addEventListener('shown.bs.modal', function () {
                m.querySelectorAll('input[type="datetime-local"][name="scheduleAt"]').forEach(clampRange);
              });
            });
          }
          function activateLoadingState(form, submitBtn) {
            if (!submitBtn) {
              return;
            }
            const buttons = form.querySelectorAll('button');
            buttons.forEach(function (btn) {
              if (btn !== submitBtn) {
                btn.disabled = true;
              }
            });
            if (!submitBtn.dataset.originalHtml) {
              submitBtn.dataset.originalHtml = submitBtn.innerHTML;
            }
            const spinner = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>';
            const loadingText = submitBtn.dataset.loadingText || 'Loading...';
            submitBtn.disabled = true;
            submitBtn.innerHTML = spinner + loadingText;
            const parent = form.parentElement;
            if (parent) {
              parent.querySelectorAll('button').forEach(function (btn) {
                if (btn.closest('form') !== form) {
                  btn.disabled = true;
                }
              });
            }
          }

          document.addEventListener('submit', function (event) {
            const form = event.target;
            if (!(form instanceof HTMLFormElement)) {
              return;
            }
            if (!form.matches('form[data-loading]')) {
              return;
            }
            if (event.defaultPrevented || form.dataset.loadingActive === 'true') {
              return;
            }
            const submitBtn =
              (event.submitter && event.submitter.hasAttribute('data-loading-button'))
                ? event.submitter
                : form.querySelector('[data-loading-button]');
            if (!submitBtn) {
              return;
            }
            form.dataset.loadingActive = 'true';
            activateLoadingState(form, submitBtn);
          });
        });
      })();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
  </html>
