<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.EmployeePosition" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.app.model.Employee" %>
<%@ page import="com.app.model.Position" %>

<%
    EmployeePosition employeePosition = (EmployeePosition) request.getAttribute("employeePosition");
    boolean isEditMode = request.getAttribute("editMode") != null;

    String pageTitle = isEditMode ? "Edit Employee Position" : "Add Employee Position";
    String action = isEditMode ? "update" : "insert";
    String submitButton = isEditMode ? "Update" : "Save";

    List<Employee> employees = (List<Employee>) request.getAttribute("employees");
    List<Position> positions = (List<Position>) request.getAttribute("positions");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="container-fluid">

    <!-- Page Title -->
    <h1 class="h3 mb-4 text-gray-800">
        <%= pageTitle %>
    </h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <div class="card shadow mb-4">

        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">
                Employee Position Form
            </h6>
        </div>

        <div class="card-body">

            <form action="employeePositions" method="post">

                <input type="hidden" name="action" value="<%= action %>">

                <% if (isEditMode && employeePosition != null) { %>
                    <input type="hidden" name="employeeId"
                           value="<%= employeePosition.getEmployeeId() %>">

                    <input type="hidden" name="positionId"
                           value="<%= employeePosition.getPositionId() %>">
                <% } %>

                <div class="form-row">

                    <!-- Employee -->
                    <div class="form-group col-md-6">
                        <label>Employee</label>

                        <select name="employeeId" class="form-control" required  <%= isEditMode ? "disabled" : "" %> >

                            <option value="">-- Select Employee --</option>

                            <% if (employees != null) {
                                for (Employee emp : employees) { %>

                                    <option value="<%= emp.getEmployeeId() %>"
                                        <%= (employeePosition != null &&
                                             emp.getEmployeeId().equals(employeePosition.getEmployeeId()))
                                             ? "selected" : "" %>>

                                        <%= emp.getFirstName() %> <%= emp.getLastName() %>

                                    </option>

                            <%  }
                               } %>

                        </select>
                    </div>

                    <!-- Position -->
                    <div class="form-group col-md-6">
                        <label>Position</label>

                        <select name="positionId" class="form-control"  <%= isEditMode ? "disabled" : "" %> required>

                            <option value="">-- Select Position --</option>

                            <% if (positions != null) {
                                for (Position pos : positions) { %>

                                    <option value="<%= pos.getPositionId() %>"
                                        <%= (employeePosition != null &&
                                             pos.getPositionId().equals(employeePosition.getPositionId()) )
                                             ? "selected" : "" %>>

                                        <%= pos.getName() %>

                                    </option>

                            <%  }
                               } %>

                        </select>
                    </div>

                </div>


                <div class="form-row">

                    <!-- Valid From -->
                    <div class="form-group col-md-6">

                        <label>Valid From</label>

                        <input
                            type="date"
                            name="validFrom"
                            class="form-control"
                            required
                            value="<%= employeePosition != null && employeePosition.getValidFrom()!=null
                                        ? sdf.format(employeePosition.getValidFrom()) : "" %>"
                        >

                    </div>

                    <!-- Valid To -->
                    <div class="form-group col-md-6">

                        <label>Valid To</label>

                        <input
                            type="date"
                            name="validTo"
                            class="form-control"
                            required
                            value="<%= employeePosition != null && employeePosition.getValidTo()!=null
                                        ? sdf.format(employeePosition.getValidTo()) : "" %>"
                        >

                    </div>
                </div>


                <!-- Buttons -->
                <div class="mt-4">

                    <button type="submit" class="btn btn-primary">

                        <i class="fas fa-save"></i>
                        <%= submitButton %>

                    </button>

                    <a href="employeePositions" class="btn btn-secondary">

                        <i class="fas fa-arrow-left"></i>
                        Cancel

                    </a>
                </div>
            </form>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />