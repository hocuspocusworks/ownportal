package net.ownportal.gateway;

import java.time.LocalDateTime;
import java.time.ZoneOffset;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;

import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
public class AuthToken {
    private static final String PORTAL_URI = "http://portal:8077";
    private static JWTVerifier verifier;

    static {
        try {
            Algorithm algorithm = Algorithm.HMAC512("c8aP9xnmwXTWF1BMeBsHx02AnLe1eLDbZ50V9MQJPw");
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
                String user = "";
                try {
                    var jwt = verifier.verify(encodedToken);
                    user = jwt.getClaim("token").asString();
                } catch (Exception ex) {
                    log.warn("could not validate token={}", t);
                    return Mono.just(JwtResult.builder().authorised(false).build());
                }
                return Mono.just(JwtResult.builder().authorised(true).user(user).build());
            });
    }

    public static Mono<JwtResult> qoutaCheck(JwtResult result) {
        final var user = result.getUser();
        return WebClient.create(PORTAL_URI)
            .get()
            .uri("/developer/me")
            .header("X-Web-User", user)
            .exchangeToMono(response -> AuthToken.handleResponseBody(response, user));
    }

    private static Mono<JwtResult> handleResponseBody(ClientResponse response, String user) {
        return response
            .bodyToMono(DeveloperDetail.class)
            .flatMap(body -> AuthToken.handleResponse(body, user));
    }

    private static Mono<JwtResult> handleResponse(DeveloperDetail body, String user) {
        if (body.getQouta() <= 0 && !isAtLeastNextDay(body.getLastUsed())) {
            return Mono.just(JwtResult.builder().authorised(true).user(user).limitReached(true).build());
        }
        return WebClient.create(PORTAL_URI)
                .post()
                .uri("/developer/qouta")
                .header("X-Web-User", user)
                .retrieve()
                .bodyToMono(DeveloperDetail.class)
                .flatMap(b -> Mono.just(JwtResult.builder().authorised(true).user(user).limitReached(false).build()));
    }

    private static boolean isAtLeastNextDay(long time) {
        final LocalDateTime now = LocalDateTime.now();
        final LocalDateTime prev = LocalDateTime.ofEpochSecond(time, 0, ZoneOffset.UTC);
        return now.getDayOfMonth() != prev.getDayOfMonth() ? true : false;
    }

    @Getter
    @Builder
    static class JwtResult {
        private final boolean authorised;
        private final String user;
        private final boolean limitReached;
    }

    @ToString
    @Getter
    @Setter
    static class DeveloperDetail {
        private String username;
        private String email;
        private boolean paidSubscription;
        private long qouta;
        private long lastUsed;
        private String token;
    }
}
