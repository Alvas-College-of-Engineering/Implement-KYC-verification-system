/**
 * KYC Form Validation Script
 * Client-side validation for KYC application form
 */

// Validation patterns
const PATTERNS = {
    NAME: /^[A-Za-z]+(\s[A-Za-z]+){1,4}$/,
    MOBILE: /^[6-9]\d{9}$/,
    EMAIL: /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/,
    PINCODE: /^[1-9][0-9]{5}$/,
    AADHAAR: /^[2-9]\d{11}$/,
    PAN: /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/,
    PASSPORT: /^[A-Z]{1}[0-9]{7}$/,
    VOTER_ID: /^[A-Z]{3}[0-9]{7}$/
};

// ID validation rules
const ID_VALIDATORS = {
    AADHAAR: (value) => PATTERNS.AADHAAR.test(value),
    PAN: (value) => PATTERNS.PAN.test(value),
    PASSPORT: (value) => PATTERNS.PASSPORT.test(value),
    VOTER_ID: (value) => PATTERNS.VOTER_ID.test(value),
    DRIVING_LICENSE: (value) => value.length >= 10
};

// Initialize form validation when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('kycForm');
    
    if (form) {
        // Add input event listeners for real-time validation
        const fullName = document.getElementById('fullName');
        const dateOfBirth = document.getElementById('dateOfBirth');
        const mobileNumber = document.getElementById('mobileNumber');
        const email = document.getElementById('email');
        const pinCode = document.getElementById('pinCode');
        const idProofType = document.getElementById('idProofType');
        const idProofNumber = document.getElementById('idProofNumber');
        
        if (fullName) fullName.addEventListener('input', () => validateFullName());
        if (dateOfBirth) dateOfBirth.addEventListener('change', () => validateDOB());
        if (mobileNumber) mobileNumber.addEventListener('input', () => validateMobile());
        if (email) email.addEventListener('input', () => validateEmail());
        if (pinCode) pinCode.addEventListener('input', () => validatePinCode());
        if (idProofType) idProofType.addEventListener('change', () => validateIDProof());
        if (idProofNumber) idProofNumber.addEventListener('input', () => validateIDProof());
        
        // Form submission handler
        form.addEventListener('submit', function(e) {
            let isValid = true;
            
            isValid &= validateFullName();
            isValid &= validateDOB();
            isValid &= validateMobile();
            isValid &= validateEmail();
            isValid &= validatePinCode();
            isValid &= validateIDProof();
            isValid &= validateGender();
            isValid &= validateAddress();
            isValid &= validateCity();
            isValid &= validateState();
            isValid &= validateOccupation();
            isValid &= validateAnnualIncome();
            
            if (!isValid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = document.querySelector('.error-message.show');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            } else {
                // Show loading overlay
                const loading = document.getElementById('loading');
                if (loading) {
                    loading.classList.add('show');
                }
            }
        });
        
        // Input formatting
        if (mobileNumber) {
            mobileNumber.addEventListener('input', function(e) {
                this.value = this.value.replace(/\D/g, '').slice(0, 10);
            });
        }
        
        if (pinCode) {
            pinCode.addEventListener('input', function(e) {
                this.value = this.value.replace(/\D/g, '').slice(0, 6);
            });
        }
        
        if (idProofNumber) {
            idProofNumber.addEventListener('input', function(e) {
                this.value = this.value.toUpperCase();
            });
        }
    }
});

// Validation functions
function validateFullName() {
    const input = document.getElementById('fullName');
    const error = document.getElementById('fullNameError');
    
    if (!input || !error) return true;
    
    const value = input.value.trim();
    
    if (value.length === 0) {
        showError(error, 'Full name is required');
        return false;
    } else if (value.length < 3) {
        showError(error, 'Name must be at least 3 characters');
        return false;
    } else if (!PATTERNS.NAME.test(value)) {
        showError(error, 'Please enter first and last name (letters only)');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateDOB() {
    const input = document.getElementById('dateOfBirth');
    const error = document.getElementById('dobError');
    
    if (!input || !error) return true;
    
    const value = input.value;
    
    if (!value) {
        showError(error, 'Date of birth is required');
        return false;
    }
    
    const birthDate = new Date(value);
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }
    
    if (age < 18) {
        showError(error, `You must be at least 18 years old. Current age: ${age}`);
        return false;
    } else if (age > 100) {
        showError(error, `Age ${age} exceeds maximum allowed (100 years)`);
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateMobile() {
    const input = document.getElementById('mobileNumber');
    const error = document.getElementById('mobileError');
    
    if (!input || !error) return true;
    
    const value = input.value.trim();
    
    if (!value) {
        showError(error, 'Mobile number is required');
        return false;
    } else if (!PATTERNS.MOBILE.test(value)) {
        showError(error, 'Invalid mobile number (10 digits, starts with 6-9)');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateEmail() {
    const input = document.getElementById('email');
    const error = document.getElementById('emailError');
    
    if (!input || !error) return true;
    
    const value = input.value.trim();
    
    if (!value) {
        showError(error, 'Email address is required');
        return false;
    } else if (!PATTERNS.EMAIL.test(value)) {
        showError(error, 'Invalid email format (e.g., name@example.com)');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validatePinCode() {
    const input = document.getElementById('pinCode');
    const error = document.getElementById('pinError');
    
    if (!input || !error) return true;
    
    const value = input.value.trim();
    
    if (!value) {
        showError(error, 'PIN code is required');
        return false;
    } else if (!PATTERNS.PINCODE.test(value)) {
        showError(error, 'Invalid PIN code (6 digits, cannot start with 0)');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateIDProof() {
    const idType = document.getElementById('idProofType');
    const idNumber = document.getElementById('idProofNumber');
    const error = document.getElementById('idError');
    
    if (!idType || !idNumber || !error) return true;
    
    const type = idType.value;
    const number = idNumber.value.trim().toUpperCase();
    
    if (!type) {
        showError(error, 'Please select an ID proof type');
        return false;
    }
    
    if (!number) {
        showError(error, 'ID proof number is required');
        return false;
    }
    
    const validator = ID_VALIDATORS[type];
    if (validator && !validator(number)) {
        let message = 'Invalid ID number format';
        switch(type) {
            case 'AADHAAR':
                message = 'Invalid Aadhaar (12 digits, starts with 2-9)';
                break;
            case 'PAN':
                message = 'Invalid PAN (Format: ABCDE1234F)';
                break;
            case 'PASSPORT':
                message = 'Invalid Passport (Format: A1234567)';
                break;
            case 'VOTER_ID':
                message = 'Invalid Voter ID (Format: ABC1234567)';
                break;
            case 'DRIVING_LICENSE':
                message = 'Invalid Driving License number';
                break;
        }
        showError(error, message);
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateGender() {
    const input = document.getElementById('gender');
    if (!input) return true;
    
    if (!input.value) {
        // Create error element if not exists
        let error = document.getElementById('genderError');
        if (!error) {
            error = document.createElement('div');
            error.id = 'genderError';
            error.className = 'error-message';
            input.parentNode.appendChild(error);
        }
        showError(error, 'Please select gender');
        return false;
    } else {
        const error = document.getElementById('genderError');
        if (error) hideError(error);
        return true;
    }
}

function validateAddress() {
    const input = document.getElementById('address');
    if (!input) return true;
    
    const value = input.value.trim();
    let error = document.getElementById('addressError');
    
    if (!error) {
        error = document.createElement('div');
        error.id = 'addressError';
        error.className = 'error-message';
        input.parentNode.appendChild(error);
    }
    
    if (!value) {
        showError(error, 'Address is required');
        return false;
    } else if (value.length < 10) {
        showError(error, 'Address must be at least 10 characters');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateCity() {
    const input = document.getElementById('city');
    if (!input) return true;
    
    const value = input.value.trim();
    let error = document.getElementById('cityError');
    
    if (!error) {
        error = document.createElement('div');
        error.id = 'cityError';
        error.className = 'error-message';
        input.parentNode.appendChild(error);
    }
    
    if (!value) {
        showError(error, 'City is required');
        return false;
    } else if (value.length < 2) {
        showError(error, 'City name is too short');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateState() {
    const input = document.getElementById('state');
    if (!input) return true;
    
    let error = document.getElementById('stateError');
    
    if (!error) {
        error = document.createElement('div');
        error.id = 'stateError';
        error.className = 'error-message';
        input.parentNode.appendChild(error);
    }
    
    if (!input.value) {
        showError(error, 'Please select state');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateOccupation() {
    const input = document.getElementById('occupation');
    if (!input) return true;
    
    let error = document.getElementById('occupationError');
    
    if (!error) {
        error = document.createElement('div');
        error.id = 'occupationError';
        error.className = 'error-message';
        input.parentNode.appendChild(error);
    }
    
    if (!input.value) {
        showError(error, 'Please select occupation');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

function validateAnnualIncome() {
    const input = document.getElementById('annualIncome');
    if (!input) return true;
    
    const value = parseFloat(input.value);
    let error = document.getElementById('incomeError');
    
    if (!error) {
        error = document.createElement('div');
        error.id = 'incomeError';
        error.className = 'error-message';
        input.parentNode.appendChild(error);
    }
    
    if (isNaN(value)) {
        showError(error, 'Annual income is required');
        return false;
    } else if (value < 0) {
        showError(error, 'Annual income cannot be negative');
        return false;
    } else {
        hideError(error);
        return true;
    }
}

// Helper functions
function showError(element, message) {
    element.textContent = message;
    element.classList.add('show');
}

function hideError(element) {
    element.textContent = '';
    element.classList.remove('show');
}

// Export functions for global use
window.validateForm = function() {
    return validateFullName() && validateDOB() && validateMobile() && 
           validateEmail() && validatePinCode() && validateIDProof() &&
           validateGender() && validateAddress() && validateCity() &&
           validateState() && validateOccupation() && validateAnnualIncome();
};