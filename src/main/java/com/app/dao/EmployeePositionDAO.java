package com.app.dao;

import com.app.config.DatabaseConfig;
import com.app.exception.RecordException;
import com.app.model.EmployeePosition;
import com.app.model.Position;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeePositionDAO {

    public List<EmployeePosition> getAllEmployeePosition(){
        List<EmployeePosition> employeePositions = new ArrayList<>();
        String sql = "SELECT * FROM employee_positions ORDER BY employee_id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()){
                employeePositions.add(extractEmployeePositionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employeePositions;
    }

    public EmployeePosition getEmployeePositionById(String employeePositionId, String positionId){
        String sql = "SELECT * FROM employee_positions WHERE employee_id = ? and position_id = ? ";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, employeePositionId);
            stmt.setString(2, positionId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return extractEmployeePositionFromResultSet(rs);
            }
        } catch (SQLException e){
            e.printStackTrace();
        }

        return null;
    }

    public boolean createEmployeePosition(EmployeePosition employeePosition)
            throws RecordException {

        String sql = "INSERT INTO employee_positions (employee_id, position_id, valid_from, valid_to, created_by, created_at) " +
                " VALUES (?, ?, ?, ?, ?, ?) ";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, employeePosition.getEmployeeId());
            stmt.setString(2, employeePosition.getPositionId());
            stmt.setDate(3, new java.sql.Date(employeePosition.getValidFrom().getTime()));
            stmt.setDate(4, new java.sql.Date(employeePosition.getValidTo().getTime()));
            stmt.setString(5, employeePosition.getCreatedBy());
            stmt.setDate(6, new java.sql.Date(new java.util.Date().getTime()));

            return stmt.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {

            throw new RecordException("Employee dan Position sudah terdaftar atau tidak valid.");

        } catch (SQLException e) {

            throw new RecordException("Terjadi kesalahan database: " + e.getMessage());
        }
    }

    public boolean updateEmployeePosition(EmployeePosition employeePosition){
        String sql = "UPDATE employee_positions SET valid_from = ?, valid_to = ? WHERE employee_id = ? and position_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setDate(1, new java.sql.Date(employeePosition.getValidFrom().getTime()));
            stmt.setDate(2, new java.sql.Date(employeePosition.getValidTo().getTime()));
            stmt.setString(3, employeePosition.getEmployeeId());
            stmt.setString(4, employeePosition.getPositionId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEmployeePosition(String employeeId, String positionId) {
        String sql = "DELETE FROM employee_positions WHERE employee_id = ? and position_id = ?";

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

    private EmployeePosition extractEmployeePositionFromResultSet(ResultSet rs) throws SQLException {
        EmployeePosition employeePosition = new EmployeePosition();
        employeePosition.setPositionId(rs.getString("position_id"));
        employeePosition.setEmployeeId(rs.getString("employee_id"));
        employeePosition.setValidFrom(rs.getDate("valid_from"));
        employeePosition.setValidTo(rs.getDate("valid_to"));
        return employeePosition;
    }

}
