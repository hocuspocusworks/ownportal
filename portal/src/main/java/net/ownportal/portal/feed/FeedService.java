package net.ownportal.portal.feed;

import org.springframework.stereotype.Component;

import net.ownportal.portal.filter.UserService;

@Component
public class FeedService {
    private final UserService userService;
    private final FeedRepository repo;

    public FeedService(UserService userService, FeedRepository repo) {
        this.userService = userService;
        this.repo = repo;
    }

    private void newFeed() {
        final var dao = new FeedDao();
        dao.setPaidUser(userService.isPaidUser());
        dao.setUsername(userService.getUsername());
        repo.save(dao);
    }

    private void createFeedIfNotExist() {
        if (!userService.hasFeed()) {
            newFeed();
        }
    }

    private void createGroupIfNotExist(String name) {
        // var feed = repo.findByUsername(userService.getUsername());
        var feed = repo.findByUsername(userService.getUsername());
        if (!feed.isEmpty()) {
            System.out.println(feed.get(0).getUsername() + " => " + feed.get(0).isPaidUser());
        }
    }

    void newGroup(final String name) {
        createFeedIfNotExist();
        createGroupIfNotExist(name);
    }
}
