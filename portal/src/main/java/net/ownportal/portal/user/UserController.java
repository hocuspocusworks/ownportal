package net.ownportal.portal.user;

import javax.servlet.http.HttpServletResponse;

import com.password4j.Password;

import org.springframework.http.HttpHeaders;
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
        final var hash = Password.hash(user.getPassword())
            .addRandomSalt()
            .withPBKDF2();
        userDao.setUsername(user.getUsername());
        userDao.setPassword(hash.getResult());
        userDao.setSalt(hash.getSalt());
        userDao.setEmail(user.getEmail());
        return userRepository.save(userDao);
    }

    @PostMapping("login")
    public String login(@RequestBody UserLogin input, final HttpServletResponse response) {
        var userOpt = userRepository.findOneByUsername(input.getUsername());
        if (userOpt.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return "";
        }
        final boolean isVerified = Password.check(input.getPassword(), userOpt.get().getPassword())
            .addSalt(userOpt.get().getSalt())
            .withPBKDF2();
        if (!isVerified) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return "";
        }
        final var token = WebToken.generateToken(userOpt.get().getUsername());
        response.addHeader(HttpHeaders.SET_COOKIE, WebToken.getCookie(token));
        return "";
    }

    @PostMapping("logout")
    public String logout(final HttpServletResponse response) {
        log.debug("unsetting the cookie");
        response.addHeader(HttpHeaders.SET_COOKIE, WebToken.getCookie(null, 0));
        return "";
    }

    private boolean exists(final String username) {
        if (userRepository.findOneByUsername(username).isEmpty()) {
            return false;
        }
        return true;
    }
}
