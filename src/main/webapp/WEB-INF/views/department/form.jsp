<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Department" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Department department = (Department) request.getAttribute("department");
    boolean isEditMode = request.getAttribute("editMode") != null;
    String pageTitle = isEditMode ? "Edit Department" : "Add New Department";
    String action = isEditMode ? "update" : "insert";
    String submitButton = isEditMode ? "Update Department" : "Save Department";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= pageTitle %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .col {
            flex: 1;
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
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .error {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .required {
            color: #dc3545;
        }
        .form-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 30px;
        }
        .form-section h3 {
            margin-top: 0;
            color: #495057;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><%= pageTitle %></h1>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="departments" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (isEditMode && department != null) { %>
                <input type="hidden" name="departmentId" value="<%= department.getDepartmentId() %>">
            <% } %>

            <!-- Personal Information Section -->
            <div class="form-section">

                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="departmentId">Department Id<span class="required">*</span></label>
                            <input type="text" id="departmentId" name="departmentId"
                                   value="<%= department != null ? department.getDepartmentId() : "" %>"
                                   required>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="name">Department Name <span class="required">*</span></label>
                            <input type="text" id="name" name="name"
                                   value="<%= department != null ? department.getName() : "" %>"
                                   required>
                        </div>
                    </div>
                </div>

            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary"><%= submitButton %></button>
                <a href="employees" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <script>
        // Set minimum date to today for hire date
        document.addEventListener('DOMContentLoaded', function() {
            var today = new Date().toISOString().split('T')[0];
            var hireDateInput = document.getElementById('hireDate');

            // If not in edit mode, set max to today
            if (!<%= isEditMode %>) {
                hireDateInput.max = today;
            }

            // Format currency input
            var salaryInput = document.getElementById('salary');
            salaryInput.addEventListener('blur', function() {
                if (this.value) {
                    this.value = parseFloat(this.value).toFixed(2);
                }
            });

            // Phone number formatting
            var phoneInput = document.getElementById('phone');
            phoneInput.addEventListener('input', function() {
                var value = this.value.replace(/\D/g, '');
                if (value.length > 10) {
                    value = value.substring(0, 10);
                }
                if (value.length > 6) {
                    value = value.substring(0, 3) + '-' + value.substring(3, 6) + '-' + value.substring(6);
                } else if (value.length > 3) {
                    value = value.substring(0, 3) + '-' + value.substring(3);
                }
                this.value = value;
            });
        });
    </script>
</body>
</html>