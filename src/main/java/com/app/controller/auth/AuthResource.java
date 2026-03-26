package com.app.controller.auth;

import com.app.model.LoginRequest;
import com.app.model.LoginResponse;
import com.app.security.JwtUtil;
import com.app.util.PasswordUtil;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;

@Path("/auth")
public class AuthResource {

    @POST
    @Path("/login")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(LoginRequest request) {

        String username = request.getUsername();
        String password = request.getPassword();

        // contoh validasi sederhana
        if ("admin".equals(username) && "123".equals(password)) {

            String token = JwtUtil.generateToken(username);
            String refreshToken = JwtUtil.generateRefreshToken(request.getUsername());

//            LoginResponse response = new LoginResponse();
//            response.setToken(token);
//            response.setUsername(username);

            Map<String, String> response = new HashMap<>();
            response.put("accessToken", token);
            response.put("refreshToken", refreshToken);

            return Response.ok(response).build();
        }

        return Response.status(Response.Status.UNAUTHORIZED)
                .entity("Username atau password salah")
                .build();
    }

    @POST
    @Path("/refresh")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response refreshToken(Map<String, String> body) {
        String refreshToken = body.get("refreshToken");

        try {
            String username = JwtUtil.validateToken(refreshToken); // validasi refresh token
            String newAccessToken = JwtUtil.generateToken(username);

            Map<String, String> response = new HashMap<>();
            response.put("accessToken", newAccessToken);

            return Response.ok(response).build();
        } catch(Exception e){
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("Refresh token tidak valid atau kadaluwarsa")
                    .build();
        }
    }

    @GET
    @Path("/test")
    @Produces(MediaType.TEXT_PLAIN)
    public String test() {
        System.out.println("AuthResource terpanggil");
        return "API OK";
    }
}