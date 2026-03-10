package com.app.controller.web;

import com.app.dao.EmployeeDAO;
import com.app.dao.UserDAO;
import com.app.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialException;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    private EmployeeDAO employeeDAO;
    private UserDAO userDAO;

    @Override
    public void init(){
        employeeDAO = new EmployeeDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try{
            List<?> employees = employeeDAO.getAllEmployees();
            List<User> users = userDAO.getAllUsers();

            int totalEmployees = employees != null ? employees.size() : 0;
            int totalUsers = users != null ? users.size() : 0;
            int activeUsers = 0;

            if(users != null){
                for(User u : users){
                    if(u.isActive()){
                        activeUsers++;
                    }
                }
            }

            double totalSalary = totalEmployees * 50000;

            request.setAttribute("user", user);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("totalSalary", totalSalary);

            NumberFormat numberFormat= NumberFormat.getInstance();
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
            request.setAttribute("numberFormat", numberFormat);
            request.setAttribute("currencyFormat", currencyFormat);

            String currentTime = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy HH:mm").format(new java.util.Date());
            request.setAttribute("currentTime", currentTime);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("error", "Unable to load dashboard data : " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/error/dashboard-error.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
