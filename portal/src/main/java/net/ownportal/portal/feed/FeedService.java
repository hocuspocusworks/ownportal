package net.ownportal.portal.feed;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.portal.filter.UserService;

@Component
@Slf4j
class FeedService {
    private final UserService userService;
    private final FeedRepository repo;

    FeedService(UserService userService, FeedRepository repo) {
        this.userService = userService;
        this.repo = repo;
    }

    void newGroup(final GroupDto group) {
        createFeedIfNotExist();
        createGroupIfNotExist(group.getName());
    }

    private void createFeedIfNotExist() {
        if (!userService.hasFeed()) {
            newFeed();
        }
    }

    private void newFeed() {
        final var dao = new FeedDao();
        dao.setPaidUser(userService.isPaidUser());
        dao.setUsername(userService.getUsername());
        repo.save(dao);
    }

    private void createGroupIfNotExist(final String name) {
        final var feed = repo.findOneByUsername(userService.getUsername()).get();
        final var groups = groupsForFeed(feed);
        if (groupExists(name, groups)) {
            return;
        }
        addNewGroup(name, groups);
        log.debug("saving new feed group for {}", userService.getUsername());
        repo.save(feed);
    }

    private List<GroupDto> groupsForFeed(final FeedDao feed) {
        final List<GroupDto> groups = new ArrayList<>();
        if (feed.getGroups() != null) {
            groups.addAll(feed.getGroups());
        }
        feed.setGroups(groups);
        return groups;
    }

    private boolean groupExists(final String name, List<GroupDto> groups) {
        final var matchingGroup = groups
            .stream()
            .filter(g -> g.getName().equals(name));
        if (matchingGroup.count() > 0) {
            log.debug("group already exists for {}, not adding another one", userService.getUsername());
            return true;
        }
        return false;
    }

    private void addNewGroup(String name, List<GroupDto> groups) {
        final var group = new GroupDto();
        group.setName(name);
        groups.add(group);
    }
}
