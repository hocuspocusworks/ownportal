package net.ownportal.portal.feed;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.portal.filter.UserService;

@RestController
@RequestMapping("/feed")
@Slf4j
class FeedController {
    private final UserService userService;
    private final FeedService feedService;

    public FeedController(UserService userService, FeedService feedService) {
        this.userService = userService;
        this.feedService = feedService;
    }

    @PostMapping("/newGroup")
    public String newGroup(@RequestBody GroupDto group) {
        if (!userService.limitReached()) {
            log.debug("adding new group for user {}", userService);
            feedService.newGroup(group);
            userService.increaseGroupNumber(1);
        }
        return "";
    }
}
