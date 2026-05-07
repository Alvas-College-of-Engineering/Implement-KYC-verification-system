<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - SecureBank</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: #f5f7fa;
            }

            .sidebar {
                width: 260px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                position: fixed;
                height: 100%;
                padding: 30px 0;
            }

            .sidebar h2 {
                text-align: center;
                margin-bottom: 40px;
                font-size: 24px;
            }

            .sidebar h2 span {
                color: #FFD700;
            }

            .sidebar nav a {
                display: block;
                padding: 15px 30px;
                color: white;
                text-decoration: none;
                transition: all 0.3s;
            }

            .sidebar nav a:hover {
                background: rgba(255, 255, 255, 0.1);
                padding-left: 40px;
            }

            .main-content {
                margin-left: 260px;
                padding: 30px;
            }

            .header {
                background: white;
                padding: 20px 30px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-box {
                background: white;
                padding: 25px;
                border-radius: 15px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s;
            }

            .stat-box:hover {
                transform: translateY(-5px);
            }

            .stat-value {
                font-size: 36px;
                font-weight: 700;
                color: #667eea;
            }

            .stat-label {
                color: #666;
                margin-top: 10px;
            }

            .welcome-card {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
            }

            @media (max-width: 768px) {
                .sidebar {
                    width: 100%;
                    height: auto;
                    position: relative;
                }

                .main-content {
                    margin-left: 0;
                }
            }
        </style>
    </head>

    <body>
        <div class="sidebar">
            <h2>Secure<span>Bank</span></h2>
            <nav>
                <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
                <a href="${pageContext.request.contextPath}/view-customers">Customers</a>
                <a href="${pageContext.request.contextPath}/stats">Statistics</a>
                <a href="${pageContext.request.contextPath}/kyc">New KYC</a>
                <a href="${pageContext.request.contextPath}/">Logout</a>
            </nav>
        </div>

        <div class="main-content">
            <div class="welcome-card">
                <h1>Welcome to Admin Dashboard</h1>
                <p>Manage KYC applications, view customer details, and monitor verification statistics.</p>
            </div>

            <div class="stats-grid">
                <div class="stat-box">
                    <div class="stat-value" id="totalCount">-</div>
                    <div class="stat-label">Total Applications</div>
                </div>
                <div class="stat-box">
                    <div class="stat-value" id="verifiedCount">-</div>
                    <div class="stat-label">Verified</div>
                </div>
                <div class="stat-box">
                    <div class="stat-value" id="rejectedCount">-</div>
                    <div class="stat-label">Rejected</div>
                </div>
                <div class="stat-box">
                    <div class="stat-value" id="pendingCount">-</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
        </div>

        <script>
            fetch('${pageContext.request.contextPath}/api/stats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalCount').textContent = data.total || 0;
                    document.getElementById('verifiedCount').textContent = data.verified || 0;
                    document.getElementById('rejectedCount').textContent = data.rejected || 0;
                    document.getElementById('pendingCount').textContent = data.pending || 0;
                })
                .catch(error => console.error('Error fetching stats:', error));
        </script>
    </body>

    </html>