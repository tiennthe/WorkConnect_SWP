<footer class="rts__section footer__home__one" style="background-color: #495057; color: #f8f9fa; border-top: 5px solid #28a745;">
    <div class="container">
        <div class="row">
            <div class="footer__wrapper d-flex flex-wrap justify-content-between pt-60 pb-60">
                <div class="rts__footer__widget text-center text-md-start mb-4 mt-3">
                    <a href="index.html" class="footer__logo" aria-label="logo">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/logo.svg" width="160" height="40" alt="logo">
                    </a>
                    <p class="mt-3">Empowering connections between job seekers and employers—simpler, smarter, faster.</p>
                </div>

                <div class="rts__footer__widget mb-4">
                    <div class="font-20 fw-medium mb-3 h6">Contact Us</div>
                    <ul class="list-unstyled mb-3">
                        <li><a href="#" style="color: #f8f9fa; text-decoration: none" class="footer-link"><i class="fa-light fa-location-dot"></i> Thach That district, Ha Noi city</a></li>
                        <li><a href="callto:+880171234578" style="color: #f8f9fa; text-decoration: none" class="footer-link"><i class="fa-light fa-phone"></i> +(61) 545-432-234</a></li>
                        <li><a href="mailto:tiennthe172719@fpt.edu.vn" style="color: #f8f9fa; text-decoration: none" class="footer-link"><i class="fa-light fa-envelope"></i> tiennthe172719@fpt.edu.vn</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="rts__copyright" style="background-color: #6c757d; border-top: 1px solid #28a745;">
        <div class="container">
            <p class="text-center fw-medium py-4 mb-0">
                Copyright &copy; 2025 All Rights Reserved by Group 2 - SWP391
            </p>
        </div>
    </div>
</footer>

<style>
    /* Ensures the page-wrapper takes up at least 100% of the viewport height */
    html, body {
        height: 100%;
        margin: 0;
    }

    .page-wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    .content {
        flex: 1; /* This makes the main content area grow to fill space */
    }

    .rts__section.footer__home__one {
        background-color: #495057;
        color: #f8f9fa;
        border-top: 5px solid #28a745;
    }

    .footer__wrapper {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        padding-top: 60px;
        padding-bottom: 60px;
    }

    .footer__link {
        transition: color 0.3s ease, transform 0.3s ease;
    }

    .footer__link:hover {
        color: #28a745;
        transform: scale(1.05);
    }

    @media (max-width: 768px) {
        .footer__wrapper {
            flex-direction: column;
            align-items: center;
        }
    }

</style>
