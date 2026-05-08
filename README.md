# Implement-KYC-verification-system

A secure and efficient **KYC (Know Your Customer) Verification System** developed using modern web technologies. This project helps organizations digitally verify customer identities through document upload, validation, and secure authentication.

![Frontend](https://img.shields.io/badge/Frontend-HTML5-orange)
![Style](https://img.shields.io/badge/Style-CSS3-blue)
![Logic](https://img.shields.io/badge/Logic-JavaScript-yellow)
![JSP](https://img.shields.io/badge/View-JSP-red)
![Servlet](https://img.shields.io/badge/Backend-Servlet-green)
![Java](https://img.shields.io/badge/Language-Java-orange)
![Database](https://img.shields.io/badge/Database-MySQL-blue)

---


# 📌 Overview

The **KYC Verification System** is designed to simplify and automate the identity verification process for organizations and businesses.

The system allows users to:
- Register and login securely
- Upload KYC documents
- Submit verification requests
- Track approval status

Administrators can:
- Review submitted documents
- Approve or reject applications
- Manage user records efficiently

This project demonstrates practical implementation of:
- Authentication systems
- File upload handling
- Database management
- Full Stack Web Development
- Secure verification workflow

---

# ✨ Features

## 👤 User Features

- 📝 User Registration & Login
- 📤 Upload KYC Documents
- 🖼️ Document Preview
- 🔍 Verification Status Tracking
- 🔒 Secure Authentication
- 📱 Responsive Interface

## 🛠️ Admin Features

- 📂 View User Applications
- ✅ Approve / Reject Verification Requests
- 🔎 Search User Records
- 📊 Dashboard Monitoring
- 📋 Manage Uploaded Documents

## ⚙️ System Features

- 🔐 Secure Data Handling
- ⚡ Fast Processing
- 🚫 Duplicate Prevention
- 📁 Multiple Document Support
- 📱 Mobile Friendly Design

---

# 🏗️ System Architecture

```text
┌──────────────────────────────┐
│        Presentation Layer    │
│      JSP + HTML + CSS        │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│       Business Logic Layer   │
│        Java Servlets         │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│        Database Layer        │
│       JDBC + MySQL DB        │
└──────────────────────────────┘
```

---



# 🚀 Installation

## 1️⃣ Clone Repository

```bash
git clone https://github.com/yourusername/kyc-verification-system.git
```

## 2️⃣ Open Project Folder

```bash
cd kyc-verification-system
```

## 3️⃣ Install Dependencies

```bash
npm install
```

## 4️⃣ Start Application

```bash
npm start
```

## 5️⃣ Open Browser

```text
http://localhost:3000
```

---

# 📖 Usage

## 👤 User Workflow

1. Register Account
2. Login Securely
3. Upload Documents
4. Submit KYC Request
5. Check Verification Status

## 🛠️ Admin Workflow

1. Login as Admin
2. Review User Documents
3. Approve / Reject Requests
4. Update Verification Status

---

# 📁 Folder Structure
```text
kyc-fixed/
│
├── src/
│   │
│   ├── main/
│   │   │
│   │   ├── java/
│   │   │   │
│   │   │   └── com/
│   │   │       └── banking/
│   │   │           └── kyc/
│   │   │               │
│   │   │               ├── controller/
│   │   │               ├── model/
│   │   │               ├── service/
│   │   │               ├── services/
│   │   │               ├── util/
│   │   │               └── validator/
│   │   │
│   │   ├── resources/
│   │   │   └── db.properties
│   │   │
│   │   └── webapp/
│   │       │
│   │       ├── admin/
│   │       ├── css/
│   │       ├── js/
│   │       ├── WEB-INF/
│   │       ├── index.jsp
│   │       ├── kyc-form.jsp
│   │       └── result.jsp
│   │
│   └── test/
│
├── database.sql
├── pom.xml
└── README.md
```

---

# 📦 Modules

## 🔑 Authentication Module

- User Registration
- User Login
- Password Protection
- Session Management

## 📤 Document Upload Module

- Aadhaar Upload
- PAN Upload
- Passport Upload
- Driving License Upload

## ✅ Verification Module

- Admin Review Process
- Approval / Rejection System
- Verification Status Updates

## 📊 Dashboard Module

- User Dashboard
- Admin Dashboard
- Statistics Overview

---

# 🗄️ Database Schema

## 👤 User Collection

| Field | Type |
|------|------|
| name | String |
| email | String |
| password | String |
| phone | String |
| status | String |

---

## 📄 Document Collection

| Field | Type |
|------|------|
| userId | ObjectId |
| documentType | String |
| documentPath | String |
| uploadDate | Date |
| verificationStatus | String |

---



## 🔐 Login Page

- Secure login interface for users

## 📤 Upload Page

- Upload Aadhaar, PAN, Passport, etc.

## 🛠️ Admin Dashboard

- Verify and manage KYC requests

---

# 🔮 Future Enhancements

- 🤖 AI-based Verification
- 📷 OCR Integration
- ☁️ Cloud Storage Support
- 📧 Email Notifications
- 📱 Mobile App Development
- 🔐 Two-Factor Authentication
- 🌐 Multi-language Support

---

# 👨‍💻 Authors

| Name | USN | 
|------|------|
| **Apoorva Nayak** | **4AL22CS021** |


---


© 2026 Apoorva Nayak | KYC Verification System

