package net.ownportal.portal.feed;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/user")
@Slf4j
public class UserController {
    private Algorithm algorithm;
    private UserRepository userRepository;

    public UserController(UserRepository repo) {
        algorithm = Algorithm.HMAC512("secret");
        userRepository = repo;
    }

    @PostMapping("login")
    public String login(@RequestBody UserDao input, final HttpServletResponse response) {
        var userOpt = userRepository.findOneByUsernameAndPassword(input.getUsername(), input.getPassword());
        if (userOpt.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "";
        }
        final var token = generateToken();
        response.addCookie(getCookie(token));
        return "";
    }

    @PostMapping("logout")
    public String logout(final HttpServletResponse response) {
        log.debug("unsetting the cookie");
        response.addCookie(getCookie(null, 0));
        return "";
    }

    private Cookie getCookie(final String content) {
        Cookie cookie = new Cookie("ownportal", content);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        return cookie;
    }

    private Cookie getCookie(final String content, final int expiry) {
        final var cookie = getCookie(content);
        cookie.setMaxAge(expiry);
        return cookie;
    }

    private String generateToken() {
        return JWT.create()
            .withIssuer("ownportal")
            .sign(algorithm);
    }

    @PostMapping("register")
    public String register() {
        return "";
    }
}
