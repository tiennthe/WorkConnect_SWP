<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Recruiter Dashboard</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                background-color: #f8f9fa;
                font-size: 16px;
            }
            /* Main content next to the sidebar */
            .main-content {
                margin-left: 260px;
                padding: 20px;
                min-height: 100vh;
            }

            /* Main content next to the sidebar */
            .main-content {
                margin-left: 260px; /* Keeps content away from the sidebar */
                padding: 80px 20px 20px; /* Adjust top padding for the fixed header */
                min-height: 100vh;
            }
            /* Dashboard styling */
            .top-metrics {
                display: flex;
                justify-content: space-between;
                margin-bottom: 30px;
            }

            .metric-box {
                flex: 1;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                margin-right: 20px;
                text-align: center;
                box-shadow: 0 4px 8px rgba(0,0,0,0.05);
                transition: transform 0.2s;
            }

            .metric-box:last-child {
                margin-right: 0;
            }

            .metric-box:hover {
                transform: translateY(-5px);
            }

            .chart-container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.05);
                width: 80%;
                max-width: 800px;
                margin: 0 auto;
            }

            .recent-postings {
                display: flex;
                justify-content: space-between;
                gap: 20px;
            }

            .table-container, .chart-container {
                flex: 1;
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            table thead th {
                background-color: #007bff;
                color: white;
                padding: 10px;
                text-align: center;
            }

            table tbody td {
                text-align: center;
                padding: 10px;
                border: 1px solid #ddd;
            }

            /* Page Title */
            .page-title {
                margin-top: -78px;
                font-size: 22px;
                font-weight: bold;
                color: #34495e;
                margin-bottom: 30px;
            }
            @media (max-width: 768px) {
                .top-metrics {
                    flex-direction: column;
                }

                .metric-box {
                    margin-bottom: 20px;
                    margin-right: 0;
                }

                .nav-links {
                    flex-direction: column;
                }
            }

        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <%@ include file="../recruiter/sidebar-re.jsp" %>
        <!-- Main Content -->
        <div class="main-content">
            <!-- Header with Bootstrap Navbar -->
            <%@ include file="../recruiter/header-re.jsp" %>
            <h1 class="page-title">Dashboard Overview</h1>

            <div class="row">
                <!-- Cards Section -->
                <div class="col-lg-3 col-md-6">
                    <div class="card text-center mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Posted Jobs</h5>
                            <h3 class="text-primary">${listSize.size()}</h3>
                            <p>Jobs posted this month</p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card text-center mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Offending post</h5>
                            <h3 class="text-info">${totalViolateJPForRecruiter}</h3>
                            <p>Total number of job postings</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card text-center mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Pending candidate</h5>
                            <h3 class="text-success">${totalPendingApplications}</h3>
                            <p>Total number of candidates</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card text-center mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Successful candidate</h5>
                            <h3 class="text-warning">${totalAgreeForRecruiter}</h3>
                            <p>Total number of candidates</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">

            </div>
            <!-- Top 5 Recent Job Postings and Chart section -->
            <div class="recent-postings">
                <!-- Recent Job Postings Table -->
                <div class="table-container">
                    <h5>Top 5 Recent Job Postings</h5>
                    <table>
                        <thead>
                            <tr>
                                <th>Job Title</th>
                                <th>Posted Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="i" items="${listTop5}">
                                <tr>
                                    <td>${i.getTitle()}</td>
                                    <td><fmt:formatDate value="${i.getPostedDate()}" pattern="dd/MM/yyyy"/></td>
                                </tr>
                            </c:forEach>                      
                        </tbody>
                    </table>
                </div>

                <!-- Chart Section -->
                <div class="chart-container">
                    <canvas id="applicantChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="../recruiter/footer-re.jsp" %>

        <!-- Chart.js Script to Generate Chart -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            var ctx = document.getElementById('applicantChart').getContext('2d');
            var applicantChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Quarter 1', 'Quarter 2', 'Quarter 3', 'Quarter 4'],
                    datasets: [{
                            label: 'Number of job postings per quarter',
                            data: [${q1}, ${q2}, ${q3}, ${q4}],
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>

        <!-- Script to trigger modal when Profile is clicked -->
        <script>
            document.querySelectorAll('.sidebar a').forEach(link => {
                link.addEventListener('click', function (e) {
                    if (this.getAttribute('href') === '#') {
                        e.preventDefault();
                        var profileModal = new bootstrap.Modal(document.getElementById('profileModal'));
                        profileModal.show();
                    }
                });
            });
        </script>
    </body>
</html