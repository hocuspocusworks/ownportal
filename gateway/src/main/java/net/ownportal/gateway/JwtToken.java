package net.ownportal.gateway;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
class JwtToken {
    
    public static Mono<JwtResult> validate(String token) {
        log.info("validating JWT token");
        if (!token.equals("auth")) {
            return Mono.just(new JwtResult(false));
        }
        return Mono.just(new JwtResult(true));
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
