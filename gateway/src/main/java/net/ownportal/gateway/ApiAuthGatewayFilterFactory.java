package net.ownportal.gateway;

import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import lombok.extern.slf4j.Slf4j;
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
        final var exchangeWithIp = exchange(exchange);
        return AuthToken
            .validate(extractApiToken(exchangeWithIp))
            .flatMap(result -> chain.filter(exchangeWithIp));
    }

    private ServerWebExchange exchange(ServerWebExchange exchange) {
        return exchangeWithForwardedIp(exchange);
    }

    private ServerWebExchange exchangeWithForwardedIp(ServerWebExchange exchange) {
        var mutatedRequest = exchange.getRequest()
            .mutate()
            .header("X-Forwarded-For", remoteIp(exchange))
            .build();
        return exchange.mutate().request(mutatedRequest).build();
    }

    private String remoteIp(ServerWebExchange exchange) {
        return exchange.getRequest().getHeaders().getFirst("X-Forwarded-For");
    }

    private static String extractApiToken(ServerWebExchange exchange) {
        return exchange
            .getRequest()
            .getHeaders()
            .getFirst("Authorization");
    }

    public static class Config {
    }

}
