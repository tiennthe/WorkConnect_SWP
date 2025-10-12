<%-- Document : adminHome.jsp Created on : Oct 13, 2025, 12:24:03 AM Author :
sonmthe28 --%> <%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="java.util.Map"%> <%@page import="java.util.HashMap"%> <%@page
import="java.util.List"%> <%@page import="java.util.Map.Entry"%> <%@page
import="model.Account"%> <%@page import="dao.AccountDAO"%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Admin - Home</title>
    <!--css-->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <style>
      /* Common styling for all dashboard cards */
      /* Cập nhật styling cho card */
      .dashboard-card {
        padding: 20px; /* Giảm padding */
        border-radius: 6px;
        box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
        color: white;
      }

      .dashboard-card h3 {
        font-size: 1.25rem; /* Giảm kích thước chữ của tiêu đề */
        margin-bottom: 5px;
      }

      .dashboard-card p {
        font-size: 1rem; /* Giảm kích thước chữ của nội dung */
        margin: 0;
      }

      .dashboard-card i {
        font-size: 1.5rem; /* Giảm kích thước của icon */
        margin-bottom: 5px;
      }

      /* Unique colors for each type of card */
      .bg-seekers {
        background-color: #007bff; /* Blue for Seekers */
      }

      .bg-recruiters {
        background-color: #ffc107; /* Yellow for Recruiters */
      }

      .bg-companies {
        background-color: #17a2b8; /* Teal for Companies */
      }
      /* CSS cho tiêu đề biểu đồ với nền xanh lá cây */
      .chart-title-green {
        background-color: #28a745; /* Màu nền xanh lá cây */
        color: #fff; /* Màu chữ trắng */
        padding: 15px;
        text-align: center;
        font-size: 1.5rem;
        font-weight: bold;
        margin: 0; /* Loại bỏ khoảng trống trên và dưới */
        border-radius: 5px 5px 0 0; /* Bo tròn góc trên */
      }

      /* Cập nhật cho thẻ card để loại bỏ khoảng trắng và mở rộng phần biểu đồ */
      .chart-container {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-top: 0; /* Loại bỏ khoảng cách phía trên */
      }

      .chart-container .card-body {
        padding: 0; /* Loại bỏ padding mặc định trong thẻ card-body */
      }
    </style>
  </head>
  <body>
    <!-- header area -->
    <jsp:include page="../common/admin/header-admin.jsp"></jsp:include>
    <!-- header area end -->
    <!-- content area -->
    <!-- Thay thế phần content area hiện tại với đoạn code sau -->
    <div class="row g-0">
      <!-- Thêm g-0 để remove gutters -->
      <div class="col-md-2">
        <!--Side bar-->
        <jsp:include page="../common/admin/sidebar-admin.jsp"></jsp:include>
        <!--side bar-end-->
      </div>

      <div class="col-md-10 ps-0">
        <!-- Thêm ps-0 để remove padding bên trái -->
        <div class="dashboard__right">
          <div class="dash__content">
            <div class="dash__overview">
              <!-- Dashboard Stats Overview -->
              <div class="container-fluid py-4">
                <!-- Đổi container thành container-fluid và thêm padding top/bottom -->
                <div class="row">
                  <!-- Total Seekers -->
                  <div class="col-md-4 mb-4">
                    <div class="dashboard-card bg-seekers">
                      <i class="fas fa-user fa-2x text-white mb-2"></i>
                      <h3>Total Seekers</h3>
                      <p id="total-seekers">${totalSeeker}</p>
                      <p class="text-white">
                        Active:
                        <span id="active-seekers">${totalSeekerActive}</span>
                      </p>
                      <p class="text-white">
                        Inactive:
                        <span id="inactive-seekers"
                          >${totalSeekerInactive}</span
                        >
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- all plugin js -->
    <jsp:include page="../common/admin/common-js-admin.jsp"></jsp:include>
    <!-- Thêm thư viện Chart.js nếu chưa có -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Thêm ChartDataLabels plugin -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
  </body>
  <script
    src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
    crossorigin="anonymous"
  ></script>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
    integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    crossorigin="anonymous"
  ></script>
</html>
