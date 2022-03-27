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
        log.info("hitting API auth filter");
        return chain.filter(exchange)
            .then(Mono.fromRunnable(() -> log.info("API auth filter post call")));
    }

    public static class Config {
    }
}
