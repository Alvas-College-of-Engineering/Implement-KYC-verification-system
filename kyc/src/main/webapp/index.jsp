<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SecureBank - Digital Banking Platform</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
            }

            .navbar {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                padding: 20px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-size: 28px;
                font-weight: 800;
                color: white;
            }

            .logo span {
                color: #FFD700;
            }

            .nav-links a {
                color: white;
                text-decoration: none;
                margin-left: 30px;
                transition: opacity 0.3s;
            }

            .nav-links a:hover {
                opacity: 0.8;
            }

            .hero {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 80px 40px;
                color: white;
            }

            .hero-content {
                flex: 1;
            }

            .hero-content h1 {
                font-size: 52px;
                font-weight: 800;
                margin-bottom: 20px;
                line-height: 1.2;
            }

            .hero-content .highlight {
                color: #FFD700;
            }

            .hero-content p {
                font-size: 18px;
                opacity: 0.9;
                margin-bottom: 30px;
                max-width: 500px;
            }

            .btn-group {
                display: flex;
                gap: 20px;
            }

            .btn {
                padding: 12px 30px;
                border-radius: 50px;
                text-decoration: none;
                font-weight: 600;
                transition: transform 0.3s;
                display: inline-block;
            }

            .btn-primary {
                background: #FFD700;
                color: #333;
            }

            .btn-outline {
                border: 2px solid white;
                color: white;
            }

            .btn:hover {
                transform: translateY(-3px);
            }

            .hero-image {
                flex: 1;
                text-align: center;
            }

            .hero-image .emoji {
                font-size: 200px;
            }

            .stats {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                padding: 40px;
                background: white;
                border-radius: 30px 30px 0 0;
            }

            .stat-item {
                text-align: center;
            }

            .stat-number {
                font-size: 36px;
                font-weight: 800;
                color: #667eea;
            }

            .stat-label {
                color: #666;
                margin-top: 10px;
            }

            @media (max-width: 768px) {
                .hero {
                    flex-direction: column;
                    text-align: center;
                    padding: 40px 20px;
                }

                .hero-content h1 {
                    font-size: 32px;
                }

                .btn-group {
                    justify-content: center;
                }

                .stats {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
        </style>
    </head>

    <body>
        <div class="navbar">
            <div class="logo">Secure<span>Bank</span></div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/kyc">Open Account</a>
                <a href="${pageContext.request.contextPath}/view-customers">Customers</a>
                <a href="${pageContext.request.contextPath}/stats">Statistics</a>
            </div>
        </div>

        <div class="hero">
            <div class="hero-content">
                <h1>Banking that <span class="highlight">Grows</span><br>with You</h1>
                <p>Open your account instantly with our seamless digital KYC process. No branch visit required.</p>
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/kyc" class="btn btn-primary">Start KYC →</a>
                    <a href="${pageContext.request.contextPath}/view-customers" class="btn btn-outline">View
                        Customers</a>
                </div>
            </div>
            <div class="hero-image">
                <div class="emoji">🏦</div>
            </div>
        </div>

        <div class="stats">
            <div class="stat-item">
                <div class="stat-number" id="totalCount">-</div>
                <div class="stat-label">Total Customers</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" id="verifiedCount">-</div>
                <div class="stat-label">Verified Accounts</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Customer Support</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">100%</div>
                <div class="stat-label">Digital Process</div>
            </div>
        </div>

        <script>
            fetch('${pageContext.request.contextPath}/api/stats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalCount').textContent = data.total || 0;
                    document.getElementById('verifiedCount').textContent = data.verified || 0;
                })
                .catch(error => console.error('Error fetching stats:', error));
        </script>
    </body>

    </html>