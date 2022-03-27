package net.ownportal.portal.developer;

import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import com.github.f4b6a3.uuid.codec.base.Base62Codec;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.ownportal.portal.UserDetail;
import net.ownportal.portal.UserLogin;
import net.ownportal.portal.WebToken;
import net.ownportal.portal.filter.UserService;

@RestController
@RequestMapping("/developer")
class DeveloperController {
    private final UserService userService;
    private final DeveloperRepository repo;

    public DeveloperController(UserService service, DeveloperRepository repo) {
        this.userService = service;
        this.repo = repo;
    }

    @GetMapping("me")
    DeveloperDetail me() {
        return developer();
    }

    @GetMapping("token")
    DeveloperDetail newApiToken(HttpServletResponse response) {
        final var dev = developer();
        if (dev.getUsername().isBlank()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return DeveloperDetail.empty();
        }
        final var dao = DeveloperDao.from(dev);
        dao.setApiToken(generateApiToken());
        return DeveloperDetail.from(repo.save(dao));
    }

    @PostMapping("login")
    public String login(@RequestBody UserLogin user, HttpServletResponse response) {
        final var opt = repo.findOneByUsernameAndPassword(user.getUsername(), user.getPassword());
        if (opt.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return "";
        }
        final var token = WebToken.generateToken(opt.get().getUsername());
        response.addCookie(WebToken.getCookie(token));
        return "";
    }

    @PostMapping("register")
    DeveloperDao register(@RequestBody UserDetail user, HttpServletResponse response) {
        if (exists(user.getUsername())) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            return DeveloperDao.empty();
        }
        final var devDao = DeveloperDao.newDao();
        devDao.setUsername(user.getUsername());
        devDao.setPassword(user.getPassword());
        devDao.setEmail(user.getEmail());
        devDao.setApiToken(generateApiToken());
        return repo.save(devDao);
    }

    private String generateApiToken() {
        return Base62Codec.INSTANCE.encode(UUID.randomUUID());
    }

    private boolean exists(final String username) {
        if (repo.findOneByUsername(username).isEmpty()) {
            return false;
        }
        return true;
    }

    private DeveloperDetail developer() {
        if (exists(userService.getUsername())) {
            final var dao = repo.findOneByUsername(userService.getUsername()).get();
            return DeveloperDetail.from(dao);
        }
        return DeveloperDetail.empty();
    }
}
