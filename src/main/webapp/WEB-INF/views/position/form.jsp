<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Position" %>

<%
    Position position = (Position) request.getAttribute("position");

    boolean isEditMode = request.getAttribute("editMode") != null;

    String pageTitle = isEditMode ? "Edit Position" : "Add New Position";
    String action = isEditMode ? "update" : "insert";
    String submitButton = isEditMode ? "Update Position" : "Save Position";
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

    <form action="positions" method="post">

        <input type="hidden" name="action" value="<%= action %>">

        <% if (isEditMode && position != null) { %>
            <input type="hidden" name="id" value="<%= position.getPositionId() %>">
        <% } %>

        <!-- CARD -->
        <div class="card shadow mb-4">

            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">
                    Position Information
                </h6>
            </div>

            <div class="card-body">

                <div class="form-group">
                    <label>Position ID *</label>

                    <input type="text"
                           name="positionId"
                           class="form-control"
                           value="<%= position != null ? position.getPositionId() : "" %>"
                           <%= isEditMode ? "disabled" : "" %>
                           required>
                </div>

                <div class="form-row">

                    <div class="form-group col-md-6">
                        <label>Name *</label>

                        <input type="text"
                               name="name"
                               class="form-control"
                               value="<%= position != null ? position.getName() : "" %>"
                               required>
                    </div>

                    <div class="form-group col-md-6">
                        <label>Department *</label>

                        <input type="text"
                               name="department"
                               class="form-control"
                               value="<%= position != null ? position.getDepartment() : "" %>"
                               required>
                    </div>

                </div>

            </div>

        </div>

        <!-- BUTTONS -->
        <div class="mb-4">

            <button type="submit" class="btn btn-primary">
                <%= submitButton %>
            </button>

            <a href="positions" class="btn btn-secondary">
                Cancel
            </a>

        </div>

    </form>

</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>