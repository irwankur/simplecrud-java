package com.app.controller.web;

import com.app.dao.EmployeeDAO;
import com.app.model.Employee;
import com.app.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/employees")
public class EmployeeController extends HttpServlet {

    private EmployeeDAO employeeDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if(action == null){
            listEmployee(request, response);
        } else {
            switch (action){
                case "new" :
                    showNewForm(request, response);
                    break;
                case "edit" :
                    showEditForm(request, response);
                    break;
                case "view" :
                    showViewForm(request, response);
                    break;
                case "delete" :
                    deleteEmployee(request, response);
                    break;
                default :
                    listEmployee(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            insertEmployee(request, response);
        } else if ("update".equals(action)) {
            updateEmployee(request, response);
        } else {
            listEmployee(request, response);
        }
    }

    private void listEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        List<Employee> employees = employeeDAO.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/WEB-INF/views/employee/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String id = request.getParameter("id");
        Employee employee = employeeDAO.getEmployeeById(id);
        request.setAttribute("employee", employee);
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String id = request.getParameter("id");
        Employee employee = employeeDAO.getEmployeeById(id);
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/employee/view.jsp").forward(request, response);
    }

    private void insertEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Employee employee = new Employee();
            employee.setEmployeeId(request.getParameter("employeeId"));
            employee.setFirstName(request.getParameter("firstName"));
            employee.setLastName(request.getParameter("lastName"));
            employee.setEmail(request.getParameter("email"));
            employee.setDepartment(request.getParameter("department"));
            employee.setPosition(request.getParameter("position"));
            employee.setSalary(new BigDecimal(request.getParameter("salary")));
            employee.setHireDate(dateFormat.parse(request.getParameter("hireDate")));
            employee.setPhone(request.getParameter("phone"));
            employee.setAddress(request.getParameter("address"));

            User user = (User) request.getSession().getAttribute("user");
            employee.setCreatedBy(user.getUserId());

            boolean success = employeeDAO.createEmployee(employee);

            if (success) {
                response.sendRedirect("employees?message=Employee Created Successfully");
            } else {
                request.setAttribute("error", "Invalid date format");
                request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
            }
        } catch (ParseException e){
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp");
        }

    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Employee employee = new Employee();
            employee.setEmployeeId(request.getParameter("id"));
            employee.setFirstName(request.getParameter("firstName"));
            employee.setLastName(request.getParameter("lastName"));
            employee.setEmail(request.getParameter("email"));
            employee.setDepartment(request.getParameter("department"));
            employee.setPosition(request.getParameter("position"));
            employee.setSalary(new BigDecimal(request.getParameter("salary")));
            employee.setHireDate(dateFormat.parse(request.getParameter("hireDate")));
            employee.setPhone(request.getParameter("phone"));
            employee.setAddress(request.getParameter("address"));

            boolean success = employeeDAO.updateEmployee(employee);

            if(success){
                response.sendRedirect("employees?message=Employee updated successfully");
            } else {
                request.setAttribute("error", "Failed to update employee");
                request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
            }
        } catch (ParseException e){
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String employeeId = request.getParameter("employeeId");
        String positionId = request.getParameter("positionId");
        boolean success = employeeDAO.deleteEmployee(employeeId, positionId);

        if(success) {
            response.sendRedirect("employees?message=Employee deleted successfully");
        } else {
            response.sendRedirect("employees?error=Failed to delete employee");
        }

    }

}
