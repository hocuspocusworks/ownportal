package net.ownportal.portal.story;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import net.ownportal.portal.user.User;

@Repository
interface StoryRepository extends JpaRepository<Favourite, String> {
    List<Favourite> findAllByUser(User user);
}
