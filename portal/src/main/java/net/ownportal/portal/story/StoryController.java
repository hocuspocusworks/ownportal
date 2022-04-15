package net.ownportal.portal.story;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.ownportal.portal.filter.UserService;

@RestController
@RequestMapping("/story")
@RequiredArgsConstructor
@Slf4j
public class StoryController {
    private final StoryRepository repository;
    private final UserService userService;

    @PostMapping("/favourite")
    String newFavourite(@RequestBody FavouriteDao dao) {
        log.debug("saving a like");
        dao.setUsername(userService.getUsername());
        repository.save(dao);
        return "";
    }

    @GetMapping("/favourite")
    List<FavouriteDao> getFavourites() {
        return repository.findAllByUsername(userService.getUsername());
    }
}
