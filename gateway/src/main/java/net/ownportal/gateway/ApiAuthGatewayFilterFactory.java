package net.ownportal.gateway;

import java.nio.charset.StandardCharsets;

import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.gateway.AuthToken.JwtResult;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Component
@Slf4j
public class ApiAuthGatewayFilterFactory extends AbstractGatewayFilterFactory<ApiAuthGatewayFilterFactory.Config> {

    public ApiAuthGatewayFilterFactory() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return this::filter;
    }

    private Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        log.debug("hitting API auth filter");
        return AuthToken
            .validate(extractApiToken(exchange))
            .flatMap(AuthToken::qoutaCheck)
            .flatMap(result -> processValidation(result, exchange, chain));
    }

    private Mono<Void> processValidation(JwtResult result, ServerWebExchange exchange, GatewayFilterChain chain) {
        if (result.isAuthorised() && !result.isLimitReached()) {
            return chain.filter(exchange);
        } else if (result.isLimitReached()) {
            return limitReached(exchange);
        }
        return discard(exchange);
    }

    private static String extractApiToken(ServerWebExchange exchange) {
        return exchange
            .getRequest()
            .getHeaders()
            .getFirst("Authorization");
    }

    private Mono<Void> discard(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        exchange.getResponse().getHeaders().add("Content-Type", "application/json");
        byte[] bytes = "{\"status\": 401, \"message\": \"Not Authorized\"}".getBytes(StandardCharsets.UTF_8);
        var buffer = exchange.getResponse().bufferFactory().wrap(bytes);
        return exchange.getResponse().writeWith(Flux.just(buffer));
    }

    private Mono<Void> limitReached(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
        exchange.getResponse().getHeaders().add("Content-Type", "application/json");
        byte[] bytes = "{\"status\": 429, \"message\": \"API Limit Reached\"}".getBytes(StandardCharsets.UTF_8);
        var buffer = exchange.getResponse().bufferFactory().wrap(bytes);
        return exchange.getResponse().writeWith(Flux.just(buffer));
    }

    public static class Config {
    }

}
