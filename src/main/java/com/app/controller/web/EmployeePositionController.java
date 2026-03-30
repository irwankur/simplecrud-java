package com.app.controller.web;

import com.app.dao.EmployeeDAO;
import com.app.dao.EmployeePositionDAO;
import com.app.dao.PositionDAO;
import com.app.exception.RecordException;
import com.app.model.Employee;
import com.app.model.EmployeePosition;
import com.app.model.Position;
import com.app.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/employeePositions")
public class EmployeePositionController extends HttpServlet {

    private EmployeePositionDAO employeePositionDAO;
    private EmployeeDAO employeeDAO;
    private PositionDAO positionDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init(){
        employeePositionDAO = new EmployeePositionDAO();
        employeeDAO = new EmployeeDAO();
        positionDAO = new PositionDAO();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            listEmployeePosition(request, response);
        } else {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    showViewForm(request, response);
                    break;
                case "delete":
                    deleteEmployeePosition(request, response);
                    break;
                default:
                    listEmployeePosition(request, response);
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
            insertEmployeePosition(request, response);
        } else if ("update".equals(action)) {
            updateEmployeePosition(request, response);
        } else {
            listEmployeePosition(request, response);
        }
    }

    private void listEmployeePosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<EmployeePosition> employeePosition = employeePositionDAO.getAllEmployeePosition();
        request.setAttribute("employeePositions", employeePosition);
        request.getRequestDispatcher("/WEB-INF/views/employeePosition/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Employee> employees = employeeDAO.getAllEmployees();
        List<Position> positions = positionDAO.getAllPosition();

        request.setAttribute("employees", employees);
        request.setAttribute("positions", positions);

        request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String employeeId = request.getParameter("employeeId");
        String positionId = request.getParameter("positionId");
        EmployeePosition employeePosition = employeePositionDAO.getEmployeePositionById(employeeId, positionId);
        List<Employee> employee = employeeDAO.getAllEmployees();
        List<Position> position = positionDAO.getAllPosition();
        request.setAttribute("employeePosition", employeePosition);
        request.setAttribute("employees", employee);
        request.setAttribute("positions", position);
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String employeeId = request.getParameter("employeeId");
        String positionId = request.getParameter("positionId");
        EmployeePosition employeePosition = employeePositionDAO.getEmployeePositionById(employeeId, positionId);
        request.setAttribute("employeePosition", employeePosition);
        request.getRequestDispatcher("/WEB-INF/views/employeePosition/view.jsp").forward(request, response);
    }

    private void insertEmployeePosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            EmployeePosition employeePosition = new EmployeePosition();

            employeePosition.setEmployeeId(request.getParameter("employeeId"));
            employeePosition.setPositionId(request.getParameter("positionId"));

            String validFromStr = request.getParameter("validFrom");
            String validToStr = request.getParameter("validTo");

            if (validFromStr == null || validFromStr.isEmpty()) {
                throw new RecordException("Valid From wajib diisi");
            }

            employeePosition.setValidFrom(dateFormat.parse(validFromStr));
            employeePosition.setValidTo(dateFormat.parse(validToStr));

            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            employeePosition.setCreatedBy(user.getUserId());

            boolean success = employeePositionDAO.createEmployeePosition(employeePosition);

            if (success) {
                response.sendRedirect("employeePositions?message=Employee Position created successfully");
            } else {
                request.setAttribute("error", "Failed to create position");
                request.setAttribute("employeePosition", employeePosition);
                request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp")
                    .forward(request, response);
        }
    }

    private void updateEmployeePosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            EmployeePosition employeePosition = new EmployeePosition();
            employeePosition.setEmployeeId(request.getParameter("employeeId"));
            employeePosition.setPositionId(request.getParameter("positionId"));
            employeePosition.setValidFrom(dateFormat.parse(request.getParameter("validFrom")));
            employeePosition.setValidTo(dateFormat.parse(request.getParameter("validTo")));

            boolean success = employeePositionDAO.updateEmployeePosition(employeePosition);

            if (success) {
                response.sendRedirect("employeePositions?message=Employee Position updated successfully");
            } else {
                request.setAttribute("error", "Failed to update position");
                request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/employeePosition/form.jsp").forward(request, response);
        }
    }

    private void deleteEmployeePosition(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String employee_id = request.getParameter("employeeId");
        String position_id = request.getParameter("positionId");
        boolean success = employeePositionDAO.deleteEmployeePosition(employee_id, position_id);

        if (success) {
            response.sendRedirect("employeePositions?message=Employee position deleted successfully");
        } else {
            response.sendRedirect("employeePositions?error=Failed to delete employee position");
        }
    }

}
