package net.ownportal.portal;

import javax.servlet.http.Cookie;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

public class WebToken {
    private static Algorithm algorithm;

    static {
        algorithm = Algorithm.HMAC512("secret");
    }

    public static Cookie getCookie(final String content) {
        Cookie cookie = new Cookie("ownportal", content);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        return cookie;
    }

    public static Cookie getCookie(final String content, final int expiry) {
        final var cookie = getCookie(content);
        cookie.setMaxAge(expiry);
        return cookie;
    }

    public static String generateToken(final String payload) {
        return JWT.create()
            .withIssuer("ownportal")
            .withClaim("user", payload)
            .sign(algorithm);
    }
}
