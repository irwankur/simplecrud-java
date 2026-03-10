package com.app.controller.web;

import com.app.dao.DepartmentDAO;
import com.app.dao.EmployeeDAO;
import com.app.exception.RecordException;
import com.app.model.Department;
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
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;


@WebServlet("/departments")
public class DepartmentController extends HttpServlet {

    private DepartmentDAO departmentDAO;

    @Override
    public void init(){
        departmentDAO = new DepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if(action == null){
            listDepartment(request, response);
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
                    deleteDepartment(request, response);
                    break;
                default :
                    listDepartment(request, response);
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
            insertDeparment(request, response);
        } else if ("update".equals(action)) {
            updateDepartment(request, response);
        } else {
            listDepartment(request, response);
        }
    }

    private void listDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/department/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/department/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String id = request.getParameter("id");
        Department department = departmentDAO.getDepartmentById(id);
        request.setAttribute("department", department);
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/WEB-INF/views/department/form.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String id = request.getParameter("id");
        Department department = departmentDAO.getDepartmentById(id);
        request.setAttribute("department", department);
        request.getRequestDispatcher("/WEB-INF/views/department/view.jsp").forward(request, response);
    }

    private void insertDeparment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        try {
            Department department = new Department();
            department.setDepartmentId(request.getParameter("departmentId"));
            department.setName(request.getParameter("name"));

            User user = (User) request.getSession().getAttribute("user");
            department.setCreatedBy(user.getUserId());

            boolean success = departmentDAO.createDepartment(department);

            if (success) {
                response.sendRedirect("departments?message=Department Created Successfully");
            } else {
                request.setAttribute("error", "Invalid date format");
                request.getRequestDispatcher("/WEB-INF/views/department/form.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("/WEB-INF/views/department/form.jsp")
                    .forward(request, response);
        }

    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Department department = new Department();
            department.setDepartmentId(request.getParameter("departmentId"));
            department.setName(request.getParameter("name"));

            boolean success = departmentDAO.updateDepartment(department);

            if (success) {
                response.sendRedirect("departments?message=Department updated successfully");
            } else {
                request.setAttribute("error", "Failed to update department");
                request.getRequestDispatcher("/WEB-INF/views/department/form.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/department/form.jsp").forward(request, response);
        }
    }


    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String departmentId = request.getParameter("departmentId");
        boolean success = departmentDAO.deleteDepartment(departmentId);

        if(success) {
            response.sendRedirect("departments?message=Department deleted successfully");
        } else {
            response.sendRedirect("departments?error=Failed to delete Department");
        }

    }


}
