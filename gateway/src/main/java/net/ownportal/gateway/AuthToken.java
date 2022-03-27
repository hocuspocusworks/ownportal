package net.ownportal.gateway;

import java.util.Base64;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
public class AuthToken {
    private static JWTVerifier verifier;

    static {
        try {
            Algorithm algorithm = Algorithm.HMAC256("secret");
            verifier = JWT.require(algorithm)
                        .withIssuer("ownportal")
                        .build();
        } catch (JWTVerificationException ex) {
            ex.printStackTrace();
        }
    }

    public static Mono<JwtResult> validate(String encodedToken) {
        log.debug("validating JWT token");
        return Mono.just(encodedToken)
            .flatMap(t -> {
                try {
                    var decoded = new String(Base64.getDecoder().decode(t));
                    verifier.verify(decoded);
                } catch (Exception ex) {
                    log.info("could not validate token={}", t);
                    return Mono.just(new JwtResult(false));
                }
                return Mono.just(new JwtResult(true, ""));
            });
    }

    @Getter
    static class JwtResult {
        private final boolean authorised;
        private final String user;

        private JwtResult(boolean auth) {
            this.authorised = auth;
            this.user = "";
        }

        private JwtResult(boolean auth, String user) {
            this.authorised = auth;
            this.user = user;
        }
    }
}
