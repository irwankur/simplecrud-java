<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Employee" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="container-fluid">

    <!-- Page Title -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 text-gray-800">
            Employee Management
        </h1>

        <a href="employees?action=new"
           class="btn btn-primary btn-sm shadow-sm">

            <i class="fas fa-plus fa-sm text-white-50"></i>
            Add Employee

        </a>
    </div>

    <!-- Message -->
    <% if (request.getParameter("message") != null) { %>
        <div class="alert alert-success">
            <%= request.getParameter("message") %>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <!-- Table Card -->
    <div class="card shadow mb-4">

        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">
                Employee List
            </h6>
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-bordered table-hover"
                       id="dataTable"
                       width="100%"
                       cellspacing="0">

                    <thead>

                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Department</th>
                            <th>Position</th>
                            <th>Salary</th>
                            <th>Hire Date</th>
                            <th width="180">Actions</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        List<Employee> employees = (List<Employee>) request.getAttribute("employees");

                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                        if (employees != null && !employees.isEmpty()) {

                            for (Employee emp : employees) {
                    %>

                        <tr>

                            <td><%= emp.getEmployeeId() %></td>

                            <td>
                                <%= emp.getFirstName() %>
                                <%= emp.getLastName() %>
                            </td>

                            <td><%= emp.getEmail() %></td>

                            <td><%= emp.getDepartment() %></td>

                            <td><%= emp.getPosition() %></td>

                            <td>
                                $<%= String.format("%,.2f", emp.getSalary()) %>
                            </td>

                            <td>
                                <%= emp.getHireDate() != null ? sdf.format(emp.getHireDate()) : "" %>
                            </td>

                            <td>

                                <a href="employees?action=view&id=<%= emp.getEmployeeId() %>"
                                   class="btn btn-info btn-sm">

                                    <i class="fas fa-eye"></i>

                                </a>

                                <a href="employees?action=edit&id=<%= emp.getEmployeeId() %>"
                                   class="btn btn-warning btn-sm">

                                    <i class="fas fa-edit"></i>

                                </a>

                                <a href="employees?action=delete&id=<%= emp.getEmployeeId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this employee?')">

                                    <i class="fas fa-trash"></i>

                                </a>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>
                            <td colspan="8" class="text-center">
                                No employees found
                            </td>
                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />