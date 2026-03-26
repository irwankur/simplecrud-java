package com.app.filter;

import com.app.security.JwtUtil;

import javax.ws.rs.container.*;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import java.io.IOException;

@Provider
public class ApiAuthenticationFilter implements ContainerRequestFilter {

    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {

        String path = requestContext.getUriInfo().getPath();

        if(path.equals("auth/login") || path.equals("auth/refresh")){
            return;
        }

        String authHeader = requestContext.getHeaderString("Authorization");

        if(authHeader == null || !authHeader.startsWith("Bearer ")){

            requestContext.abortWith(
                    Response.status(Response.Status.UNAUTHORIZED)
                            .entity("Token tidak ada")
                            .build()
            );

            return;
        }

        String token = authHeader.substring("Bearer ".length());

        try{

            JwtUtil.validateToken(token);

        }catch(Exception e){

            requestContext.abortWith(
                    Response.status(Response.Status.UNAUTHORIZED)
                            .entity("Token tidak valid")
                            .build()
            );
        }
    }
}