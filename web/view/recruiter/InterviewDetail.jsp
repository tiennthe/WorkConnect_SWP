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
                    <p><strong>Schedule:</strong> ${interview.scheduleAt}</p>
                    <p>
                      <strong>Reason:</strong>
                      <c:out
                        value="${interview.reason != null ? interview.reason : '-'}"
                      />
                    </p>
                    <p>
                      <strong>Created By:</strong>
                      <c:out value="${createdByName}" />
                    </p>
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
                        data-loading="true"
                      >
                        <input type="hidden" name="action" value="confirm" />
                        <input
                          type="hidden"
                          name="id"
                          value="${interview.id}"
                        />
                        <button
                          type="submit"
                          class="btn btn-success"
                          data-loading-button
                          data-loading-text="Confirming..."
                        >
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
                      <table class="table table-striped align-middle">
                        <thead>
                          <tr>
                            <th>Schedule</th>
                            <th>Status</th>
                            <th>Reason</th>
                            <th>Created By</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="h" items="${history}">
                            <tr>
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
                              <td>
                                <c:out
                                  value="${empty h.reason ? '-' : h.reason}"
                                />
                              </td>
                              <td>
                                <c:out value="${createdByNameMap[h.id]}" />
                              </td>
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
    <!-- Reschedule Modal -->
    <div class="modal fade" id="resModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Reschedule Interview</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <form
            action="${pageContext.request.contextPath}/interviewsManagement"
            method="post"
            data-loading="true"
          >
            <div class="modal-body">
              <div class="mb-3">
                <label class="form-label">New date & time</label>
                <input
                  type="datetime-local"
                  name="scheduleAt"
                  class="form-control"
                  required
                />
              </div>
              <div class="mb-3">
                <label class="form-label">Reason</label>
                <textarea
                  name="reason"
                  class="form-control"
                  rows="3"
                  required
                ></textarea>
              </div>
              <input type="hidden" name="action" value="reschedule" />
              <input type="hidden" name="id" value="${interview.id}" />
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
              >
                Close
              </button>
              <button type="submit" class="btn btn-warning" data-loading-button data-loading-text="Scheduling...">
                Save
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <script>
      (function () {
        function pad(n) {
          return String(n).padStart(2, "0");
        }
        function toLocalDatetimeValue(date) {
          const d = new Date(date.getTime());
          d.setSeconds(0, 0);
          return [
            d.getFullYear(),
            "-",
            pad(d.getMonth() + 1),
            "-",
            pad(d.getDate()),
            "T",
            pad(d.getHours()),
            ":",
            pad(d.getMinutes()),
          ].join("");
        }
        function bounds() {
          const now = new Date();
          now.setSeconds(0, 0);
          const max = new Date(now.getTime());
          max.setMonth(max.getMonth() + 1);
          return { now, max };
        }
        function clampRange(input) {
          const { now, max } = bounds();
          const minStr = toLocalDatetimeValue(now);
          const maxStr = toLocalDatetimeValue(max);
          input.setAttribute("min", minStr);
          input.setAttribute("max", maxStr);
          if (input.value) {
            const selected = new Date(input.value);
            if (selected < now) input.value = minStr;
            if (selected > max) input.value = maxStr;
          }
        }
        document.addEventListener("DOMContentLoaded", function () {
          const inputs = document.querySelectorAll(
            'input[type="datetime-local"][name="scheduleAt"]'
          );
          inputs.forEach(function (input) {
            clampRange(input);
            input.addEventListener("focus", function () {
              clampRange(input);
            });
            input.addEventListener("input", function () {
              clampRange(input);
            });
            if (input.form) {
              input.form.addEventListener("submit", function (e) {
                const { now, max } = bounds();
                const val = input.value ? new Date(input.value) : null;
                if (!val || val < now || val > max) {
                  e.preventDefault();
                  clampRange(input);
                  if (input.reportValidity) {
                    input.setCustomValidity(
                      "Please choose a date/time within the next month."
                    );
                    input.reportValidity();
                    input.setCustomValidity("");
                  } else {
                    alert("Please choose a date/time within the next month.");
                  }
                }
              });
            }
          });
          if (window.bootstrap) {
            document.querySelectorAll(".modal").forEach(function (m) {
              m.addEventListener("shown.bs.modal", function () {
                m.querySelectorAll(
                  'input[type="datetime-local"][name="scheduleAt"]'
                ).forEach(clampRange);
              });
            });
          }
          const loadingForms = document.querySelectorAll("form[data-loading]");
          loadingForms.forEach(function (form) {
            const submitBtn = form.querySelector("[data-loading-button]");
            if (!submitBtn) {
              return;
            }
            form.addEventListener("submit", function (e) {
              if (e.defaultPrevented) {
                return;
              }
              const buttons = form.querySelectorAll("button");
              buttons.forEach(function (btn) {
                if (btn !== submitBtn) {
                  btn.disabled = true;
                }
              });
              if (!submitBtn.dataset.originalHtml) {
                submitBtn.dataset.originalHtml = submitBtn.innerHTML;
              }
              const spinner =
                '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>';
              const loadingText = submitBtn.dataset.loadingText || "Loading...";
              submitBtn.disabled = true;
              submitBtn.innerHTML = spinner + loadingText;
              const parent = form.parentElement;
              if (parent) {
                parent.querySelectorAll("button").forEach(function (btn) {
                  if (btn.closest("form") !== form) {
                    btn.disabled = true;
                  }
                });
              }
            });
          });
        });
      })();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
