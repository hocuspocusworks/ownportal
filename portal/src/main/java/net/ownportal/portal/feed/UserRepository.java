package net.ownportal.portal.feed;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends MongoRepository<UserDao, String> {

    Optional<UserDao> findOneByUsernameAndPassword(String username, String password);
}
