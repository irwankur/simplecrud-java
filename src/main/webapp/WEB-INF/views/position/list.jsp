<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Position" %>
<%@ page import="java.util.List" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container-fluid">

    <!-- Page Title -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 text-gray-800">
            Position Management
        </h1>

        <a href="employees?action=new"
           class="btn btn-primary btn-sm shadow-sm">

            <i class="fas fa-plus fa-sm text-white-50"></i>
            Add Position

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
                Position List
            </h6>

        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-bordered"
                       id="dataTable"
                       width="100%">

                    <thead>

                        <tr>
                            <th>Position ID</th>
                            <th>Name</th>
                            <th>Department</th>
                            <th width="200">Actions</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        List<Position> positions = (List<Position>) request.getAttribute("position");

                        if (positions != null && !positions.isEmpty()) {

                            for (Position pos : positions) {
                    %>

                        <tr>

                            <td><%= pos.getPositionId() %></td>

                            <td><%= pos.getName() %></td>

                            <td><%= pos.getDepartment() %></td>

                            <td>

                                <a href="positions?action=view&id=<%= pos.getPositionId() %>"
                                   class="btn btn-info btn-sm">
                                   <i class="fas fa-eye"></i>
                                </a>

                                <a href="positions?action=edit&id=<%= pos.getPositionId() %>"
                                   class="btn btn-warning btn-sm">
                                   <i class="fas fa-edit"></i>
                                </a>

                                <a href="positions?action=delete&id=<%= pos.getPositionId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this position?')">
                                   <i class="fas fa-trash"></i>
                                </a>

                            </td>

                        </tr>

                    <%
                            }

                        } else {
                    %>

                        <tr>
                            <td colspan="4" class="text-center">
                                No positions found
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

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>