<%-- 
    Document   : changePassword
    Created on : Oct 9, 2025, 2:11:20 AM
    Author     : sonmthe28
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Change Password</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7fc;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                padding: 20px;
            }

            .password-container {
                display: flex;
                justify-content: center;
                align-items: center;
                width: 100%;
            }

            .password-box {
                background-color: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                width: 400px; /* Thu nhỏ khung lại */
                text-align: center;
            }

            h2 {
                margin-bottom: 40px;
                font-size: 32px; /* Tăng kích thước chữ của "Change Password" */
                color: #28a745;
            }

            .input-group {
                margin-bottom: 30px;
                text-align: left;
                position: relative;
            }

            label {
                display: block;
                font-size: 16px;
                font-weight: bold; /* In đậm các label */
                margin-bottom: 10px;
            }

            input[type="password"], input[type="text"] {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
            }

            .toggle-password {
                position: absolute;
                right: 10px;
                top: 40px;
                cursor: pointer;
                color: #007bff;
                font-size: 14px;
            }

            .password-note {
                font-size: 14px;
                color: #737477;
                margin-top: 5px;
                font-style: italic;
                display: none; /* Ẩn ghi chú mặc định */
            }

            .button-group {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }

            .btn {
                padding: 12px 30px; /* Thu nhỏ nút */
                border: none;
                border-radius: 5px;
                text-decoration: none;
                font-size: 16px; /* Thu nhỏ chữ */
            }

            .update-btn {
                background-color: #28a745;
                color: white;
            }

            .update-btn:hover {
                background-color: #218838;
            }

            .cancel-btn {
                background-color: #6c757d;
                color: white;
                text-decoration: none;
                line-height: 20px;
            }

            .cancel-btn:hover {
                background-color: #5a6268;
            }

            .error-message {
                color: #f08080;
                background-color: #ffecec;
                border: 1px solid #f5c6cb;
                padding: 20px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 20px;
                font-weight: bold;
            }

        </style>
    </head>
    <body>
        <div class="password-container">
            <div class="password-box">
                <h2>Change Password</h2>
                <form action="${pageContext.request.contextPath}/authen?action=change-password" method="POST" onsubmit="return validateForm()">
                    <div class="input-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('currentPassword', this)">Show</span>
                    </div>
                    <div class="input-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('newPassword', this)">Show</span>
                        <p id="passwordNote" class="password-note">Passwords must be 8 to 20 characters long and include numbers, letters and special characters.</p>
                    </div>
                    <div class="input-group">
                        <label for="retypePassword">Retype Password</label>
                        <input type="password" id="retypePassword" name="retypePassword" required onkeydown="preventSpaces(event)">
                        <span class="toggle-password" onclick="togglePasswordVisibility('retypePassword', this)">Show</span>
                    </div>
                    <c:if test="${not empty requestScope.changePWfail}">
                        <div class="error-message">${requestScope.changePWfail}</div>
                    </c:if>
                    <div class="button-group">
                        <button type="submit" class="btn update-btn">Update</button>
                        <a class="btn cancel-btn" onclick="cancelChangePassword()">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- JavaScript -->
        <script>
            // Function to show or hide the password
            function togglePasswordVisibility(id, element) {
                var input = document.getElementById(id);
                if (input.type === "password") {
                    input.type = "text";
                    element.textContent = "Hide";
                } else {
                    input.type = "password";
                    element.textContent = "Show";
                }
            }

            // Function to cancel password change and redirect to appropriate page
            function cancelChangePassword() {
                var role = ${sessionScope.account.getRoleId()};
                if (role === 1) {
                    window.location.href = "${pageContext.request.contextPath}/view/admin/adminHome.jsp";
                } else if (role === 2) {
                    window.location.href = "${pageContext.request.contextPath}/view/recruiter/recruiterHome.jsp";
                } else if (role === 3) {
                    window.location.href = "${pageContext.request.contextPath}/HomeSeeker";
                }
            }

            // Event listeners to show/hide password note
            var newPasswordInput = document.getElementById('newPassword');
            var passwordNote = document.getElementById('passwordNote');

            newPasswordInput.addEventListener('focus', function() {
                passwordNote.style.display = 'block'; // Hiện ghi chú khi người dùng nhấp vào trường
            });

            newPasswordInput.addEventListener('blur', function() {
                passwordNote.style.display = 'none'; // Ẩn ghi chú khi người dùng nhấp ra ngoài trường
            });

            // Prevent entering spaces in password fields
            function preventSpaces(event) {
                if (event.key === " ") {
                    event.preventDefault();
                    alert("Passwords cannot contain spaces.");
                }
            }

            // Validate form before submission to ensure no spaces in passwords
            function validateForm() {
                var currentPassword = document.getElementById("currentPassword").value;
                var newPassword = document.getElementById("newPassword").value;
                var retypePassword = document.getElementById("retypePassword").value;

                if (currentPassword.includes(" ") || newPassword.includes(" ") || retypePassword.includes(" ")) {
                    alert("Passwords cannot contain spaces.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>
