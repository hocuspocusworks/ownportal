package net.ownportal.portal;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

public class AuthToken {
    private static Algorithm algorithm;

    static {
        algorithm = Algorithm.HMAC256("secret");
    }

    public static String generateToken(final String user) {
        return JWT.create()
            .withIssuer("ownportal")
            .withClaim("user", user)
            .sign(algorithm);
    }

    public static String generateToken(final String user, final String payload) {
        return JWT.create()
            .withIssuer("ownportal")
            .withClaim("user", user)
            .withClaim("payload", payload)
            .sign(algorithm);
    }
}
