package com.banking.kyc.controller;

import com.banking.kyc.model.Customer;
import com.banking.kyc.service.KYCService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "KYCControllerServlet", urlPatterns = {"/kyc", "/submit-kyc"})
public class KYCControllerServlet extends HttpServlet {

    private KYCService kycService;

    @Override
    public void init() throws ServletException {
        kycService = new KYCService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/kyc-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Collect form data
        Customer customer = new Customer();
        customer.setFullName(request.getParameter("fullName"));
        customer.setDateOfBirth(request.getParameter("dateOfBirth"));
        customer.setIdProofType(request.getParameter("idProofType"));
        customer.setIdProofNumber(request.getParameter("idProofNumber"));
        customer.setAddress(request.getParameter("address"));
        customer.setCity(request.getParameter("city"));
        customer.setState(request.getParameter("state"));
        customer.setPinCode(request.getParameter("pinCode"));
        customer.setMobileNumber(request.getParameter("mobileNumber"));
        customer.setEmail(request.getParameter("email"));
        customer.setOccupation(request.getParameter("occupation"));
        customer.setAnnualIncome(request.getParameter("annualIncome"));

        // Process KYC
        KYCService.KYCProcessResult result = kycService.processKYC(customer);

        // Set attributes for result.jsp
        request.setAttribute("result",     result);
        request.setAttribute("customer",   result.getCustomer());
        request.setAttribute("validation", result.getValidationResult());

        if (result.isSuccess()) {
            request.setAttribute("account", result.getAccount());
        }

        request.getRequestDispatcher("/result.jsp").forward(request, response);
    }
}
