package net.ownportal.portal;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import org.springframework.http.ResponseCookie;

public class WebToken {
    private static Algorithm algorithm;

    static {
        algorithm = Algorithm.HMAC512("secret");
    }

    public static String getCookie(final String content) {
        return ResponseCookie.from("ownportal", content)
            .httpOnly(true)
            .secure(true)
            .path("/")
            .sameSite("None")
            .build()
            .toString();
    }

    public static String getCookie(final String content, final int expiry) {
        return ResponseCookie.from("ownportal", content)
            .httpOnly(true)
            .secure(true)
            .path("/")
            .sameSite("None")
            .maxAge(expiry)
            .build()
            .toString();
    }

    public static String generateToken(final String payload) {
        return JWT.create()
            .withIssuer("ownportal")
            .withClaim("user", payload)
            .sign(algorithm);
    }
}
