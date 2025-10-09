package controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

import constant.CommonConst;
import dao.AccountDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Account;
import utils.Email;
import validate.Validation;

@MultipartConfig
@WebServlet(name = "AuthenticationController", urlPatterns = {"/authen"})
public class AuthenticationController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();
    Validation valid = new Validation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get action parameter
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url;

        // Handle GET requests based on the action
        switch (action) {
            case "login":
                url = "view/authen/login.jsp";
                break;
            case "log-out":
                logOut(request, response);
                return;
            case "change-password":
                url = "view/authen/changePassword.jsp";
                break;
            case "sign-up":
                url = "view/authen/register.jsp";
                break;
            case "view-profile":
                url = "view/user/userProfile.jsp";
                break;
            case "edit-profile":
                url = "view/user/editUserProfile.jsp";
                break;
            default:
                url = "view/authen/login.jsp";
        }

        // Forward to the appropriate page
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get action parameter
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";
        String url = null;

        // Handle POST requests based on the action
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "sign-up":
            {
                try {
                    url = signUp(request, response);
                } catch (MessagingException ex) {
                    Logger.getLogger(AuthenticationController.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            }
            case "verify-otp":  // Handle OTP verification
                url = verifyOtp(request, response);
                break;
            case "edit-profile":
                url = editProfile(request, response);
                break;
            case "forgot-password":
                try {
                    url = sendResetOtp(request, response); // Handle OTP for password reset
                } catch (MessagingException ex) {
                    Logger.getLogger(AuthenticationController.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            case "verify-reset-otp": // Handle OTP verification for password reset
                url = verifyResetOtp(request, response);
                break;
            case "reset-password":
                url = resetPassword(request, response);
                break;
            case "log-out":
                logOut(request, response);
                return;
            case "change-password":
                url = changePassword(request, response);
                break;
            case "deactivate-account":  // Thêm hành động để xóa tài khoản
                url = deactivateAccount(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                return;
        }
        // Forward to the appropriate page
        request.getRequestDispatcher(url).forward(request, response);
    }
    
    private String deactivateAccount(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tài khoản từ session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

        if (account != null) {
            // Lấy mật khẩu mà người dùng đã nhập từ request
            String currentPassword = request.getParameter("currentPassword");

            // Kiểm tra xem mật khẩu nhập vào có trùng với mật khẩu của tài khoản hiện tại không
            if (account.getPassword().equals(currentPassword)) {  // So sánh mật khẩu đã lưu với mật khẩu nhập vào
                // Nếu mật khẩu đúng, xóa tài khoản khỏi cơ sở dữ liệu
                accountDAO.deactiveAccount(account);

                // Chuyển hướng đến trang đăng nhập sau khi vô hiệu hoá thành công
                request.setAttribute("message", "Your account has deactivated successfully.");
                return "view/authen/login.jsp";
            } else {
                // Nếu mật khẩu không đúng, yêu cầu người dùng nhập lại và lưu trạng thái tab
                request.setAttribute("error", "Incorrect password. Please try again.");
                request.setAttribute("activeTab", "#deactivate-account"); // Đặt tab Deactivate là tab đang mở

                if (account.getRoleId() == 3) {
                    return "view/user/userProfile.jsp"; // Trở lại trang yêu cầu nhập lại mật khẩu
                }
                if (account.getRoleId() == 2) {
                    return "view/recruiter/deactiveAccountRecruiter.jsp"; // Trở lại trang yêu cầu nhập lại mật khẩu
                }
            }
        } else {
            // Nếu không có tài khoản trong session, quay lại trang chủ
            return "home";
        }
        return null;
    }
    
    private String changePassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String currPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String retypePass = request.getParameter("retypePassword");

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);
        String url = null;

        int status = 0;

        if (!currPass.equals(acc.getPassword()) && !newPass.equals(retypePass)) {
            status = 3;
        } else if (!currPass.equals(acc.getPassword())) {
            status = 1;
        } else if (!newPass.equals(retypePass)) {
            status = 2;
        } else if (!valid.checkPassword(newPass)) {
            status = 4;
        } else {
            status = 5;
        }

        switch (status) {
            case 1:
                request.setAttribute("changePWfail", "Incorrect current password.");
                if (acc.getRoleId() == 2) {
                    return "view/recruiter/changePW-re.jsp";
                }
                if (acc.getRoleId() == 1 || acc.getRoleId() == 3) {
                    return "view/authen/changePassword.jsp";
                }
                break;
            case 2:
                request.setAttribute("changePWfail", "New password and retype password do not match.");
                if (acc.getRoleId() == 2) {
                    return "view/recruiter/changePW-re.jsp";
                }
                if (acc.getRoleId() == 1 || acc.getRoleId() == 3) {
                    return "view/authen/changePassword.jsp";
                }
                break;
            case 3:
                request.setAttribute("changePWfail", "Both current password is incorrect and new password does not match.");
                if (acc.getRoleId() == 2) {
                    return "view/recruiter/changePW-re.jsp";
                }
                if (acc.getRoleId() == 1 || acc.getRoleId() == 3) {
                    return "view/authen/changePassword.jsp";
                }
                break;
            case 4:
                request.setAttribute("changePWfail", "The new password must be 8-20 characters long, and include at "
                        + "least one letter and one special character.");
                if (acc.getRoleId() == 2) {
                    return "view/recruiter/changePW-re.jsp";
                }
                if (acc.getRoleId() == 1 || acc.getRoleId() == 3) {
                    return "view/authen/changePassword.jsp";
                }
                break;
            case 5:
                acc.setPassword(newPass);
                accountDAO.updatePasswordByUsername(acc);
                request.setAttribute("changePWsuccess", "Password Changed Successfully. Please Login Again.");
                url = "view/authen/login.jsp";
                break;
        }
        return url;
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = null;

        // Get login credentials from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        // Create cookies for username, password, and remember me
        Cookie cUser = new Cookie("cu", username);
        Cookie cPass = new Cookie("cp", password);
        Cookie cRem = new Cookie("cr", remember);

        // Set cookie max age (persistent for 1 day if "remember me" is checked)
        if (remember != null) {
            cUser.setMaxAge(60 * 60 * 24);
            cPass.setMaxAge(60 * 60 * 24);
            cRem.setMaxAge(60 * 60 * 24);
        } else {
            cUser.setMaxAge(0);
            cPass.setMaxAge(0);
            cRem.setMaxAge(0);
        }

        // Add cookies to the response
        response.addCookie(cUser);
        response.addCookie(cPass);
        response.addCookie(cRem);

        // Check credentials in the database
        Account account = new Account();
        account.setUsername(username);
        account.setPassword(password);
        Account accFound = accountDAO.findUserByUsernameAndPassword(account);

        HttpSession session = request.getSession();

        if (accFound == null) {
            // If no account is found, show the incorrect username/password message
            request.setAttribute("messLogin", "Username or Password Incorrect!");
            url = "view/authen/login.jsp";
        } else if (!accFound.isIsActive()) {
            // If the account is found but inactive
            request.setAttribute("messLogin", "Your account is deactivated. Please contact Admin by email to resolve this.");
            url = "view/authen/login.jsp";
        } else {
            // If the account is found and active
            session.setAttribute(CommonConst.SESSION_ACCOUNT, accFound);
            session.setMaxInactiveInterval(60 * 60 * 24);

            // Handle based on role
            switch (accFound.getRoleId()) {
                case 1: // Admin role
                    url = "dashboard";
                    break;
                case 3: // Job seeker role
                    url = "HomeSeeker";
                    break;
                default:
                    // If role is not recognized, redirect to login with error
                    request.setAttribute("messLogin", "Invalid user role. Please contact support.");
                    url = "view/authen/login.jsp";
                    break;
            }
        }
        return url;
    }

    private String signUp(HttpServletRequest request, HttpServletResponse response) throws MessagingException, ServletException, IOException {
        String url;

        // Get sign-up information
        int roleId = Integer.parseInt(request.getParameter("role"));
        String lastname = request.getParameter("lastname");
        String firstname = request.getParameter("firstname");
        String gender = request.getParameter("gender");
        Date dob = Date.valueOf(request.getParameter("dob"));
        int yearofbirth = dob.toLocalDate().getYear();
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        // set sign-up information to request to save the data in the form
        request.setAttribute("role", roleId);
        request.setAttribute("lname", lastname);
        request.setAttribute("fname", firstname);
        request.setAttribute("gender", gender);
        request.setAttribute("dob", dob);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("password", password);

        // Create account object
        Account account = new Account();
        account.setRoleId(roleId);
        account.setLastName(lastname);
        account.setFirstName(firstname);
        switch (gender) {
            case "male":
                account.setGender(true);
                break;
            case "female":
                account.setGender(false);
                break;
            default:
                account.setGender(true);
        }
        account.setDob(dob);
        account.setUsername(username);
        account.setEmail(email);
        account.setPassword(password);

        // Check if username or email already exists
        boolean isExistUsername = accountDAO.checkUsernameExist(account);
        boolean isExistUserEmail = accountDAO.checkUserEmailExist(account);

        // Handle validation errors
        // Initialize error messages
        Map<String, String> errorMessages = new HashMap<>();

        if (!valid.checkName(firstname)) {
            errorMessages.put("errorFname", "Your first name is invalid!!");
        }
        if (!valid.checkYearOfBirth(yearofbirth)) {
            errorMessages.put("errorDob", "You must be between 17 and 50 years old!");
        }
        if (!valid.checkName(lastname)) {
            errorMessages.put("errorLname", "Your last name is invalid!!");
        }
        if (!valid.checkUserName(username)) {
            errorMessages.put("errorUsername", "Your username must not contain special characters");
        }
        if (isExistUsername) {
            errorMessages.put("errorUsernameExits", "Username exists!!");
        }
        if (isExistUserEmail) {
            errorMessages.put("errorEmail", "Email exists!!");
        }
        if (!valid.checkPassword(password)) {
            errorMessages.put("errorPassword", "Password must follow the convention!!");
        }

        // Check if there are any errors
        if (!errorMessages.isEmpty()) {
            // Set error messages in request attributes
            for (Map.Entry<String, String> entry : errorMessages.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
            url = "view/authen/register.jsp";
        } else {
            // Generate OTP and send email
            int sixDigitNumber = 100000 + new Random().nextInt(900000);
            Email.sendEmail(email, "OTP Register Account", "Hello, your OTP code is: " + sixDigitNumber);

            // Store OTP and account info in session
            HttpSession session = request.getSession();
            session.setAttribute("OTPCode", sixDigitNumber);
            session.setAttribute("userRegister", account);

            // Forward to OTP confirmation page
            return "view/authen/confirmOTP.jsp";  // Forward to OTP page after registration
        }
        return url;
    }

    private String verifyOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Retrieve the OTP entered by the user and the OTP stored in session
        try {
            int enteredOtp = Integer.parseInt(request.getParameter("otp"));
            int sessionOtp = (int) session.getAttribute("OTPCode");
            // parse sang string và so sanh hai chuỗi
            String inputOtp = Integer.toString(enteredOtp).trim();
            String storedOtp = Integer.toString(sessionOtp).trim();
            if (inputOtp.equals(storedOtp)) {
                // OTP is correct, complete the registration process
                Account account = (Account) session.getAttribute("userRegister");
                accountDAO.insert(account);  // Save the user account to the database

                // Clear the OTP from the session
                session.removeAttribute("OTPCode");
                session.removeAttribute("userRegister");

                // Redirect to the login page
                return "view/authen/login.jsp";
            } else {
                // OTP is incorrect, set an error message and stay on the OTP page
                request.setAttribute("error", "Invalid OTP. Please try again.");
                return "view/authen/ConfirmOTP.jsp";
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            return "view/authen/confirmOTP.jsp";
        }
    }

    private String logOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/home");
        return null;
    }

    private String editProfile(HttpServletRequest request, HttpServletResponse response) {
        String url = "";
        try {
            // Lấy các thông tin từ form
            String lastName = request.getParameter("lastName");
            String firstName = request.getParameter("firstName");
            String phone = request.getParameter("phone");
            Date dob = Date.valueOf(request.getParameter("date"));
            int yearofbirth = dob.toLocalDate().getYear();
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String email = request.getParameter("email");

            // Lấy ảnh avatar từ form (nếu có)
            Part part = request.getPart("avatar");
            String imagePath = null;

            // Nếu có ảnh mới thì xử lý tải lên
            if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                // Đường dẫn lưu ảnh
                String path = request.getServletContext().getRealPath("/images");
                File dir = new File(path);

                // Kiểm tra xem thư mục có tồn tại không, nếu không thì tạo mới
                if (!dir.exists()) {
                    dir.mkdirs(); // Tạo thư mục nếu chưa tồn tại
                }

                // Tạo file ảnh trong thư mục images
                File image = new File(dir, part.getSubmittedFileName());

                // Ghi file ảnh vào đường dẫn
                part.write(image.getAbsolutePath());

                // Lấy đường dẫn tương đối của ảnh để lưu vào database
                imagePath = request.getContextPath() + "/images/" + image.getName();
            }

            // Lấy session và đối tượng Account hiện tại
            HttpSession session = request.getSession();
            Account accountEdit = (Account) session.getAttribute(CommonConst.SESSION_ACCOUNT);

            // Cập nhật thông tin trong đối tượng Account
            accountEdit.setLastName(lastName);
            accountEdit.setFirstName(firstName);
            accountEdit.setPhone(phone);
            accountEdit.setDob(dob);
            accountEdit.setGender(gender.equalsIgnoreCase("male"));
            accountEdit.setAddress(address);
            accountEdit.setEmail(email);

            // Nếu có ảnh mới, cập nhật ảnh avatar, nếu không, giữ lại ảnh hiện tại
            if (imagePath != null) {
                accountEdit.setAvatar(imagePath);
            }

            // Kiểm tra điều kiện hợp lệ cho ngày sinh và số điện thoại
            List<String> errorsMessage = new ArrayList<>();
            if (!valid.checkYearOfBirth(yearofbirth)) {
                errorsMessage.add("You must be between 17 and 50 years old!");
            }
            if (!valid.CheckPhoneNumber(phone)) {
                errorsMessage.add("Phone number is not valid!");
            }
            if (!valid.checkName(lastName)) {
                errorsMessage.add("Last name is invalid!");
            }
            if (!valid.checkName(firstName)) {
                errorsMessage.add("First name is invalid!");
            }

            // Nếu có lỗi, đặt thông báo lỗi vào request và quay lại trang chỉnh sửa hồ sơ
            if (!errorsMessage.isEmpty()) {
                if (accountEdit.getRoleId() == 2) {
                    request.setAttribute("errorsMessage", errorsMessage);
                    url = "view/recruiter/editRecruiterProfile.jsp";
                }
                if (accountEdit.getRoleId() == 3) {
                    request.setAttribute("errorsMessage", errorsMessage);
                    url = "view/user/editUserProfile.jsp";
                }

            } else {
                accountDAO.updateAccount(accountEdit);
                request.setAttribute("successMessage", "Profile updated successfully.");
                if (accountEdit.getRoleId() == 2) {
                    url = "view/recruiter/editRecruiterProfile.jsp";
                }
                if (accountEdit.getRoleId() == 3) {
                    url = "view/user/editUserProfile.jsp";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            url = "view/user/editUserProfile.jsp";
        }
        return url;
    }

    private String sendResetOtp(HttpServletRequest request, HttpServletResponse response) throws MessagingException, ServletException, IOException {
        String url;

        // Get user email from the request
        String email = request.getParameter("email");
        Account account = new Account();
        account.setEmail(email);

        // Check if the email exists in the database
        boolean isExistUserEmail = accountDAO.checkUserEmailExist(account); // Pass the email to check

        if (!isExistUserEmail) {
            // Email does not exist, set error message and stay on the forgot password page
            request.setAttribute("error", "Email does not exist. Please try again.");
            url = "view/authen/forgotPassword.jsp"; // Stay on forgot password page
        } else {
            // Generate a 6-digit OTP and send it to the user's email
            int sixDigitNumber = 100000 + new Random().nextInt(900000); //SWT: Bugs
            Email.sendEmail(email, "OTP Reset Password", "Your OTP code is: " + sixDigitNumber);

            // Store OTP and account info in the session
            HttpSession session = request.getSession();
            session.setAttribute("ResetOTPCode", sixDigitNumber);
            session.setAttribute("userResetEmail", email); // Store email for verification later

            // Forward to OTP confirmation page for password reset
            url = "view/authen/forgotPasswordOTP.jsp"; // OTP page
        }

        return url;
    }

    private String verifyResetOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int enteredOtp = Integer.parseInt(request.getParameter("otp"));
            int sessionOtp = (int) session.getAttribute("ResetOTPCode");
//            parse sang string và so sanh hai chuỗi
            String inputOtp = Integer.toString(enteredOtp).trim();
            String storedOtp = Integer.toString(sessionOtp).trim();
            if (inputOtp.equals(storedOtp)) {
                // OTP is correct, forward to the reset password page
                return "view/authen/resetPassword.jsp";
            } else {
                // OTP is incorrect, set an error message and stay on the OTP page
                request.setAttribute("error", "Invalid OTP. Please try again.");
                return "view/authen/forgotPasswordOTP.jsp";
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            return "view/authen/forgotPasswordOTP.jsp";
        }
    }

    // Đặt lại mật khẩu
    private String resetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy email từ session (đã lưu trong quá trình gửi OTP)
        String email = (String) session.getAttribute("userResetEmail");

        // Lấy mật khẩu và mật khẩu xác nhận từ request
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            // Mật khẩu và xác nhận mật khẩu không khớp
            request.setAttribute("error", "Passwords do not match. Please try again.");
            return "view/authen/resetPassword.jsp";
        } else if (!valid.checkPassword(newPassword)) {
            request.setAttribute("error", "The new password must be 8-20 characters long, and include at "
                    + "least one letter and one special character.");
            return "view/authen/resetPassword.jsp";
        } else {
            // Get user email from the request
            Account account = new Account();
            account.setEmail(email);

            // Check if the email exists in the database
            boolean isExistUserEmail = accountDAO.checkUserEmailExist(account); // Pass the email to check

            if (isExistUserEmail) {
                // Mã hóa mật khẩu mới nếu cần (tuỳ thuộc vào cơ chế mã hóa của bạn)
                account.setPassword(newPassword);

                // Cập nhật mật khẩu vào cơ sở dữ liệu
                accountDAO.updatePasswordbyEmail(account);

                // Xóa thông tin liên quan đến reset password trong session
                session.removeAttribute("userResetEmail");
                session.removeAttribute("ResetOTPCode");

                // Chuyển hướng đến trang đăng nhập với thông báo thành công
                request.setAttribute("message", "Password successfully updated! Please login with your new password.");
                return "view/authen/login.jsp";
            } else {
                // Không tìm thấy tài khoản, báo lỗi
                request.setAttribute("error", "User not found. Please try again.");
                return "view/authen/resetPassword.jsp";
            }
        }
    }
}
