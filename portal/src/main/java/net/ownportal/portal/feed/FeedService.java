package net.ownportal.portal.feed;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

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

    FeedDao getFeedForUsername(final String username) {
        var feedOpt = repo.findOneByUsername(username);
        if (feedOpt.isEmpty()) {
            return new FeedDao();
        }
        return feedOpt.get();
    }

    void newGroup(final GroupDao group) {
        createFeedIfNotExist();
        createGroupIfNotExist(group.getName());
    }

    void newStream(final StreamDto stream) {
        final var feed = repo.findOneByUsername(userService.getUsername()).get();
        if (!feedContainsGroup(stream.getGroup(), feed) || groupContainsStream(stream, feed)) {
            log.info("feed doesn't contain the right group or stream already exists");
            return;
        }
        addNewStream(stream, feed);
        log.debug("saving new stream for {}", userService.getUsername());
        repo.save(feed);
    }
    
    private boolean groupContainsStream(StreamDto stream, FeedDao feed) {
        var group = groupForFeed(stream.getGroup(), feed).get();
        if (group.getStreams() == null) {
            return false;
        }
        long results = group.getStreams()
            .stream()
            .filter(s -> s.getName().equals(stream.getStream()))
            .count();
        return results > 0 ? true : false;
    }

    private void addNewStream(StreamDto stream, FeedDao feed) {
        final var dao = new StreamDao();
        dao.setName(stream.getStream());
        dao.setUrl(stream.getUrl());
        var group = groupForFeed(stream.getGroup(), feed).get();
        var streams = group.getStreams();
        if (streams == null) {
            streams = new ArrayList<>();
        }
        streams.add(dao);
        group.setStreams(streams);
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
        if (feedContainsGroup(name, feed)) {
            return;
        }
        addNewGroup(name, feed);
        log.debug("saving new feed group for {}", userService.getUsername());
        repo.save(feed);
    }

    private List<GroupDao> groupsForFeed(final FeedDao feed) {
        final List<GroupDao> groups = new ArrayList<>();
        if (feed.getGroups() != null) {
            groups.addAll(feed.getGroups());
        }
        feed.setGroups(groups);
        return groups;
    }

    private Optional<GroupDao> groupForFeed(final String name, final FeedDao feed) {
        if (!feedContainsGroup(name, feed)) {
            log.debug("group {} doesn't exist for user {} so can't create a stream", name, userService.getUsername());
            return Optional.empty();
        }
        return Optional.of(feed.getGroups()
            .stream()
            .filter(g -> g.getName().equals(name))
            .collect(Collectors.toList())
            .get(0));
    }

    private boolean feedContainsGroup(final String name, final FeedDao feed) {
        final var groups = groupsForFeed(feed);
        final var matchingGroup = groups
            .stream()
            .filter(g -> g.getName().equals(name));
        if (matchingGroup.count() > 0) {
            log.debug("group already exists for {}, not adding another one", userService.getUsername());
            return true;
        }
        return false;
    }

    private void addNewGroup(String name, FeedDao feed) {
        final var group = new GroupDao();
        group.setName(name);
        var groups = groupsForFeed(feed);
        groups.add(group);
        feed.setGroups(groups);
    }
}
