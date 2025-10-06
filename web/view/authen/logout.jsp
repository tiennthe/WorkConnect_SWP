<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Logout</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
            background: #EEEEEE;
            font-family: 'Arial', sans-serif;
        }

        .logout-card {
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .logout-card:hover {
            transform: translateY(-5px);
        }

        .logout-logo {
            width: 150px;
            margin-bottom: 20px;
        }

        .logout-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .logout-buttons {
            margin-top: 30px;
        }

        .btn-custom {
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 16px;
        }

        .btn-secondary-custom {
            background-color: #6c757d;
            color: white;
            border: none;
            transition: background-color 0.3s ease;
        }

        .btn-secondary-custom:hover {
            background-color: #5a6268;
        }

        .btn-primary-custom {
            background-color: #007bff;
            color: white;
            border: none;
            transition: background-color 0.3s ease;
        }

        .btn-primary-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
    <div class="logout-card text-center" style="width: 90%; max-width: 400px;">
        <img class="logout-logo" src="${pageContext.request.contextPath}/assets/img/logo/header__one.svg" alt="logo">
        <h2 class="logout-title">Are you sure you want to log out?</h2>
        <div class="logout-buttons">
            <button class="btn btn-secondary btn-custom btn-secondary-custom mr-3" onclick="cancelLogout()">Cancel</button>
            <button class="btn btn-primary btn-custom btn-primary-custom" id="confirmLogout">Log Out</button>
        </div>
    </div>

    <!-- Bootstrap JS, jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Handle the "Log Out" button click
        document.getElementById("confirmLogout").addEventListener("click", function() {
            window.location.href = "${pageContext.request.contextPath}/authen?action=log-out";
        });

        // Handle the "Cancel" button click
        function cancelLogout() {
            window.history.back();
        }
    </script>
</body>
</html>
