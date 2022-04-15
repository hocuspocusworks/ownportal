package net.ownportal.portal.filter;

import java.io.IOException;
import java.time.Instant;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Order(1)
@Slf4j
class PortalRequestFilter implements Filter {
    private final UserService userService;

    public PortalRequestFilter(final UserService userService) {
        this.userService = userService;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
    throws IOException, ServletException {
        final var start = Instant.now().toEpochMilli();
        final var httpRequest = (HttpServletRequest) request;
        final var user = httpRequest.getHeader("X-Web-User");

        userService.username(user).qouta(1000);

        chain.doFilter(request, response);

        final var end = Instant.now();
        log.info("Request {} took {}ms", httpRequest.getRequestURI(), end.minusMillis(start).toEpochMilli());
    }
}
