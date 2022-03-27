package net.ownportal.portal.user;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.portal.UserDetail;
import net.ownportal.portal.UserLogin;
import net.ownportal.portal.WebToken;

@RestController
@RequestMapping("/user")
@Slf4j
class UserController {
    private UserRepository userRepository;

    public UserController(UserRepository repo) {
        userRepository = repo;
    }

    @PostMapping("register")
    UserDao register(@RequestBody UserDetail user, HttpServletResponse response) {
        if (exists(user.getUsername())) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            return UserDao.empty();
        }
        final var userDao = new UserDao();
        userDao.setUsername(user.getUsername());
        userDao.setPassword(user.getPassword());
        userDao.setEmail(user.getEmail());
        return userRepository.save(userDao);
    }

    @PostMapping("login")
    public String login(@RequestBody UserLogin input, final HttpServletResponse response) {
        var userOpt = userRepository.findOneByUsernameAndPassword(input.getUsername(), input.getPassword());
        if (userOpt.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return "";
        }
        final var token = WebToken.generateToken(userOpt.get().getUsername());
        response.addCookie(WebToken.getCookie(token));
        return "";
    }

    @PostMapping("logout")
    public String logout(final HttpServletResponse response) {
        log.debug("unsetting the cookie");
        response.addCookie(WebToken.getCookie(null, 0));
        return "";
    }

    private boolean exists(final String username) {
        if (userRepository.findOneByUsername(username).isEmpty()) {
            return false;
        }
        return true;
    }
}
