package com.app.controller.api;

import com.app.dao.EmployeeDAO;
import com.app.model.Employee;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;

@Path("/employees")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EmployeeResource {

    private EmployeeDAO employeeDAO = new EmployeeDAO();

    @GET
    public List<Employee> getAllEmployees() {
        return employeeDAO.getAllEmployees();
    }

    @GET
    @Path("/{id}")
    public Employee getEmployee(@PathParam("id") String id) {
        return employeeDAO.getEmployeeById(id);
    }

    @POST
    public Response createEmployee(Employee employee) {

        boolean success = employeeDAO.createEmployee(employee);

        if(success){
            return Response.status(Response.Status.CREATED)
                    .entity("{\"message\":\"Employee created\"}")
                    .build();
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"message\":\"Failed to create employee\"}")
                .build();
    }

    @PUT
    @Path("/{id}")
    public Response updateEmployee(@PathParam("id") String id, Employee employee) {

        employee.setEmployeeId(id);

        boolean success = employeeDAO.updateEmployee(employee);

        if(success){
            return Response.ok("{\"message\":\"Employee updated\"}").build();
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"message\":\"Failed to update\"}")
                .build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteEmployee(@PathParam("id") String id) {

        boolean success = employeeDAO.deleteEmployee(id, null);

        if(success){
            return Response.ok("{\"message\":\"Employee deleted\"}").build();
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"message\":\"Failed to delete\"}")
                .build();
    }
}