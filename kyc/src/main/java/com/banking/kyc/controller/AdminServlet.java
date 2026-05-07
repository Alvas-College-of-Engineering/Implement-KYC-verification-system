package com.banking.kyc.controller;

import com.banking.kyc.model.Customer;
import com.banking.kyc.service.KYCService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/view-customers", "/stats", "/api/stats"})
public class AdminServlet extends HttpServlet {

    private KYCService kycService;

    @Override
    public void init() throws ServletException {
        kycService = new KYCService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/admin":
                request.getRequestDispatcher("/admin/dashboard.jsp")
                       .forward(request, response);
                break;

            case "/view-customers":
                List<Customer> customers = kycService.getAllCustomers();
                request.setAttribute("customers", customers);
                request.getRequestDispatcher("/admin/customers.jsp")
                       .forward(request, response);
                break;

            case "/stats":
                request.getRequestDispatcher("/admin/stats.jsp")
                       .forward(request, response);
                break;

            case "/api/stats":
                Map<String, Object> stats = kycService.getStatistics();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.print(toJson(stats));
                    out.flush();
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    /** Minimal JSON serialiser — avoids a Jackson dependency for this simple map. */
    private String toJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        int i = 0;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (i++ > 0) sb.append(',');
            sb.append('"').append(entry.getKey()).append('"').append(':');
            Object v = entry.getValue();
            if (v instanceof String) {
                sb.append('"').append(v).append('"');
            } else {
                sb.append(v);   // numbers / booleans
            }
        }
        sb.append('}');
        return sb.toString();
    }
}
