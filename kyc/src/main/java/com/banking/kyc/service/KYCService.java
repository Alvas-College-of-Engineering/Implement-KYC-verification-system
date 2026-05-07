package com.banking.kyc.service;

import com.banking.kyc.model.BankAccount;
import com.banking.kyc.model.Customer;
import com.banking.kyc.model.KYCValidationResult;
import com.banking.kyc.services.DatabaseService;
import com.banking.kyc.util.IDGenerator;
import com.banking.kyc.validator.KYCValidator;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * KYCService - Business logic layer for KYC processing.
 * Orchestrates validation, ID generation, account creation, and persistence.
 */
public class KYCService {

    private final KYCValidator validator;
    private final DatabaseService dbService;

    public KYCService() {
        this.validator = new KYCValidator();
        this.dbService = DatabaseService.getInstance();
    }

    // -----------------------------------------------------------------------
    // Inner result class expected by both servlets
    // -----------------------------------------------------------------------

    public static class KYCProcessResult {
        private final boolean success;
        private final String message;
        private final Customer customer;
        private final BankAccount account;
        private final KYCValidationResult validationResult;

        public KYCProcessResult(boolean success, String message,
                Customer customer, BankAccount account,
                KYCValidationResult validationResult) {
            this.success = success;
            this.message = message;
            this.customer = customer;
            this.account = account;
            this.validationResult = validationResult;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Customer getCustomer() { return customer; }
        public BankAccount getAccount() { return account; }
        public KYCValidationResult getValidationResult() { return validationResult; }
    }

    // -----------------------------------------------------------------------
    // Core KYC processing
    // -----------------------------------------------------------------------

    public KYCProcessResult processKYC(Customer customer) {
        // 1. Assign generated IDs
        customer.setCustomerId(IDGenerator.generateCustomerId());

        // 2. Validate
        KYCValidationResult validation = validator.validate(customer);

        BankAccount account = null;

        if (validation.isValid()) {
            // 3a. KYC passed — create account
            customer.setKycStatus(Customer.KYCStatus.VERIFIED);
            account = new BankAccount(customer.getCustomerId(), BankAccount.AccountType.SAVINGS);
            account.setAccountNumber(IDGenerator.generateAccountNumber());
            customer.setAccountNumber(account.getAccountNumber());

            // 4. Persist to DB
            try {
                dbService.saveCustomer(customer, account, validation);
            } catch (SQLException e) {
                // Log and continue — don't crash the user experience
                System.err.println("[KYCService] DB save failed: " + e.getMessage());
            }

            return new KYCProcessResult(true,
                    "Your KYC verification was successful. Your account has been created.",
                    customer, account, validation);
        } else {
            // 3b. KYC failed
            customer.setKycStatus(Customer.KYCStatus.REJECTED);
            String reason = String.join("; ", validation.getErrors());
            customer.setRejectionReason(reason.isEmpty() ? "Validation checks failed" : reason);

            // 4. Persist rejected record
            try {
                dbService.saveCustomer(customer, null, validation);
            } catch (SQLException e) {
                System.err.println("[KYCService] DB save failed: " + e.getMessage());
            }

            return new KYCProcessResult(false,
                    "KYC verification failed. Please review the errors and resubmit.",
                    customer, null, validation);
        }
    }

    // -----------------------------------------------------------------------
    // Admin / reporting methods
    // -----------------------------------------------------------------------

    public List<Customer> getAllCustomers() {
        try {
            return dbService.getAllCustomers();
        } catch (SQLException e) {
            System.err.println("[KYCService] getAllCustomers failed: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public Map<String, Object> getStatistics() {
        try {
            return dbService.getStatistics();
        } catch (SQLException e) {
            System.err.println("[KYCService] getStatistics failed: " + e.getMessage());
            // Return zeroed-out map so the UI still renders
            Map<String, Object> empty = new LinkedHashMap<>();
            empty.put("total", 0);
            empty.put("verified", 0);
            empty.put("rejected", 0);
            empty.put("pending", 0);
            empty.put("under_review", 0);
            return empty;
        }
    }
}
