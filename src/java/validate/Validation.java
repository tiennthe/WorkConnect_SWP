package java.validate;

import java.time.Year;

public class Validation {

    public boolean checkPassword(String password) {
        // Biểu thức chính quy kiểm tra mật khẩu:
        // - Phải có ít nhất 1 chữ cái hoa
        // - Phải có ít nhất 1 ký tự đặc biệt
        // - Phải có từ 8 đến 20 ký tự
        String passwordRegex = "^(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_.+=-]).{8,20}$";

        return password.matches(passwordRegex);
    }

    // Kiểm tra tên (không chứa số và cho phép ký tự có dấu tiếng Việt)
    public boolean checkName(String name) {
        // Biểu thức chính quy cho tên: không chứa số, cho phép ký tự dấu tiếng Việt
        String nameRegex = "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯăÁÂĐÊÔƠàáâãèéêìíòóôõùúăđĩũơƯưẠ-ỹ\\s]+$";
        return name.matches(nameRegex);
    }

    // Kiểm tra năm sinh, người dùng phải từ 17 đến 50 tuổi
    public boolean checkYearOfBirth(int yearOfBirth) {
        int currentYear = Year.now().getValue(); // Lấy năm hiện tại
        int age = currentYear - yearOfBirth;

        // Người dùng phải từ 17 đến 50 tuổi
        return age >= 17 && age <= 50;
    }

    // Hàm kiểm tra số điện thoại
    public boolean CheckPhoneNumber(String phone) {
        // Biểu thức chính quy để kiểm tra số điện thoại
        String regex = "^(\\+\\d{1,3})?\\d{10}$";
        return phone.matches(regex);
    }

    public boolean checkUserName(String username) {
        // Biểu thức chính quy: chỉ cho phép chữ cái, số và dấu gạch dưới
        String regex = "^[a-zA-Z0-9_]+$";

        // Kiểm tra username có khớp với biểu thức chính quy không
        return username.matches(regex);
    }

    public boolean checkNoSpaces(String input) {
        // Sử dụng regex để kiểm tra nếu chuỗi không chứa khoảng trắng
        return input.matches("\\S+");
    }

    // Method to check if the input has at least 30 characters
    public boolean checkAtLeast30Chars(String input) {
        // Check if input meets the minimum length requirement
        if (input.length() >= 30) {
            return true; // Input is valid
        } else {
            return false; // Input is not valid
        }
    }

    // Hàm kiểm tra mật khẩu hiện tại và mật khẩu mới có khác nhau hay không
    public boolean isPasswordDifferent(String currentPassword, String newPassword) {
        if (currentPassword == null || newPassword == null) {
            throw new IllegalArgumentException("Passwords cannot be null");
        }

        // Kiểm tra mật khẩu mới có khác mật khẩu hiện tại hay không
        return !currentPassword.equals(newPassword);
    }

    public boolean checkCode(String businessCode) {
        String regex = "^\\d{5}$";
        return businessCode.matches(regex);
    }

}
