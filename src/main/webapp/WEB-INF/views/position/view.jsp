<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.company.model.Employee" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%
    Employee employee = (Employee) request.getAttribute("employee");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    SimpleDateFormat timestampFormat = new SimpleDateFormat("MMMM dd, yyyy HH:mm:ss");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

    if (employee == null) {
        response.sendRedirect("employees");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Employee</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 30px;
        }
        .employee-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: bold;
            margin-right: 30px;
        }
        .employee-info h2 {
            margin: 0;
            color: #333;
        }
        .employee-info p {
            margin: 5px 0;
            color: #666;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            border-left: 4px solid #007bff;
        }
        .info-card h3 {
            margin-top: 0;
            color: #495057;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .info-item {
            margin-bottom: 10px;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            display: inline-block;
            width: 150px;
        }
        .info-value {
            color: #333;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-warning {
            background-color: #ffc107;
            color: black;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-department {
            background-color: #e9ecef;
            color: #495057;
        }
        .badge-position {
            background-color: #d1ecf1;
            color: #0c5460;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Employee Details</h1>

        <div class="employee-header">
            <div class="avatar">
                <%= employee.getFirstName().charAt(0) %><%= employee.getLastName().charAt(0) %>
            </div>
            <div class="employee-info">
                <h2><%= employee.getFirstName() %> <%= employee.getLastName() %></h2>
                <p><%= employee.getPosition() %> • <%= employee.getDepartment() %> Department</p>
                <p>Employee ID: #<%= String.format("%04d", employee.getEmployeeId()) %></p>
            </div>
        </div>

        <div class="info-grid">
            <!-- Personal Information -->
            <div class="info-card">
                <h3>Personal Information</h3>
                <div class="info-item">
                    <span class="info-label">Full Name:</span>
                    <span class="info-value"><%= employee.getFirstName() %> <%= employee.getLastName() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email:</span>
                    <span class="info-value"><%= employee.getEmail() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Phone:</span>
                    <span class="info-value"><%= employee.getPhone() != null ? employee.getPhone() : "N/A" %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Address:</span>
                    <span class="info-value"><%= employee.getAddress() != null ? employee.getAddress() : "N/A" %></span>
                </div>
            </div>

            <!-- Employment Information -->
            <div class="info-card">
                <h3>Employment Information</h3>
                <div class="info-item">
                    <span class="info-label">Department:</span>
                    <span class="info-value badge badge-department"><%= employee.getDepartment() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Position:</span>
                    <span class="info-value badge badge-position"><%= employee.getPosition() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Salary:</span>
                    <span class="info-value"><%= currencyFormat.format(employee.getSalary()) %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Hire Date:</span>
                    <span class="info-value"><%= dateFormat.format(employee.getHireDate()) %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Tenure:</span>
                    <span class="info-value">
                        <%
                            long diff = System.currentTimeMillis() - employee.getHireDate().getTime();
                            long years = diff / (1000L * 60 * 60 * 24 * 365);
                            long months = (diff % (1000L * 60 * 60 * 24 * 365)) / (1000L * 60 * 60 * 24 * 30);
                            if (years > 0) {
                                out.print(years + " year" + (years > 1 ? "s" : ""));
                                if (months > 0) {
                                    out.print(", " + months + " month" + (months > 1 ? "s" : ""));
                                }
                            } else {
                                out.print(months + " month" + (months > 1 ? "s" : ""));
                            }
                        %>
                    </span>
                </div>
            </div>
        </div>

        <!-- System Information -->
        <div class="info-card">
            <h3>System Information</h3>
            <div class="info-item">
                <span class="info-label">Record Created:</span>
                <span class="info-value"><%= timestampFormat.format(employee.getCreatedAt()) %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Last Updated:</span>
                <span class="info-value"><%= timestampFormat.format(employee.getUpdatedAt()) %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Record ID:</span>
                <span class="info-value">EMP-<%= String.format("%06d", employee.getEmployeeId()) %></span>
            </div>
        </div>

        <div class="button-group">
            <a href="employees?action=edit&id=<%= employee.getEmployeeId() %>" class="btn btn-warning">Edit Employee</a>
            <a href="employees" class="btn btn-secondary">Back to List</a>
            <a href="dashboard" class="btn btn-primary">Go to Dashboard</a>
        </div>
    </div>
</body>
</html>