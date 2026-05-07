<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>KYC Application - SecureBank</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <div class="header">
            <div class="logo">Secure<span>Bank</span></div>
            <div class="nav">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/view-customers">Customers</a>
                <a href="${pageContext.request.contextPath}/stats">Stats</a>
            </div>
        </div>

        <div class="container">
            <div class="form-card">
                <div class="form-header">
                    <h2>KYC Verification Form</h2>
                    <p>Please fill in all the details accurately. All fields marked with * are required.</p>
                </div>

                <div class="form-body">
                    <form id="kycForm" action="${pageContext.request.contextPath}/submit-kyc" method="POST">
                        <!-- Personal Information -->
                        <div class="section">
                            <div class="section-title">Personal Information</div>
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label>Full Name <span class="required">*</span></label>
                                    <input type="text" name="fullName" id="fullName" required>
                                    <div class="error-message" id="fullNameError">Please enter your full name (First and
                                        Last name)</div>
                                </div>
                                <div class="form-group">
                                    <label>Date of Birth <span class="required">*</span></label>
                                    <input type="date" name="dateOfBirth" id="dateOfBirth" required>
                                    <div class="error-message" id="dobError">You must be at least 18 years old</div>
                                </div>
                                <div class="form-group">
                                    <label>Gender <span class="required">*</span></label>
                                    <select name="gender" id="gender" required>
                                        <option value="">Select Gender</option>
                                        <option>Male</option>
                                        <option>Female</option>
                                        <option>Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Identity Proof -->
                        <div class="section">
                            <div class="section-title">Identity Proof</div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>ID Proof Type <span class="required">*</span></label>
                                    <select name="idProofType" id="idProofType" required>
                                        <option value="">Select ID Type</option>
                                        <option value="AADHAAR">Aadhaar Card</option>
                                        <option value="PAN">PAN Card</option>
                                        <option value="PASSPORT">Passport</option>
                                        <option value="VOTER_ID">Voter ID</option>
                                        <option value="DRIVING_LICENSE">Driving License</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>ID Proof Number <span class="required">*</span></label>
                                    <input type="text" name="idProofNumber" id="idProofNumber" required>
                                    <div class="error-message" id="idError">Invalid ID number format</div>
                                </div>
                            </div>
                        </div>

                        <!-- Address Details -->
                        <div class="section">
                            <div class="section-title">Address Details</div>
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label>Street Address <span class="required">*</span></label>
                                    <textarea name="address" id="address" rows="3" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label>City <span class="required">*</span></label>
                                    <input type="text" name="city" id="city" required>
                                </div>
                                <div class="form-group">
                                    <label>State <span class="required">*</span></label>
                                    <select name="state" id="state" required>
                                        <option value="">Select State</option>
                                        <option>Maharashtra</option>
                                        <option>Delhi</option>
                                        <option>Karnataka</option>
                                        <option>Tamil Nadu</option>
                                        <option>West Bengal</option>
                                        <option>Gujarat</option>
                                        <option>Uttar Pradesh</option>
                                        <option>Rajasthan</option>
                                        <option>Punjab</option>
                                        <option>Haryana</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>PIN Code <span class="required">*</span></label>
                                    <input type="text" name="pinCode" id="pinCode" maxlength="6" required>
                                    <div class="error-message" id="pinError">Invalid PIN code (6 digits)</div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact & Financial -->
                        <div class="section">
                            <div class="section-title">Contact & Financial Details</div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Mobile Number <span class="required">*</span></label>
                                    <input type="tel" name="mobileNumber" id="mobileNumber" maxlength="10" required>
                                    <div class="error-message" id="mobileError">Invalid mobile number (10 digits, starts
                                        with 6-9)</div>
                                </div>
                                <div class="form-group">
                                    <label>Email Address <span class="required">*</span></label>
                                    <input type="email" name="email" id="email" required>
                                    <div class="error-message" id="emailError">Invalid email address</div>
                                </div>
                                <div class="form-group">
                                    <label>Occupation <span class="required">*</span></label>
                                    <select name="occupation" id="occupation" required>
                                        <option value="">Select Occupation</option>
                                        <option>Salaried Employee</option>
                                        <option>Self-Employed</option>
                                        <option>Business Owner</option>
                                        <option>Student</option>
                                        <option>Homemaker</option>
                                        <option>Retired</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Annual Income (₹) <span class="required">*</span></label>
                                    <input type="number" name="annualIncome" id="annualIncome" min="0" required>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit">Submit KYC Application</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Processing your KYC application...</p>
        </div>

        <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    </body>

    </html>