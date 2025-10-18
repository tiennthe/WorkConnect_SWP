<%-- Document : adminHome.jsp 
     Created on : Oct 13, 2025, 12:24:03 AM 
     Author : sonmthe28 
--%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="model.JobPostings"%>
<%@page import="model.Account"%>
<%@page import="model.Recruiters"%>
<%@page import="dao.RecruitersDAO"%>
<%@page import="dao.AccountDAO"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Admin - Home</title>
        <!--css-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Common styling for all dashboard cards */
            /* Cập nhật styling cho card */
            .dashboard-card {
                padding: 20px; /* Giảm padding */
                border-radius: 6px;
                box-shadow: 0 3px 6px rgba(0,0,0,0.1);
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
            <div class="row g-0"> <!-- Thêm g-0 để remove gutters -->
                <div class="col-md-2">
                    <!--Side bar-->
                <jsp:include page="../common/admin/sidebar-admin.jsp"></jsp:include>
                    <!--side bar-end-->
                </div>

                <div class="col-md-10 ps-0"> <!-- Thêm ps-0 để remove padding bên trái -->
                    <div class="dashboard__right">
                        <div class="dash__content">
                            <div class="dash__overview">
                                <!-- Dashboard Stats Overview -->
                                <div class="container-fluid py-4"> <!-- Đổi container thành container-fluid và thêm padding top/bottom -->
                                    <div class="row">
                                        <!-- Total Seekers -->
                                        <div class="col-md-4 mb-4">
                                            <div class="dashboard-card bg-seekers">
                                                <i class="fas fa-user fa-2x text-white mb-2"></i>
                                                <h3>Total Seekers</h3>
                                                <p id="total-seekers">${totalSeeker}</p>
                                            <p class="text-white">Active: <span id="active-seekers">${totalSeekerActive}</span></p>
                                            <p class="text-white">Inactive: <span id="inactive-seekers">${totalSeekerInactive}</span></p>
                                        </div>
                                    </div>

                                    <!-- Total Recruiters -->
                                    <div class="col-md-4 mb-4">
                                        <div class="dashboard-card bg-recruiters">
                                            <i class="fas fa-user-tie fa-2x text-white mb-2"></i>
                                            <h3>Total Recruiters</h3>
                                            <p id="total-recruiters">${totalRecruiter}</p>
                                            <p class="text-white">Active: <span id="active-recruiters">${totalRecruiterActive}</span></p>
                                            <p class="text-white">Inactive: <span id="inactive-recruiters">${totalRecruiterInactive}</span></p>
                                        </div>
                                    </div>

                                    <!-- Total Companies -->
                                    <div class="col-md-4 mb-4">
                                        <div class="dashboard-card bg-companies">
                                            <i class="fas fa-building fa-2x text-white mb-2"></i>
                                            <h3>Total Companies</h3>
                                            <p id="total-companies">${totalCompany}</p>
                                            <p class="text-white">Active: <span id="active-companies">${totalCompanyActive}</span></p>
                                            <p class="text-white">Inactive: <span id="inactive-companies">${totalCompanyInactive}</span></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Chart Section for Top 5 Recruiters by Job Posting Frequency -->
                <div class="container-fluid py-10">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card chart-container">
                                <h4 class="chart-title-green">Top 5 Employers with the Most Posts Chart</h4>
                                <div class="card-body">
                                    <canvas id="jobPostingTopRecruitersChart"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4"> <!-- Phần không gian cho biểu đồ hình tròn -->
                            <div class="card chart-container">
                                <h4 class="chart-title-green">Job Posting Status Chart</h4>
                                <div class="card-body">
                                    <canvas id="jobPostingStatusChart"></canvas>
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
            <script>
                // Khởi tạo một đối tượng để lưu dữ liệu top 5 recruiter
                const topRecruitersData = {
            <% 
                Map<Integer, Integer> recruiterPostCount = (Map<Integer, Integer>) request.getAttribute("recruiterPostCount");
                Recruiters recruiter = new Recruiters();
                RecruitersDAO recruiterDao = new RecruitersDAO();
                Account account = new Account();
                AccountDAO accDao = new AccountDAO();
                if (recruiterPostCount != null) {
                    int count = 0;
                    for (Map.Entry<Integer, Integer> entry : recruiterPostCount.entrySet()) {
                        int recruiterId = entry.getKey();
                        //lay ve doi tuong recruiter theo id
                        recruiter = recruiterDao.findById(String.valueOf(recruiterId));
                        //lay ve account tu recruiter
                        account = accDao.findUserById(recruiter.getAccountID());
                        int postCount = entry.getValue();

                        // Xuất đối tượng JSON cho từng recruiter
                        out.print("\"" + account.getFullName() + "\": " + postCount);
                        if (count < recruiterPostCount.size() - 1) {
                            out.print(", ");
                        }
                        count++;
                    }
                }
            %>
                };

                // Tách labels (tên nhà tuyển dụng) và data (số lượng job postings) từ dữ liệu thực
                const labelsTopRecruiters = Object.keys(topRecruitersData);
                const dataTopRecruiters = Object.values(topRecruitersData);

                // Khởi tạo biểu đồ cho Top 5 Recruiters
                const ctxTopRecruiters = document.getElementById('jobPostingTopRecruitersChart').getContext('2d');
                new Chart(ctxTopRecruiters, {
                    type: 'bar',
                    data: {
                        labels: labelsTopRecruiters,
                        datasets: [{
                                label: 'Number of job postings',
                                data: dataTopRecruiters,
                                backgroundColor: 'rgba(153, 102, 255, 0.5)',
                                borderColor: 'rgba(153, 102, 255, 1)',
                                borderWidth: 1,
                                // Thêm thuộc tính barThickness để điều chỉnh chiều rộng cột
                                barThickness: 30, // Điều chỉnh giá trị này để thu hẹp chiều rộng cột
                                maxBarThickness: 50 // Giới hạn tối đa chiều rộng cột
                            }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Number of job postings'
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Recruiter'
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                position: 'top'
                            },
                            title: {
                                display: true,
                                text: 'Top 5 Employers with the Most Posts'
                            }
                        }
                    }
                });

        </script>
        <script>
            // Khởi tạo biểu đồ trạng thái job posting với ChartDataLabels để hiển thị phần trăm
            const jobPostingStatusData = {
            <% 
               Map<String, Integer> jobPostingStatusData = (Map<String, Integer>) request.getAttribute("jobPostingStatusData");
               if (jobPostingStatusData != null) {
                   int count = 0;
                   for (Map.Entry<String, Integer> entry : jobPostingStatusData.entrySet()) {
                       String status = entry.getKey();
                       int value = entry.getValue();
                       out.print("\"" + status + "\": " + value);
                       if (count < jobPostingStatusData.size() - 1) {
                           out.print(", ");
                       }
                       count++;
                   }
               }
            %>
            };

            const ctxJobPostingStatus = document.getElementById('jobPostingStatusChart').getContext('2d');
            new Chart(ctxJobPostingStatus, {
                type: 'pie',
                data: {
                    labels: Object.keys(jobPostingStatusData), // Tên trạng thái
                    datasets: [{
                            data: Object.values(jobPostingStatusData), // Số lượng cho mỗi trạng thái
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.5)', // Màu cho Closed
                                'rgba(255, 206, 86, 0.5)', // Màu cho Violate
                                'rgba(75, 192, 192, 0.5)'  // Màu cho Open
                            ],
                            borderColor: [
                                'rgba(255, 99, 132, 1)', // Đường viền cho Closed
                                'rgba(255, 206, 86, 1)', // Đường viền cho Violate
                                'rgba(75, 192, 192, 1)'    // Đường viền cho Open
                            ],
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top'
                        },
                        title: {
                            display: true,
                            text: 'Job Posting Status'
                        },
                        // Sử dụng plugin datalabels để hiển thị phần trăm
                        datalabels: {
                            color: '#fff',
                            formatter: (value, ctx) => {
                                let sum = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                let percentage = (value * 100 / sum).toFixed(2) + "%";
                                return percentage;
                            },
                            font: {
                                weight: 'bold'
                            }
                        }
                    }
                },
                plugins: [ChartDataLabels] // Kích hoạt plugin ChartDataLabels
            });
        </script>



    </body>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</html>