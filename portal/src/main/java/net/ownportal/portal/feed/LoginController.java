package net.ownportal.portal.feed;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@CrossOrigin
@RequestMapping("/user")
@Slf4j
public class LoginController {
    private Algorithm algorithm;

    public LoginController() {
        algorithm = Algorithm.HMAC512("secret");
    }

    @PostMapping("login")
    public String login(final HttpServletResponse response) {
        String token = JWT.create()
                .withIssuer("ownportal")
                .sign(algorithm);
        log.info("created token={}", token);
        Cookie cookie = new Cookie("ownportal", token);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        response.addCookie(cookie);
        return "";
    }

    @PostMapping("register")
    public String register() {
        return "";
    }
}
