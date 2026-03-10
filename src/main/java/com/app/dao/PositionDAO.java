package com.app.dao;

import com.app.config.DatabaseConfig;
import com.app.model.Employee;
import com.app.model.Position;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PositionDAO {

    public List<Position> getAllPosition(){
        List<Position> positions = new ArrayList<>();
        String sql = "SELECT * FROM positions ORDER BY position_id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()){
                positions.add(extractPositionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return positions;
    }

    public Position getPositionById(String positionId){
        String sql = "SELECT * FROM positions WHERE position_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, positionId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return extractPositionFromResultSet(rs);
            }
        } catch (SQLException e){
            e.printStackTrace();
        }

        return null;
    }

    public boolean createPosition(Position position){
        String sql = "INSERT INTO positions (position_id, name, department, created_by, created_at) " +
                " VALUES (?, ?, ?, ?, ?) ";
        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, position.getPositionId());
            stmt.setString(2, position.getName());
            stmt.setString(3, position.getDepartment());
            stmt.setString(4, position.getCreatedBy());
            stmt.setDate(5, new java.sql.Date(position.getCreatedAt().getTime()));

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePosition(Position position){
        String sql = "UPDATE positions SET name = ?, department = ? WHERE position_id = ?";

        try(Connection conn = DatabaseConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1, position.getName());
            stmt.setString(2, position.getDepartment());
            stmt.setString(3, position.getPositionId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePosition(String employeeId) {
        String sql = "DELETE FROM positions WHERE position_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, employeeId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Position extractPositionFromResultSet(ResultSet rs) throws SQLException {
        Position position = new Position();
        position.setPositionId(rs.getString("position_id"));
        position.setName(rs.getString("name"));
        position.setDepartment(rs.getString("department"));
        return position;
    }

}
