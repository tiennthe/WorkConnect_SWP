<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Sidebar -->
<div class="sidebar">
    <!-- User Info Section (Avatar & Name at the top) -->
    <div class="user-info">
        <c:if test="${empty sessionScope.account.getAvatar()}">
            <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="rounded-circle avatar-img">
        </c:if>
        <c:if test="${!empty sessionScope.account.getAvatar()}">
            <img src="${sessionScope.account.getAvatar()}" alt="User Avatar" class="avatar-img">
        </c:if>
        <div class="user-name">
            <span>${sessionScope.account.getFullName()}</span>
        </div>
    </div>

    <!-- Navigation Links -->
    <a href="${pageContext.request.contextPath}/Dashboard">
        <i class="fa-solid fa-home"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/view/recruiter/viewRecruiterProfile.jsp">
        <i class="fa-duotone fa-solid fa-address-card"></i> Profile
    </a>
    <a href="${pageContext.request.contextPath}/jobPost">
        <i class="fa-solid fa-list"></i> Job Posting
    </a>
    <a href="${pageContext.request.contextPath}/company?action=create">
        <i class="fa-solid fa-building me"></i> Create Company
    </a>
    <a href="${pageContext.request.contextPath}/company?action=edit">
        <i class="fas fa-pencil-alt me"></i> Edit Company
    </a>
    <a href="${pageContext.request.contextPath}/view/recruiter/changePW-re.jsp"><i class="fas fa-lock"></i> Change Password</a>
    <a href="${pageContext.request.contextPath}/view/recruiter/deactiveAccountRecruiter.jsp"><i class="fa-solid fa-eraser"></i> Deactive Account</a>

    <a href="${pageContext.request.contextPath}/view/authen/logout.jsp" style="color: red;">
        <i class="fas fa-sign-out-alt" style="color: red;"></i> Log Out
    </a>
</div>

<!-- Include styles -->
<header>
    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
        />
</header>

<style>
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
        font-size: 22px;
    }

    /* Remove JobPath brand section */
    /* User Info Section */
    .user-info {
        text-align: center;
        margin-bottom: 20px;
        margin-top: 20px; /* Ensure it aligns with the top of the sidebar */
    }

    .user-info .avatar-img {
        width: 60px; /* Reduced size for smaller avatar */
        height: 60px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: 10px;
    }

    .user-info .user-name {
        font-weight: bold;
        color: #333;
    }

    /* Navigation Links */
    .sidebar a {
        padding: 15px 20px;
        text-decoration: none;
        font-size: 16px;
        color: #333;
        display: flex;
        align-items: center;
    }

    .sidebar a i {
        margin-right: 15px;
        font-size: 15px;
        display: inline-block;
    }

    .sidebar a:hover {
        background-color: #f0f0f0;
    }

    /* Account Actions */
    .account-actions {
        margin-top: 20px;
        padding: 0 20px;
    }

    .account-actions a {
        padding: 10px 0;
        display: block;
        font-size: 16px;
        text-decoration: none;
        color: #333;
        display: flex;
        align-items: center;
    }

    .account-actions a i {
        margin-right: 10px;
        font-size: 16px;
    }

    .account-actions a:hover {
        background-color: #f0f0f0;
    }
</style>