package com.sushil.grievance.security;

import java.security.Key;
import java.util.Date;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

public class JwtUtil {
	
	private static final String SECRET = "mysecretkeymysecretkeymysecretkey";
	private static final Key key= Keys.hmacShaKeyFor(SECRET.getBytes());
	
	public static String generateToken(String email,String role)
	{
		return Jwts.builder()
				.setSubject(email)
				.claim("role", role)
				.setIssuedAt(new Date())
				.setExpiration(new Date(System.currentTimeMillis()+1000*60*60))
				.signWith(key,SignatureAlgorithm.HS256)
				.compact();
		
	}
	
	public static String validateToken(String token)
	{
		return Jwts.parserBuilder()
				.setSigningKey(key)
				.build()
				.parseClaimsJws(token)
				.getBody()
				.getSubject();
	}
	
	
	
	public static Claims extractAllClaims(String token)
	{
		return Jwts.parserBuilder()
				.setSigningKey(key)
				.build()
				.parseClaimsJws(token)
				.getBody();	
	}
	
	public static String extractRole(String token)
	{
		return  extractAllClaims(token).get("role", String.class);
	}

}
