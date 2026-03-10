package com.app.dao;

import com.app.config.DatabaseConfig;
import com.app.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public List<Employee> getAllEmployees(){
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY employee_id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()){
                employees.add(extractEmployeeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employees;
    }

    public Employee getEmployeeById(String employeeId){
        String sql = "SELECT * FROM employees WHERE employee_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, employeeId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return extractEmployeeFromResultSet(rs);
            }
        } catch (SQLException e){
            e.printStackTrace();
        }

        return null;
    }

    public boolean createEmployee(Employee employee){
        String sql = "INSERT INTO employees (employee_id, first_name, last_name, email, department," +
                " position, salary, hire_date, phone, address, created_by) " +
                " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        try(Connection conn = DatabaseConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, employee.getEmployeeId());
            stmt.setString(2, employee.getFirstName());
            stmt.setString(3, employee.getLastName());
            stmt.setString(4, employee.getEmail());
            stmt.setString(5, employee.getDepartment());
            stmt.setString(6, employee.getPosition());
            stmt.setBigDecimal(7, employee.getSalary());
            stmt.setDate(8, new java.sql.Date(employee.getHireDate().getTime()));
            stmt.setString(9, employee.getPhone());
            stmt.setString(10, employee.getAddress());
            stmt.setString(11, employee.getCreatedBy());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateEmployee(Employee employee){
        String sql = "UPDATE employees SET first_name = ?, last_name = ?, email = ?, " +
                "department = ?, position = ?, salary = ?, hire_date = ?, " +
                "phone = ?, address = ? WHERE employee_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, employee.getFirstName());
            stmt.setString(2, employee.getLastName());
            stmt.setString(3, employee.getEmail());
            stmt.setString(4, employee.getDepartment());
            stmt.setString(5, employee.getPosition());
            stmt.setBigDecimal(6, employee.getSalary());
            stmt.setDate(7, new java.sql.Date(employee.getHireDate().getTime()));
            stmt.setString(8, employee.getPhone());
            stmt.setString(9, employee.getAddress());
            stmt.setString(10, employee.getEmployeeId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEmployee(String employeeId, String positionId) {
        String sql = "DELETE FROM employees WHERE employee_id = ? AND position_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, employeeId);
            stmt.setString(2, positionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Employee extractEmployeeFromResultSet(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        employee.setEmployeeId(rs.getString("employee_id"));
        employee.setFirstName(rs.getString("first_name"));
        employee.setLastName(rs.getString("last_name"));
        employee.setEmail(rs.getString("email"));
        employee.setDepartment(rs.getString("department"));
        employee.setPosition(rs.getString("position"));
        employee.setSalary(rs.getBigDecimal("salary"));
        employee.setHireDate(rs.getDate("hire_date"));
        employee.setPhone(rs.getString("phone"));
        employee.setAddress(rs.getString("address"));
        employee.setCreatedBy(rs.getString("created_by"));
        employee.setCreatedAt(rs.getTimestamp("created_at"));
        employee.setUpdatedAt(rs.getTimestamp("updated_at"));
        return employee;
    }

}
