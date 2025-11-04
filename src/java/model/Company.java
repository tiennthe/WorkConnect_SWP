/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Company {
    private int id;
    private String name;
    private String description;
    private String location;
    private boolean verificationStatus;
    private int accountId;
    private String businessCode;
    private String BusinessLicenseImage;
    private String province;
    private String ward;
    private int provinceId;
    private int wardId;
    
    public Company() {
    }

    public Company(int id, String name, String description, String location, boolean verificationStatus, int accountId, String businessCode, String BusinessLicenseImage, String province, String ward, int provinceId, int wardId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.location = location;
        this.verificationStatus = verificationStatus;
        this.accountId = accountId;
        this.businessCode = businessCode;
        this.BusinessLicenseImage = BusinessLicenseImage;
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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public boolean isVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(boolean verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getBusinessCode() {
        return businessCode;
    }

    public void setBusinessCode(String businessCode) {
        this.businessCode = businessCode;
    }

    public String getBusinessLicenseImage() {
        return BusinessLicenseImage;
    }

    public void setBusinessLicenseImage(String BusinessLicenseImage) {
        this.BusinessLicenseImage = BusinessLicenseImage;
    }

}