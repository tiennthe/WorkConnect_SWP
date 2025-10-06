<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="bg-light shadow-sm">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between py-3">
            <div class="rts__logo">
                <a href="${pageContext.request.contextPath}/home">
                    <img class="logo__image" src="${pageContext.request.contextPath}/assets/img/logo/logo.svg" width="160" height="40" alt="logo">
                </a>
            </div>
            <div class="rts__menu d-flex gap-4 align-items-center">
                <div class="navigation d-none d-lg-block">
                    <nav class="navigation__menu" id="offcanvas__menu">
                        <ul class="nav">
                            <!-- Add your navigation items here -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">About</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Services</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Contact</a>
                            </li>
                        </ul>
                    </nav>
                </div>
                <div class="header__right__btn d-flex gap-3">
                    <c:if test="${empty sessionScope.account}">
                        <a href="${pageContext.request.contextPath}/authen" class="btn btn-success d-none d-sm-flex border-2">Sign In</a>
                        <button class="btn btn-outline-secondary d-md-block d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvas" aria-controls="offcanvas">
                            <i class="fa-sharp fa-regular fa-bars"></i>
                        </button>
                    </c:if>
                        <c:if test="${sessionScope.account.roleId == 1}">    
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
                                    <span class="text-muted">Admin</span>
                                </div>
                            </a>

                            <!-- Dropdown Menu -->
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg animate__animated animate__fadeIn">
                                <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/dashboard">
                                        <i class="fa-solid fa-house me-2"></i> Dashboard</a></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/view/authen/logout.jsp">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i> Log Out</a></li>
                            </ul>
                        </div>
                    </c:if>
                        <c:if test="${sessionScope.account.roleId == 2}">    
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
                                    <span class="text-muted">Recruiter</span>
                                </div>
                            </a>

                            <!-- Dropdown Menu -->
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg animate__animated animate__fadeIn">
                                <li><a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/Dashboard">
                                        <i class="fa-solid fa-house me-2"></i> Dashboard</a></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/view/authen/logout.jsp">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i> Log Out</a></li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</header>
