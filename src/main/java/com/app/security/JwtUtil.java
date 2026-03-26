package com.app.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

public class JwtUtil {

    private static final String SECRET = "mysecretkeymysecretkeymysecretkey";
    private static final Key KEY = Keys.hmacShaKeyFor(SECRET.getBytes());
    private static final long REFRESH_TOKEN_EXP = 7 * 24 * 60 * 60_000L; // 7 hari

    public static String generateToken(String username){

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 60_000))
                .signWith(KEY)
                .compact();
    }

    public static String validateToken(String token){

        Claims claims = Jwts.parserBuilder()
                .setSigningKey(KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();

        return claims.getSubject();
    }

    public static String generateRefreshToken(String username){
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + REFRESH_TOKEN_EXP))
                .signWith(KEY)
                .compact();
    }
}