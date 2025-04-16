package com.smhrd.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.smhrd.model.AdminDTO;

import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class JwtUtil {

    private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);

    @Value("${SECRET_KEY}")
    private String SECRET_KEY;
    
    private final long EXPIRATION_TIME = 1000 * 60 * 60; // 1시간

    public String createToke(AdminDTO info) {
        return Jwts.builder()
            .setSubject("admin")
            .claim("admin_id", info.getAdmin_id())
            .claim("admin_name", info.getAdmin_name())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
            .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
            .compact();
    }

    //토큰 유효성 검사 
    public Claims validateToken(String token) {

        try {
            return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
        } catch (io.jsonwebtoken.ExpiredJwtException e) {
            logger.error("JWT 토큰 만료: " + e.getMessage(), e);
            throw new RuntimeException("토큰 만료");
        } catch (io.jsonwebtoken.SignatureException e) {
            logger.error("JWT 서명 불일치: " + e.getMessage(), e);
            throw new RuntimeException("서명 불일치");
        } catch (Exception e) {
            logger.error("JWT 토큰 검증 실패: " + e.getMessage(), e);
            throw new RuntimeException("토큰 검증 실패");
        }
    }



}
