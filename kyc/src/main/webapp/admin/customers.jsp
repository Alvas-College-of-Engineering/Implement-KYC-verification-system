<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Customers - SecureBank</title>
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
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }

                table {
                    width: 100%;
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }

                th {
                    background: #667eea;
                    color: white;
                    padding: 15px;
                    text-align: left;
                }

                td {
                    padding: 12px 15px;
                    border-bottom: 1px solid #e0e0e0;
                }

                .status-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                }

                .status-verified {
                    background: #d4edda;
                    color: #155724;
                }

                .status-rejected {
                    background: #f8d7da;
                    color: #721c24;
                }

                .status-pending {
                    background: #fff3cd;
                    color: #856404;
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

                    table {
                        font-size: 12px;
                    }

                    th,
                    td {
                        padding: 8px;
                    }
                }

                .search-box {
                    padding: 10px;
                    width: 300px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
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
                    <h1>Customer Management</h1>
                    <input type="text" id="searchInput" class="search-box"
                        placeholder="Search by name, ID, or mobile...">
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Full Name</th>
                            <th>Mobile</th>
                            <th>Email</th>
                            <th>KYC Status</th>
                            <th>Account Number</th>
                            <th>Registration Date</th>
                        </tr>
                    </thead>
                    <tbody id="customerTableBody">
                        <c:forEach items="${customers}" var="customer">
                            <tr class="customer-row">
                                <td>${customer.customerId}</td>
                                <td>${customer.fullName}</td>
                                <td>${customer.mobileNumber}</td>
                                <td>${customer.email}</td>
                                <td>
                                    <span class="status-badge status-${customer.kycStatus.name().toLowerCase()}">
                                        ${customer.kycStatus.name()}
                                    </span>
                                </td>
                                <td>${customer.accountNumber != null ? customer.accountNumber : 'N/A'}</td>
                                <td>${customer.registrationTime}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty customers}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px;">
                                    No customers found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <script>
                document.getElementById('searchInput').addEventListener('keyup', function () {
                    let searchValue = this.value.toLowerCase();
                    let rows = document.querySelectorAll('.customer-row');

                    rows.forEach(row => {
                        let text = row.textContent.toLowerCase();
                        if (text.includes(searchValue)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            </script>
        </body>

        </html>