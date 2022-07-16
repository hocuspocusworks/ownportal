package net.ownportal.portal.feed;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import net.ownportal.portal.user.User;

@Repository
interface GroupRepository extends JpaRepository<Group, Long> {
    Optional<Group> findByNameAndUser(String name, User user);
}
