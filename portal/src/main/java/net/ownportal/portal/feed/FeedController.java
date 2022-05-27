package net.ownportal.portal.feed;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.ownportal.portal.filter.UserService;
import net.ownportal.portal.user.User;

@RestController
@RequestMapping("feed")
@Slf4j
@RequiredArgsConstructor
class FeedController {
    private final UserService userService;
    private final GroupRepository groupRepo;

    @GetMapping("me")
    FeedResponse getMyFeed() {
        final var feed = new FeedResponse();
        for (var group : userService.user().getUserGroups()) {
            var g = new GroupResponse();
            g.setName(group.getName());
            for (var stream : group.getStreams()) {
                var s = new StreamResponse();
                s.setName(stream.getName());
                s.setUrl(stream.getSource().getUrl());
                g.getStreams().add(s);
            }
            feed.getGroups().add(g);
        }
        return feed;
    }

    @PostMapping("newGroup")
    String newGroup(@RequestBody GroupDto group) {
        Group g = new Group();
        groupRepo.save(g);
        User u = userService.user();
        g.setName(group.getName());
        u.getUserGroups().add(g);
        userService.save(u);
        return "";
    }

    @PostMapping("newStream")
    String newStream(@RequestBody StreamDto stream) {
        log.debug("adding new stream for {} to group {}", userService.getUsername(), stream.getGroup());
        return "";
    }

    @DeleteMapping("group")
    String deleteGroup(@RequestBody String name) {
        return "";
    }

    @DeleteMapping("stream")
    String deleteStream(@RequestBody String name) {
        return "";
    }
}
