<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.User" %>
<%@ page import="com.app.dao.EmployeeDAO" %>
<%@ page import="com.app.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%
    // Check authentication
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }

    // Get statistics
    EmployeeDAO employeeDAO = new EmployeeDAO();
    UserDAO userDAO = new UserDAO();

    int totalEmployees = 0;
    int totalUsers = 0;
    double totalSalary = 0;
    int activeUsers = 0;

    try {
        List<?> employees = employeeDAO.getAllEmployees();
        List<User> users = userDAO.getAllUsers();

        totalEmployees = employees != null ? employees.size() : 0;
        totalUsers = users != null ? users.size() : 0;

        // Count active users
        if (users != null) {
            for (User u : users) {
                if (u.isActive()) {
                    activeUsers++;
                }
            }
        }

        // Calculate total salary (simplified)
        totalSalary = totalEmployees * 50000; // Example calculation

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Format numbers
    NumberFormat numberFormat = NumberFormat.getInstance();
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

    String currentTime = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy HH:mm").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Simple HR System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --info: #4895ef;
            --warning: #f72585;
            --danger: #e63946;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fb;
            color: #333;
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 3px 0 15px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }

        .logo {
            padding: 0 20px 30px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .logo p {
            font-size: 12px;
            opacity: 0.8;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            margin-bottom: 30px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            margin: 0 15px 30px;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 20px;
            color: var(--primary);
            margin-right: 15px;
        }

        .user-info h3 {
            font-size: 16px;
            margin-bottom: 5px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.8;
        }

        .role-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: bold;
            margin-top: 5px;
        }

        .role-admin {
            background-color: rgba(255, 193, 7, 0.2);
            color: #ffc107;
        }

        .role-user {
            background-color: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .nav-menu {
            padding: 0 15px;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 600;
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            margin-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
        }

        .logout-btn:hover {
            background: rgba(231, 57, 70, 0.2);
            color: #ff6b6b;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 20px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 15px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .page-title h2 {
            font-size: 24px;
            color: var(--dark);
            font-weight: 600;
        }

        .page-title p {
            color: var(--gray);
            font-size: 14px;
            margin-top: 5px;
        }

        .time-display {
            font-size: 14px;
            color: var(--gray);
            font-weight: 500;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 24px;
        }

        .icon-employee {
            background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%);
            color: white;
        }

        .icon-user {
            background: linear-gradient(135deg, #f72585 0%, #b5179e 100%);
            color: white;
        }

        .icon-salary {
            background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%);
            color: white;
        }

        .icon-active {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .stat-info h3 {
            font-size: 14px;
            color: var(--gray);
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-change {
            font-size: 12px;
            color: var(--success);
        }

        .stat-change.negative {
            color: var(--danger);
        }

        /* Quick Actions */
        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin: 40px 0 20px;
            color: var(--dark);
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--primary);
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
        }

        .action-card:hover {
            transform: translateY(-3px);
        }

        .action-card h4 {
            font-size: 18px;
            margin-bottom: 10px;
            color: var(--dark);
            display: flex;
            align-items: center;
        }

        .action-card h4 i {
            margin-right: 10px;
            color: var(--primary);
        }

        .action-card p {
            color: var(--gray);
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }

        .btn i {
            margin-right: 5px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: #3aa8d8;
            transform: translateY(-2px);
        }

        .btn-warning {
            background: var(--warning);
            color: white;
        }

        .btn-warning:hover {
            background: #e1156e;
            transform: translateY(-2px);
        }

        .btn-info {
            background: var(--info);
            color: white;
        }

        .btn-info:hover {
            background: #3a84e6;
            transform: translateY(-2px);
        }

        .btn-light {
            background: var(--light);
            color: var(--dark);
        }

        .btn-light:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        /* Recent Activity */
        .activity-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .activity-list {
            margin-top: 20px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            background: #f8f9fa;
            color: var(--primary);
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .activity-time {
            font-size: 12px;
            color: var(--gray);
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 20px;
            color: var(--gray);
            font-size: 14px;
            border-top: 1px solid #eee;
            margin-top: 40px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: visible;
            }

            .logo h1, .logo p, .user-info, .nav-link span {
                display: none;
            }

            .logo {
                padding: 10px;
            }

            .user-profile {
                justify-content: center;
                padding: 10px;
            }

            .user-avatar {
                margin-right: 0;
            }

            .nav-link {
                justify-content: center;
                padding: 15px;
            }

            .nav-link i {
                margin-right: 0;
                font-size: 18px;
            }

            .logout-btn span {
                display: none;
            }

            .main-content {
                margin-left: 70px;
            }
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .main-content {
                padding: 15px;
            }

            .top-bar {
                flex-direction: column;
                align-items: flex-start;
            }

            .time-display {
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h1><i class="fas fa-briefcase"></i> HR System</h1>
                <p>Simple Human Resources</p>
            </div>

            <div class="user-profile">
                <div class="user-avatar">
                    <%
                        String initials = "";
                        if (user.getFullName() != null) {
                            String[] names = user.getFullName().split(" ");
                            if (names.length > 0) {
                                initials = names[0].substring(0, 1).toUpperCase();
                                if (names.length > 1) {
                                    initials += names[names.length - 1].substring(0, 1).toUpperCase();
                                }
                            }
                        }
                    %>
                    <%= initials %>
                </div>
                <div class="user-info">
                    <h3><%= user.getFullName() %></h3>
                    <p>@<%= user.getUsername() %></p>
                    <span class="role-badge <%= "ADMIN".equals(user.getRole()) ? "role-admin" : "role-user" %>">
                        <i class="fas fa-<%= "ADMIN".equals(user.getRole()) ? "crown" : "user" %>"></i>
                        <%= user.getRole() %>
                    </span>
                </div>
            </div>

            <div class="nav-menu">
                <div class="nav-item">
                    <a href="dashboard" class="nav-link active">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="employees" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Employee</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="positions" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Position</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="employeePositions" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Employee Position</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="departments" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Department</span>
                    </a>
                </div>
                <% if ("ADMIN".equals(user.getRole())) { %>
                <div class="nav-item">
                    <a href="users" class="nav-link">
                        <i class="fas fa-user-cog"></i>
                        <span>User Management</span>
                    </a>
                </div>
                <% } %>
                <div class="nav-item">
                    <a href="profile.jsp" class="nav-link">
                        <i class="fas fa-user-circle"></i>
                        <span>My Profile</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="reports.jsp" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Reports</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="settings.jsp" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </div>

                <a href="logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-title">
                    <h2>Dashboard Overview</h2>
                    <p>Welcome back, <%= user.getFullName() %>! Here's what's happening today.</p>
                </div>
                <div class="time-display">
                    <i class="far fa-clock"></i> <%= currentTime %>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-employee">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Employees</h3>
                        <div class="stat-value"><%= numberFormat.format(totalEmployees) %></div>
                        <div class="stat-change">
                            <i class="fas fa-arrow-up"></i> +12% from last month
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon icon-user">
                        <i class="fas fa-user-friends"></i>
                    </div>
                    <div class="stat-info">
                        <h3>System Users</h3>
                        <div class="stat-value"><%= numberFormat.format(totalUsers) %></div>
                        <div class="stat-change">
                            <i class="fas fa-arrow-up"></i> +<%= activeUsers %> active
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon icon-salary">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Monthly Salary</h3>
                        <div class="stat-value"><%= currencyFormat.format(totalSalary) %></div>
                        <div class="stat-change">
                            <i class="fas fa-arrow-up"></i> +5.2% from last month
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon icon-active">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Users</h3>
                        <div class="stat-value"><%= activeUsers %></div>
                        <div class="stat-change negative">
                            <i class="fas fa-arrow-down"></i> 2 inactive
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h3 class="section-title">
                <i class="fas fa-bolt"></i> Quick Actions
            </h3>

            <div class="actions-grid">
                <div class="action-card">
                    <h4><i class="fas fa-user-plus"></i> Employee Management</h4>
                    <p>Add new employees, update information, or manage existing employee records in the system.</p>
                    <div class="action-buttons">
                        <a href="employees?action=new" class="btn btn-success">
                            <i class="fas fa-plus"></i> Add Employee
                        </a>
                        <a href="employees" class="btn btn-primary">
                            <i class="fas fa-list"></i> View All
                        </a>
                    </div>
                </div>

                <% if ("ADMIN".equals(user.getRole())) { %>
                <div class="action-card">
                    <h4><i class="fas fa-user-cog"></i> User Management</h4>
                    <p>Manage system users, assign roles, and control access permissions for your HR system.</p>
                    <div class="action-buttons">
                        <a href="users?action=new" class="btn btn-success">
                            <i class="fas fa-user-plus"></i> Add User
                        </a>
                        <a href="users" class="btn btn-primary">
                            <i class="fas fa-users-cog"></i> Manage Users
                        </a>
                    </div>
                </div>
                <% } %>

                <div class="action-card">
                    <h4><i class="fas fa-chart-line"></i> Reports & Analytics</h4>
                    <p>Generate detailed reports, view analytics, and export data for payroll and management.</p>
                    <div class="action-buttons">
                        <a href="reports.jsp" class="btn btn-info">
                            <i class="fas fa-chart-pie"></i> View Reports
                        </a>
                        <a href="export.jsp" class="btn btn-light">
                            <i class="fas fa-file-export"></i> Export Data
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <h3 class="section-title">
                <i class="fas fa-history"></i> Recent Activity
            </h3>

            <div class="activity-card">
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">New employee added</div>
                            <div class="activity-time">John Doe was added to the IT department - 2 hours ago</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Payroll processed</div>
                            <div class="activity-time">Monthly payroll for <%= totalEmployees %> employees completed - Yesterday</div>
                        </div>
                    </div>

                    <% if ("ADMIN".equals(user.getRole())) { %>
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">User permission updated</div>
                            <div class="activity-time">Admin privileges granted to <%= user.getFullName() %> - 3 days ago</div>
                        </div>
                    </div>
                    <% } %>

                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-database"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">System backup completed</div>
                            <div class="activity-time">Automatic database backup was successful - 1 week ago</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Info -->
            <h3 class="section-title">
                <i class="fas fa-info-circle"></i> System Information
            </h3>

            <div class="actions-grid">
                <div class="action-card">
                    <h4><i class="fas fa-server"></i> System Status</h4>
                    <p>
                        <strong>Database:</strong> Connected<br>
                        <strong>Users Online:</strong> 1<br>
                        <strong>Last Backup:</strong> Today, 02:00 AM<br>
                        <strong>Uptime:</strong> 99.8%
                    </p>
                    <div class="action-buttons">
                        <a href="system-status.jsp" class="btn btn-light">
                            <i class="fas fa-heartbeat"></i> System Health
                        </a>
                    </div>
                </div>

                <div class="action-card">
                    <h4><i class="fas fa-user-circle"></i> Your Account</h4>
                    <p>
                        <strong>Username:</strong> <%= user.getUsername() %><br>
                        <strong>Email:</strong> <%= user.getEmail() %><br>
                        <strong>Role:</strong> <%= user.getRole() %><br>
                        <strong>Status:</strong> <span style="color: <%= user.isActive() ? "#28a745" : "#dc3545" %>">
                            <%= user.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </p>
                    <div class="action-buttons">
                        <a href="profile.jsp" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                        <a href="change-password.jsp" class="btn btn-warning">
                            <i class="fas fa-key"></i> Change Password
                        </a>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="footer">
                <p>
                    &copy; 2024 Simple HR System v1.0 |
                    Logged in as: <strong><%= user.getUsername() %></strong> |
                    Session: <%= session.getId().substring(0, 8) %>... |
                    <a href="help.jsp" style="color: var(--primary); text-decoration: none;">Help & Support</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        // Add active class to current nav item
        document.addEventListener('DOMContentLoaded', function() {
            const currentPage = window.location.pathname.split('/').pop() || 'dashboard';
            const navLinks = document.querySelectorAll('.nav-link');

            navLinks.forEach(link => {
                const href = link.getAttribute('href');
                if (href === currentPage || (currentPage === '' && href === 'dashboard')) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            });

            // Update time every minute
            function updateTime() {
                const now = new Date();
                const options = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                };
                const timeStr = now.toLocaleDateString('en-US', options);
                document.querySelector('.time-display').innerHTML =
                    `<i class="far fa-clock"></i> ${timeStr}`;
            }

            updateTime();
            setInterval(updateTime, 60000);

            // Add hover effects to cards
            const cards = document.querySelectorAll('.stat-card, .action-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });

                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Logout confirmation
            document.querySelector('.logout-btn').addEventListener('click', function(e) {
                if (!confirm('Are you sure you want to logout?')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>