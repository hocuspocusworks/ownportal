package net.ownportal.portal.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(1)
class PortalRequestFilter implements Filter {
    private final UserService userService;

    public PortalRequestFilter(final UserService userService) {
        this.userService = userService;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
    throws IOException, ServletException {
        // TODO Auto-generated method stub
        userService.username("test").qouta(1000);

        chain.doFilter(request, response);

        System.out.println("end of request");
    }
}
