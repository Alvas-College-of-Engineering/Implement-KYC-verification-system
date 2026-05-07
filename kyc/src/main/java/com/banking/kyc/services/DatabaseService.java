package com.banking.kyc.services;

import com.banking.kyc.model.BankAccount;
import com.banking.kyc.model.Customer;
import com.banking.kyc.model.KYCValidationResult;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * DatabaseService — Singleton data-access layer using HikariCP + MySQL.
 *
 * Fixes applied:
 *  - getStatistics(): replaced broken CallableStatement approach with plain SQL
 *    so the app works even without the stored procedure defined in the DB.
 *  - saveCustomer(): handles null / non-numeric annualIncome gracefully.
 *  - initializeDataSource(): loads config from db.properties when available.
 *  - mapCustomer(): null-safe for date_of_birth and annual_income columns.
 */
public class DatabaseService {

    private static HikariDataSource dataSource;
    private static DatabaseService instance;

    private DatabaseService() {
        initializeDataSource();
    }

    public static synchronized DatabaseService getInstance() {
        if (instance == null) {
            instance = new DatabaseService();
        }
        return instance;
    }

    // -----------------------------------------------------------------------
    // Initialisation
    // -----------------------------------------------------------------------

    private void initializeDataSource() {
        String url      = "jdbc:mysql://localhost:3306/kyc_banking?useSSL=false&serverTimezone=UTC";
        String username = "kyc_user";
        String password = "SecureBank@2024";

        try (java.io.InputStream is = getClass().getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                url      = props.getProperty("db.url",      url);
                username = props.getProperty("db.username", username);
                password = props.getProperty("db.password", password);
            }
        } catch (Exception e) {
            System.err.println("[DatabaseService] Could not load db.properties: " + e.getMessage());
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url);
        config.setUsername(username);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30_000);
        config.setIdleTimeout(600_000);
        config.setMaxLifetime(1_800_000);
        config.setConnectionTestQuery("SELECT 1");

        dataSource = new HikariDataSource(config);
    }

    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // -----------------------------------------------------------------------
    // Write
    // -----------------------------------------------------------------------

    public void saveCustomer(Customer customer, BankAccount account,
                             KYCValidationResult validation) throws SQLException {

        String customerSql =
            "INSERT INTO customers " +
            "  (customer_id, full_name, date_of_birth, id_proof_type, id_proof_number, " +
            "   address, city, state, pin_code, mobile_number, email, occupation, " +
            "   annual_income, kyc_status, account_number, rejection_reason) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE kyc_status = VALUES(kyc_status), " +
            "  rejection_reason = VALUES(rejection_reason)";

        String accountSql =
            "INSERT INTO bank_accounts " +
            "  (account_number, customer_id, account_type, balance, ifsc_code, branch_name) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        String logSql =
            "INSERT INTO kyc_validation_logs " +
            "  (customer_id, validation_result, passed_checks, total_checks, details) " +
            "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(customerSql)) {
                    ps.setString(1, customer.getCustomerId());
                    ps.setString(2, customer.getFullName());
                    String dob = customer.getDateOfBirth();
                    if (dob != null && !dob.isEmpty()) {
                        ps.setDate(3, Date.valueOf(dob));
                    } else {
                        ps.setNull(3, Types.DATE);
                    }
                    ps.setString(4, customer.getIdProofType());
                    ps.setString(5, customer.getIdProofNumber());
                    ps.setString(6, customer.getAddress());
                    ps.setString(7, customer.getCity());
                    ps.setString(8, customer.getState());
                    ps.setString(9, customer.getPinCode());
                    ps.setString(10, customer.getMobileNumber());
                    ps.setString(11, customer.getEmail());
                    ps.setString(12, customer.getOccupation());
                    String incomeStr = customer.getAnnualIncome();
                    try {
                        ps.setBigDecimal(13, new BigDecimal(
                                incomeStr == null ? "0" : incomeStr.replaceAll("[,\\s]", "")));
                    } catch (NumberFormatException e) {
                        ps.setBigDecimal(13, BigDecimal.ZERO);
                    }
                    ps.setString(14, customer.getKycStatus().name());
                    ps.setString(15, customer.getAccountNumber());
                    ps.setString(16, customer.getRejectionReason());
                    ps.executeUpdate();
                }

                if (account != null && customer.getKycStatus() == Customer.KYCStatus.VERIFIED) {
                    try (PreparedStatement ps = conn.prepareStatement(accountSql)) {
                        ps.setString(1, account.getAccountNumber());
                        ps.setString(2, customer.getCustomerId());
                        ps.setString(3, account.getAccountType().name());
                        ps.setBigDecimal(4, BigDecimal.valueOf(account.getBalance()));
                        ps.setString(5, account.getIfscCode());
                        ps.setString(6, account.getBranchName());
                        ps.executeUpdate();
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(logSql)) {
                    ps.setString(1, customer.getCustomerId());
                    ps.setString(2, validation.isValid() ? "PASSED" : "FAILED");
                    ps.setInt(3, (int) validation.getPassedChecks());
                    ps.setInt(4, validation.getTotalChecks());
                    ps.setString(5, validation.getSummary());
                    ps.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // -----------------------------------------------------------------------
    // Read
    // -----------------------------------------------------------------------

    public Customer getCustomer(String customerId) throws SQLException {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapCustomer(rs);
            }
        }
        return null;
    }

    public List<Customer> getAllCustomers() throws SQLException {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapCustomer(rs));
        }
        return list;
    }

    /**
     * FIX: Was using CallableStatement.executeQuery() on a stored procedure
     * that may not exist. Replaced with a plain GROUP BY query.
     */
    public Map<String, Object> getStatistics() throws SQLException {
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("total", 0);
        stats.put("verified", 0);
        stats.put("rejected", 0);
        stats.put("pending", 0);
        stats.put("under_review", 0);

        String sql = "SELECT kyc_status, COUNT(*) AS cnt FROM customers GROUP BY kyc_status";
        int total = 0;
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                String status = rs.getString("kyc_status");
                int count = rs.getInt("cnt");
                total += count;
                switch (status) {
                    case "VERIFIED":     stats.put("verified",     count); break;
                    case "REJECTED":     stats.put("rejected",     count); break;
                    case "PENDING":      stats.put("pending",      count); break;
                    case "UNDER_REVIEW": stats.put("under_review", count); break;
                    default: break;
                }
            }
        }
        stats.put("total", total);
        return stats;
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------

    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setCustomerId(rs.getString("customer_id"));
        c.setFullName(rs.getString("full_name"));
        Date dob = rs.getDate("date_of_birth");
        c.setDateOfBirth(dob != null ? dob.toString() : "");
        c.setIdProofType(rs.getString("id_proof_type"));
        c.setIdProofNumber(rs.getString("id_proof_number"));
        c.setAddress(rs.getString("address"));
        c.setCity(rs.getString("city"));
        c.setState(rs.getString("state"));
        c.setPinCode(rs.getString("pin_code"));
        c.setMobileNumber(rs.getString("mobile_number"));
        c.setEmail(rs.getString("email"));
        c.setOccupation(rs.getString("occupation"));
        BigDecimal income = rs.getBigDecimal("annual_income");
        c.setAnnualIncome(income != null ? income.toString() : "0");
        c.setKycStatus(Customer.KYCStatus.valueOf(rs.getString("kyc_status")));
        c.setAccountNumber(rs.getString("account_number"));
        c.setRejectionReason(rs.getString("rejection_reason"));
        return c;
    }

    public void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
