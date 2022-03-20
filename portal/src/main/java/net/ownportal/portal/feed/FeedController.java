package net.ownportal.portal.feed;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.ownportal.portal.filter.UserService;

@RestController
@RequestMapping("/feed")
class FeedController {
    private final UserService userService;
    private final FeedService feedService;

    public FeedController(UserService userService, FeedService feedService) {
        this.userService = userService;
        this.feedService = feedService;
    }

    @PostMapping("/newGroup")
    public String newGroup() {
        if (!userService.limitReached()) {
            System.out.println("adding new group for user: " + userService);
            feedService.newGroup("test");
            userService.increaseGroupNumber(1);
        }
        return "";
    }
}
