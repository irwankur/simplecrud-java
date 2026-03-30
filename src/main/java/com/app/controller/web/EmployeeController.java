package com.app.controller.web;

import com.app.dao.EmployeeDAO;
import com.app.model.Employee;
import com.app.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.UUID;

@WebServlet("/employees")
@MultipartConfig
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

            Part filePart = request.getPart("foto");

            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {

                // ambil nama file original + bersihkan path
                String originalFileName = Paths.get(filePart.getSubmittedFileName())
                        .getFileName()
                        .toString();

                fileName = UUID.randomUUID() + "_" + originalFileName;

                String uploadPath = "D:/APPS/STORAGE/SIMPLECRUD/profil";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);
            }

            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("File kosong!");
            }

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

            employeeDAO.createEmployee(employee);

            response.sendRedirect("employees?message=Employee Created Successfully");

        } catch (ParseException e){

            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp");

        } catch (RuntimeException e) {

            request.setAttribute("error", "Failed to insert employee: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp")
                    .forward(request, response);
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
