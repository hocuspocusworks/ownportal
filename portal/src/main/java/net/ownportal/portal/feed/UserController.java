package net.ownportal.portal.feed;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
// @CrossOrigin(origins = "http://localhost:3000",
//         methods = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS },
//         allowCredentials = "true")
@RequestMapping("/user")
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
        response.addCookie(getCookie());
        return "";
    }

    private Cookie getCookie() {
        String token = JWT.create()
                .withIssuer("ownportal")
                .sign(algorithm);
        Cookie cookie = new Cookie("ownportal", token);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        return cookie;
    }

    @PostMapping("register")
    public String register() {
        return "";
    }
}
