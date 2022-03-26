package net.ownportal.gateway;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
class JwtToken {
    private static JWTVerifier verifier;

    static {
        try {
            Algorithm algorithm = Algorithm.HMAC512("secret");
            verifier = JWT.require(algorithm)
                        .withIssuer("ownportal")
                        .build();
        } catch (JWTVerificationException ex) {
            ex.printStackTrace();
        }
    }
    
    public static Mono<JwtResult> validate(String token) {
        log.info("validating JWT token");
        return Mono.just(token)
            .flatMap(t -> {
                try {
                    verifier.verify(t);
                } catch (Exception ex) {
                    log.info("could not validate token={}", t);
                    return Mono.just(new JwtResult(false));
                }
                return Mono.just(new JwtResult(true));
            });
    }

    static class JwtResult {
        public boolean authorised;

        public JwtResult(boolean auth) {
            this.authorised = auth;
        }

        public boolean isAuthorised() {
            return authorised;
        }
    }
}
