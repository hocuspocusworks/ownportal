package net.ownportal.portal.user;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
interface UserRepository extends MongoRepository<UserDao, String> {

    Optional<UserDao> findOneByUsernameAndPassword(String username, String password);
}
