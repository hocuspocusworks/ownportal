package net.ownportal.portal.filter;

import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import lombok.ToString;
import net.ownportal.portal.user.User;
import net.ownportal.portal.user.UserRepository;

@Component
@ToString
@RequiredArgsConstructor
public class UserService {
    private final UserDetail userDetail;
    private final UserRepository repo;

    UserService username(final String username) {
        userDetail.setUsername(username);
        return this;
    }

    UserService qouta(final int qouta) {
        userDetail.setQouta(qouta);
        return this;
    }

    public User user() {
        return repo.findOneByEmail(getUsername()).get();
    }

    public void save(User user) {
        repo.save(user);
    }

    public String getUsername() {
        return userDetail.getUsername();
    }

    public boolean hasFeed() {
        // find if the user already has a feed in mongo
        return true;
    }

    public boolean limitReached() {
        // verify all limits against user type
        // userDetail.isPaidUser()
        return false;
    }

    public boolean isPaidUser() {
        return true;
    }

    public void reduceQouta(int amount) {
        int newQouta = userDetail.getQouta() - amount;
        // save new qouta
    }

    public void increaseGroupNumber(int value) {
        int newGroupNumber = userDetail.getNumberOfGroups() + value;
        // save
    }

    public void increaseSourceNumber(int value) {
        int newSourceNumber = userDetail.getNumberOfSources() + value;
        // save
    }
}
