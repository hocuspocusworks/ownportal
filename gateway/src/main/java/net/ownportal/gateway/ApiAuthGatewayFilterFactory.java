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
        return AuthToken
            .validate(extractApiToken(exchange))
            .flatMap(result -> chain.filter(exchange));
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
