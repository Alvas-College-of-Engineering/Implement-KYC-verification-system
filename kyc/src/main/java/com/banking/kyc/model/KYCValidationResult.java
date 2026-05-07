package com.banking.kyc.model;

import java.util.ArrayList;
import java.util.List;

public class KYCValidationResult {
    private boolean valid;
    private List<String> errors;
    private List<String> warnings;
    private List<ValidationCheck> checks;
    private String summary;

    public static class ValidationCheck {
        private String fieldName;
        private String displayName;
        private boolean passed;
        private String message;

        public ValidationCheck(String fieldName, String displayName, boolean passed, String message) {
            this.fieldName = fieldName;
            this.displayName = displayName;
            this.passed = passed;
            this.message = message;
        }

        public String getFieldName() { return fieldName; }
        public String getDisplayName() { return displayName; }
        public boolean isPassed() { return passed; }
        public String getMessage() { return message; }
    }

    public KYCValidationResult() {
        this.errors = new ArrayList<>();
        this.warnings = new ArrayList<>();
        this.checks = new ArrayList<>();
        this.valid = true;
    }

    public void addError(String error) {
        this.errors.add(error);
        this.valid = false;
    }

    public void addWarning(String warning) {
        this.warnings.add(warning);
    }

    public void addCheck(String fieldName, String displayName, boolean passed, String message) {
        this.checks.add(new ValidationCheck(fieldName, displayName, passed, message));
        if (!passed) {
            this.valid = false;
        }
    }

    public boolean isValid() { return valid; }
    public void setValid(boolean valid) { this.valid = valid; }
    public List<String> getErrors() { return errors; }
    public List<String> getWarnings() { return warnings; }
    public List<ValidationCheck> getChecks() { return checks; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public int getTotalChecks() { return checks.size(); }
    public long getPassedChecks() { return checks.stream().filter(ValidationCheck::isPassed).count(); }
    public long getFailedChecks() { return checks.stream().filter(c -> !c.isPassed()).count(); }
}