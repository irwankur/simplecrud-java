<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Employee" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Employee employee = (Employee) request.getAttribute("employee");
    boolean isEditMode = request.getAttribute("editMode") != null;

    String pageTitle = isEditMode ? "Edit Employee" : "Add New Employee";
    String action = isEditMode ? "update" : "insert";
    String submitButton = isEditMode ? "Update Employee" : "Save Employee";

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String hireDate = "";

    if (employee != null && employee.getHireDate() != null) {
        hireDate = dateFormat.format(employee.getHireDate());
    }
%>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container-fluid">

    <!-- Page Title -->
    <h1 class="h3 mb-4 text-gray-800"><%= pageTitle %></h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="employees" method="post">

        <input type="hidden" name="action" value="<%= action %>">

        <% if (isEditMode && employee != null) { %>
            <input type="hidden" name="id" value="<%= employee.getEmployeeId() %>">
        <% } %>

        <!-- PERSONAL INFORMATION -->
        <div class="card shadow mb-4">

            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">
                    Personal Information
                </h6>
            </div>

            <div class="card-body">

                <div class="form-group">
                    <label>Employee ID *</label>
                    <input type="text"
                           name="employeeId"
                           class="form-control"
                           value="<%= employee != null ? employee.getEmployeeId() : "" %>"
                           required>
                </div>

                <div class="form-row">

                    <div class="form-group col-md-6">
                        <label>First Name *</label>
                        <input type="text"
                               name="firstName"
                               class="form-control"
                               value="<%= employee != null ? employee.getFirstName() : "" %>"
                               required>
                    </div>

                    <div class="form-group col-md-6">
                        <label>Last Name *</label>
                        <input type="text"
                               name="lastName"
                               class="form-control"
                               value="<%= employee != null ? employee.getLastName() : "" %>"
                               required>
                    </div>

                </div>

                <div class="form-row">

                    <div class="form-group col-md-6">
                        <label>Email *</label>
                        <input type="email"
                               name="email"
                               class="form-control"
                               value="<%= employee != null ? employee.getEmail() : "" %>"
                               required>
                    </div>

                    <div class="form-group col-md-6">
                        <label>Phone</label>
                        <input type="text"
                               id="phone"
                               name="phone"
                               class="form-control"
                               value="<%= employee != null ? employee.getPhone() : "" %>">
                    </div>

                </div>

                <div class="form-group">
                    <label>Address</label>
                    <textarea class="form-control"
                              name="address"
                              rows="3"><%= employee != null && employee.getAddress()!=null ? employee.getAddress() : "" %></textarea>
                </div>

            </div>

        </div>

        <!-- EMPLOYMENT INFORMATION -->
        <div class="card shadow mb-4">

            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">
                    Employment Information
                </h6>
            </div>

            <div class="card-body">

                <div class="form-row">

                    <div class="form-group col-md-6">
                        <label>Department *</label>
                        <select name="department" class="form-control" required>

                            <option value="">Select Department</option>

                            <option value="IT"
                            <%= employee != null && "IT".equals(employee.getDepartment()) ? "selected" : "" %>>
                            IT
                            </option>

                            <option value="HR"
                            <%= employee != null && "HR".equals(employee.getDepartment()) ? "selected" : "" %>>
                            Human Resources
                            </option>

                            <option value="Finance"
                            <%= employee != null && "Finance".equals(employee.getDepartment()) ? "selected" : "" %>>
                            Finance
                            </option>

                            <option value="Marketing"
                            <%= employee != null && "Marketing".equals(employee.getDepartment()) ? "selected" : "" %>>
                            Marketing
                            </option>

                            <option value="Sales"
                            <%= employee != null && "Sales".equals(employee.getDepartment()) ? "selected" : "" %>>
                            Sales
                            </option>

                        </select>
                    </div>

                    <div class="form-group col-md-6">
                        <label>Position *</label>
                        <input type="text"
                               name="position"
                               class="form-control"
                               value="<%= employee != null ? employee.getPosition() : "" %>"
                               required>
                    </div>

                </div>

                <div class="form-row">

                    <div class="form-group col-md-6">
                        <label>Salary *</label>
                        <input type="number"
                               id="salary"
                               name="salary"
                               class="form-control"
                               value="<%= employee != null ? employee.getSalary() : "" %>"
                               step="0.01"
                               required>
                    </div>

                    <div class="form-group col-md-6">
                        <label>Hire Date *</label>
                        <input type="date"
                               id="hireDate"
                               name="hireDate"
                               class="form-control"
                               value="<%= hireDate %>"
                               required>
                    </div>

                </div>

            </div>

        </div>

        <!-- BUTTON -->
        <div class="mb-4">

            <button type="submit" class="btn btn-primary">
                <%= submitButton %>
            </button>

            <a href="employees" class="btn btn-secondary">
                Cancel
            </a>

        </div>

    </form>

</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>