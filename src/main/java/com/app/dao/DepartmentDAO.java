package com.app.dao;

import com.app.config.DatabaseConfig;
import com.app.model.Department;
import com.app.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    public List<Department> getAllDepartments(){
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()){
                departments.add(extractDepartmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return departments;
    }

    public Department getDepartmentById(String departmentId){
        String sql = "SELECT * FROM departments WHERE department_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, departmentId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return extractDepartmentFromResultSet(rs);
            }
        } catch (SQLException e){
            e.printStackTrace();
        }

        return null;
    }

    public boolean createDepartment(Department department) throws SQLException {
        String sql = "INSERT INTO departments (department_id, name, created_by, created_at) " +
                " VALUES (?, ?, ?, ?) ";
        try(Connection conn = DatabaseConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, department.getDepartmentId());
            stmt.setString(2, department.getName());
            stmt.setString(3, department.getCreatedBy());
            stmt.setDate(4, new java.sql.Date(new java.util.Date().getTime()));

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateDepartment(Department department) throws SQLException{
        String sql = "UPDATE departments SET name = ?, updated_at = ? WHERE department_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, department.getName());
            stmt.setDate(2, new java.sql.Date(new java.util.Date().getTime()));
            stmt.setString(3, department.getDepartmentId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDepartment(String departmentId) {
        String sql = "DELETE FROM departments WHERE department_id = ? ";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, departmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Department extractDepartmentFromResultSet(ResultSet rs) throws SQLException {
        Department department = new Department();
        department.setDepartmentId(rs.getString("department_id"));
        department.setName(rs.getString("name"));
        department.setCreatedAt(rs.getDate("created_at"));
        department.setCreatedBy(rs.getString("created_by"));
        department.setUpdatedAt(rs.getDate("updated_at"));
        return department;
    }

}
