<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="bg-light shadow-sm">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between py-3">
            <!-- Logo -->
            <div class="rts__logo">
                <a href="${pageContext.request.contextPath}/HomeSeeker" class="d-flex align-items-center">
                    <img class="logo__image" src="${pageContext.request.contextPath}/assets/img/logo/logo.png" 
                         width="160" height="40" alt="logo" class="me-2">
                </a>
            </div>

            <!-- Navigation Menu -->
            <div class="rts__menu d-flex gap-4 align-items-center">
                <div class="navigation d-none d-lg-block">
                    <nav class="navigation__menu" id="offcanvas__menu">
                        <ul class="nav">
                            <li class="nav-item">
                                <a class="nav-link text-dark fw-bold" href="${pageContext.request.contextPath}/HomeSeeker">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark fw-bold" href="#">About</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark fw-bold" href="#">Services</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark fw-bold" href="#">Contact</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark fw-bold" href="${pageContext.request.contextPath}/FavourJobPosting">Favourite Job Post</a>
                            </li>
                        </ul>
                    </nav>
                </div>

                <!-- User Dropdown -->
                <div class="header__right__btn d-flex gap-3">
                    <div class="dropdown mt-auto">
                        <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" 
                           id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="author__image me-2">
                                <c:choose>
                                    <c:when test="${empty sessionScope.account.avatar}">
                                        <img src="${pageContext.request.contextPath}/assets/img/dashboard/avatar-mail.png" 
                                             alt="Avatar" class="rounded-circle" width="40" height="40">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${sessionScope.account.avatar}" 
                                             alt="Avatar" class="rounded-circle" width="40" height="40">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="d-flex flex-column align-items-start">
                                <strong class="user-name text-dark">${sessionScope.account.fullName}</strong>
                                <span class="text-muted">Seeker Page</span>
                            </div>
                        </a>

                        <!-- Dropdown Menu -->
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg animate__animated animate__fadeIn">
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/authen?action=view-profile">
                                <i class="fa-solid fa-user me-2"></i> Profile</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/cv">
                                <i class="fa-solid fa-file me-2"></i> Manage your CV</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/education">
                                <i class="fa-solid fa-school me-2"></i> Manage your Education</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/experience">
                                <i class="fa-solid fa-briefcase me-2"></i> Manage your Experience</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/application">
                                <i class="fa-solid fa-bell me-2"></i> My Applications</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/feedbackSeeker">
                                <i class="fa-solid fa-briefcase me-2"></i> Your Feedback</a></li>
                            <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/authen?action=change-password">
                                <i class="fa-solid fa-lock me-2"></i> Change Password</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/view/authen/logout.jsp">
                                <i class="fa-solid fa-right-from-bracket me-2"></i> Log Out</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

