<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Employee" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-warning {
            background-color: #ffc107;
            color: black;
        }
        .btn-info {
            background-color: #17a2b8;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-cell {
            display: flex;
            gap: 5px;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .logout {
            float: right;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Employee Management</h1>
            <div>
                <a href="dashboard" class="btn">Dashboard</a>
                <a href="users" class="btn btn-info">Manage Users</a>
                <a href="logout" class="btn btn-danger logout">Logout</a>
            </div>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>Employee List</h2>
            <a href="employees?action=new" class="btn btn-success">Add New Employee</a>
        </div>

        <% if (request.getParameter("message") != null) { %>
            <div class="message success"><%= request.getParameter("message") %></div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="message error"><%= request.getParameter("error") %></div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Position</th>
                    <th>Salary</th>
                    <th>Hire Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                if (employees != null && !employees.isEmpty()) {
                    for (Employee emp : employees) {
                %>
                <tr>
                    <td><%= emp.getEmployeeId() %></td>
                    <td><%= emp.getFirstName() %> <%= emp.getLastName() %></td>
                    <td><%= emp.getEmail() %></td>
                    <td><%= emp.getDepartment() %></td>
                    <td><%= emp.getPosition() %></td>
                    <td>$<%= emp.getSalary() %></td>
                    <td><%= emp.getHireDate() %></td>
                    <td class="action-cell">
                        <a href="employees?action=view&id=<%= emp.getEmployeeId() %>" class="btn btn-info">View</a>
                        <a href="employees?action=edit&id=<%= emp.getEmployeeId() %>" class="btn btn-warning">Edit</a>
                        <a href="employees?action=delete&id=<%= emp.getEmployeeId() %>"
                           class="btn btn-danger"
                           onclick="return confirm('Are you sure you want to delete this employee?')">Delete</a>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="8" style="text-align: center;">No employees found.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div