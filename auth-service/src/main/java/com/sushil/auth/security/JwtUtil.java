package com.sushil.auth.security;

import java.security.Key;
import java.util.Date;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

public class JwtUtil {
	
	private static final String SECRET = "mysecretkeymysecretkeymysecretkey";
	private static final Key key= Keys.hmacShaKeyFor(SECRET.getBytes());
	
	public static String generateToken(String email)
	{
		return Jwts.builder()
				.setSubject(email)
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

}
