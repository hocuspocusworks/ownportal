package net.ownportal.gateway;

import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Component
@Slf4j
public class WebAuthGatewayFilterFactory extends AbstractGatewayFilterFactory<WebAuthGatewayFilterFactory.Config> {

    public WebAuthGatewayFilterFactory() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return this::filter;
    }

    private Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        log.info("hitting WEB auth filter");
        return JwtToken
            .validate(extractJwtToken(exchange))
            .flatMap(auth -> processValidation(auth, exchange, chain));
    }

    private static String extractJwtToken(ServerWebExchange exchange) {
        return exchange
            .getRequest()
            .getCookies()
            .get("ownportal")
            .get(0)
            .getValue();
    }

    private Mono<Void> processValidation(JwtToken.JwtResult auth, ServerWebExchange exchange, GatewayFilterChain chain) {
        if (auth.isAuthorised()) {
            return chain.filter(exchange);
        }
        exchange.getResponse().setStatusCode(HttpStatus.FORBIDDEN);
        return exchange.getResponse().setComplete();
    }

    public static class Config {
    }
}
