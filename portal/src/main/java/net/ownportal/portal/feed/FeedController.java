package net.ownportal.portal.feed;

import org.springframework.web.bind.annotation.GetMapping;
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

    FeedController(UserService userService, FeedService feedService) {
        this.userService = userService;
        this.feedService = feedService;
    }

    @GetMapping("/me")
    FeedDao getMyFeed() {
        return feedService.getFeedForUsername(userService.getUsername());
    }

    @PostMapping("/newGroup")
    String newGroup(@RequestBody GroupDao group) {
        if (!userService.limitReached()) {
            log.debug("adding new group for user {}", userService);
            feedService.newGroup(group);
            userService.increaseGroupNumber(1);
        }
        return "";
    }

    @PostMapping("/newStream")
    String newStream(@RequestBody StreamDto stream) {
        log.debug("adding new stream for {} to group {}", userService.getUsername(), stream.getGroup());
        feedService.newStream(stream);
        return "";
    }
}
