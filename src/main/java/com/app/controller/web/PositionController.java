package com.app.controller.web;

import com.app.dao.PositionDAO;
import com.app.model.Position;
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
import java.util.Date;
import java.util.List;

@WebServlet("/positions")
public class PositionController extends HttpServlet {

    private PositionDAO positionDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init(){
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
            listPosition(request, response);
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
                    deletePosition(request, response);
                    break;
                default:
                    listPosition(request, response);
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
            insertPosition(request, response);
        } else if ("update".equals(action)) {
            updatePosition(request, response);
        } else {
            listPosition(request, response);
        }
    }

    private void listPosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Position> position = positionDAO.getAllPosition();
        request.setAttribute("position", position);
        request.getRequestDispatcher("/WEB-INF/views/position/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/position/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Position position = positionDAO.getPositionById(id);
        request.setAttribute("position", position);
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/WEB-INF/views/position/form.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Position position = positionDAO.getPositionById(id);
        request.setAttribute("position", position);
        request.getRequestDispatcher("/WEB-INF/views/position/view.jsp").forward(request, response);
    }

    private void insertPosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Position position = new Position();
            position.setPositionId(request.getParameter("positionId"));
            position.setName(request.getParameter("name"));
            position.setDepartment(request.getParameter("department"));
            position.setCreatedAt(new Date());

            User user = (User) request.getSession().getAttribute("user");
            position.setCreatedBy(user.getUserId());

            positionDAO.createPosition(position);

            response.sendRedirect("positions?message=Position created successfully");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/position/form.jsp").forward(request, response);
        }
    }

    private void updatePosition(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Position position = new Position();
            position.setPositionId(request.getParameter("id"));
            position.setName(request.getParameter("name"));
            position.setDepartment(request.getParameter("department"));

            boolean success = positionDAO.updatePosition(position);

            if (success) {
                response.sendRedirect("positions?message=Position updated successfully");
            } else {
                request.setAttribute("error", "Failed to update position");
                request.getRequestDispatcher("/WEB-INF/views/position/form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/position/form.jsp").forward(request, response);
        }
    }

    private void deletePosition(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String id = request.getParameter("id");
        boolean success = positionDAO.deletePosition(id);

        if (success) {
            response.sendRedirect("positions?message=Position deleted successfully");
        } else {
            response.sendRedirect("positions?error=Failed to delete position");
        }
    }
}
