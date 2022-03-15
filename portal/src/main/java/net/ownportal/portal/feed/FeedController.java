package net.ownportal.portal.feed;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.ownportal.portal.filter.UserService;

@RestController
@RequestMapping("/feed")
class FeedController {
    private final UserService userService;

    public FeedController(final UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/addGroup")
    public String addGroup() {
        if (!userService.limitReached()) {
            System.out.println("adding new group for user: " + userService);
            userService.increaseGroupNumber(1);
        }
        return "";
    }
}
