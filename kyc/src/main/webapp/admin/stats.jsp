<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Statistics - SecureBank</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .stat-card {
                    background: white;
                    padding: 25px;
                    border-radius: 15px;
                    text-align: center;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    transition: transform 0.3s;
                }

                .stat-card:hover {
                    transform: translateY(-5px);
                }

                .stat-value {
                    font-size: 42px;
                                font-weight: 700;
        }
        
        .stat-label {
            color: #666;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .chart-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .chart-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        canvas {
            max-height: 300px;
        }
        
        .btn {
            padding: 8px 16px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 12px;
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
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            .chart-wrapper {
                grid-template-columns: 1fr;
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
            <div class="header">
                <h1>KYC Statistics Dashboard</h1>
                <a href="${pageContext.request.contextPath}/admin" class="btn">Back to Dashboard</a>
            </div>
    
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value" style="color: #667eea;" id="totalCount">${stats.total}</div>
                    <div class="stat-label">Total Applications</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" style="color: #28a745;" id="verifiedCount">${stats.verified}</div>
                    <div class="stat-label">Verified</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" style="color: #dc3545;" id="rejectedCount">${stats.rejected}</div>
                    <div class="stat-label">Rejected</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" style="color: #ffc107;" id="pendingCount">${stats.pending}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
    
            <div class="chart-container">
                <div class="chart-wrapper">
                    <canvas id="kycChart"></canvas>
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
    
            <div class="chart-container">
                <h3 style="margin-bottom: 20px;">Verification Success Rate</h3>
                <canvas id="successRateChart"></canvas>
            </div>
        </div>
    
        <script>
            const total = ${ stats.total };
            const verified = ${ stats.verified };
            const rejected = ${ stats.rejected };
            const pending = ${ stats.pending };

            // Doughnut Chart for KYC Status Distribution
            const ctx1 = document.getElementById('kycChart').getContext('2d');
            new Chart(ctx1, {
                type: 'doughnut',
                data: {
                    labels: ['Verified', 'Rejected', 'Pending'],
                    datasets: [{
                        data: [verified, rejected, pending],
                        backgroundColor: ['#28a745', '#dc3545', '#ffc107'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        title: {
                            display: true,
                            text: 'KYC Status Distribution'
                        }
                    }
                }
            });

            // Bar Chart for Monthly Trends (Sample data - can be enhanced with actual monthly data)
            const ctx2 = document.getElementById('trendChart').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Applications',
                        data: [12, 19, 15, 17, 14, 20],
                        backgroundColor: '#667eea',
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Monthly Application Trends'
                        }
                    }
                }
            });

            // Success Rate Gauge
            const successRate = total > 0 ? (verified / total * 100).toFixed(1) : 0;
            const ctx3 = document.getElementById('successRateChart').getContext('2d');
            new Chart(ctx3, {
                type: 'doughnut',
                data: {
                    labels: ['Success Rate', 'Remaining'],
                    datasets: [{
                        data: [successRate, 100 - successRate],
                        backgroundColor: ['#28a745', '#e9ecef'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    cutout: '70%',
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.raw.toFixed(1) + '%';
                                }
                            }
                        },
                        legend: {
                            position: 'bottom'
                        },
                        title: {
                            display: true,
                            text: 'Overall Success Rate: ' + successRate + '%'
                        }
                    }
                }
            });
        </script>
    </body>
    
    </html>