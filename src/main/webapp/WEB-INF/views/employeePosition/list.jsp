<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.EmployeePosition" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="container-fluid">

    <!-- Page Title -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 text-gray-800">
            Employee Position Management
        </h1>

        <a href="employeePositions?action=new"
           class="btn btn-primary btn-sm shadow-sm">

            <i class="fas fa-plus fa-sm text-white-50"></i>
            Add Employee Position

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
                Employee Position List
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
                            <th>Employee ID</th>
                            <th>Position ID</th>
                            <th>Valid From</th>
                            <th>Valid To</th>
                            <th width="180">Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        List<EmployeePosition> employeePositions =
                            (List<EmployeePosition>) request.getAttribute("employeePositions");

                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                        if (employeePositions != null && !employeePositions.isEmpty()) {

                            for (EmployeePosition empPos : employeePositions) {
                    %>

                        <tr>

                            <td><%= empPos.getEmployeeId() %></td>

                            <td><%= empPos.getPositionId() %></td>

                            <td>
                                <%= empPos.getValidFrom() != null ?
                                    sdf.format(empPos.getValidFrom()) : "" %>
                            </td>

                            <td>
                                <%= empPos.getValidTo() != null ?
                                    sdf.format(empPos.getValidTo()) : "" %>
                            </td>

                            <td>

                                <a href="employeePositions?action=view&employeeId=<%= empPos.getEmployeeId() %>&positionId=<%= empPos.getPositionId() %>"
                                   class="btn btn-info btn-sm">

                                    <i class="fas fa-eye"></i>

                                </a>

                                <a href="employeePositions?action=edit&employeeId=<%= empPos.getEmployeeId() %>&positionId=<%= empPos.getPositionId() %>"
                                   class="btn btn-warning btn-sm">

                                    <i class="fas fa-edit"></i>

                                </a>

                                <a href="employeePositions?action=delete&employeeId=<%= empPos.getEmployeeId() %>&positionId=<%= empPos.getPositionId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this employee position?')">

                                    <i class="fas fa-trash"></i>

                                </a>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>
                            <td colspan="5" class="text-center">
                                No employee positions found
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