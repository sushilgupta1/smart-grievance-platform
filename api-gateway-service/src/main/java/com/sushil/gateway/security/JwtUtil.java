package com.sushil.gateway.security;

import java.security.Key;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

public class JwtUtil {

	private static final String SECRET = "mysecretkeymysecretkeymysecretkey";

	private static Key getSignedKey() {
		return Keys.hmacShaKeyFor(SECRET.getBytes());
	}

	public static Claims validateToken(String token) {
		return Jwts.parserBuilder()
				.setSigningKey(getSignedKey())
				.build()
				.parseClaimsJws(token)
				.getBody();
	}
	
	

}
