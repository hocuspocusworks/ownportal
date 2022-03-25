package net.ownportal.gateway;

import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class QuotaGatewayFilterFactory extends AbstractGatewayFilterFactory<QuotaGatewayFilterFactory.Config> {

    public QuotaGatewayFilterFactory() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            log.info("modifying qouta");
            return chain.filter(exchange);
        };
    }

    public static class Config {
    }
}
