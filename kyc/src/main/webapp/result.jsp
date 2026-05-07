<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>KYC Result - SecureBank</title>
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
                    padding: 20px;
                }

                .container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .result-card {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                    margin-top: 40px;
                    animation: slideUp 0.5s ease;
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .result-header {
                    padding: 40px;
                    text-align: center;
                    color: white;
                }

                .result-header.success {
                    background: linear-gradient(135deg, #11998e, #38ef7d);
                }

                .result-header.failed {
                    background: linear-gradient(135deg, #eb3349, #f45c43);
                }

                .result-icon {
                    font-size: 80px;
                    margin-bottom: 20px;
                }

                .result-header h2 {
                    font-size: 32px;
                    margin-bottom: 10px;
                }

                .result-body {
                    padding: 40px;
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 20px;
                    margin-bottom: 30px;
                }

                .stat-card {
                    text-align: center;
                    padding: 20px;
                    background: #f8f9fa;
                    border-radius: 15px;
                }

                .stat-number {
                    font-size: 36px;
                    font-weight: 700;
                    color: #667eea;
                }

                .stat-label {
                    font-size: 14px;
                    color: #666;
                    margin-top: 5px;
                }

                .checks-list {
                    margin: 30px 0;
                }

                .check-item {
                    display: flex;
                    align-items: center;
                    padding: 15px;
                    margin: 10px 0;
                    background: #f8f9fa;
                    border-radius: 10px;
                    border-left: 4px solid;
                }

                .check-item.pass {
                    border-left-color: #38ef7d;
                }

                .check-item.fail {
                    border-left-color: #f45c43;
                }

                .check-status {
                    width: 30px;
                    font-size: 20px;
                    margin-right: 15px;
                }

                .check-info {
                    flex: 1;
                }

                .check-name {
                    font-weight: 600;
                    margin-bottom: 5px;
                }

                .check-message {
                    font-size: 13px;
                    color: #666;
                }

                .account-details {
                    background: linear-gradient(135deg, #667eea, #764ba2);
                    color: white;
                    padding: 30px;
                    border-radius: 15px;
                    margin-top: 30px;
                }

                .account-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 10px 0;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                }

                .btn {
                    display: inline-block;
                    padding: 12px 30px;
                    background: #667eea;
                    color: white;
                    text-decoration: none;
                    border-radius: 8px;
                    margin-top: 20px;
                    transition: transform 0.3s;
                    border: none;
                    cursor: pointer;
                    margin-right: 10px;
                }

                .btn:hover {
                    transform: translateY(-2px);
                }

                .btn-secondary {
                    background: #6c757d;
                }

                @media (max-width: 768px) {
                    .stats-grid {
                        grid-template-columns: 1fr;
                    }

                    .result-body {
                        padding: 20px;
                    }
                }

                .customer-info {
                    background: #e8f0fe;
                    padding: 20px;
                    border-radius: 10px;
                    margin-top: 20px;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 8px 0;
                    border-bottom: 1px solid #ccc;
                }

                .info-label {
                    font-weight: 600;
                    color: #555;
                }

                .info-value {
                    color: #333;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="result-card">
                    <div class="result-header ${result.success ? 'success' : 'failed'}">
                        <div class="result-icon">${result.success ? '✅' : '❌'}</div>
                        <h2>${result.success ? 'KYC Verified Successfully!' : 'KYC Verification Failed'}</h2>
                        <p>${result.message}</p>
                    </div>

                    <div class="result-body">
                        <!-- Statistics -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-number">${validation.totalChecks}</div>
                                <div class="stat-label">Total Checks</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-number" style="color: #28a745;">${validation.passedChecks}</div>
                                <div class="stat-label">Passed</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-number" style="color: #dc3545;">${validation.failedChecks}</div>
                                <div class="stat-label">Failed</div>
                            </div>
                        </div>

                        <!-- Customer Information -->
                        <div class="customer-info">
                            <h3 style="margin-bottom: 15px;">Customer Information</h3>
                            <div class="info-row">
                                <span class="info-label">Customer ID:</span>
                                <span class="info-value">${customer.customerId}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">${customer.fullName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">${customer.dateOfBirth}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Mobile Number:</span>
                                <span class="info-value">${customer.mobileNumber}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">${customer.email}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">KYC Status:</span>
                                <span class="info-value"
                                    style="color: ${result.success ? '#28a745' : '#dc3545'}; font-weight: 600;">
                                    ${customer.kycStatus}
                                </span>
                            </div>
                        </div>

                        <!-- Validation Checks -->
                        <h3 style="margin: 30px 0 20px;">Verification Details</h3>
                        <div class="checks-list">
                            <c:forEach items="${validation.checks}" var="check">
                                <div class="check-item ${check.passed ? 'pass' : 'fail'}">
                                    <div class="check-status">${check.passed ? '✓' : '✗'}</div>
                                    <div class="check-info">
                                        <div class="check-name">${check.displayName}</div>
                                        <div class="check-message">${check.message}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Account Details (if verified) -->
                        <c:if test="${result.success && not empty account}">
                            <div class="account-details">
                                <h3 style="margin-bottom: 20px;">🎉 Account Created Successfully!</h3>
                                <div class="account-row">
                                    <span>Account Number:</span>
                                    <strong>${account.accountNumber}</strong>
                                </div>
                                <div class="account-row">
                                    <span>Account Type:</span>
                                    <strong>${account.accountType.displayName}</strong>
                                </div>
                                <div class="account-row">
                                    <span>IFSC Code:</span>
                                    <strong>${account.ifscCode}</strong>
                                </div>
                                <div class="account-row">
                                    <span>Branch:</span>
                                    <strong>${account.branchName}</strong>
                                </div>
                                <div class="account-row">
                                    <span>Status:</span>
                                    <strong style="color: #38ef7d;">${account.status}</strong>
                                </div>
                                <div class="account-row">
                                    <span>Opening Balance:</span>
                                    <strong>₹${account.balance}</strong>
                                </div>
                            </div>
                        </c:if>

                        <div style="text-align: center; margin-top: 30px;">
                            <a href="${pageContext.request.contextPath}/kyc" class="btn">New Application</a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>