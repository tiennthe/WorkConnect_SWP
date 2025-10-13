<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<footer>
    <p>Copyright &copy; 2025 All Rights Reserved by Group 2 - SWP391</p>
    <a href="#">Privacy Policy</a>
    <a href="#">Terms of Service</a>
</footer>

<style>
    /* Main container to push the footer down */
    .job-posting-container {
        flex: 1;
        padding: 20px;
        margin-left: 260px; /* Adjust for sidebar */
        background-color: #f5f5f5;
        min-height: calc(100vh - 80px); /* Ensures content stretches to push footer */
    }

    /* Footer styling */
    footer {
        background-color: #389354;
        color: white;
        text-align: center;
        padding: 10px 0; /* Reduced padding for smaller footer */
        width: calc(100% - 260px);
        margin-left: 260px;
        flex-shrink: 0; /* Ensures footer stays at the bottom when content is short */
    }

    footer a {
        color: white;
        text-decoration: none;
        margin: 0 10px;
    }

    footer a:hover {
        text-decoration: underline;
    }
</style>