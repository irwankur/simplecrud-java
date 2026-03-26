package com.app.controller.auth;

import com.app.dao.UserDAO;
import com.app.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        HttpSession session = request.getSession(false);

        if(session != null && session.getAttribute("user") != null){
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()){
            request.setAttribute("error", "Username and password are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        username = username.trim();
        password = password.trim();

        User user = userDAO.authenticate(username, password);

        if(user != null){

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());

            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {

            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
            dispatcher.forward(request, response);

        }

    }

}
