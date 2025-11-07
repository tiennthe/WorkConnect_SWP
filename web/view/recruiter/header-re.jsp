<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header>
    <!-- Navigation Links -->
    <div class="nav-links">
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/home">Home</a>
        </div>
        <div class="nav-item">
            <a href="#">About</a>
        </div>
        <div class="nav-item">
            <a href="#">Services</a>
        </div>
        <div class="nav-item">
            <a href="#">Contact</a>
        </div>
    </div>

    <!-- JobPath Logo/Text -->
    <div class="jobpath-logo">
        <img class="logo__image" src="${pageContext.request.contextPath}/assets/img/logo/logo.png" width="160" height="40" alt="logo">
    </div>
</header>

<style>
    /* Header styling */
    header {
        background-color: #389354;
        padding: 15px 30px;
        color: white;
        display: flex;
        justify-content: space-between; /* Space between navigation links and JobPath */
        align-items: center;
        position: fixed;
        top: 0;
        left: 260px; /* Leaves room for the sidebar */
        width: calc(100% - 260px); /* Adjust the header width to avoid sidebar overlap */
        height: 70px; /* Fixed height for the header */
        z-index: 1000;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Adds a slight shadow to separate header */
    }

    /* Sidebar styling */
    .sidebar {
        height: 100vh;
        width: 260px;
        position: fixed;
        top: 0;
        left: 0;
        background-color: #fff;
        padding-top: 20px;
        overflow-y: auto;
        border-right: 1px solid #ddd;
    }

    /* Center the Navigation Links */
    .nav-links {
        display: flex;
        justify-content: center;
        flex-grow: 1;
    }

    .nav-item {
        margin: 0 20px;
    }

    .nav-item a {
        color: white;
        text-decoration: none;
    }

    .nav-item a:hover {
        color: #f8f9fa;
    }

    /* JobPath Logo/Text */
    .jobpath-logo {
        font-size: 24px;
        font-weight: bold;
    }

    .green-text {
        color: #28a745; /* Green color for the word 'Path' */
    }

    /* Add margin-top to main content to avoid overlapping header */
    .main-content {
        margin-top: 90px; /* Adjust this value if needed based on header height */
    }

    /* General page styling for conflict-free content */
    body {
        margin: 0;
        padding: 0;
    }
</style>

<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
