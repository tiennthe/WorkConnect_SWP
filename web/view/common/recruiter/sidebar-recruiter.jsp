<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex flex-column flex-shrink-0 p-3 bg-light text-light vh-100" 
     style="width: 280px; position: fixed; top: 0; left: 0; border-right: 2px solid #28a745;">
    <div class="rts__logo text-center mb-3">
        <a href="${pageContext.request.contextPath}/view/recruiter/recruiterHome.jsp">
            <img class="logo__image" src="${pageContext.request.contextPath}/assets/img/logo/header__one.svg" width="160" height="40" alt="logo">
        </a>
    </div>
    <hr class="bg-light">
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="/admin/dashboard" class="nav-link" aria-current="page">
                <span class="me-2"><i class="fa-solid fa-house"></i></span> Dashboard
            </a>
        </li>
        <li>
            <a href="/admin/users" class="nav-link">
                <span class="me-2"><i class="fa-solid fa-users"></i></span> Users
            </a>
        </li>
        <li>
            <a href="/admin/jobs" class="nav-link">
                <span class="me-2"><i class="fa-solid fa-briefcase"></i></span> Job Postings
            </a>
        </li>
        <li>
            <a href="/admin/reports" class="nav-link">
                <span class="me-2"><i class="fa-solid fa-file-alt"></i></span> Reports
            </a>
        </li>
        <li>
            <a href="/admin/settings" class="nav-link">
                <span class="me-2"><i class="fa-solid fa-gear"></i></span> Settings
            </a>
        </li>
    </ul>
    <hr class="bg-light">
    <div class="dropdown mt-auto">
        <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
            <div class="author__image me-2">
                <c:if test="${empty sessionScope.account.avatar}">
                    <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" alt="Avatar" class="rounded-circle" width="40" height="40">
                </c:if>
                <c:if test="${!empty sessionScope.account.avatar}">
                    <img src="${sessionScope.account.avatar}" alt="Avatar" class="rounded-circle" width="40" height="40">
                </c:if>
            </div>
            <div class="d-flex flex-column align-items-start">
                <strong class="user-name text-black">${sessionScope.account.fullName}</strong>
                <span class="text-secondary">Recruiter Page</span>
            </div>
        </a>

        <ul class="dropdown-menu text-small shadow" aria-labelledby="dropdownUser1">
            <li><a class="dropdown-item text-black" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-house me-2"></i> Dashboard</a></li>
            <li><a class="dropdown-item text-black" href="${pageContext.request.contextPath}/view/recruiter/recruiterProfile.jsp"><i class="fa-solid fa-user me-2"></i> Profile</a></li>
            <li><a class="dropdown-item text-black" href="${pageContext.request.contextPath}/admin/alerts"><i class="fa-solid fa-bell me-2"></i> Job Alerts</a></li>
            <li><a class="dropdown-item text-black" href="${pageContext.request.contextPath}/authen?action=change-password"><i class="fa-solid fa-lock me-2"></i> Change Password</a></li>
            <li><hr class="dropdown-divider bg-light"></li>
            <li><a class="dropdown-item text-white bg-danger" href="${pageContext.request.contextPath}/view/authen/logout.jsp"><i class="fa-solid fa-right-from-bracket me-2"></i> Log Out</a></li>
        </ul>
    </div>
</div>

<style>
    .nav-link {
        transition: background-color 0.3s ease, color 0.3s ease;
        padding: 10px 15px;
        border-radius: 5px;
        display: flex; /* Align icon and text */
        align-items: center; /* Center align vertically */
        color: green;
    }

    .nav-link:hover {
        background-color: #28a745; /* Hover color */
        color: #fff; /* Text color on hover */
    }

    .nav-link.active {
        background-color: #28a745; /* Active link color */
        color: #fff; /* Active text color */
    }

    .dropdown-menu {
        background-color: whitesmoke; /* Dark dropdown background */
    }

    .dropdown-item:hover {
        background-color: #28a745; /* Dropdown item hover color */
        color: black; /* Text color on hover */
    }
</style>