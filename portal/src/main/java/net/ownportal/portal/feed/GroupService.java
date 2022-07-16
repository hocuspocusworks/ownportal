package net.ownportal.portal.feed;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import net.ownportal.portal.user.User;

@Service
@RequiredArgsConstructor
class GroupService {
    private final GroupRepository repo;

    public Group getByNameAndUser(String name, User user) {
        var groupOpt = repo.findByNameAndUser(name, user);
        if (groupOpt.isEmpty()) {
            throw new RuntimeException("group doesn't exist");
        }
        return groupOpt.get();
    }

    public void save(Group group) {
        repo.save(group);
    }
}
