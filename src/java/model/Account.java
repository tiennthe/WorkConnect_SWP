package model;

import java.sql.Date;

public class Account {

    private int id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String firstName;
    private String lastName;
    private Date dob;
    private String address;
    private String avatar;
    private int roleId;
    private boolean isActive;
    private Date createAt;
    private Date updatedAt;
    private boolean gender;
    private String province;
    private String ward;
    private int provinceId;
    private int wardId;

   
    public Account() {
    }

    public Account(int id, String username, String password, String email, String phone, String firstName, String lastName, Date dob, String address, String avatar, int roleId, boolean isActive, Date createAt, Date updatedAt, boolean gender, String province, String ward, int provinceId, int wardId) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.address = address;
        this.avatar = avatar;
        this.roleId = roleId;
        this.isActive = isActive;
        this.createAt = createAt;
        this.updatedAt = updatedAt;
        this.gender = gender;
        this.province = province;
        this.ward = ward;
        this.provinceId = provinceId;
        this.wardId = wardId;
    }

    public String getWard(){
        return ward;
    }
    
    public String getProvince(){
        return province;
    }

    public int getProvinceId() {
        return provinceId;
    }

    public int getWardId() {
        return wardId;
    }

    public void setProvinceId(int provinceId) {
        this.provinceId = provinceId;
    }

    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date creatAt) {
        this.createAt = creatAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updateAt) {
        this.updatedAt = updateAt;
    }
    public String getFullName() {
        return lastName + " " + firstName;
    } 

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }
    
}
