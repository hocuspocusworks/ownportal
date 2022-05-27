package net.ownportal.portal.user;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    Optional<User> findOneByEmail(String username);
    Optional<User> findOneByEmailAndPassword(String username, String password);
}
